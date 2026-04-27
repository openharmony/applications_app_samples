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

#include "StyledStringBase.h"
#include "baseUtils.h"
#include <arkui/styled_string.h>
#include <cstdint>
#include <hilog/log.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_declaration.h>
#include <resourcemanager/ohresmgr.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

#define LOG_TAG "StyledStringBase"
#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, LOG_TAG, __VA_ARGS__)

static ArkUI_NodeHandle textContainer;

/**
 * @brief 设置文本标题
 * @param title 文本标题内容
 */
void StyledStringBase::SetTextTitle(ArkUI_NodeHandle container, const char* title)
{
    if (container == nullptr) {
        return;
    }
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue topMargin = {.f32 = TOP_MARGIN};
    ArkUI_NumberValue bottomMargin = {.f32 = BOTTOM_MARGIN};
    ArkUI_NumberValue noMargin = {.f32 = 0};
    ArkUI_NumberValue marginValue[] = {topMargin, noMargin, bottomMargin, noMargin};
    ArkUI_AttributeItem marginItem = {marginValue, SIZE_4};
    Manager::nodeAPI_->setAttribute(text, NODE_MARGIN, &marginItem);
    ArkUI_NumberValue width = {.f32 = STYLED_STRING_COMPONENT_WIDTH};
    ArkUI_AttributeItem widthItem = {&width, SIZE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue fontSize = {.f32 = TITLE_FONT_SIZE};
    ArkUI_AttributeItem fontSizeItem = {&fontSize, SIZE_1};
    Manager::nodeAPI_->setAttribute(text, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_AttributeItem contentItem = {.string = title};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &contentItem);

    // 将标题的文本节点添加到父容器中
    Manager::nodeAPI_->addChild(container, text);
}

void StyledStringBase::CreateStyledStringWithTextStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::StyledStringBase::SetTextTitle(node, "创建带文本样式的StyledString");

    OH_ArkUI_TextStyle *textStyle = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle, FONT_SIZE);
    OH_ArkUI_TextStyle_SetFontWeight(textStyle, ARKUI_FONT_WEIGHT_BOLD);
    OH_ArkUI_TextStyle_SetFontStyle(textStyle, ARKUI_FONT_STYLE_ITALIC);
    OH_ArkUI_TextStyle_SetFontFamily(textStyle, "sans-serif");
    OH_ArkUI_TextStyle_SetStrokeWidth(textStyle, STROKE_WIDTH);
    OH_ArkUI_TextStyle_SetStrokeColor(textStyle, COLOR_BLUE);
    OH_ArkUI_TextStyle_SetSuperscript(textStyle, OH_ARKUI_SUPERSCRIPTSTYLE_NORMAL);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle, textStyle);
    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello World", spanStyles, 1);
    func(styledString);
    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_TextStyle_Destroy(textStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithParagraphStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::StyledStringBase::SetTextTitle(node, "创建带段落样式的StyledString");
    OH_ArkUI_ParagraphStyle *paragraphStyle = OH_ArkUI_ParagraphStyle_Create();
    OH_ArkUI_ParagraphStyle_SetTextAlign(paragraphStyle, ARKUI_TEXT_ALIGNMENT_CENTER);
    OH_ArkUI_ParagraphStyle_SetTextIndent(paragraphStyle, FONT_SIZE_20);
    OH_ArkUI_ParagraphStyle_SetMaxLines(paragraphStyle, PARAGRAPH_MAX_LINES);
    OH_ArkUI_ParagraphStyle_SetOverflow(paragraphStyle, ARKUI_TEXT_OVERFLOW_ELLIPSIS);
    OH_ArkUI_ParagraphStyle_SetWordBreak(paragraphStyle, ARKUI_WORD_BREAK_NORMAL);
    OH_ArkUI_ParagraphStyle_SetParagraphSpacing(paragraphStyle, PARAGRAPH_SPACING);
    OH_ArkUI_ParagraphStyle_SetTextVerticalAlign(paragraphStyle, ARKUI_TEXT_VERTICAL_ALIGNMENT_CENTER);
    OH_ArkUI_ParagraphStyle_SetTextDirection(paragraphStyle, ARKUI_TEXT_DIRECTION_LTR);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_12);
    OH_ArkUI_SpanStyle_SetParagraphStyle(spanStyle, paragraphStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("段落样式示例", spanStyles, 1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_ParagraphStyle_Destroy(paragraphStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithDecorationStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::StyledStringBase::SetTextTitle(node, "创建带装饰样式的StyledString");

    OH_ArkUI_DecorationStyle *decorationStyle = OH_ArkUI_DecorationStyle_Create();
    OH_ArkUI_DecorationStyle_SetTextDecorationType(decorationStyle, ARKUI_TEXT_DECORATION_TYPE_UNDERLINE);
    OH_ArkUI_DecorationStyle_SetColor(decorationStyle, COLOR_RED);
    OH_ArkUI_DecorationStyle_SetTextDecorationStyle(decorationStyle, ARKUI_TEXT_DECORATION_STYLE_DOUBLE);
    OH_ArkUI_DecorationStyle_SetThicknessScale(decorationStyle, THICKNESS_SCALE);
    OH_ArkUI_DecorationStyle_SetEnableMultiType(decorationStyle, false);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_8);
    OH_ArkUI_SpanStyle_SetDecorationStyle(spanStyle, decorationStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("下划线示例", spanStyles, 1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_DecorationStyle_Destroy(decorationStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}


void StyledStringBase::CreateStyledStringWithBaselineOffsetStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带基线偏移样式的StyledString");

    OH_ArkUI_BaselineOffsetStyle *baselineOffsetStyle = OH_ArkUI_BaselineOffsetStyle_Create();
    OH_ArkUI_BaselineOffsetStyle_SetBaselineOffset(baselineOffsetStyle, BASELINE_OFFSET);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_6);
    OH_ArkUI_SpanStyle_SetBaselineOffsetStyle(spanStyle, baselineOffsetStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("基线偏移基线偏移", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_BaselineOffsetStyle_Destroy(baselineOffsetStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithLetterSpacingStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带字间距样式的StyledString");

    OH_ArkUI_LetterSpacingStyle *letterSpacingStyle = OH_ArkUI_LetterSpacingStyle_Create();
    OH_ArkUI_LetterSpacingStyle_SetLetterSpacing(letterSpacingStyle, LETTER_SPACING);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetLetterSpacingStyle(spanStyle, letterSpacingStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("字间距", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_LetterSpacingStyle_Destroy(letterSpacingStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithTextShadowStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带文本阴影样式的StyledString");

    OH_ArkUI_ShadowOptions *shadowOptions = OH_ArkUI_ShadowOptions_Create();
    OH_ArkUI_ShadowOptions_SetRadius(shadowOptions, SHADOW_RADIUS);
    OH_ArkUI_ShadowOptions_SetType(shadowOptions, ARKUI_SHADOW_TYPE_COLOR);
    OH_ArkUI_ShadowOptions_SetColor(shadowOptions, COLOR_BLUE);
    OH_ArkUI_ShadowOptions_SetOffsetX(shadowOptions, SHADOW_OFFSET);
    OH_ArkUI_ShadowOptions_SetOffsetY(shadowOptions, SHADOW_OFFSET);
    OH_ArkUI_ShadowOptions_SetFill(shadowOptions, true);

    OH_ArkUI_TextShadowStyle *textShadow = OH_ArkUI_TextShadowStyle_Create();
    const OH_ArkUI_ShadowOptions *shadowOptionsArray[] = {shadowOptions};
    OH_ArkUI_TextShadowStyle_SetTextShadow(textShadow, shadowOptionsArray, SIZE_1);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_4);
    OH_ArkUI_SpanStyle_SetTextShadowStyle(spanStyle, textShadow);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("阴影", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_TextShadowStyle_Destroy(textShadow);
    OH_ArkUI_ShadowOptions_Destroy(shadowOptions);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithBackgroundColorStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带背景色样式的StyledString");

    OH_ArkUI_BackgroundColorStyle *backgroundColorStyle = OH_ArkUI_BackgroundColorStyle_Create();
    OH_ArkUI_BackgroundColorStyle_SetColor(backgroundColorStyle, COLOR_YELLOW);
    OH_ArkUI_BackgroundColorStyle_SetRadius(backgroundColorStyle, BACKGROUND_RADIUS, BACKGROUND_RADIUS,
                                            BACKGROUND_RADIUS, BACKGROUND_RADIUS);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_4);
    OH_ArkUI_SpanStyle_SetBackgroundColorStyle(spanStyle, backgroundColorStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("背景色", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_BackgroundColorStyle_Destroy(backgroundColorStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithGestureStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带手势样式的StyledString");

    OH_ArkUI_GestureStyle *gestureStyle = OH_ArkUI_GestureStyle_Create();
    OH_ArkUI_GestureStyle_RegisterOnClickCallback(gestureStyle, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "onClick callback triggered");
    });
    OH_ArkUI_GestureStyle_RegisterOnLongPressCallback(gestureStyle, [](ArkUI_GestureEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "onLongPress callback triggered");
    });
    OH_ArkUI_GestureStyle_RegisterOnTouchCallback(gestureStyle, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "onTouch callback triggered");
    });

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_4);
    OH_ArkUI_SpanStyle_SetGestureStyle(spanStyle, gestureStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("点击我", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_GestureStyle_Destroy(gestureStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithLineHeightStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带行高样式的StyledString");

    OH_ArkUI_LineHeightStyle *lineHeightStyle = OH_ArkUI_LineHeightStyle_Create();
    OH_ArkUI_LineHeightStyle_SetLineHeight(lineHeightStyle, LINE_HEIGHT);
    OH_ArkUI_LineHeightStyle_SetLineHeightMultiple(lineHeightStyle, LINE_HEIGHT_MULTIPLE);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_10);
    OH_ArkUI_SpanStyle_SetLineHeightStyle(spanStyle, lineHeightStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("行高样式示例", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_LineHeightStyle_Destroy(lineHeightStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithLineSpacingStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带行间距样式的StyledString");

    OH_ArkUI_LineSpacingStyle *lineSpacingStyle = OH_ArkUI_LineSpacingStyle_Create();
    OH_ArkUI_LineSpacingStyle_SetLineSpacing(lineSpacingStyle, LINE_SPACING);
    OH_ArkUI_LineSpacingStyle_SetOnlyBetweenLines(lineSpacingStyle, ONLY_BETWEEN_LINES);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_12);
    OH_ArkUI_SpanStyle_SetLineSpacingStyle(spanStyle, lineSpacingStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("行间距样式示例\n段落内容", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_LineSpacingStyle_Destroy(lineSpacingStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::CreateStyledStringWithUrlStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "创建带URL样式的StyledString");

    OH_ArkUI_UrlStyle *urlStyle = OH_ArkUI_UrlStyle_Create();
    OH_ArkUI_UrlStyle_SetUrl(urlStyle, "https://www.baidu.com");

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_12);
    OH_ArkUI_SpanStyle_SetUrlStyle(spanStyle, urlStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("百度官网", spanStyles, SIZE_1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_UrlStyle_Destroy(urlStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::StyledStringBasicOperations(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "StyledString基础操作示例");

    OH_ArkUI_TextStyle *textStyle = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle, textStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello World", spanStyles, SIZE_1);

    int32_t length = 0;
    OH_ArkUI_StyledString_Descriptor_GetLength(styledString, &length);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "Length: %{public}d", length);

    char buffer[BUFFER_SIZE];
    int32_t writeLength = 0;
    OH_ArkUI_StyledString_Descriptor_GetString(styledString, buffer, BUFFER_SIZE, &writeLength);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "String: %{public}s", buffer);

    OH_ArkUI_StyledString_Descriptor_ReplaceString(styledString, 0, SPAN_LENGTH_5, "Hi");
    OH_ArkUI_StyledString_Descriptor_InsertString(styledString, SPAN_LENGTH_2, " There");
    OH_ArkUI_StyledString_Descriptor_RemoveString(styledString, SPAN_LENGTH_10, SPAN_LENGTH_2);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_TextStyle_Destroy(textStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::StyledStringStyleOperations(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "StyledString样式操作示例");

    OH_ArkUI_TextStyle *textStyle1 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle1, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle1, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle1 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle1, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle1, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle1, textStyle1);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle1};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello World", spanStyles, SIZE_1);

    OH_ArkUI_TextStyle *textStyle2 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle2, COLOR_BLUE);
    OH_ArkUI_TextStyle_SetFontSize(textStyle2, FONT_SIZE_20);

    OH_ArkUI_SpanStyle *spanStyle2 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle2, SPAN_LENGTH_6);
    OH_ArkUI_SpanStyle_SetLength(spanStyle2, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle2, textStyle2);

    OH_ArkUI_StyledString_Descriptor_SetStyle(styledString, spanStyle2);
    OH_ArkUI_StyledString_Descriptor_RemoveStyle(styledString, 0, SPAN_LENGTH_5, OH_ARKUI_STYLEDSTRINGKEY_FONT);

    auto *spanStyleGet = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle *spanStylesGet[] = {spanStyleGet, spanStyleGet};
    OH_ArkUI_SpanStyle **spanStylesGetPointer = spanStylesGet;
    uint32_t writeLength = 0;
    OH_ArkUI_StyledString_Descriptor_GetStyles(styledString, 0, SPAN_LENGTH_10 + 1, OH_ARKUI_STYLEDSTRINGKEY_FONT,
                                               spanStylesGetPointer,
                                               MAX_STYLES_TO_GET, &writeLength);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "Got %{public}d styles",
                 writeLength);

    for (uint32_t i = 0; i < writeLength; i++) {
        OH_ArkUI_SpanStyle_Destroy(spanStylesGetPointer[i]);
    }

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle1);
    OH_ArkUI_TextStyle_Destroy(textStyle1);
    OH_ArkUI_SpanStyle_Destroy(spanStyle2);
    OH_ArkUI_TextStyle_Destroy(textStyle2);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}


void StyledStringBase::StyledStringAdvancedOperations(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "StyledString高级操作示例");

    OH_ArkUI_TextStyle *textStyle1 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle1, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle1, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle1 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle1, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle1, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle1, textStyle1);

    const OH_ArkUI_SpanStyle *spanStyles1[] = {spanStyle1};
    ArkUI_StyledString_Descriptor *styledString1 =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello", spanStyles1, SIZE_1);

    OH_ArkUI_TextStyle *textStyle2 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle2, COLOR_BLUE);
    OH_ArkUI_TextStyle_SetFontSize(textStyle2, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle2 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle2, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle2, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle2, textStyle2);

    const OH_ArkUI_SpanStyle *spanStyles2[] = {spanStyle2};
    ArkUI_StyledString_Descriptor *styledString2 =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("World", spanStyles2, SIZE_1);

    OH_ArkUI_StyledString_Descriptor_AppendStyledString(styledString1, styledString2);
    OH_ArkUI_StyledString_Descriptor_InsertStyledString(styledString1, SPAN_LENGTH_5, styledString2);

    ArkUI_StyledString_Descriptor *subString = OH_ArkUI_StyledString_Descriptor_Create();
    OH_ArkUI_StyledString_Descriptor_SubStyledString(styledString1, subString, 0, SPAN_LENGTH_5);

    ArkUI_StyledString_Descriptor *styledString3 = OH_ArkUI_StyledString_Descriptor_Create();
    OH_ArkUI_StyledString_Descriptor_FromHtml(styledString3, "<span style='color: red;'>Hello</span>");

    const char *html = OH_ArkUI_ConvertToHtml(styledString1);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "HTML: %{public}s", html);
    func(styledString1);
    OH_ArkUI_SpanStyle_Destroy(spanStyle1);
    OH_ArkUI_TextStyle_Destroy(textStyle1);
    OH_ArkUI_SpanStyle_Destroy(spanStyle2);
    OH_ArkUI_TextStyle_Destroy(textStyle2);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString1);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString2);
    OH_ArkUI_StyledString_Descriptor_Destroy(subString);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString3);
}

