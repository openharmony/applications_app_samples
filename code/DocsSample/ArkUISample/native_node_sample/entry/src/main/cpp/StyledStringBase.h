/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef NATIVE_NODE_SAMPLE_STYLEDSTRINGBASE_H
#define NATIVE_NODE_SAMPLE_STYLEDSTRINGBASE_H

#include "manager.h"
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_color_filter.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

// ===== 常量定义 =====
constexpr int32_t SIZE_1 = 1;
constexpr int32_t SIZE_4 = 4;
constexpr float COLUMN_WIDTH = 400.0f;
constexpr float PLACEHOLDER_FONT_SIZE = 10.0f;
constexpr float TITLE_FONT_SIZE = 14.0f;
constexpr uint32_t PLACEHOLDER_FONT_WEIGHT = 1;
constexpr float STYLED_STRING_COMPONENT_BORDER_WIDTH = 1.0f;
constexpr float STYLED_STRING_COMPONENT_WIDTH = 300.0f;
constexpr uint32_t COLOR_RED = 0xFFFF0000;
constexpr float TOP_MARGIN = 20.0f;
constexpr float BOTTOM_MARGIN = 10.0f;
constexpr int32_t MAX_LINES = 4;
constexpr float THICKNESS_SCALE = 2.0f;
constexpr int32_t DATA_DETECTOR_TYPE_NUM = 2;
constexpr uint32_t DATA_DETECTOR_COLOR = 0xFF0000FF;
constexpr float CUSTOM_KEYBOARD_HEIGHT = 300.0f;
constexpr float MENU_ITEM_WIDTH = 100.0f;
constexpr float MENU_ITEM_HEIGHT = 50.0f;
constexpr float SINGLE_LINE_EDITOR_HEIGHT = 40.0f;
constexpr int32_t MAX_LENGTH = 40;
constexpr float BUTTON_WIDTH = 100.0f;
constexpr float BUTTON_HEIGHT = 40.0f;
constexpr float FONT_SIZE = 20.0f;
constexpr uint32_t FONT_WEIGHT = 1;
constexpr uint32_t DECORATION_COLOR = 0xFF00FFFF;
constexpr float SHADOW_RADIUS = 5.0f;
constexpr uint32_t SHADOW_COLOR = 0xFF0000FF;
constexpr float SHADOW_OFFSET_X = 1.0f;
constexpr float SHADOW_OFFSET_Y = 2.0f;
constexpr int32_t SHADOW_NUM = 2;
constexpr int32_t LINE_HEIGHT = 10;
constexpr int32_t LINE_HEIGHT_MULTIPLE = 2;
constexpr int32_t LINE_SPACING = 30;
constexpr bool ONLY_BETWEEN_LINES = true;
constexpr int32_t LETTER_SPACING = 9;
constexpr uint32_t TEXT_STYLE_BG_COLOR = 0xFF00FF00;
constexpr float TEXT_STYLE_BG_RADIUS_TL = 10.0f;
constexpr float TEXT_STYLE_BG_RADIUS_TR = 15.0f;
constexpr float TEXT_STYLE_BG_RADIUS_BL = 20.0f;
constexpr float TEXT_STYLE_BG_RADIUS_BR = 25.0f;
constexpr int32_t FONT_FAMILY_LENGTH = 9;
constexpr int32_t FONT_FEATURE_LENGTH = 21;
constexpr int32_t PIXEL_MAP_LENGTH = 960000;
constexpr int32_t PIXEL_LENGTH = 4;
constexpr int32_t COLOR_INDEX_1 = 1;
constexpr int32_t COLOR_INDEX_2 = 2;
constexpr int32_t COLOR_INDEX_3 = 3;
constexpr uint8_t COLOR_255 = uint8_t(255);
constexpr uint32_t PIXEL_WIDTH = 200.0f;
constexpr uint32_t PIXEL_HEIGHT = 200.0f;
constexpr float PIXEL_OPACITY = 0.8f;
constexpr uint32_t LEADING_MARGIN_WIDTH = 10;
constexpr uint32_t LEADING_MARGIN_HEIGHT = 10;
constexpr int32_t PREVIEW_TEXT_BUFFER_LEN = 100;
constexpr double GLYPH_DX = 30.0;
constexpr double GLYPH_DY = 20.0;
constexpr int32_t RECTS_FOR_RANGE_END = 100;
constexpr uint32_t SELECT_END = 2;
constexpr uint32_t PARAGRAPH_SPACING = 5;
constexpr int32_t MENU_ITEM_INDEX = 2;
constexpr int32_t MENU_ITEM_BUFFER = 20;
constexpr int32_t MENU_ITEM_ID_111 = 111;
constexpr int32_t MENU_ITEM_ID_120 = 120;
constexpr float TEXT_EDITOR_HEIGHT = 100.0f;

constexpr uint32_t COLOR_BLUE = 0xFF0000FF;
constexpr uint32_t COLOR_GREEN = 0xFF00FF00;
constexpr uint32_t COLOR_YELLOW = 0xFFFFFF00;
constexpr uint32_t COLOR_BLACK = 0xFF000000;

constexpr int32_t EVENT_ON_WILL_CHANGE = 1;
constexpr int32_t EVENT_ON_DID_CHANGE = 2;

constexpr int32_t BUFFER_SIZE = 256;
constexpr int32_t LOG_DOMAIN_COLOR = 0xFF00;
constexpr int32_t MARSHAL_BUFFER_SIZE = 1024;
constexpr int32_t PIXELMAP_DATA_SIZE = 960000;

