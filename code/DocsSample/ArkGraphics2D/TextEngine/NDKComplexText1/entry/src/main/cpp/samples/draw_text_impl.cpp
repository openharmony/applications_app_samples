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

#include "common/log_common.h"
#include "sample_bitmap.h"

#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_point.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_register_font.h>
#include <native_drawing/drawing_shader_effect.h>
#include <native_drawing/drawing_text_blob.h>
#include <native_drawing/drawing_text_global.h>
#include <native_drawing/drawing_text_line.h>
#include <native_drawing/drawing_text_lineTypography.h>
#include <native_drawing/drawing_text_run.h>
#include <native_drawing/drawing_text_typography.h>

constexpr double TWENTY_DOUBLE = 20.0;
constexpr double TEN_DOUBLE = 10.0;
constexpr double FIVE_DOUBLE = 5.0;
constexpr double FOUR_DOUBLE = 4.0;
constexpr double TWO_DOUBLE = 2.0;
constexpr int TWO_INT = 2;
constexpr double DIV_TWENTY(double size) { return size / TWENTY_DOUBLE; }
constexpr double DIV_TEN(double size) { return size / TEN_DOUBLE; }
constexpr double DIV_FIVE(double size) { return size / FIVE_DOUBLE; }
constexpr double DIV_FOUR(double size) { return size / FOUR_DOUBLE; }
constexpr double DIV_TWO(double size) { return size / TWO_DOUBLE; }

void SampleBitMap::DrawMultilingualText()
{
    // [Start complex_text_c_multilingual_text]
    // 创建一个 TypographyStyle，创建 TypographyCreate 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置 locale 为中文
    OH_Drawing_SetTypographyTextLocale(typoStyle, "zh-Hans");

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 将之前创建的 TextStyle 加入 handler 中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 设置文本内容，并将文本添加到 handler 中
    const char *text = "你好，中文\n";
    OH_Drawing_TypographyHandlerAddText(handler, text);

    // 通过 handler 创建一个 Typography
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_multilingual_text]
}

void SampleBitMap::DrawBreakAllText()
{
    // [Start complex_text_c_break_all_text]
    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TWENTY(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 设置文本内容
    const char *text =
        "Nunc quis augue viverra, venenatis arcu eu, gravida odio. Integer posuere nisi quis ex pretium, a dapibus "
        "nisl gravida. Mauris lacinia accumsan enim, non tempus ligula. Mauris iaculis dui eu nisi tristique, in porta "
        "urna varius. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris "
        "congue nibh mi, vel ultrices ex volutpat et. Aliquam consectetur odio in libero tristique, a mattis ex "
        "mollis. Praesent et nisl iaculis, facilisis metus nec, faucibus lacus. Duis nec dolor at nibh eleifend "
        "tempus. Nunc et enim interdum, commodo eros ac, pretium sapien. Pellentesque laoreet orci a nunc pharetra "
        "pharetra.";

    // 创建一个断词策略为 BREAK_ALL 的 TypographyStyle
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置断词策略为 WORD_BREAK_TYPE_BREAK_ALL
    OH_Drawing_SetTypographyTextWordBreakType(typoStyle, OH_Drawing_WordBreakType::WORD_BREAK_TYPE_BREAK_ALL);
    // 设置最大行数为 10，行数大于 10 的部分不显示
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 10);

    // 使用之前创建的 FontCollection 和 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_break_all_text]
}