void StyledStringBase::StyledStringComparisonAndSerialization(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "StyledString比较和序列化示例");

    OH_ArkUI_TextStyle *textStyle = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle, textStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString1 =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello", spanStyles, SIZE_1);

    ArkUI_StyledString_Descriptor *styledString2 =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello", spanStyles, SIZE_1);

    bool isEqual = false;
    OH_ArkUI_StyledString_Descriptor_IsEqual(styledString1, styledString2, &isEqual);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "Is equal: %{public}d", isEqual);

    uint8_t buffer[MARSHAL_BUFFER_SIZE];
    size_t resultSize = 0;
    int32_t errorCode = OH_ArkUI_MarshallStyledStringDescriptor(buffer, MARSHAL_BUFFER_SIZE,
                                                                styledString1, &resultSize);
    if (errorCode == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "Marshaled size: %{public}zu",
                     resultSize);
        ArkUI_StyledString_Descriptor *unmarshaledString = OH_ArkUI_StyledString_Descriptor_Create();
        errorCode = OH_ArkUI_UnmarshallStyledStringDescriptor(buffer, resultSize, unmarshaledString);
        if (errorCode == ARKUI_ERROR_CODE_NO_ERROR) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                         "Unmarshalled successfully");
            func(unmarshaledString);
        }
    }

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_TextStyle_Destroy(textStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString1);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString2);
}

