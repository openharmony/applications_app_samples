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

#ifndef SCROLLABLENDK_SCROLL_NODE_H
#define SCROLLABLENDK_SCROLL_NODE_H

#include <cstdint>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>

#include "common/ArkUINode.h"
#include "common/ArkUIUtils.h"
#include "common/ArkUIScrollEvent.h"

namespace ScrollableNDK {

/**
 * @brief ArkUI Scroll 节点轻封装
 */
class ArkUIScrollNode {
public:
    ArkUIScrollNode()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api_);
        scroll_ = api_->createNode(ARKUI_NODE_SCROLL);
        api_->addNodeEventReceiver(scroll_, StaticEvent);

        scrollGuard_.Bind(api_, scroll_, nullptr, SCROLL_EVT_ALL);
    }

    ~ArkUIScrollNode()
    {
        scrollGuard_.Release();
        scroll_ = nullptr;
        api_ = nullptr;
    }

    // ===== 通用布局/外观 =====
    void SetWidthPercent(float percent) { Utils::SetAttributeFloat32(api_, scroll_, NODE_WIDTH_PERCENT, percent); }
    void SetHeightPercent(float percent) { Utils::SetAttributeFloat32(api_, scroll_, NODE_HEIGHT_PERCENT, percent); }
    void SetBackgroundColor(uint32_t color) { Utils::SetAttributeUInt32(api_, scroll_, NODE_BACKGROUND_COLOR, color); }

    // ===== Scroll 属性（仅组件通用能力）=====
    void SetScrollDirection(int32_t dir)
    {
        ArkUI_NumberValue v{.i32 = dir};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_SCROLL_DIRECTION, &it);
    }

    void SetScrollBarDisplayMode(int32_t mode)
    {
        ArkUI_NumberValue v{.i32 = mode};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_BAR_DISPLAY_MODE, &it);
    }

    void SetScrollBarWidth(float w)
    {
        ArkUI_NumberValue v{.f32 = w};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_BAR_WIDTH, &it);
    }

    void SetScrollBarColor(uint32_t argb)
    {
        ArkUI_NumberValue v{.u32 = argb};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_BAR_COLOR, &it);
    }

    /** @brief 滚动条外边距：top,right,bottom,left（单位：vp） */
    void SetScrollBarMargin(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue vTop{.f32 = top};
        ArkUI_NumberValue vRight{.f32 = right};
        ArkUI_NumberValue vBottom{.f32 = bottom};
        ArkUI_NumberValue vLeft{.f32 = left};
        ArkUI_NumberValue v[] = {vTop, vRight, vBottom, vLeft};
        ArkUI_AttributeItem it{v, 4};
        api_->setAttribute(scroll_, NODE_SCROLL_BAR_MARGIN, &it);
    }

    void SetEnableScrollInteraction(bool enable)
    {
        ArkUI_NumberValue v{.i32 = enable ? 1 : 0};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_ENABLE_SCROLL_INTERACTION, &it);
    }

    void SetFriction(float friction) { Utils::SetAttributeFloat32(api_, scroll_, NODE_SCROLL_FRICTION, friction); }

    void SetNestedMode(int32_t mode)
    {
        ArkUI_NumberValue v{.i32 = mode};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_NESTED_SCROLL, &it);
    }

    void SetScrollEdge(int32_t edge)
    {
        ArkUI_NumberValue v{.i32 = edge};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_EDGE, &it);
    }

    void SetContentClipMode(int32_t mode)
    {
        ArkUI_NumberValue v{.i32 = mode};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_CLIP_CONTENT, &it);
    }

    void SetClipContent(bool clip)
    {
        ArkUI_NumberValue v{.i32 = clip ? 1 : 0};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_CLIP_CONTENT, &it);
    }

    void SetPageEnabled(bool enable)
    {
        ArkUI_NumberValue v{.i32 = enable ? 1 : 0};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_PAGE, &it);
    }

    void SetBackToTopEnabled(bool enable)
    {
        ArkUI_NumberValue v{.i32 = enable ? 1 : 0};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_BACK_TO_TOP, &it);
    }

    // 偏移/尺寸/By/Fling/渐隐/限速
    void SetOffset(float x, float y)
    {
        ArkUI_NumberValue vx{.f32 = x};
        ArkUI_NumberValue vy{.f32 = y};
        ArkUI_NumberValue v[] = {vx, vy};
        ArkUI_AttributeItem it{v, 2};
        api_->setAttribute(scroll_, NODE_SCROLL_OFFSET, &it);
    }

    void SetSize(float w, float h)
    {
        ArkUI_NumberValue vw{.f32 = w};
        ArkUI_NumberValue vh{.f32 = h};
        ArkUI_NumberValue v[] = {vw, vh};
        ArkUI_AttributeItem it{v, 2};
        api_->setAttribute(scroll_, NODE_SCROLL_SIZE, &it);
    }

    void ScrollBy(float dx, float dy)
    {
        ArkUI_NumberValue vx{.f32 = dx};
        ArkUI_NumberValue vy{.f32 = dy};
        ArkUI_NumberValue v[] = {vx, vy};
        ArkUI_AttributeItem it{v, 2};
        api_->setAttribute(scroll_, NODE_SCROLL_BY, &it);
    }

    void Fling(float velocity)
    {
        ArkUI_NumberValue v{.f32 = velocity};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_FLING, &it);
    }

    void SetFadingEdge(float len)
    {
        ArkUI_NumberValue v{.f32 = len};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_FADING_EDGE, &it);
    }

    void SetFlingSpeedLimit(float limit)
    {
        ArkUI_NumberValue v{.f32 = limit};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_FLING_SPEED_LIMIT, &it);
    }

    // 边缘效果
    void SetEdgeEffect(int32_t effect)
    {
        ArkUI_NumberValue v{.i32 = effect};
        ArkUI_AttributeItem it{&v, 1};
        api_->setAttribute(scroll_, NODE_SCROLL_EDGE_EFFECT, &it);
    }

    // ===== 子节点 =====
    void AddChild(ArkUI_NodeHandle child)
    {
        if (child != nullptr) {
            api_->addChild(scroll_, child);
        }
    }

    ArkUI_NodeHandle GetScroll() const { return scroll_; }

private:
    static void StaticEvent(ArkUI_NodeEvent *ev) { (void)ev; }

private:
    ArkUI_NativeNodeAPI_1 *api_{nullptr};
    ArkUI_NodeHandle scroll_{nullptr};
    ScrollEventGuard scrollGuard_;
};

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_SCROLL_NODE_H
