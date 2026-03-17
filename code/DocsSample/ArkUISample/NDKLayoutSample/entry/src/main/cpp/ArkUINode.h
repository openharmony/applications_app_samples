/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
#ifndef NDKLAYOUTSAMPLE_ARKUINODE_H
#define NDKLAYOUTSAMPLE_ARKUINODE_H

#include "ArkUIBaseNode.h"
#include "NativeModule.h"
#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace NativeModule {

class ArkUINode : public ArkUIBaseNode {
public:
    explicit ArkUINode(ArkUI_NodeHandle handle) : ArkUIBaseNode(handle) {}

    ~ArkUINode() override {}

    // [Start layout_size_node]
    void SetWidth(float width)
    {
        ArkUI_NumberValue value[] = {{.f32 = width}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_WIDTH, &item);
    }
    void SetPercentWidth(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_WIDTH_PERCENT, &item);
    }
    void SetHeight(float height)
    {
        ArkUI_NumberValue value[] = {{.f32 = height}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_HEIGHT, &item);
    }
    void SetPercentHeight(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_HEIGHT_PERCENT, &item);
    }
    void SetSize(float width, float height)
    {
        ArkUI_NumberValue value[] = {{.f32 = width}, {.f32 = height}};
        ArkUI_AttributeItem item = {value, 2};
        nativeModule_->setAttribute(handle_, NODE_SIZE, &item);
    }
    // [End layout_size_node]
    // [Start layout_spacing_node]
    void SetPadding(float padding)
    {
        ArkUI_NumberValue value[] = {{.f32 = padding}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_PADDING, &item);
    }
    void SetPadding(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue value[] = {{.f32 = top}, {.f32 = right}, {.f32 = bottom}, {.f32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_PADDING, &item);
    }
    void SetPercentPadding(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_PADDING_PERCENT, &item);
    }
    void SetPercentPadding(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue value[] = {{.f32 = top}, {.f32 = right}, {.f32 = bottom}, {.f32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_PADDING_PERCENT, &item);
    }
    void SetMargin(float margin)
    {
        ArkUI_NumberValue value[] = {{.f32 = margin}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_MARGIN, &item);
    }
    void SetMargin(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue value[] = {{.f32 = top}, {.f32 = right}, {.f32 = bottom}, {.f32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_MARGIN, &item);
    }
    void SetPercentMargin(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_MARGIN_PERCENT, &item);
    }
    // [End layout_spacing_node]
    // [Start layout_border_node]
    void SetBorderWidth(float width)
    {
        ArkUI_NumberValue value[] = {{.f32 = width}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_BORDER_WIDTH, &item);
    }
    void SetBorderWidth(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue value[] = {{.f32 = top}, {.f32 = right}, {.f32 = bottom}, {.f32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_BORDER_WIDTH, &item);
    }
    void SetBorderRadius(float radius)
    {
        ArkUI_NumberValue value[] = {{.f32 = radius}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_BORDER_RADIUS, &item);
    }
    void SetBorderRadius(float topLeft, float topRight, float bottomLeft, float bottomRight)
    {
        ArkUI_NumberValue value[] = {
            {.f32 = topLeft}, {.f32 = topRight}, {.f32 = bottomLeft}, {.f32 = bottomRight}
        };
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_BORDER_RADIUS, &item);
    }
    void SetBorderColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_BORDER_COLOR, &item);
    }
    void SetBorderColor(uint32_t top, uint32_t right, uint32_t bottom, uint32_t left)
    {
        ArkUI_NumberValue value[] = {{.u32 = top}, {.u32 = right}, {.u32 = bottom}, {.u32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_BORDER_COLOR, &item);
    }
    void SetBorderStyle(ArkUI_BorderStyle style)
    {
        ArkUI_NumberValue value[] = {{.i32 = style}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_BORDER_STYLE, &item);
    }
    void SetBorderStyle(
        ArkUI_BorderStyle top, ArkUI_BorderStyle right, ArkUI_BorderStyle bottom, ArkUI_BorderStyle left)
    {
        ArkUI_NumberValue value[] = {
            {.i32 = top}, {.i32 = right}, {.i32 = bottom}, {.i32 = left}
        };
        ArkUI_AttributeItem item = {value, 4};
        nativeModule_->setAttribute(handle_, NODE_BORDER_STYLE, &item);
    }
    // [End layout_border_node]
    // [Start layout_position_node]
    void SetPosition(float x, float y)
    {
        ArkUI_NumberValue value[] = {{.f32 = x}, {.f32 = y}};
        ArkUI_AttributeItem item = {value, 2};
        nativeModule_->setAttribute(handle_, NODE_POSITION, &item);
    }
    void SetOffset(float x, float y)
    {
        ArkUI_NumberValue value[] = {{.f32 = x}, {.f32 = y}};
        ArkUI_AttributeItem item = {value, 2};
        nativeModule_->setAttribute(handle_, NODE_OFFSET, &item);
    }
    // [End layout_position_node]
    // [Start layout_aspect_ratio_node]
    void SetAspectRatio(float ratio)
    {
        ArkUI_NumberValue value[] = {{.f32 = ratio}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_ASPECT_RATIO, &item);
    }
    // [End layout_aspect_ratio_node]
    // [Start layout_safe_area_node]
    void SetExpandSafeArea(uint32_t type, uint32_t edge)
    {
        ArkUI_NumberValue value[] = {{.u32 = type}, {.u32 = edge}};
        ArkUI_AttributeItem item = {value, 2};
        nativeModule_->setAttribute(handle_, NODE_EXPAND_SAFE_AREA, &item);
    }
    // [End layout_safe_area_node]
    void SetAlignSelf(ArkUI_ItemAlignment align)
    {
        ArkUI_NumberValue value[] = {{.i32 = align}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_ALIGN_SELF, &item);
    }
    // [Start layout_weight_node]
    void SetLayoutWeight(uint32_t weight)
    {
        ArkUI_NumberValue value[] = {{.u32 = weight}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_LAYOUT_WEIGHT, &item);
    }
    // [End layout_weight_node]
    void SetDisplayPriority(uint32_t priority)
    {
        ArkUI_NumberValue value[] = {{.u32 = priority}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_DISPLAY_PRIORITY, &item);
    }
    void SetStackAlignContent(ArkUI_Alignment align)
    {
        ArkUI_NumberValue value[] = {{.i32 = align}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_STACK_ALIGN_CONTENT, &item);
    }
    void SetBackgroundColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_BACKGROUND_COLOR, &item);
    }

protected:
    void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        nativeModule_->addChild(handle_, child->GetHandle());
    }
    void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        nativeModule_->removeChild(handle_, child->GetHandle());
    }
    void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) override
    {
        nativeModule_->insertChildAt(handle_, child->GetHandle(), index);
    }
};
} // namespace NativeModule

#endif // NDKLAYOUTSAMPLE_ARKUINODE_H