void StyledStringBase::StyledStringCustomSpan(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "CustomSpan示例");

    auto onMeasure = [](float fontSize) -> ArkUI_CustomSpanMetrics* {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN_COLOR, "TextEditorMaker", "onMeasure fontSize:%{public}f",
                     fontSize);
        ArkUI_CustomSpanMetrics *customSpanMetrics = OH_ArkUI_CustomSpanMetrics_Create();
        OH_ArkUI_CustomSpanMetrics_SetHeight(customSpanMetrics, CUSTOM_SPAN_HEIGHT);
        OH_ArkUI_CustomSpanMetrics_SetWidth(customSpanMetrics, CUSTOM_SPAN_WIDTH);
        return customSpanMetrics;
    };
    auto onDraw = [](ArkUI_DrawContext *context, ArkUI_CustomSpanDrawInfo *drawInfo) -> void {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN_COLOR, "TextEditorMaker", "onDraw");
        if (context == nullptr || drawInfo == nullptr) {
            return;
        }
        float xOffset = OH_ArkUI_CustomSpanDrawInfo_GetXOffset(drawInfo);
        float lineTop = OH_ArkUI_CustomSpanDrawInfo_GetLineTop(drawInfo);
        float lineBottom = OH_ArkUI_CustomSpanDrawInfo_GetLineBottom(drawInfo);
        float baseline = OH_ArkUI_CustomSpanDrawInfo_GetBaseline(drawInfo);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN_COLOR, "TextEditorMaker",
                     "onDraw xOffset: %{public}f lineTop: %{public}f lineBottom: %{public}f baseline: %{public}f",
                     xOffset, lineTop, lineBottom, baseline);
        auto *canvas = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(context));
        if (canvas == nullptr) {
            return;
        }
        OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
        OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0x00, 0x00));
        OH_Drawing_PenSetWidth(pen, PEN_WIDTH);
        OH_Drawing_CanvasAttachPen(canvas, pen);
        OH_Drawing_Rect *rect = OH_Drawing_RectCreate(RECT_START, RECT_START, RECT_END, RECT_END);
        OH_Drawing_CanvasDrawRect(canvas, rect);
        OH_Drawing_CanvasDetachPen(canvas);
    };
    OH_ArkUI_CustomSpan *style = OH_ArkUI_CustomSpan_Create();
    OH_ArkUI_CustomSpan_RegisterOnMeasureCallback(style, onMeasure);
    void (*onDraw1)(ArkUI_DrawContext *, ArkUI_CustomSpanDrawInfo *) = onDraw;
    OH_ArkUI_CustomSpan_RegisterOnDrawCallback(style, onDraw1);
    ArkUI_StyledString_Descriptor *styledString = OH_ArkUI_StyledString_Descriptor_CreateWithCustomSpan(style);
    func(styledString);
}