void SampleBitMap::DrawBreakWordText()
{
    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TWENTY(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 设置文本内容
    const char *text =
        "Nunc quis augue viverra, venenatis arcu eu, gravida odio. Integer posuere nisi quis ex pretium, a dapibus "
        "nisl gravida. Mauris lacinia accumsan enim, non tempus ligula. Mauris iaculis dui eu nisi tristique, in porta "
        "urna varius. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris "
        "congue nibh mi, vel ultrices ex volutpat et. Aliquam consectetur odio in libero tristique, a mattis ex "
        "mollis. Praesent et nisl iaculis, facilisis metus nec, faucibus lacus. Duis nec dolor at nibh eleifend "
        "tempus. Nunc et enim interdum, commodo eros ac, pretium sapien. Pellentesque laoreet orci a nunc pharetra "
        "pharetra.";

    // 创建一个断词策略为 BREAK_WORD 的 TypographyStyle
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // [Start complex_text_c_break_word_text]
    // 设置断词策略为 WORD_BREAK_TYPE_BREAK_WORD
    OH_Drawing_SetTypographyTextWordBreakType(typoStyle, OH_Drawing_WordBreakType::WORD_BREAK_TYPE_BREAK_WORD);
    // [End complex_text_c_break_word_text]
    // 设置最大行数为 10，行数大于 10 的部分不显示
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 10);

    // 使用之前创建的 FontCollection 和 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

void SampleBitMap::DrawBreakHyphenText()
{
    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TWENTY(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 设置文本内容
    const char *text =
        "Nunc quis augue viverra, venenatis arcu eu, gravida odio. Integer posuere nisi quis ex pretium, a dapibus "
        "nisl gravida. Mauris lacinia accumsan enim, non tempus ligula. Mauris iaculis dui eu nisi tristique, in porta "
        "urna varius. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris "
        "congue nibh mi, vel ultrices ex volutpat et. Aliquam consectetur odio in libero tristique, a mattis ex "
        "mollis. Praesent et nisl iaculis, facilisis metus nec, faucibus lacus. Duis nec dolor at nibh eleifend "
        "tempus. Nunc et enim interdum, commodo eros ac, pretium sapien. Pellentesque laoreet orci a nunc pharetra "
        "pharetra.";

    // 创建一个断词策略为 BREAK_HYPHEN 的 TypographyStyle
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_LEFT);
    // [Start complex_text_c_break_hyphen_text]
    // 设置断词策略为 WORD_BREAK_TYPE_BREAK_HYPHEN
    OH_Drawing_SetTypographyTextWordBreakType(typoStyle, OH_Drawing_WordBreakType::WORD_BREAK_TYPE_BREAK_HYPHEN);
    // [End complex_text_c_break_hyphen_text]
    // 设置最大行数为 10，行数大于 10 的部分不显示
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 10);

    // 使用之前创建的 FontCollection 和 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

void SampleBitMap::DrawBreakHyphenGBText()
{
    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TWENTY(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 设置文本内容
    const char *text =
        "Nunc quis augue viverra, venenatis arcu eu, gravida odio. Integer posuere nisi quis ex pretium, a dapibus "
        "nisl gravida. Mauris lacinia accumsan enim, non tempus ligula. Mauris iaculis dui eu nisi tristique, in porta "
        "urna varius. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris "
        "congue nibh mi, vel ultrices ex volutpat et. Aliquam consectetur odio in libero tristique, a mattis ex "
        "mollis. Praesent et nisl iaculis, facilisis metus nec, faucibus lacus. Duis nec dolor at nibh eleifend "
        "tempus. Nunc et enim interdum, commodo eros ac, pretium sapien. Pellentesque laoreet orci a nunc pharetra "
        "pharetra.";

    // 创建一个断词策略为 BREAK_HYPHEN 的 TypographyStyle
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_LEFT);
    // [Start complex_text_c_break_hyphen_gb_text]
    // 设置断词策略为 WORD_BREAK_TYPE_BREAK_HYPHEN
    OH_Drawing_SetTypographyTextWordBreakType(typoStyle, OH_Drawing_WordBreakType::WORD_BREAK_TYPE_BREAK_HYPHEN);
    // 设置 locale 为 en-gb
    OH_Drawing_SetTextStyleLocale(txtStyle, "en-gb");
    // [End complex_text_c_break_hyphen_gb_text]
    // 设置最大行数为 10，行数大于 10 的部分不显示
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 10);
    OH_Drawing_SetTypographyTextStyle(typoStyle, txtStyle);

    // 使用之前创建的 FontCollection 和 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

void SampleBitMap::DrawBreakHyphenUSText()
{
    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TWENTY(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 设置文本内容
    const char *text =
        "Nunc quis augue viverra, venenatis arcu eu, gravida odio. Integer posuere nisi quis ex pretium, a dapibus "
        "nisl gravida. Mauris lacinia accumsan enim, non tempus ligula. Mauris iaculis dui eu nisi tristique, in porta "
        "urna varius. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris "
        "congue nibh mi, vel ultrices ex volutpat et. Aliquam consectetur odio in libero tristique, a mattis ex "
        "mollis. Praesent et nisl iaculis, facilisis metus nec, faucibus lacus. Duis nec dolor at nibh eleifend "
        "tempus. Nunc et enim interdum, commodo eros ac, pretium sapien. Pellentesque laoreet orci a nunc pharetra "
        "pharetra.";

    // 创建一个断词策略为 BREAK_HYPHEN 的 TypographyStyle
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_LEFT);
    // [Start complex_text_c_break_hyphen_us_text]
    // 设置断词策略为 WORD_BREAK_TYPE_BREAK_HYPHEN
    OH_Drawing_SetTypographyTextWordBreakType(typoStyle, OH_Drawing_WordBreakType::WORD_BREAK_TYPE_BREAK_HYPHEN);
    // 设置 locale 为 en-us
    OH_Drawing_SetTextStyleLocale(txtStyle, "en-us");
    // [End complex_text_c_break_hyphen_us_text]
    // 设置最大行数为 10，行数大于 10 的部分不显示
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 10);
    OH_Drawing_SetTypographyTextStyle(typoStyle, txtStyle);

    // 使用之前创建的 FontCollection 和 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}


void SampleBitMap::DrawDecorationText()
{
    // [Start complex_text_c_decoration_text]
    // 创建一个TypographyStyle创建Typography时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置文本内容
    const char *text = "Hello World Drawing\n";

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyleWithDeco = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyleWithDeco, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleWithDeco, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithDeco, FONT_WEIGHT_400);
    // 设置装饰线为 LINE_THROUGH
    OH_Drawing_SetTextStyleDecoration(txtStyleWithDeco, TEXT_DECORATION_LINE_THROUGH);
    // 设置装饰线样式为 WAVY
    OH_Drawing_SetTextStyleDecorationStyle(txtStyleWithDeco, TEXT_DECORATION_STYLE_WAVY);
    // 设置装饰线颜色
    OH_Drawing_SetTextStyleDecorationColor(txtStyleWithDeco, OH_Drawing_ColorSetArgb(0xFF, 0x6F, 0xFF, 0xFF));

    // 创建一个不带装饰线的 TextStyle 用于对比
    OH_Drawing_TextStyle *txtStyleNoDeco = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleNoDeco, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleNoDeco, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleNoDeco, FONT_WEIGHT_400);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 加入带有装饰线的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithDeco);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    // 后续加入的不带装饰线的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleNoDeco);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithDeco);
    OH_Drawing_DestroyTextStyle(txtStyleNoDeco);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_decoration_text]
}

