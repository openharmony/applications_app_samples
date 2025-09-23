/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef SCROLLABLENDK_COMPONENTS_LIST_LISTNODE_H
#define SCROLLABLENDK_COMPONENTS_LIST_LISTNODE_H

#include <functional>
#include <memory>

#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <hilog/log.h>

#include "common/ArkUINode.h"
#include "common/ArkUIConstants.h"
#include "common/ArkUIUtils.h"
#include "common/ArkUIScrollEvent.h"
#include "common/ArkUINodeAdapter.h"

#ifndef LOG_TAG
#define LOG_TAG "ListNode"
#endif

namespace ScrollableNDK {

class ListNode : public BaseNode {
public:
    // 嵌套滚动模式常量
    static constexpr int32_t K_NESTED_SCROLL_PARENT_FIRST = 0;
    static constexpr int32_t K_NESTED_SCROLL_CHILD_FIRST = 1;
    static constexpr int32_t K_NESTED_SCROLL_SELF_FIRST = 2;

    // 组件事件数据数组索引常量
    static constexpr int32_t K_SCROLL_INDEX_FIRST_DATA_INDEX = 0;
    static constexpr int32_t K_SCROLL_INDEX_LAST_DATA_INDEX = 3;
    static constexpr int32_t K_VISIBLE_CHANGE_FIRST_CHILD_DATA_INDEX = 0;
    static constexpr int32_t K_VISIBLE_CHANGE_START_AREA_DATA_INDEX = 1;
    static constexpr int32_t K_VISIBLE_CHANGE_START_INDEX_DATA_INDEX = 2;
    static constexpr int32_t K_VISIBLE_CHANGE_LAST_CHILD_DATA_INDEX = 3;
    static constexpr int32_t K_VISIBLE_CHANGE_END_AREA_DATA_INDEX = 4;
    static constexpr int32_t K_VISIBLE_CHANGE_END_INDEX_DATA_INDEX = 5;
    static constexpr int32_t K_SCROLL_FRAME_BEGIN_DATA_INDEX = 0;

public:
    ListNode()
        : BaseNode(NodeApiInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_LIST)),
          nodeApi_(NodeApiInstance::GetInstance()->GetNativeNodeAPI())
    {
        if (!Utils::IsNotNull(nodeApi_) || !Utils::IsNotNull(GetHandle())) {
            return;
        }

        nodeApi_->addNodeEventReceiver(GetHandle(), &ListNode::StaticEventReceiver);
        const uint32_t scrollEventMask = SCROLL_EVT_FRAME_BEGIN | SCROLL_EVT_REACH_END;
        scrollEventGuard_.Bind(nodeApi_, GetHandle(), this, scrollEventMask);
    }

    ~ListNode() override
    {
        scrollEventGuard_.Release();

        if (!Utils::IsNotNull(nodeApi_)) {
            return;
        }
        UnregisterSpecificEvents();
        ResetListAdapter();
        CleanupChildrenMainSizeOption();
    }

    // ========================================
    // 通用属性设置接口
    // ========================================
    void SetTransparentBackground() { SetBackgroundColor(Constants::K_COLOR_TRANSPARENT); }

    void SetClipContent(bool clipEnabled)
    {
        Utils::SetAttributeInt32(nodeApi_, GetHandle(), NODE_SCROLL_CLIP_CONTENT, clipEnabled ? 1 : 0);
    }

    void SetEdgeEffectSpring(bool springEnabled)
    {
        int32_t effectValue = springEnabled ? ARKUI_EDGE_EFFECT_SPRING : ARKUI_EDGE_EFFECT_NONE;
        Utils::SetAttributeInt32(nodeApi_, GetHandle(), NODE_SCROLL_EDGE_EFFECT, effectValue);
    }

    void SetScrollBarVisible(bool visible)
    {
        int32_t displayMode = visible ? ARKUI_SCROLL_BAR_DISPLAY_MODE_ON : ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF;
        Utils::SetAttributeInt32(nodeApi_, GetHandle(), NODE_SCROLL_BAR_DISPLAY_MODE, displayMode);
    }

    void SetItemSpacing(float spacing) { Utils::SetAttributeFloat32(nodeApi_, GetHandle(), NODE_LIST_SPACE, spacing); }

    void SetScrollBarState(bool visible) { SetScrollBarVisible(visible); }

    void SetSpace(float spacing) { SetItemSpacing(spacing); }

    void SetNestedScrollMode(int32_t mode)
    {
        Utils::SetAttributeInt32(nodeApi_, GetHandle(), NODE_SCROLL_NESTED_SCROLL, mode);
    }

    // ========================================
    // 滚动控制接口
    // ========================================
    void ScrollToIndex(int32_t index)
    {
        Utils::SetAttributeInt32(nodeApi_, GetHandle(), NODE_LIST_SCROLL_TO_INDEX, index);
    }