void StyledStringBase::StyledStringImageAttachment(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "ImageAttachment示例");

    uint8_t data[PIXELMAP_DATA_SIZE];
    size_t dataSize = PIXELMAP_DATA_SIZE;
    for (int i = 0; i < dataSize; i++) {
        data[i] = i + 1;
    }
    OH_Pixelmap_InitializationOptions *createOpts;
    OH_PixelmapInitializationOptions_Create(&createOpts);
    OH_PixelmapInitializationOptions_SetWidth(createOpts, static_cast<uint32_t>(PIXELMAP_WIDTH));
    OH_PixelmapInitializationOptions_SetHeight(createOpts, static_cast<uint32_t>(PIXELMAP_HEIGHT));
    OH_PixelmapInitializationOptions_SetPixelFormat(createOpts, PIXEL_FORMAT_BGRA_8888);
    OH_PixelmapInitializationOptions_SetAlphaType(createOpts, PIXELMAP_ALPHA_TYPE_UNKNOWN);
    OH_PixelmapNative *pixelmap = nullptr;
    OH_PixelmapNative_CreatePixelmap(data, dataSize, createOpts, &pixelmap);
    OH_PixelmapNative_Opacity(pixelmap, IMAGE_ATTACHMENT_OPACITY);
    OH_ArkUI_ImageAttachment *arkUI_ImageAttachment = OH_ArkUI_ImageAttachment_Create();
    OH_ArkUI_ImageAttachment_SetPixelMap(arkUI_ImageAttachment, pixelmap);
    OH_ArkUI_ImageAttachment_SetSizeWidth(arkUI_ImageAttachment, static_cast<int32_t>(IMAGE_ATTACHMENT_SIZE));
    OH_ArkUI_ImageAttachment_SetSizeHeight(arkUI_ImageAttachment, static_cast<int32_t>(IMAGE_ATTACHMENT_SIZE));
    OH_ArkUI_ImageAttachment_SetVerticalAlign(arkUI_ImageAttachment,
                                              ArkUI_ImageSpanAlignment::ARKUI_IMAGE_SPAN_ALIGNMENT_BASELINE);
    float matrix[COLOR_MATRIX_SIZE] = {COLOR_FILTER_RED, 0, 0, 0, 0, 0,
        COLOR_FILTER_RED, 0, 0, 0, 0, 0, COLOR_FILTER_BLUE,
        COLOR_FILTER_BLUE, 0, 0, 0, COLOR_FILTER_ALPHA, COLOR_FILTER_ALPHA, 0};
    float *ptr = matrix;
    OH_ArkUI_ImageAttachment_SetColorFilter(arkUI_ImageAttachment, ptr, static_cast<uint32_t>(COLOR_MATRIX_SIZE));

    OH_Drawing_ColorFilter *colorFilter = OH_Drawing_ColorFilterCreateMatrix(matrix);
    OH_ArkUI_ImageAttachment_SetDrawingColorFilter(arkUI_ImageAttachment, colorFilter);

    OH_ArkUI_ImageAttachment_SetObjectFit(arkUI_ImageAttachment, ArkUI_ObjectFit::ARKUI_OBJECT_FIT_AUTO);
    OH_ArkUI_ImageAttachment_SetMargin(arkUI_ImageAttachment, {IMAGE_ATTACHMENT_MARGIN, IMAGE_ATTACHMENT_MARGIN,
                                                               IMAGE_ATTACHMENT_MARGIN, IMAGE_ATTACHMENT_MARGIN});
    OH_ArkUI_ImageAttachment_SetPadding(arkUI_ImageAttachment, {IMAGE_ATTACHMENT_PADDING, IMAGE_ATTACHMENT_PADDING,
                                                                IMAGE_ATTACHMENT_PADDING, IMAGE_ATTACHMENT_PADDING});
    OH_ArkUI_ImageAttachment_SetBorderRadiuses(arkUI_ImageAttachment, IMAGE_ATTACHMENT_BORDER_RADIUS,
                                               IMAGE_ATTACHMENT_BORDER_RADIUS, IMAGE_ATTACHMENT_BORDER_RADIUS,
                                               IMAGE_ATTACHMENT_BORDER_RADIUS);
    OH_ArkUI_ImageAttachment_SetSyncLoad(arkUI_ImageAttachment, true);
    OH_ArkUI_ImageAttachment_SetSupportSvg(arkUI_ImageAttachment, true);
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithImageAttachment(arkUI_ImageAttachment);

    func(styledString);
}