void SampleBitMap::DrawFontFeatureText()
{
    // [Start complex_text_c_font_feature_text]
    // 创建一个 TypographyStyle，创建 TypographyCreate 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置文本内容
    const char *text = "1/2 1/3 1/4\n";

    // 设置文字颜色、大小、字重，不设置TextStyle无法绘制出文本
    OH_Drawing_TextStyle *txtStyleWithFeature = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyleWithFeature, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleWithFeature, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithFeature, FONT_WEIGHT_900);
    // 设置启用frac font feature，此功能将斜线分隔的数字替换为普通（对角线）分数。
    OH_Drawing_TextStyleAddFontFeature(txtStyleWithFeature, "frac", 1);

    // 创建一个不带字体特征的 TextStyle 用于对比
    OH_Drawing_TextStyle *txtStyleNoFeature = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重。不设置 TextStyle 无法绘制出文本
    OH_Drawing_SetTextStyleColor(txtStyleNoFeature, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleNoFeature, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleNoFeature, FONT_WEIGHT_900);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 加入带有字体特征的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithFeature);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 销毁之前创建的 TextStyle
    OH_Drawing_TypographyHandlerPopTextStyle(handler);

    // 后续加入的不带字体特征的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleNoFeature);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 销毁之前创建的 TextStyle
    OH_Drawing_TypographyHandlerPopTextStyle(handler);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithFeature);
    OH_Drawing_DestroyTextStyle(txtStyleNoFeature);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_font_feature_text]
}