    void ScrollToIndexInGroup(int32_t groupIndex, int32_t itemIndex)
    {
        ArkUI_NumberValue values[] = {{.i32 = groupIndex}, {.i32 = itemIndex}};
        ArkUI_AttributeItem item{values, 2};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_SCROLL_TO_INDEX_IN_GROUP, &item);
    }

    // ========================================
    // 适配器设置接口
    // ========================================
    void SetLazyAdapter(const std::shared_ptr<ArkUINodeAdapter> &adapter)
    {
        if (!Utils::IsNotNull(adapter)) {
            nodeApi_->resetAttribute(GetHandle(), NODE_LIST_NODE_ADAPTER);
            listAdapter_.reset();
            return;
        }
        adapter->EnsurePlaceholderTypeOr(static_cast<int32_t>(ARKUI_NODE_LIST_ITEM));
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetAdapter()};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_NODE_ADAPTER, &item);
        listAdapter_ = adapter;
    }

    // —— 扩展属性 —— //
    void SetDirection(int axis /*ArkUI_Axis*/)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = axis;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_DIRECTION, &it);
    }

    void SetSticky(int sticky /*ArkUI_StickyStyle*/)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = sticky;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_STICKY, &it);
    }

    void SetCachedCount(int32_t count)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = count;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_CACHED_COUNT, &it);
    }

    void SetInitialIndex(int32_t index)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = index;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_INITIAL_INDEX, &it);
    }

    void SetDivider(float widthPx)
    {
        ArkUI_NumberValue v0{};
        v0.f32 = widthPx;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_DIVIDER, &it);
    }

    void SetAlignListItem(int align /*ArkUI_ListItemAlignment*/)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = align;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_ALIGN_LIST_ITEM, &it);
    }

    void SetChildrenMainSizeOption(ArkUI_ListChildrenMainSize *opt)
    {
        ArkUI_AttributeItem it{nullptr, 0, nullptr, opt};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_CHILDREN_MAIN_SIZE, &it);
        childrenMainSizeOption_ = opt;
    }

    void SetFocusWrapMode(int mode)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = mode;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_FOCUS_WRAP_MODE, &it);
    }

    void SetMaintainVisibleContentPosition(bool on)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = on ? 1 : 0;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_MAINTAIN_VISIBLE_CONTENT_POSITION, &it);
    }

    void SetStackFromEnd(bool on)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = on ? 1 : 0;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_STACK_FROM_END, &it);
    }

    void SetSyncLoad(bool on)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = on ? 1 : 0;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_SYNC_LOAD, &it);
    }

    void SetScrollSnapAlign(int align /*ARKUI_SCROLL_SNAP_ALIGN_**/)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = align;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_SCROLL_SNAP_ALIGN, &it);
    }

    void SetLanes(int lanes)
    {
        ArkUI_NumberValue v0{};
        v0.i32 = lanes;
        ArkUI_AttributeItem it{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_LIST_LANES, &it);
    }

    void SetContentOffsets(float startPx, float endPx)
    {
        ArkUI_NumberValue v0{};
        v0.f32 = startPx;
        ArkUI_AttributeItem it0{&v0, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_SCROLL_CONTENT_START_OFFSET, &it0);

        ArkUI_NumberValue v1{};
        v1.f32 = endPx;
        ArkUI_AttributeItem it1{&v1, 1};
        nodeApi_->setAttribute(GetHandle(), NODE_SCROLL_CONTENT_END_OFFSET, &it1);
    }

    // ========================================
    // 事件注册接口
    // ========================================
    void RegisterOnScrollIndex(const std::function<void(int32_t, int32_t)> &callback)
    {
        onScrollIndexCallback_ = callback;
        if (!isScrollIndexEventRegistered_) {
            nodeApi_->registerNodeEvent(GetHandle(), NODE_LIST_ON_SCROLL_INDEX, 0, this);
            isScrollIndexEventRegistered_ = true;
        }
    }

    void RegisterOnVisibleContentChange(
        const std::function<void(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t)> &callback)
    {
        onVisibleChangeCallback_ = callback;
        if (!isVisibleChangeEventRegistered_) {
            nodeApi_->registerNodeEvent(GetHandle(), NODE_LIST_ON_SCROLL_VISIBLE_CONTENT_CHANGE, 0, this);
            isVisibleChangeEventRegistered_ = true;
        }
    }

    void RegisterOnWillScroll(const std::function<void()> &callback)
    {
        onWillScrollCallback_ = callback;
        if (!isWillScrollEventRegistered_) {
            nodeApi_->registerNodeEvent(GetHandle(), NODE_LIST_ON_WILL_SCROLL, 0, this);
            isWillScrollEventRegistered_ = true;
        }
    }

    void RegisterOnDidScroll(const std::function<void()> &callback)
    {
        onDidScrollCallback_ = callback;
        if (!isDidScrollEventRegistered_) {
            nodeApi_->registerNodeEvent(GetHandle(), NODE_LIST_ON_DID_SCROLL, 0, this);
            isDidScrollEventRegistered_ = true;
        }
    }

    void RegisterOnReachEnd(const std::function<void()> &callback) { onReachEndCallback_ = callback; }

    void RegisterOnScrollFrameBegin(const std::function<void(float)> &callback)
    {
        onScrollFrameBeginCallback_ = callback;
    }

