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

#ifndef MYAPPLICATION_TYPEDARKUINODE_H
#define MYAPPLICATION_TYPEDARKUINODE_H

#include "common/ArkUINode.h"

namespace NativeModule {
class ArkUIScrollNode : public ArkUINode {
public:
    ArkUIScrollNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_SCROLL)) {}
    void SetScrollDirection(ArkUI_Axis scrollDirection)
    {
        ArkUI_NumberValue dir_value[] = {{ .i32 = scrollDirection }};
        ArkUI_AttributeItem dir_item = { dir_value, sizeof(dir_value) / sizeof(ArkUI_NumberValue) };
        auto result = nativeModule_->setAttribute(handle_, NODE_SCROLL_SCROLL_DIRECTION, &dir_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIScrollNode SetScrollDirection Failed %{public}d", result);
        }
    }
    void SetScrollBarDisplayMode(ArkUI_ScrollBarDisplayMode mode)
    {
        ArkUI_NumberValue mode_value[] = {{ .i32 = mode }};
        ArkUI_AttributeItem mode_item = { mode_value, sizeof(mode_value) / sizeof(ArkUI_NumberValue) };
        auto result = nativeModule_->setAttribute(handle_, NODE_SCROLL_BAR_DISPLAY_MODE, &mode_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIScrollNode SetScrollDirection Failed %{public}d", result);
        }
    }
};

class ArkUIRowNode : public ArkUINode {
public:
    ArkUIRowNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_ROW)) {}
};

class ArkUIColumnNode : public ArkUINode {
public:
    ArkUIColumnNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_COLUMN)) {}
};

class ArkUIButtonNode : public ArkUINode {
public:
    ArkUIButtonNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_BUTTON)) {}
    void SetLabel(const char* src)
    {
        ArkUI_AttributeItem label_item = { .string = src };
        auto result = nativeModule_->setAttribute(handle_, NODE_BUTTON_LABEL, &label_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIButtonNode SetLabel Failed %{public}d", result);
        }
    }
};

class ArkUIImageNode : public ArkUINode {
public:
    ArkUIImageNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_IMAGE)) {}
    void SetSrc(const char* src)
    {
        ArkUI_AttributeItem image_src_item = {};
        image_src_item.string = src;
        auto result = nativeModule_->setAttribute(handle_, NODE_IMAGE_SRC, &image_src_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIImageNode SetSrc Failed %{public}d", result);
        }
    }
    void SetAutoResize(bool autoResize)
    {
        ArkUI_NumberValue value[] = {{.i32 = autoResize} };
        ArkUI_AttributeItem item = {value, 1};
        auto result = nativeModule_->setAttribute(handle_, NODE_IMAGE_AUTO_RESIZE, &item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIImageNode SetAutoResize Failed %{public}d", result);
        }
    }
};

class ArkUIRefreshNode : public ArkUINode {
public:
    ArkUIRefreshNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_REFRESH)) {}
    void SetRefreshing(bool refreshing)
    {
        ArkUI_NumberValue refreshing_value[] = {{ .i32 = refreshing }};
        ArkUI_AttributeItem refreshing_item = {
            refreshing_value, sizeof(refreshing_value) / sizeof(ArkUI_NumberValue) };
        auto result = nativeModule_->setAttribute(handle_, NODE_REFRESH_REFRESHING, &refreshing_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIRefreshNode SetRefreshing Failed %{public}d", result);
        }
    }
};

class ArkUITextInputNode : public ArkUINode {
public:
    ArkUITextInputNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_TEXT_INPUT)) {}
};

class ArkUITextNode : public ArkUINode {
public:
    ArkUITextNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_TEXT)) {}
    void SetContent(const char* content)
    {
        ArkUI_AttributeItem content_item = { .string = content };
        auto result = nativeModule_->setAttribute(handle_, NODE_TEXT_CONTENT, &content_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUITextNode SetContent Failed %{public}d", result);
        }
    }
    void SetFontSize(float size)
    {
        ArkUI_NumberValue size_value[] = {{ .f32 = size }};
        ArkUI_AttributeItem size_item = { size_value, sizeof(size_value) / sizeof(ArkUI_NumberValue) };
        auto result = nativeModule_->setAttribute(handle_, NODE_FONT_SIZE, &size_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIGridNode SetColumnGap Failed %{public}d", result);
        }
    }
};

class ArkUIGridNode : public ArkUINode {
public:
    ArkUIGridNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_GRID)) {}
    void SetColumnTemplate(const char* columnTemplate)
    {
        ArkUI_AttributeItem template_item = { .string = columnTemplate };
        auto result = nativeModule_->setAttribute(handle_, NODE_GRID_COLUMN_TEMPLATE, &template_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIGridNode SetColumnTemplate Failed %{public}d", result);
        }
    }
    void SetColumnGap(float gap)
    {
        ArkUI_NumberValue gap_value[] = {{ .f32 = gap }};
        ArkUI_AttributeItem gap_item = { gap_value, sizeof(gap_value) / sizeof(ArkUI_NumberValue) };
        auto result = nativeModule_->setAttribute(handle_, NODE_GRID_COLUMN_GAP, &gap_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIGridNode SetColumnGap Failed %{public}d", result);
        }
    }
    void SetRowGap(float gap)
    {
        ArkUI_NumberValue gap_value[] = {{ .f32 = gap }};
        ArkUI_AttributeItem gap_item = { gap_value, sizeof(gap_value) / sizeof(ArkUI_NumberValue) };
        auto result = nativeModule_->setAttribute(handle_, NODE_GRID_ROW_GAP, &gap_item);
        if (result != ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_ERROR(LOG_APP, "ArkUIGridNode SetRowGap Failed %{public}d", result);
        }
    }
};

class ArkUIGridItemNode : public ArkUINode {
public:
    ArkUIGridItemNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_GRID_ITEM)) {}
};

class ArkUIStackNode : public ArkUINode {
public:
    ArkUIStackNode()
        : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_STACK)) {}
};
} // namespace NativeModule

#endif //MYAPPLICATION_TYPEDARKUINODE_H