void SampleBitMap::DrawFontVariationText()
{
    // [Start complex_text_c_font_variation_text]
    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置文字内容
    const char *text = "Hello World Drawing\n";

    OH_Drawing_TextStyle *txtStyleWithVar = OH_Drawing_CreateTextStyle();
    // 设置可变字体的字重为800，在字体文件支持的情况下，还可以设置"slnt", "wdth"
    OH_Drawing_TextStyleAddFontVariation(txtStyleWithVar, "wght", 800);
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleWithVar, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleWithVar, DIV_TEN(width_));
    // 此处设置字重不生效，将被可变字体的字重覆盖
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithVar, FONT_WEIGHT_400);

    // 创建一个不带可变字体的 TextStyle 用于对比
    OH_Drawing_TextStyle *txtStyleNoVar = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleNoVar, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleNoVar, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleNoVar, FONT_WEIGHT_400);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 加入带有可变字体的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithVar);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 弹出之前创建的 TextStyle
    OH_Drawing_TypographyHandlerPopTextStyle(handler);

    // 后续加入的不带可变字体的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleNoVar);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 弹出之前创建的 TextStyle
    OH_Drawing_TypographyHandlerPopTextStyle(handler);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithVar);
    OH_Drawing_DestroyTextStyle(txtStyleNoVar);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_font_variation_text]
}

void SampleBitMap::DrawShadowText()
{
    // [Start complex_text_c_shadow_text]
    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置文本内容
    const char *text = "Hello World Drawing\n";

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyleWithShadow = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyleWithShadow, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleWithShadow, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithShadow, FONT_WEIGHT_400);
    // 设置阴影偏移量
    OH_Drawing_Point *offset = OH_Drawing_PointCreate(1, 1);
    OH_Drawing_TextShadow *shadow = OH_Drawing_CreateTextShadow();
    double radius = 10.0;
    // 为 TextShadow 设置样式
    OH_Drawing_SetTextShadow(shadow, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00), offset, radius);
    // 将 TextShadow 加入 TextStyle
    OH_Drawing_TextStyleAddShadow(txtStyleWithShadow, shadow);

    // 创建一个不带阴影的 TextStyle 用于对比
    OH_Drawing_TextStyle *txtStyleNoShadow = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleNoShadow, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleNoShadow, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyleNoShadow, FONT_WEIGHT_400);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 加入带有阴影的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithShadow);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    // 后续加入的不带阴影的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleNoShadow);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithShadow);
    OH_Drawing_PointDestroy(offset);
    OH_Drawing_DestroyTextShadow(shadow);
    OH_Drawing_DestroyTextStyle(txtStyleNoShadow);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_shadow_text]
}

void SampleBitMap::DrawPlaceholderText()
{
    // [Start complex_text_c_placeholder_text]
    // 设置页面最大宽度
    double maxWidth = width_;
    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

    // 设置文本内容
    const char *text = "Hello World Drawing\n";

    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);

    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handlerWithPlaceholder = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 创建一个 placeholder，并且初始化其成员变量
    OH_Drawing_PlaceholderSpan placeholder;
    placeholder.width = DIV_TEN(width_);
    placeholder.height = DIV_FIVE(width_);
    placeholder.alignment = ALIGNMENT_ABOVE_BASELINE; // 基线对齐策略
    placeholder.baseline = TEXT_BASELINE_ALPHABETIC;  // 使用的文本基线类型
    placeholder.baselineOffset = 0.0; // 相比基线的偏移量。只有对齐策略是 OFFSET_AT_BASELINE 时生效

    // 将 placeholder 放在开头
    OH_Drawing_TypographyHandlerAddPlaceholder(handlerWithPlaceholder, &placeholder);

    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handlerWithPlaceholder, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handlerWithPlaceholder, text);

    OH_Drawing_Typography *typographyWithPlaceholder = OH_Drawing_CreateTypography(handlerWithPlaceholder);
    OH_Drawing_TypographyLayout(typographyWithPlaceholder, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typographyWithPlaceholder, cCanvas_, 0, DIV_TEN(width_));

    // 创建 OH_Drawing_TypographyCreate
    OH_Drawing_TypographyCreate *handlerNoPlaceholder = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handlerNoPlaceholder, txtStyle);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handlerNoPlaceholder, text);

    OH_Drawing_Typography *typographyNoPlaceholder = OH_Drawing_CreateTypography(handlerNoPlaceholder);

    OH_Drawing_TypographyLayout(typographyNoPlaceholder, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typographyNoPlaceholder, cCanvas_, 0, DIV_TWO(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handlerWithPlaceholder);
    OH_Drawing_DestroyTypographyHandler(handlerNoPlaceholder);
    OH_Drawing_DestroyTypography(typographyWithPlaceholder);
    OH_Drawing_DestroyTypography(typographyNoPlaceholder);
    // [End complex_text_c_placeholder_text]
}