protected:
    void OnNodeEvent(ArkUI_NodeEvent *event) override
    {
        BaseNode::OnNodeEvent(event);

        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (!Utils::IsNotNull(componentEvent)) {
            return;
        }

        int32_t eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        HandleSpecificListEvent(eventType, componentEvent);
    }

private:
    void UnregisterSpecificEvents()
    {
        if (isScrollIndexEventRegistered_) {
            nodeApi_->unregisterNodeEvent(GetHandle(), NODE_LIST_ON_SCROLL_INDEX);
        }
        if (isVisibleChangeEventRegistered_) {
            nodeApi_->unregisterNodeEvent(GetHandle(), NODE_LIST_ON_SCROLL_VISIBLE_CONTENT_CHANGE);
        }
        if (isWillScrollEventRegistered_) {
            nodeApi_->unregisterNodeEvent(GetHandle(), NODE_LIST_ON_WILL_SCROLL);
        }
        if (isDidScrollEventRegistered_) {
            nodeApi_->unregisterNodeEvent(GetHandle(), NODE_LIST_ON_DID_SCROLL);
        }
    }

    void ResetListAdapter()
    {
        if (Utils::IsNotNull(listAdapter_)) {
            nodeApi_->resetAttribute(GetHandle(), NODE_LIST_NODE_ADAPTER);
            listAdapter_.reset();
        }
    }

    void CleanupChildrenMainSizeOption()
    {
        if (Utils::IsNotNull(childrenMainSizeOption_)) {
            nodeApi_->resetAttribute(GetHandle(), NODE_LIST_CHILDREN_MAIN_SIZE);
            OH_ArkUI_ListChildrenMainSizeOption_Dispose(childrenMainSizeOption_);
            childrenMainSizeOption_ = nullptr;
        }
    }
    void HandleSpecificListEvent(int32_t eventType, ArkUI_NodeComponentEvent *componentEvent)
    {
        switch (eventType) {
            case NODE_LIST_ON_SCROLL_INDEX: {
                int32_t firstIndex = componentEvent->data[K_SCROLL_INDEX_FIRST_DATA_INDEX].i32;
                int32_t lastIndex = componentEvent->data[K_SCROLL_INDEX_LAST_DATA_INDEX].i32;
                if (onScrollIndexCallback_) {
                    onScrollIndexCallback_(firstIndex, lastIndex);
                }
                break;
            }
            case NODE_LIST_ON_SCROLL_VISIBLE_CONTENT_CHANGE: {
                if (onVisibleChangeCallback_) {
                    onVisibleChangeCallback_(componentEvent->data[K_VISIBLE_CHANGE_FIRST_CHILD_DATA_INDEX].i32,
                                             componentEvent->data[K_VISIBLE_CHANGE_START_AREA_DATA_INDEX].i32,
                                             componentEvent->data[K_VISIBLE_CHANGE_START_INDEX_DATA_INDEX].i32,
                                             componentEvent->data[K_VISIBLE_CHANGE_LAST_CHILD_DATA_INDEX].i32,
                                             componentEvent->data[K_VISIBLE_CHANGE_END_AREA_DATA_INDEX].i32,
                                             componentEvent->data[K_VISIBLE_CHANGE_END_INDEX_DATA_INDEX].i32);
                }
                break;
            }
            case NODE_SCROLL_EVENT_ON_REACH_END: {
                if (onReachEndCallback_) {
                    onReachEndCallback_();
                }
                break;
            }
            case NODE_SCROLL_EVENT_ON_SCROLL_FRAME_BEGIN: {
                if (onScrollFrameBeginCallback_) {
                    onScrollFrameBeginCallback_(componentEvent->data[K_SCROLL_FRAME_BEGIN_DATA_INDEX].f32);
                }
                break;
            }
            case NODE_LIST_ON_WILL_SCROLL: {
                if (onWillScrollCallback_) {
                    onWillScrollCallback_();
                }
                break;
            }
            case NODE_LIST_ON_DID_SCROLL: {
                if (onDidScrollCallback_) {
                    onDidScrollCallback_();
                }
                break;
            }
            default:
                break;
        }
    }

private:
    ArkUI_NativeNodeAPI_1 *nodeApi_ = nullptr;
    std::shared_ptr<ArkUINodeAdapter> listAdapter_;
    ArkUI_ListChildrenMainSize *childrenMainSizeOption_ = nullptr;

    // 事件回调函数
    std::function<void(int32_t, int32_t)> onScrollIndexCallback_;
    std::function<void(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t)> onVisibleChangeCallback_;
    std::function<void()> onReachEndCallback_;
    std::function<void(float)> onScrollFrameBeginCallback_;
    std::function<void()> onWillScrollCallback_;
    std::function<void()> onDidScrollCallback_;

    // 事件注册状态
    bool isScrollIndexEventRegistered_ = false;
    bool isVisibleChangeEventRegistered_ = false;
    bool isWillScrollEventRegistered_ = false;
    bool isDidScrollEventRegistered_ = false;

    ScrollEventGuard scrollEventGuard_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_COMPONENTS_LIST_LISTNODE_H
