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

#ifndef DRAGANDDROP_COMMON_H
#define DRAGANDDROP_COMMON_H

#include "container.h"
#include <arkui/native_node.h>
#include <arkui/native_type.h>

#define DEFAULT_WIDTH 200.0
#define DEFAULT_HEIGHT 200.0
#define DEFAULT_BORDER_WIDTH 0.0
#define DEFAULT_TEXT_FONT_SIZE 12
#define DEFAULT_BG_COLOR 0xFFFFFFFF

namespace NativeXComponentSample {

ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
ArkUI_ContextHandle context;

void SetBackgroundColor(ArkUI_NodeHandle &node, uint32_t color = DEFAULT_BG_COLOR)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue colorValue[] = {{.u32 = color}};
    ArkUI_AttributeItem colorItem = {colorValue, 1};
    nodeAPI->setAttribute(node, NODE_BACKGROUND_COLOR, &colorItem);
}

void SetWidth(ArkUI_NodeHandle &node, float width = DEFAULT_WIDTH)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue widthValue[] = {width};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    nodeAPI->setAttribute(node, NODE_WIDTH, &widthItem);
}

void SetWidthPercent(ArkUI_NodeHandle &node, float width = 1)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue widthValue[] = {width};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    nodeAPI->setAttribute(node, NODE_WIDTH_PERCENT, &widthItem);
}

void SetHeight(ArkUI_NodeHandle &node, float height = DEFAULT_HEIGHT)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue heightValue[] = {height};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    nodeAPI->setAttribute(node, NODE_HEIGHT, &heightItem);
}

void SetHeightPercent(ArkUI_NodeHandle &node, float height = 1)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue heightValue[] = {height};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    nodeAPI->setAttribute(node, NODE_HEIGHT_PERCENT, &heightItem);
}

void SetBorderWidth(ArkUI_NodeHandle &node, float width = DEFAULT_BORDER_WIDTH)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue borderWidthValue[] = {width};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_WIDTH, &borderWidthItem);
}

void SetBorderRadius(ArkUI_NodeHandle &node)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue borderRadiusValue[] = {{.f32 = 110}};
    ArkUI_AttributeItem borderRadiusItem = {borderRadiusValue, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_RADIUS, &borderRadiusItem);
}

void SetTextFontSize(ArkUI_NodeHandle &node)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue borderRadiusValue[] = {{.f32 = 20}};
    ArkUI_AttributeItem borderRadiusItem = {borderRadiusValue, 1};
    nodeAPI->setAttribute(node, NODE_FONT_SIZE, &borderRadiusItem);
}

void SetFocusable(ArkUI_NodeHandle &node)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue focusValue[] = {{.i32 = 1}};
    ArkUI_AttributeItem focusValueItem = {focusValue, 1};
    nodeAPI->setAttribute(node, NODE_FOCUSABLE, &focusValueItem);
}

void SetDefaultFocus(ArkUI_NodeHandle &node)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue focusValue[] = {{.i32 = 1}};
    ArkUI_AttributeItem focusValueItem = {focusValue, 1};
    nodeAPI->setAttribute(node, NODE_DEFAULT_FOCUS, &focusValueItem);
}

void SetFocusOnTouch(ArkUI_NodeHandle &node)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue focusValue[] = {{.i32 = 1}};
    ArkUI_AttributeItem focusValueItem = {focusValue, 1};
    nodeAPI->setAttribute(node, NODE_FOCUS_ON_TOUCH, &focusValueItem);
}

void SetText(ArkUI_NodeHandle &node, const char *str, float size = DEFAULT_TEXT_FONT_SIZE)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_AttributeItem textValueItem = {.string = str};
    ArkUI_NumberValue fontSize[] = {size};
    ArkUI_AttributeItem fontItem = {fontSize, 1};
    nodeAPI->setAttribute(node, NODE_TEXT_CONTENT, &textValueItem);
    nodeAPI->setAttribute(node, NODE_TEXT_FONT, &fontItem);
}

void SetId(ArkUI_NodeHandle &node, const char *id)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_AttributeItem idItem = {.string = id};
    nodeAPI->setAttribute(node, NODE_ID, &idItem);
}

} // namespace NativeXComponentSample

#endif // DRAGANDDROP_COMMON_H