void SampleBitMap::DrawAutoSpaceText()
{
    // [Start complex_text_c_auto_space_text]
    // 创建一个TypographyStyle创建Typography时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置使能自动间距，默认为false
    OH_Drawing_SetTypographyTextAutoSpace(typoStyle, true);
    // 设置文字内容
    const char *text = "test测试©test©测。";

    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置TextStyle会使用TypographyStyle中的默认TextStyle
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));

    // 创建FontCollection，FontCollection用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用FontCollection和之前创建的TypographyStyle创建TypographyCreate。TypographyCreate用于创建Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 将文本样式添加到handler中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将文本添加到handler中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 创建段落
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    // 将段落按照排版宽度进行排版
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 设置使能自动间距，用于对比
    OH_Drawing_SetTypographyTextAutoSpace(typoStyle, false);

    // 使用FontCollection和之前创建的TypographyStyle创建TypographyCreate。TypographyCreate用于创建Typography
    OH_Drawing_TypographyCreate *handlerWithoutAutoSpace = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 将文本样式添加到handlerWithoutAutoSpace中
    OH_Drawing_TypographyHandlerPushTextStyle(handlerWithoutAutoSpace, txtStyle);
    // 将文本添加到handlerWithoutAutoSpace中
    OH_Drawing_TypographyHandlerAddText(handlerWithoutAutoSpace, text);
    // 创建段落
    OH_Drawing_Typography *typographyWithoutAutoSpace = OH_Drawing_CreateTypography(handlerWithoutAutoSpace);
    // 将段落按照排版宽度进行排版
    OH_Drawing_TypographyLayout(typographyWithoutAutoSpace, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typographyWithoutAutoSpace, cCanvas_, 0, DIV_FOUR(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypographyHandler(handlerWithoutAutoSpace);
    OH_Drawing_DestroyTypography(typography);
    OH_Drawing_DestroyTypography(typographyWithoutAutoSpace);
    // [End complex_text_c_auto_space_text]
}

void SampleBitMap::DrawGradientText()
{
    // [Start complex_text_c_gradient_text]
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字大小
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));
    // 创建着色器对象，并设置颜色、变化起始点与结束点
    OH_Drawing_Point *startPt = OH_Drawing_PointCreate(0, 0);
    // 结束点位于(900, 900)
    OH_Drawing_Point *endPt = OH_Drawing_PointCreate(900, 900);
    uint32_t colors[] = {0xFFFFFF00, 0xFFFF0000, 0xFF0000FF};
    float pos[] = {0.0f, 0.5f, 1.0f};
    // pos数组长度为3
    OH_Drawing_ShaderEffect *colorShaderEffect =
        OH_Drawing_ShaderEffectCreateLinearGradient(startPt, endPt, colors, pos, 3, OH_Drawing_TileMode::CLAMP);
    // 创建画刷对象,并将着色器添加到画刷
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetShaderEffect(brush, colorShaderEffect);
    // 将画刷添加到文本样式中
    OH_Drawing_SetTextStyleForegroundBrush(txtStyle, brush);
    // 创建排版对象，并绘制
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "Hello World";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    // 将段落按照排版宽度进行排版
    OH_Drawing_TypographyLayout(typography, maxWidth);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放对象
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_ShaderEffectDestroy(colorShaderEffect);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_gradient_text]
}

void SampleBitMap::DrawVerticalAlignmentText()
{
    // [Start complex_text_c_vertical_alignment_text]
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置垂直对齐方式
    OH_Drawing_SetTypographyVerticalAlignment(typoStyle,
                                              OH_Drawing_TextVerticalAlignment::TEXT_VERTICAL_ALIGNMENT_CENTER);
    // 设置文字大小
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));
    // 设置文字颜色
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    // 创建排版对象，并绘制
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "VerticalAlignment-center";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    // 将段落按照排版宽度进行排版
    OH_Drawing_TypographyLayout(typography, maxWidth);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放对象
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_vertical_alignment_text]
}