void StyledStringBase::StyledStringClearStyles(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "StyledString清除样式示例");

    OH_ArkUI_TextStyle *textStyle = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle, textStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello World", spanStyles, SIZE_1);

    OH_ArkUI_StyledString_Descriptor_ClearStyles(styledString);

    func(styledString);
    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_TextStyle_Destroy(textStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::StyledStringUserDataSpan(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "UserDataSpan示例");

    OH_ArkUI_UserDataSpan *userDataSpan = OH_ArkUI_UserDataSpan_Create();

    const char *customData = "Custom User Data";
    OH_ArkUI_UserDataSpan_SetUserData(userDataSpan, (void *)customData);

    void *retrievedData = nullptr;
    OH_ArkUI_UserDataSpan_GetUserData(userDataSpan, &retrievedData);

    if (retrievedData != nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "Retrieved data: %{public}s",
                     (char *)retrievedData);
    }

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetUserDataSpan(spanStyle, userDataSpan);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello", spanStyles, SIZE_1);
    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_UserDataSpan_Destroy(userDataSpan);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::StyledStringReplaceStyle(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "ReplaceStyle示例");

    OH_ArkUI_TextStyle *textStyle1 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle1, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle1, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle1 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle1, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle1, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle1, textStyle1);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle1};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello World", spanStyles, SIZE_1);

    OH_ArkUI_TextStyle *textStyle2 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle2, COLOR_BLUE);
    OH_ArkUI_TextStyle_SetFontSize(textStyle2, FONT_SIZE_20);

    OH_ArkUI_SpanStyle *spanStyle2 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle2, SPAN_LENGTH_6);
    OH_ArkUI_SpanStyle_SetLength(spanStyle2, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle2, textStyle2);

    ArkUI_ErrorCode errorCode = OH_ArkUI_StyledString_Descriptor_ReplaceStyle(styledString, spanStyle2);
    if (errorCode == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker", "ReplaceStyle succeeded");
    }
    func(styledString);
    OH_ArkUI_SpanStyle_Destroy(spanStyle1);
    OH_ArkUI_TextStyle_Destroy(textStyle1);
    OH_ArkUI_SpanStyle_Destroy(spanStyle2);
    OH_ArkUI_TextStyle_Destroy(textStyle2);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}

