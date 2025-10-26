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
// [Start List_encapsulated_object]
// ArkUIListNode.h
// 提供列表组件的封装。
#ifndef MYAPPLICATION_ARKUILISTNODE_H
#define MYAPPLICATION_ARKUILISTNODE_H

#include "ArkUINode.h"
#include "ArkUIListItemAdapter.h"
namespace NativeModule {
class ArkUIListNode : public ArkUINode {
public:
    ArkUIListNode() // 创建ArkUI的列表组件。
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_LIST)) {}

    ~ArkUIListNode() override
    {
        if (nativeModule_) {
            nativeModule_->unregisterNodeEvent(handle_, NODE_LIST_ON_SCROLL_INDEX);
        }
        if (adapter_) {
            // 析构的时候卸载adapter下的UI组件。
            nativeModule_->resetAttribute(handle_, NODE_LIST_NODE_ADAPTER);
            adapter_.reset();
        }
    }
    // List组件的属性接口封装。
    void SetScrollBarState(bool isShow)
    {
        ArkUI_ScrollBarDisplayMode displayMode =
            isShow ? ARKUI_SCROLL_BAR_DISPLAY_MODE_ON : ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF;
        ArkUI_NumberValue value[] = {{.i32 = displayMode}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_SCROLL_BAR_DISPLAY_MODE, &item);
    }

    void RegisterOnScrollIndex(const std::function<void(int32_t index)> &onScrollIndex)
    {
        onScrollIndex_ = onScrollIndex;
        nativeModule_->registerNodeEvent(handle_, NODE_LIST_ON_SCROLL_INDEX, 0, nullptr);
    }
    // 引入懒加载模块。
    void SetLazyAdapter(const std::shared_ptr<ArkUIListItemAdapter> &adapter)
    {
        ArkUI_AttributeItem item{nullptr, 0, nullptr, adapter->GetHandle()};
        nativeModule_->setAttribute(handle_, NODE_LIST_NODE_ADAPTER, &item);
        adapter_ = adapter;
    }
    // [Start ScrollTo]
    void ScrollTo(float offset)
    {
        ArkUI_NumberValue value[] = {{.f32 = 0}, {.f32 = offset}, {.f32 = 0}};
        ArkUI_AttributeItem Item = {.value = value, .size = 3};
        nativeModule_->setAttribute(handle_, NODE_SCROLL_OFFSET, &Item);
    }
    // [End ScrollTo]
    // [Start ScrollToIndex]
    void ScrollToIndex(int32_t index)
    {
        ArkUI_NumberValue value[] = {{.i32 = index}};
        ArkUI_AttributeItem Item = {.value = value, .size = 1};
        nativeModule_->setAttribute(handle_, NODE_LIST_SCROLL_TO_INDEX, &Item);
    }
    // [End ScrollToIndex]
    // [Start ScrollBy]
    void ScrollBy(float offset)
    {
        ArkUI_NumberValue value[] = {{.f32 = 0}, {.f32 = offset}};
        ArkUI_AttributeItem Item = {.value = value, .size = 2};
        nativeModule_->setAttribute(handle_, NODE_SCROLL_BY, &Item);
    }
    // [End ScrollBy]
    // [Start SetSticky]
    void SetSticky(ArkUI_StickyStyle style)
    {
        ArkUI_NumberValue value[] = {{.i32 = style}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_LIST_STICKY, &item);
    }
// [End SetSticky]
protected:
    void OnNodeEvent(ArkUI_NodeEvent *event) override
    {
        auto eventType = OH_ArkUI_NodeEvent_GetEventType);
        switch (eventType) {
            case NODE_LIST_ON_SCROLL_INDEX: {
                auto index = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event)->data[0];
                ifonScrollIndex_) {
                    onScrollIndex_(index.i32);
                }
            }
            default: {
        }
        }
    }

private:
    std::function<void(int32_t index)> onScrollIndex_;

    std::shared_ptr<ArkUIListItemAdapter> adapter_;
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUILISTNODE_H
       // [End List_encapsulated_object]