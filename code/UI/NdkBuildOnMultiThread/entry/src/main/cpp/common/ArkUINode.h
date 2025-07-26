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

#ifndef MYAPPLICATION_ARKUINODE_H
#define MYAPPLICATION_ARKUINODE_H

#include "ArkUIBaseNode.h"

namespace NativeModule {

class ArkUINode : public ArkUIBaseNode {
public:
    explicit ArkUINode(ArkUI_NodeHandle handle) : ArkUIBaseNode(handle) {}

    ~ArkUINode() override {}

    // Native相关通用属性调用封装。
    void SetWidth(float width)
    {
        ArkUI_NumberValue value[] = {{.f32 = width}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_WIDTH, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetWidth Failed %{public}d", result);
        }
    }
    void SetPercentWidth(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_WIDTH_PERCENT, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetPercentWidth Failed %{public}d", result);
        }
    }
    void SetHeight(float height)
    {
        ArkUI_NumberValue value[] = {{.f32 = height}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_HEIGHT, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetHeight Failed %{public}d", result);
        }
    }
    void SetPercentHeight(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_HEIGHT_PERCENT, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetPercentHeight Failed %{public}d", result);
        }
    }
    void SetPosition(float x, float y)
    {
        ArkUI_NumberValue value[] = {{.f32 = x}, {.f32 = y}};
        ArkUI_AttributeItem item = {value, 2};
        auto result = nativeModule_->setAttribute(handle_, NODE_POSITION, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetPosition Failed %{public}d", result);
        }
    }
    void SetBackgroundColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_BACKGROUND_COLOR, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetBackgroundColor Failed %{public}d", result);
        }
    }
    void SetForegroundColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_FOREGROUND_COLOR, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetForegroundColor Failed %{public}d", result);
        }
    }
    
    void SetBorderRadius(float borderRadius)
    {
        ArkUI_NumberValue value[] = {{.f32 = borderRadius}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_BORDER_RADIUS, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetBorderRadius Failed %{public}d", result);
        }
    }
    void SetMargin(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue value[] = {{.f32 = top}, {.f32 = right}, {.f32 = bottom}, {.f32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        auto result = nativeModule_->setAttribute(handle_, NODE_MARGIN, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetMargin Failed %{public}d", result);
        }
    }
    void SetPadding(float top, float right, float bottom, float left)
    {
        ArkUI_NumberValue value[] = {{.f32 = top}, {.f32 = right}, {.f32 = bottom}, {.f32 = left}};
        ArkUI_AttributeItem item = {value, 4};
        auto result = nativeModule_->setAttribute(handle_, NODE_PADDING, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetPadding Failed %{public}d", result);
        }
    }
    void SetClip(bool clip)
    {
        ArkUI_NumberValue value[] = {{.i32 = clip}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_CLIP, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetClip Failed %{public}d", result);
        }
    }
    
    void SetAlignment(ArkUI_Alignment alignment)
    {
        ArkUI_NumberValue value[] = {{.i32 = alignment}};
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_ALIGNMENT, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode SetAlignment Failed %{public}d", result);
        }
    }

protected:
    // 组件树操作的实现类对接。
    void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        auto result = nativeModule_->addChild(handle_, child->GetHandle());
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode AddChild Failed %{public}d", result);
        }
    }
    void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        auto result = nativeModule_->removeChild(handle_, child->GetHandle());
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode RemoveChild Failed %{public}d", result);
        }
    }
    void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) override
    {
        auto result = nativeModule_->insertChildAt(handle_, child->GetHandle(), index);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUINode InsertChild Failed %{public}d", result);
        }
    }
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUINODE_H
