/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ARKUI_CAPI_UTILS_H
#define ARKUI_CAPI_UTILS_H

#include "customdialogexample.h"
#include <arkui/native_dialog.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>

class CustomDialogUtils  {
public:
    ~CustomDialogUtils();
    static auto SetWidth(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle &nodeHandle, float width)
    {
        ArkUI_NumberValue width_value[] = {{.f32 = width}};
        ArkUI_AttributeItem width_item = {width_value, sizeof(width_value) / sizeof(ArkUI_NumberValue)};
        nodeAPI->setAttribute(nodeHandle, NODE_WIDTH, &width_item);
        return nodeHandle;
    }
    static auto SetHeight(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle &nodeHandle, float height)
    {
        ArkUI_NumberValue height_value[] = {{.f32 = height}};
        ArkUI_AttributeItem height_item = {height_value, sizeof(height_value) / sizeof(ArkUI_NumberValue)};
        nodeAPI->setAttribute(nodeHandle, NODE_HEIGHT, &height_item);
        return nodeHandle;
    }
    static auto SetBackgroundColor(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle nodeHandle, uint32_t color)
    {
        ArkUI_NumberValue color_value[] = {{.u32 = color}};
        ArkUI_AttributeItem color_item = {color_value, sizeof(color_value) / sizeof(ArkUI_NumberValue)};
        nodeAPI->setAttribute(nodeHandle, NODE_BACKGROUND_COLOR, &color_item);
        return nodeHandle;
    }
    static auto SetMargin(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle &nodeHandle, float margin)
    {
        ArkUI_NumberValue margin_value[] = {{.f32 = margin}};
        ArkUI_AttributeItem margin_item = {margin_value, sizeof(margin_value) / sizeof(ArkUI_NumberValue)};
        nodeAPI->setAttribute(nodeHandle, NODE_MARGIN, &margin_item);
        return nodeHandle;
    }
    static auto SetId(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle &nodeHandle, const char *id)
    {
        ArkUI_AttributeItem id_item = {};
        id_item.string = id;
        nodeAPI->setAttribute(nodeHandle, NODE_ID, &id_item);
        return nodeHandle;
    }
    static auto SetButton(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle &nodeHandle,
        const char *id, const char *text)
    {
        nodeHandle = SetWidth(nodeAPI, nodeHandle, PARAM_150);
        nodeHandle = SetHeight(nodeAPI, nodeHandle, PARAM_40);
        ArkUI_AttributeItem label_item = {.string = text};
        nodeAPI->setAttribute(nodeHandle, NODE_BUTTON_LABEL, &label_item);
        nodeHandle = SetBackgroundColor(nodeAPI, nodeHandle, 0xFF0000FF);
        nodeHandle = SetId(nodeAPI, nodeHandle, id);
        nodeHandle = SetMargin(nodeAPI, nodeHandle, PARAM_20);
        return nodeHandle;
    }
    static auto SetDialog(ArkUI_NativeNodeAPI_1 *nodeAPI, ArkUI_NodeHandle &nodeHandle)
    {
        nodeHandle = SetWidth(nodeAPI, nodeHandle, PARAM_200);
        nodeHandle = SetHeight(nodeAPI, nodeHandle, PARAM_300);
        nodeHandle = SetBackgroundColor(nodeAPI, nodeHandle, COLOR_GRAY);
        return nodeHandle;
    }
};

#endif  //  ARKUI_CAPI_UTILS_H