constexpr float FONT_SIZE_16 = 16.0f;
constexpr float FONT_SIZE_18 = 18.0f;
constexpr float FONT_SIZE_20 = 20.0f;
constexpr float FONT_SIZE_30 = 30.0f;

constexpr float STROKE_WIDTH = 1.0f;
constexpr float SHADOW_OFFSET = 2.0f;
constexpr float BACKGROUND_RADIUS = 5.0f;
constexpr float BASELINE_OFFSET = 20.0f;
constexpr float CUSTOM_SPAN_HEIGHT = 120.0f;
constexpr float CUSTOM_SPAN_WIDTH = 80.0f;
constexpr float PEN_WIDTH = 20.0f;
constexpr float RECT_START = 100.0f;
constexpr float RECT_END = 400.0f;
constexpr float IMAGE_ATTACHMENT_SIZE = 120.0f;
constexpr float IMAGE_ATTACHMENT_OPACITY = 0.1f;
constexpr float PIXELMAP_WIDTH = 200.0f;
constexpr float PIXELMAP_HEIGHT = 200.0f;
constexpr float COLOR_FILTER_RED = 3.0f;

constexpr float COLOR_FILTER_BLUE = 0.5f;
constexpr float COLOR_FILTER_ALPHA = 0.5f;
constexpr int32_t IMAGE_ATTACHMENT_MARGIN = 15;
constexpr int32_t IMAGE_ATTACHMENT_PADDING = 5;
constexpr int32_t IMAGE_ATTACHMENT_BORDER_RADIUS = 25;
constexpr int32_t COLOR_MATRIX_SIZE = 20;

constexpr int32_t SPAN_LENGTH_2 = 2;
constexpr int32_t SPAN_LENGTH_4 = 4;
constexpr int32_t SPAN_LENGTH_5 = 5;
constexpr int32_t SPAN_LENGTH_6 = 6;
constexpr int32_t SPAN_LENGTH_8 = 8;
constexpr int32_t SPAN_LENGTH_10 = 10;
constexpr int32_t SPAN_LENGTH_12 = 12;

constexpr int32_t PARAGRAPH_MAX_LINES = 3;

constexpr int32_t MAX_STYLES_TO_GET = 2;

constexpr int32_t INDEX_0 = 0;
constexpr int32_t INDEX_1 = 1;
constexpr int32_t INDEX_2 = 2;
constexpr int32_t INDEX_3 = 3;

constexpr float LEADING_MARGIN_CALL_BACK_RETURN_VALUE = 10.0f;

using BindDescriptorFunc = std::function<void(ArkUI_StyledString_Descriptor*& )>;

class StyledStringBase {
public:
    StyledStringBase(){};
    ~StyledStringBase(){};
    static void SetTextTitle(ArkUI_NodeHandle node, const char *title);
    static void CreateStyledStringWithTextStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithParagraphStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithParagraphStyle2(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithParagraphStyle3(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithDecorationStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithBaselineOffsetStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithLetterSpacingStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithTextShadowStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithBackgroundColorStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithGestureStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithLineHeightStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithLineSpacingStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void CreateStyledStringWithUrlStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);

    static void StyledStringBasicOperations(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringStyleOperations(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringAdvancedOperations(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringComparisonAndSerialization(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringCustomSpan(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringImageAttachment(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringClearStyles(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringUserDataSpan(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringReplaceStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void StyledStringReplaceStyledString(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void ParagraphStyleCallback(ArkUI_NodeHandle node, BindDescriptorFunc &&func);
    static void SetStyledString(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
    {
        CreateStyledStringWithTextStyle(node, std::move(func));
        CreateStyledStringWithParagraphStyle(node, std::move(func));
        CreateStyledStringWithParagraphStyle2(node, std::move(func));
        CreateStyledStringWithParagraphStyle3(node, std::move(func));
        CreateStyledStringWithDecorationStyle(node, std::move(func));
        CreateStyledStringWithBaselineOffsetStyle(node, std::move(func));
        CreateStyledStringWithLetterSpacingStyle(node, std::move(func));
        CreateStyledStringWithTextShadowStyle(node, std::move(func));
        CreateStyledStringWithBackgroundColorStyle(node, std::move(func));
        CreateStyledStringWithGestureStyle(node, std::move(func));
        CreateStyledStringWithLineHeightStyle(node, std::move(func));
        CreateStyledStringWithLineSpacingStyle(node, std::move(func));
        CreateStyledStringWithUrlStyle(node, std::move(func));
        StyledStringBasicOperations(node, std::move(func));
        StyledStringStyleOperations(node, std::move(func));
        StyledStringAdvancedOperations(node, std::move(func));
        StyledStringComparisonAndSerialization(node, std::move(func));
        StyledStringCustomSpan(node, std::move(func));
        StyledStringImageAttachment(node, std::move(func));
        StyledStringClearStyles(node, std::move(func));
        StyledStringUserDataSpan(node, std::move(func));
        StyledStringReplaceStyle(node, std::move(func));
        StyledStringReplaceStyledString(node, std::move(func));
        ParagraphStyleCallback(node, std::move(func));
    }
};

#endif // NATIVE_NODE_SAMPLE_STYLEDSTRINGBASE_H