void SampleBitMap::DrawBadgeText()
{
    // [Start complex_text_c_badge_text]
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_TextStyle *badgeTxtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字大小
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TWENTY(width_));
    OH_Drawing_SetTextStyleFontSize(badgeTxtStyle, DIV_TWENTY(width_));
    // 设置文字颜色
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleColor(badgeTxtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    // 使能文本上标
    OH_Drawing_SetTextStyleBadgeType(badgeTxtStyle, OH_Drawing_TextBadgeType::TEXT_SUPERSCRIPT);
    // 创建排版对象，并绘制
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "Mass-energy equivalence: E=mc";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, badgeTxtStyle);
    const char *badgeText = "2";
    OH_Drawing_TypographyHandlerAddText(handler, badgeText);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    // 将段落按照排版宽度进行排版
    OH_Drawing_TypographyLayout(typography, maxWidth);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放对象
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTextStyle(badgeTxtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_badge_text]
}

void SampleBitMap::DrawHighContrastText()
{
    // [Start complex_text_c_high_contrast_text]
    // 开启APP的文字渲染高对比模式，该模式的优先级要高于系统设置中的高对比度文字配置
    OH_Drawing_SetTextHighContrast(TEXT_APP_ENABLE_HIGH_CONTRAST);
    // 创建一个 TypographyStyle，创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();

    // 设置文字颜色、大小，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x6F, 0xFF, 0xFF));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);

    // 将之前创建的 TextStyle 加入 handler 中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 设置文本内容，并将文本添加到 handler 中
    const char *text = "Hello World Drawing\n";
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    // 将段落按照排版宽度进行排版
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_high_contrast_text]
}


void SampleBitMap::DrawStyleCopyText()
{
    // [Start complex_text_c_style_copy_text]
    // 创建一个TypographyStyle，其中创建Typography时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 配置段落样式包括：使能自动间距、最大行数、省略号样式、省略号文本、对齐方式
    // 使能自动间距
    OH_Drawing_SetTypographyTextAutoSpace(typoStyle, true);
    // 设置段落最大行数为3行
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 3);
    // 设置省略号模式为尾部省略号
    OH_Drawing_SetTypographyTextEllipsisModal(typoStyle, ELLIPSIS_MODAL_TAIL);
    // 设置省略号文本
    OH_Drawing_SetTypographyTextEllipsis(typoStyle, "...");
    // 设置对齐方式为居中对齐
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);

    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置TextStyle会使用TypographyStyle中的默认TextStyle
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));
    // 设置文本的装饰线
    // 添加下划线
    OH_Drawing_SetTextStyleDecoration(txtStyle, TEXT_DECORATION_UNDERLINE);
    // 设置装饰线样式为波浪线样式
    OH_Drawing_SetTextStyleDecorationStyle(txtStyle, TEXT_DECORATION_STYLE_WAVY);
    // 设置下划线粗细
    OH_Drawing_SetTextStyleDecorationThicknessScale(txtStyle, 1);
    // 设置下划线颜色为蓝色
    OH_Drawing_SetTextStyleDecorationColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0xFF));

    // 设置阴影的颜色、偏移量、模糊半径
    // 创建阴影对象
    OH_Drawing_TextShadow *shadow = OH_Drawing_CreateTextShadow();
    // 设置阴影偏移量为(5, 5)
    OH_Drawing_Point *offset = OH_Drawing_PointCreate(5, 5);
    // 定义阴影模糊半径为4
    double blurRadius = 4;
    OH_Drawing_SetTextShadow(shadow, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0x00, 0xFF), offset, blurRadius);

    // 拷贝阴影对象
    OH_Drawing_TextShadow *shadowCopy = OH_Drawing_CopyTextShadow(shadow);
    // 将拷贝出的阴影添加到文本样式中
    OH_Drawing_TextStyleAddShadow(txtStyle, shadowCopy);

    // 创建FontCollection，FontCollection用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

    // 使用FontCollection和之前创建的TypographyStyle创建TypographyCreate。TypographyCreate用于创建Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // 将段落一文本样式添加到handler中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 将段落一文本添加到handler中
    const char *text = "The text style, paragraph style, and text shadow of the copied text will be exactly the same "
                       "as those of the original text.";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 创建段落一，并将段落一按照排版宽度进行排版
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, DIV_TEN(width_));

    // 生成第二段文本，其中，文本样式和段落样式均由第一段文本拷贝而来
    // 复制文本样式
    OH_Drawing_TextStyle *textStyleCopy = OH_Drawing_CopyTextStyle(txtStyle);
    // 复制段落样式
    OH_Drawing_TypographyStyle *typographyStyleCopy = OH_Drawing_CopyTypographyStyle(typoStyle);

    // 使用复制的样式创建段落二，后续可以观察段落一和段落二是否绘制效果一致
    OH_Drawing_TypographyCreate *handlerCopy = OH_Drawing_CreateTypographyHandler(typographyStyleCopy, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handlerCopy, textStyleCopy);
    OH_Drawing_TypographyHandlerAddText(handlerCopy, text);
    OH_Drawing_Typography *typographyCopy = OH_Drawing_CreateTypography(handlerCopy);
    OH_Drawing_TypographyLayout(typographyCopy, maxWidth);
    OH_Drawing_TypographyPaint(typographyCopy, cCanvas_, 0, DIV_TWO(width_));

    // 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // 拷贝的段落样式也需要释放内存
    OH_Drawing_DestroyTypographyStyle(typographyStyleCopy);
    // 拷贝的文本样式也需要释放内存
    OH_Drawing_DestroyTextStyle(textStyleCopy);
    OH_Drawing_DestroyTypographyHandler(handlerCopy);
    OH_Drawing_DestroyTypography(typographyCopy);
    // [End complex_text_c_style_copy_text]
}