void StyledStringBase::StyledStringReplaceStyledString(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "ReplaceStyledString示例");

    OH_ArkUI_TextStyle *textStyle1 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle1, COLOR_RED);
    OH_ArkUI_TextStyle_SetFontSize(textStyle1, FONT_SIZE_16);

    OH_ArkUI_SpanStyle *spanStyle1 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle1, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle1, SPAN_LENGTH_5);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle1, textStyle1);

    const OH_ArkUI_SpanStyle *spanStyles1[] = {spanStyle1};
    ArkUI_StyledString_Descriptor *styledString1 =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Hello World", spanStyles1, SIZE_1);

    OH_ArkUI_TextStyle *textStyle2 = OH_ArkUI_TextStyle_Create();
    OH_ArkUI_TextStyle_SetFontColor(textStyle2, COLOR_BLUE);
    OH_ArkUI_TextStyle_SetFontSize(textStyle2, FONT_SIZE_18);

    OH_ArkUI_SpanStyle *spanStyle2 = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle2, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle2, SPAN_LENGTH_6);
    OH_ArkUI_SpanStyle_SetTextStyle(spanStyle2, textStyle2);

    const OH_ArkUI_SpanStyle *spanStyles2[] = {spanStyle2};
    ArkUI_StyledString_Descriptor *styledString2 =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("Harmony", spanStyles2, SIZE_1);
    ArkUI_ErrorCode errorCode =
        OH_ArkUI_StyledString_Descriptor_ReplaceStyledString(styledString1, 6, SPAN_LENGTH_5, styledString2);
    if (errorCode == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TextEditorMaker",
                     "ReplaceStyledString succeeded");
    }
    func(styledString1);

    OH_ArkUI_SpanStyle_Destroy(spanStyle1);
    OH_ArkUI_TextStyle_Destroy(textStyle1);
    OH_ArkUI_SpanStyle_Destroy(spanStyle2);
    OH_ArkUI_TextStyle_Destroy(textStyle2);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString1);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString2);
}

