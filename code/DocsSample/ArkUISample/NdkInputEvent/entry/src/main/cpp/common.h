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

#ifndef DRAGANDDROP_COMMON_H
#define DRAGANDDROP_COMMON_H

#include "container.h"
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <sstream>
#include <hilog/log.h>

#define DEFAULT_WIDTH 200.0
#define DEFAULT_HEIGHT 200.0
#define DEFAULT_BG_COLOR 0xFFFFFFFF
#define DEFAULT_BORDER_WIDTH 0.0
#define BORDER_WIDTH_1 1.0
#define DEFAULT_MARGIN 5.0
#define DEFAULT_BORDER_COLOR 0xFF000000
#define DEFAULT_RADIUS 10.0

#define BUTTON_WIDTH_S 0.3
#define BUTTON_WIDTH_L 0.55

#define SIZE_50 50
#define SIZE_80 80
#define SIZE_100 100
#define SIZE_300 300
#define BLANK_10 10.0

#define DEFAULT_TEXT_FONT_SIZE 12
#define TEXT_FONT_SIZE_15 15
#define TEXT_FONT_SIZE_20 20

#define BUTTON_LENGTH 10
#define MAX_LENGTH 128

namespace NativeXComponentSample {

ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
ArkUI_ContextHandle context;

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

void SetBackgroundColor(ArkUI_NodeHandle &node, uint32_t color = DEFAULT_BG_COLOR)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue colorValue[] = {{.u32 = color}};
    ArkUI_AttributeItem colorItem = {colorValue, 1};
    nodeAPI->setAttribute(node, NODE_BACKGROUND_COLOR, &colorItem);
}

void SetMargin(ArkUI_NodeHandle &node, float margin = DEFAULT_MARGIN)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue marginValue[] = {margin};
    ArkUI_AttributeItem marginItem = {marginValue, 1};
    nodeAPI->setAttribute(node, NODE_MARGIN, &marginItem);
}

void SetPadding(ArkUI_NodeHandle &node, float padding)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue paddingValue[] = {padding};
    ArkUI_AttributeItem paddingItem = {paddingValue, 1};
    nodeAPI->setAttribute(node, NODE_PADDING, &paddingItem);
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

void SetBorderColor(ArkUI_NodeHandle &node, uint32_t color = DEFAULT_BORDER_COLOR)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue borderColorValue[] = {{.u32 = color}};
    ArkUI_AttributeItem borderColorItem = {borderColorValue, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_COLOR, &borderColorItem);
}

void SetBorderStyle(ArkUI_NodeHandle &node, int32_t style = ARKUI_BORDER_STYLE_DASHED, float radius = 10.0)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue borderStyleValue[] = {{.i32 = style}};
    ArkUI_AttributeItem borderStyleItem = {borderStyleValue, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_STYLE, &borderStyleItem);

    ArkUI_NumberValue borderRadiusValue[] = {{.f32 = radius}};
    ArkUI_AttributeItem borderRadiusItem = {borderRadiusValue, 1};
    nodeAPI->setAttribute(node, NODE_BORDER_RADIUS, &borderRadiusItem);
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

void SetCommonAttribute(ArkUI_NodeHandle &node, float width = DEFAULT_WIDTH, float height = DEFAULT_HEIGHT,
    unsigned int color = DEFAULT_BG_COLOR, float margin = DEFAULT_MARGIN)
{
    SetWidth(node, width);
    SetHeight(node, height);
    SetBackgroundColor(node, color);
    SetMargin(node, margin);
    SetBorderWidth(node, DEFAULT_BORDER_WIDTH);
    SetBorderColor(node);
}

void SetCommonPercentAttribute(ArkUI_NodeHandle &node, float width = 1, float height = 1,
    unsigned int color = DEFAULT_BG_COLOR, float margin = DEFAULT_MARGIN)
{
    SetWidthPercent(node, width);
    SetHeightPercent(node, height);
    SetBackgroundColor(node, color);
    SetMargin(node, margin);
    SetBorderWidth(node, DEFAULT_BORDER_WIDTH);
    SetBorderColor(node);
}

void SetTextAttribute(ArkUI_NodeHandle &node, const char *str, float size = DEFAULT_TEXT_FONT_SIZE,
    float width = DEFAULT_WIDTH, float height = DEFAULT_HEIGHT)
{
    SetCommonAttribute(node, width, height, 0);
    SetText(node, str, size);
}

void SetColumnJustifyContent(ArkUI_NodeHandle &node, int32_t alignment)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue justifyValue[] = {{.i32 = alignment}};
    ArkUI_AttributeItem justifyItem = {justifyValue, 1};
    nodeAPI->setAttribute(node, NODE_COLUMN_JUSTIFY_CONTENT, &justifyItem);
}

void SetColumnAlignItem(ArkUI_NodeHandle &node, int32_t alignment)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue alignValue[] = {{.i32 = alignment}};
    ArkUI_AttributeItem alignItem = {alignValue, 1};
    nodeAPI->setAttribute(node, NODE_COLUMN_ALIGN_ITEMS, &alignItem);
}

void SetRowJustifyContent(ArkUI_NodeHandle &node, int32_t alignment)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue justifyValue[] = {{.i32 = alignment}};
    ArkUI_AttributeItem justifyItem = {justifyValue, 1};
    nodeAPI->setAttribute(node, NODE_ROW_JUSTIFY_CONTENT, &justifyItem);
}

void SetRowAlignItem(ArkUI_NodeHandle &node, int32_t alignment)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue alignValue[] = {{.i32 = alignment}};
    ArkUI_AttributeItem alignItem = {alignValue, 1};
    nodeAPI->setAttribute(node, NODE_ROW_ALIGN_ITEMS, &alignItem);
}

void SetHitTestMode(ArkUI_NodeHandle &node, int32_t mode)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_NumberValue modeValue[] = {{.i32 = mode}};
    ArkUI_AttributeItem modeItem = {modeValue, 1};
    nodeAPI->setAttribute(node, NODE_HIT_TEST_BEHAVIOR, &modeItem);
}

void SetButtonLabel(ArkUI_NodeHandle &node, const char *label)
{
    if (!nodeAPI) {
        return;
    }
    ArkUI_AttributeItem NODE_Button_SRC_Item = {.string = label};
    nodeAPI->setAttribute(node, NODE_BUTTON_LABEL, &NODE_Button_SRC_Item);
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