void SampleBitMap::DrawLineHeightLimitOneText()
{
    // [Start complex_text_c_line_height_limit_one_text]
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字大小为50
    OH_Drawing_SetTextStyleFontSize(txtStyle, 50);
    // 设置文字颜色
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleAttributeDouble(txtStyle,
        OH_Drawing_TextStyleAttributeId::TEXT_STYLE_ATTR_D_LINE_HEIGHT_MAXIMUM, 65); // 设置行高上限为65
    OH_Drawing_SetTextStyleAttributeDouble(txtStyle,
        OH_Drawing_TextStyleAttributeId::TEXT_STYLE_ATTR_D_LINE_HEIGHT_MINIMUM, 65); // 设置行高下限为65
    // 创建排版对象，并绘制
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "Hello World!";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 排版宽度为1000
    OH_Drawing_TypographyLayout(typography, 1000);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 0);

    // 释放对象
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_line_height_limit_one_text]
}

void SampleBitMap::DrawLineHeightLimitTwoText()
{
    // [Start complex_text_c_line_height_limit_two_text]
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字大小为50
    OH_Drawing_SetTextStyleFontSize(txtStyle, 50);
    // 设置文字颜色
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    // 设置行高缩放系数为1.5
    OH_Drawing_SetTextStyleFontHeight(txtStyle, 1.5);
    // 设置行高缩放样式（1代表行高缩放以字形高度作为缩放基数）
    OH_Drawing_SetTextStyleAttributeInt(txtStyle,
        OH_Drawing_TextStyleAttributeId::TEXT_STYLE_ATTR_I_LINE_HEIGHT_STYLE, 1);
    // 创建排版对象，并绘制
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "Hello World!";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 排版宽度为1000
    OH_Drawing_TypographyLayout(typography, 1000);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 0);

    // 释放对象
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_line_height_limit_two_text]
}

void SampleBitMap::DrawLineSpacingText()
{
    // [Start complex_text_c_line_spacing_text]
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyStyleAttributeDouble(typoStyle,
        OH_Drawing_TypographyStyleAttributeId::TYPOGRAPHY_STYLE_ATTR_D_LINE_SPACING, 100); // 设置行间距为100
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    // 设置文字大小为50
    OH_Drawing_SetTextStyleFontSize(txtStyle, 50);
    // 设置文字颜色
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    // 创建排版对象，并绘制
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "Hello World!";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 排版宽度为200
    OH_Drawing_TypographyLayout(typography, 200);
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 0);

    // 释放对象
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
    // [End complex_text_c_line_spacing_text]
}