void StyledStringBase::ParagraphStyleCallback(ArkUI_NodeHandle node, BindDescriptorFunc &&func)
{
    StyledStringBase::SetTextTitle(node, "ParagraphStyle段落样式回调示例");

    OH_ArkUI_ParagraphStyle *paragraphStyle = OH_ArkUI_ParagraphStyle_Create();
    OH_ArkUI_ParagraphStyle_SetTextAlign(paragraphStyle, ARKUI_TEXT_ALIGNMENT_CENTER);

    OH_ArkUI_ParagraphStyle_RegisterOnDrawLeadingMarginCallback(
        paragraphStyle, [](ArkUI_DrawContext *context, OH_ArkUI_LeadingMarginSpanDrawInfo *drawInfo) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "StyledStringMaker", "OnDrawLeadingMarginCallback");
        });

    OH_ArkUI_ParagraphStyle_RegisterOnGetLeadingMarginCallback(paragraphStyle, []() -> float {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "StyledStringMaker", "OnGetLeadingMarginCallback");
        return LEADING_MARGIN_CALL_BACK_RETURN_VALUE;
    });

    OH_ArkUI_SpanStyle *spanStyle = OH_ArkUI_SpanStyle_Create();
    OH_ArkUI_SpanStyle_SetStart(spanStyle, 0);
    OH_ArkUI_SpanStyle_SetLength(spanStyle, SPAN_LENGTH_10);
    OH_ArkUI_SpanStyle_SetParagraphStyle(spanStyle, paragraphStyle);

    const OH_ArkUI_SpanStyle *spanStyles[] = {spanStyle};
    ArkUI_StyledString_Descriptor *styledString =
        OH_ArkUI_StyledString_Descriptor_CreateWithString("高级段落样式高级段落样式", spanStyles, 1);

    func(styledString);

    OH_ArkUI_SpanStyle_Destroy(spanStyle);
    OH_ArkUI_ParagraphStyle_Destroy(paragraphStyle);
    OH_ArkUI_StyledString_Descriptor_Destroy(styledString);
}