void SampleBitMap::DrawIndependentShapingText()
{
    // [Start complex_text_c_independent_shaping_text_step1]
    // 创建一个 TypographyStyle，创建 TypographyCreate 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(txtStyle, DIV_TEN(width_));

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
    // [End complex_text_c_independent_shaping_text_step1]
    // [Start complex_text_c_independent_shaping_text_step2]
    // 设置文本内容，并将文本添加到 handler 中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    const char *text = "Hello World";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // [End complex_text_c_independent_shaping_text_step2]

    // [Start complex_text_c_independent_shaping_text_step3]
    // 通过 handler 创建一个 Typography
    OH_Drawing_LineTypography *lineTypography = OH_Drawing_CreateLineTypography(handler);
    // 创建一个 TextLine，取(0, 11)的字符
    OH_Drawing_TextLine *textLine = OH_Drawing_LineTypographyCreateLine(lineTypography, 0, 11);

    // 获取塑形结果
    OH_Drawing_Array *runs = OH_Drawing_TextLineGetGlyphRuns(textLine);
    // [End complex_text_c_independent_shaping_text_step3]
    // [Start complex_text_c_independent_shaping_text_step4]
    size_t runsLength = OH_Drawing_GetDrawingArraySize(runs);
    for (int i = 0; i < runsLength; i++) {
        OH_Drawing_Run *run = OH_Drawing_GetRunByIndex(runs, i);
        // 获取所有字形数据
        OH_Drawing_Array *glyphs = OH_Drawing_GetRunGlyphs(run, 0, 0);
        size_t glyphsLength = OH_Drawing_GetDrawingArraySize(glyphs);
        // 获取相同绘制单元字体
        OH_Drawing_Font *font = OH_Drawing_GetRunFont(run);
        OH_Drawing_Array *advances = OH_Drawing_GetRunGlyphAdvances(run, 0, 0);

        OH_Drawing_TextBlobBuilder *builder = OH_Drawing_TextBlobBuilderCreate();
        // 创建一个20*20的矩形
        OH_Drawing_Rect *rect = OH_Drawing_RectCreate(0, 0, 20, 20);
        const OH_Drawing_RunBuffer *buffer = OH_Drawing_TextBlobBuilderAllocRunPos(builder, font, glyphsLength, rect);

        // 创建字形buffer，通过drawing接口进行字形独立绘制
        int x = 0;
        int y = 0;
        for (int index = 0; index < glyphsLength; index++) {
            buffer->glyphs[index] = OH_Drawing_GetRunGlyphsByIndex(glyphs, index);
            // 设置字形位置
            buffer->pos[index * TWO_INT] = x;
            buffer->pos[index * TWO_INT + 1] = y;

            OH_Drawing_Point *advance = OH_Drawing_GetRunGlyphAdvanceByIndex(advances, index);
            float pos = 0;
            OH_Drawing_PointGetX(advance, &pos);
            x += pos + 10; // 每个字形间水平间隔10px
            OH_Drawing_PointGetY(advance, &pos);
            y += pos + 30; // 每个字形间垂直间隔30px
        }

        // 自定义绘制一串具有相同属性的一系列连续字形
        OH_Drawing_TextBlob *textBlob = OH_Drawing_TextBlobBuilderMake(builder);
        // 将文本绘制到画布(20,100)上
        OH_Drawing_CanvasDrawTextBlob(cCanvas_, textBlob, 20, 100);

        // 释放内存
        OH_Drawing_TextBlobDestroy(textBlob);
        OH_Drawing_FontDestroy(font);
        OH_Drawing_DestroyRunGlyphAdvances(advances);
        OH_Drawing_DestroyRunGlyphs(glyphs);
    }
    // [End complex_text_c_independent_shaping_text_step4]

    // [Start complex_text_c_independent_shaping_text_step5]
    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyLineTypography(lineTypography);
    OH_Drawing_DestroyTextLine(textLine);
    OH_Drawing_DestroyRuns(runs);
    // [End complex_text_c_independent_shaping_text_step5]
}