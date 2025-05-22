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

#include <bits/alltypes.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_drawing/drawing_register_font.h>
#include <native_drawing/drawing_point.h>
#include <native_buffer/native_buffer.h>

#include "common/log_common.h"
#include "sample_bitmap.h"
#include "plugin/plugin_manager.h"

static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    DRAWING_LOGI("OnSurfaceCreatedCB");
    if ((component == nullptr) || (window == nullptr)) {
        DRAWING_LOGE("OnSurfaceCreatedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("OnSurfaceCreatedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    auto render = SampleBitMap::GetInstance(id);
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    render->SetNativeWindow(nativeWindow);

    uint64_t width;
    uint64_t height;
    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    if ((xSize == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) && (render != nullptr)) {
        render->SetHeight(height);
        render->SetWidth(width);
        DRAWING_LOGI("xComponent width = %{public}llu, height = %{public}llu", width, height);
    }
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    DRAWING_LOGI("OnSurfaceDestroyedCB");
    if ((component == nullptr) || (window == nullptr)) {
        DRAWING_LOGE("OnSurfaceDestroyedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("OnSurfaceDestroyedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    SampleBitMap::Release(id);
}

static std::unordered_map<std::string, SampleBitMap *> g_instance;

void SampleBitMap::SetWidth(uint64_t width)
{
    width_ = width;
}

void SampleBitMap::SetHeight(uint64_t height)
{
    height_ = height;
}

void SampleBitMap::SetNativeWindow(OHNativeWindow *nativeWindow)
{
    nativeWindow_ = nativeWindow;
}

void SampleBitMap::Prepare()
{
    if (nativeWindow_ == nullptr) {
        DRAWING_LOGE("nativeWindow_ is nullptr");
        return;
    }
    // 这里的nativeWindow是从上一步骤中的回调函数中获得的
    int32_t usage = NATIVEBUFFER_USAGE_CPU_READ | NATIVEBUFFER_USAGE_CPU_WRITE | NATIVEBUFFER_USAGE_MEM_DMA;
    int ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, SET_USAGE, usage);
    if (ret != 0) {
        DRAWING_LOGE("failed to OH_NativeWindow_NativeWindowHandleOpt");
        return;
    }
    // 通过 OH_NativeWindow_NativeWindowRequestBuffer 获取 OHNativeWindowBuffer 实例
    ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer_, &fenceFd_);
    DRAWING_LOGI("request buffer ret = %{public}d", ret);
    // 通过 OH_NativeWindow_GetBufferHandleFromNative 获取 buffer 的 handle
    bufferHandle_ = OH_NativeWindow_GetBufferHandleFromNative(buffer_);
    // 使用系统mmap接口拿到bufferHandle的内存虚拟地址
    mappedAddr_ = static_cast<uint32_t *>(
        mmap(bufferHandle_->virAddr, bufferHandle_->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle_->fd, 0));
    if (mappedAddr_ == MAP_FAILED) {
        DRAWING_LOGE("mmap failed");
    }
}

void SampleBitMap::DisPlay()
{
    // 画完后获取像素地址，地址指向的内存包含画布画的像素数据
    void *bitmapAddr = OH_Drawing_BitmapGetPixels(cBitmap_);
    uint32_t *value = static_cast<uint32_t *>(bitmapAddr);

    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr_); // 使用mmap获取到的地址来访问内存
    if (pixel == nullptr) {
        DRAWING_LOGE("pixel is null");
        return;
    }
    if (value == nullptr) {
        DRAWING_LOGE("value is null");
        return;
    }
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    for (uint32_t x = 0; x < width; x++) {
        for (uint32_t y = 0; y < height_; y++) {
            *pixel++ = *value++;
        }
    }
    // 设置刷新区域，如果Region中的Rect为nullptr,或者rectNumber为0，则认为OHNativeWindowBuffer全部有内容更改。
    Region region {nullptr, 0};
    // 通过OH_NativeWindow_NativeWindowFlushBuffer 提交给消费者使用，例如：显示在屏幕上。
    OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer_, fenceFd_, region);
    // 内存使用完记得去掉内存映射
    int result = munmap(mappedAddr_, bufferHandle_->size);
    if (result == -1) {
        DRAWING_LOGE("munmap failed!");
    }
}

void SampleBitMap::Create()
{
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    // 创建一个bitmap对象
    cBitmap_ = OH_Drawing_BitmapCreate();
    // 定义bitmap的像素格式
    OH_Drawing_BitmapFormat cFormat {COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    // 构造对应格式的bitmap
    OH_Drawing_BitmapBuild(cBitmap_, width, height_, &cFormat);

    // 创建一个canvas对象
    cCanvas_ = OH_Drawing_CanvasCreate();
    // 将画布与bitmap绑定，画布画的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(cCanvas_, cBitmap_);
    // 使用白色清除画布内容
    OH_Drawing_CanvasClear(cCanvas_, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0xFF, 0xFF));
}

void SampleBitMap::AddFontVariation() {
    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置文字内容
    const char *text = "Hello World Drawing\n";

    OH_Drawing_TextStyle *txtStyleWithVar = OH_Drawing_CreateTextStyle();
    // 设置可变字体的字重，在字体文件支持的情况下，还可以设置"slnt", "wdth"。
    OH_Drawing_TextStyleAddFontVariation(txtStyleWithVar, "wght", 800);
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleWithVar, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleWithVar, 100);
    // 此处设置字重不生效，被可变字体的字重覆盖了。
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithVar, FONT_WEIGHT_400);

    // 创建一个不带可变字体的 TextStyle 用于对比
    OH_Drawing_TextStyle *txtStyleNoVar = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleNoVar, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleNoVar, 100);
    OH_Drawing_SetTextStyleFontWeight(txtStyleNoVar, FONT_WEIGHT_400);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fontCollection);

    // 加入带有可变字体的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithVar);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 销毁之前创建的 TextStyle
    OH_Drawing_TypographyHandlerPopTextStyle(handler);

    // 后续加入的不带可变字体的文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleNoVar);
    // 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 销毁之前创建的 TextStyle
    OH_Drawing_TypographyHandlerPopTextStyle(handler);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width_ / 5.0, height_ / 2.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 100);

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithVar);
    OH_Drawing_DestroyTextStyle(txtStyleNoVar);
    OH_Drawing_DestroyFontCollection(fontCollection);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

void SampleBitMap::SetTextShadow()
{
    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
    // 设置文本内容
    const char *text = "Hello World Drawing\n";

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyleWithShadow = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyleWithShadow, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleWithShadow, 100);
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithShadow, FONT_WEIGHT_400);
    // 设置阴影偏移量
    OH_Drawing_Point *offset = OH_Drawing_PointCreate(10, 10);
    OH_Drawing_TextShadow *shadow = OH_Drawing_CreateTextShadow();
    // 为 TextShadow 设置样式
    OH_Drawing_SetTextShadow(shadow, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00), offset, 10);
    // 将 TextShadow 加入 TextStyle
    OH_Drawing_TextStyleAddShadow(txtStyleWithShadow, shadow);

    // 创建一个不带阴影的 TextStyle 用于对比
    OH_Drawing_TextStyle *txtStyleNoShadow = OH_Drawing_CreateTextStyle();
    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_SetTextStyleColor(txtStyleNoShadow, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyleNoShadow, 100);
    OH_Drawing_SetTextStyleFontWeight(txtStyleNoShadow, FONT_WEIGHT_400);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fontCollection);

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
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width_ / 5.0, height_ / 2.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 100);

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithShadow);
    OH_Drawing_DestroyTextShadow(shadow);
    OH_Drawing_DestroyTextStyle(txtStyleNoShadow);
    OH_Drawing_DestroyFontCollection(fontCollection);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

void SampleBitMap::SetTextBrush()
{
    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyleWithBackgroundBrush = OH_Drawing_CreateTextStyle();
    OH_Drawing_Brush* backgroundBrush = OH_Drawing_BrushCreate();
    // 设置指定文本样式中的背景色画刷为红色
    OH_Drawing_BrushSetColor(backgroundBrush, OH_Drawing_ColorSetArgb(255, 255, 0, 0));
    OH_Drawing_SetTextStyleBackgroundBrush(txtStyleWithBackgroundBrush, backgroundBrush);
    // 设置文本颜色为蓝色
    OH_Drawing_SetTextStyleColor(txtStyleWithBackgroundBrush, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0xFF));
    // 设置字体基线位置。
    OH_Drawing_SetTextStyleBaseLine(txtStyleWithBackgroundBrush, TEXT_BASELINE_IDEOGRAPHIC);
    // 设置行高，按当前字体大小的倍数进行设置
    OH_Drawing_SetTextStyleFontHeight(txtStyleWithBackgroundBrush, 2.0);
    // 设置字体风格，设置1为斜体，设置0或其它为非斜体，具体可见OH_Drawing_FontStyle枚举
    OH_Drawing_SetTextStyleFontStyle(txtStyleWithBackgroundBrush, FONT_STYLE_ITALIC);
    // 设置文本为一半行间距。
    OH_Drawing_SetTextStyleHalfLeading(txtStyleWithBackgroundBrush, true);
    // 设置文本的字符间距。
    OH_Drawing_SetTextStyleLetterSpacing(txtStyleWithBackgroundBrush, 10.0);
    // 设置语言类型，数据类型为指向char的指针，如'en'代表英文，'zh-Hans'代表简体中文，'zh-Hant'代表繁体中文。
    OH_Drawing_SetTextStyleLocale(txtStyleWithBackgroundBrush, "zh-Hans");
    // 设置文本的单词间距。
    OH_Drawing_SetTextStyleWordSpacing(txtStyleWithBackgroundBrush, 5.0);
    // 设置文本大小。
    OH_Drawing_SetTextStyleFontSize(txtStyleWithBackgroundBrush, 60);
    OH_Drawing_SetTextStyleFontWeight(txtStyleWithBackgroundBrush, FONT_WEIGHT_400);

    // 创建文本样式设置其前景色。
    OH_Drawing_TextStyle *txtStyleWithForegrounddBrush = OH_Drawing_CreateTextStyle();
    // 设置文本大小。
    OH_Drawing_SetTextStyleFontSize(txtStyleWithForegrounddBrush, 60);
    OH_Drawing_Brush* foregrounddBrush = OH_Drawing_BrushCreate();
    // 设置字体前景色为绿色。
    OH_Drawing_BrushSetColor(foregrounddBrush, OH_Drawing_ColorSetArgb(255, 0, 255, 0));
    // 设置指定文本样式中的前景色画刷。
    OH_Drawing_SetTextStyleForegroundBrush(txtStyleWithForegrounddBrush, foregrounddBrush);
    // 设置文本颜色为蓝色。
    OH_Drawing_SetTextStyleColor(txtStyleWithForegrounddBrush, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0xFF));

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography。
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fontCollection);
    
    // 创建一个 placeholder，并且初始化其成员变量
    OH_Drawing_PlaceholderSpan placeholder;
    placeholder.width = 150.0;
    placeholder.height = 150.0;
    placeholder.alignment = OH_Drawing_PlaceholderVerticalAlignment::ALIGNMENT_ABOVE_BASELINE; // 基线对齐策略
    placeholder.baseline = OH_Drawing_TextBaseline::TEXT_BASELINE_ALPHABETIC; // 使用的文本基线类型
    placeholder.baselineOffset = 0.0; // 相比基线的偏移量。只有对齐策略是 OFFSET_AT_BASELINE 时生效
    // 将 placeholder 放在开头
    OH_Drawing_TypographyHandlerAddPlaceholder(handler, &placeholder);

    // 将之前创建的 TextStyle 加入 handler 中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithBackgroundBrush);
    // 设置文本内容，并将文本添加到 handler 中
    const char *text = "Hello World Drawing 你好\n";
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyleWithForegrounddBrush);
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    
    // 获取排版对象中占位符的文本框，该接口需要在OH_Drawing_TypographyLayout接口调用之后调用
    OH_Drawing_TextBox *textBox = OH_Drawing_TypographyGetRectsForPlaceholders(typography);
    // 获取文本框顶部位置 第二个参数为文本框的索引，下同。
    float top = OH_Drawing_GetTopFromTextBox(textBox, 0);
    float bottom = OH_Drawing_GetBottomFromTextBox(textBox, 0);
    float left = OH_Drawing_GetLeftFromTextBox(textBox, 0);
    float right = OH_Drawing_GetRightFromTextBox(textBox, 0);
    size_t size = OH_Drawing_GetSizeOfTextBox(textBox);
    DRAWING_LOGI("top = %{public}f  bottom = %{public}f  left = %{public}f  right = %{public}f size = %{public}zu", top, bottom, left, right, size);
    
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 100);

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyleWithBackgroundBrush);
    OH_Drawing_DestroyTextStyle(txtStyleWithForegrounddBrush);
    OH_Drawing_DestroyFontCollection(fontCollection);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

void SampleBitMap::SetTextEllipsis()
{
    // 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    // 设置指定排版样式中的文本方向。详见OH_Drawing_TextDirection枚举
    OH_Drawing_SetTypographyTextDirection(typoStyle, TEXT_DIRECTION_RTL);
    // 设置省略号样式
    OH_Drawing_SetTypographyTextEllipsis(typoStyle, "***");
    // 设置文本的省略号样式。如中间省略，详见OH_Drawing_EllipsisModal枚举
    OH_Drawing_SetTypographyTextEllipsisModal(typoStyle, ELLIPSIS_MODAL_MIDDLE);
    // 设置字体家族的名称。
    OH_Drawing_SetTypographyTextFontFamily(typoStyle, "MyFamilyName");
    // 设置文本排版字号
    OH_Drawing_SetTypographyTextFontSize(typoStyle, 10);
    // 设置字体风格，设置1为斜体，设置0或其它为非斜体，具体可见OH_Drawing_FontStyle枚举。
    OH_Drawing_SetTypographyTextFontStyle(typoStyle, FONT_STYLE_OBLIQUE);
    // 设置文本排版字重。目前只有系统默认字体支持字重的调节，其他字体设置字重值小于semi-bold时字体粗细无变化，当设置字重值大于等于semi-bold时可能会触发伪加粗效果
    OH_Drawing_SetTypographyTextFontWeight(typoStyle, FONT_WEIGHT_800);
    
    
    // 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);

    // 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, 60);
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);
    // 设置段落样式
    OH_Drawing_SetTypographyTextStyle(typoStyle, txtStyle);
    OH_Drawing_SetTypographyTextMaxLines(typoStyle, 1);

    // 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    // 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typoStyle, fontCollection);

    // 将之前创建的 TextStyle 加入 handler 中
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 设置文本内容，并将文本添加到 handler 中
    const char *text = "Typograph先关属性设置参考文本\n多行文本设置了省略模式\n省略省略省略省略省略\n省略";
    OH_Drawing_TypographyHandlerAddText(handler, text);

    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    
    // 返回文本是否超过最大行，true表示超过，false表示未超过。
    bool isExceedMaxLines = OH_Drawing_TypographyDidExceedMaxLines(typography);
    // 获取字母文字基线。
    double alphabeticBaseline = OH_Drawing_TypographyGetAlphabeticBaseline(typography);
    // 获取排版对象整体的高度，该接口需要在OH_Drawing_TypographyLayout接口调用之后调用。
    double height = OH_Drawing_TypographyGetHeight(typography);
    // 获取表意文字基线。
    double ideographicBaseline = OH_Drawing_TypographyGetIdeographicBaseline(typography);
    // 获取指定行的行宽，该接口需要在OH_Drawing_TypographyLayout接口调用之后调用
    double lineWidth =  OH_Drawing_TypographyGetLineWidth(typography, 0);
    // 获取排版对象的最大固有宽度，该接口需要在OH_Drawing_TypographyLayout接口调用之后调用。
    double maxIntrinsicWidth =  OH_Drawing_TypographyGetMaxIntrinsicWidth(typography);
    // 返回指定范围内的文本框，具体可见OH_Drawing_TextBox结构体。
    OH_Drawing_TextBox* boxes =
    OH_Drawing_TypographyGetRectsForRange(typography, 1, 2, RECT_HEIGHT_STYLE_TIGHT, RECT_WIDTH_STYLE_TIGHT);
    float bottom = OH_Drawing_GetBottomFromTextBox(boxes,0);
    DRAWING_LOGI("bottom = %{public}f", bottom);
    DRAWING_LOGI("isExceedMaxLines = %{public}zu  alphabeticBaseline = %{public}f  height = %{public}f  ideographicBaseline = %{public}f lineWidth = %{public}f maxIntrinsicWidth = %{public}f"
    ,isExceedMaxLines, alphabeticBaseline, height, ideographicBaseline, lineWidth, maxIntrinsicWidth);
    
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 100);

    // 释放内存
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyFontCollection(fontCollection);
    OH_Drawing_DestroyTypographyHandler(handler);
    OH_Drawing_DestroyTypography(typography);
}

napi_value SampleBitMap::NapiAddFontVariation(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiAddFontVariation");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiAddFontVariation: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiAddFontVariation: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiAddFontVariation: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiAddFontVariation: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiAddFontVariation: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->AddFontVariation();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("AddFontVariation executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleBitMap::NapiSetTextShadow(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiSetTextShadow");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiSetTextShadow: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiSetTextShadow: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiSetTextShadow: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiSetTextShadow: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiSetTextShadow: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->SetTextShadow();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("SetTextShadow executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleBitMap::NapiSetTextBrush(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiDawingInterface");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiDawingInterface: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiDawingInterface: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiDawingInterface: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiDawingInterface: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiDawingInterface: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->SetTextBrush();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("DawingInterface executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleBitMap::NapiSetTextEllipsis(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiSetTypography");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiSetTypography: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiSetTypography: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiSetTypography: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiSetTypography: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiSetTypography: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->SetTextEllipsis();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("SetTypography executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

SampleBitMap::~SampleBitMap()
{
    // 销毁创建的对象
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cBitmap_);
    cBitmap_ = nullptr;

    buffer_ = nullptr;
    bufferHandle_ = nullptr;
    nativeWindow_ = nullptr;
    mappedAddr_ = nullptr;
}

void SampleBitMap::Destroy()
{
    // 销毁创建的对象
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cBitmap_);
}

void SampleBitMap::Release(std::string &id)
{
    PluginManager::GetInstance()->ReleaseRender(id);
    SampleBitMap *render = SampleBitMap::GetInstance(id);
    if (render != nullptr) {
        delete render;
        render = nullptr;
        g_instance.erase(g_instance.find(id));
    }
}

void SampleBitMap::Export(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        DRAWING_LOGE("Export: env or exports is null");
        return;
    }
    napi_property_descriptor desc[] = {
        {"addFontVariation", nullptr, SampleBitMap::NapiAddFontVariation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"dawingInterface", nullptr, SampleBitMap::NapiSetTextBrush, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTypography", nullptr, SampleBitMap::NapiSetTextEllipsis, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTextShadow", nullptr, SampleBitMap::NapiSetTextShadow, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        DRAWING_LOGE("Export: napi_define_properties failed");
    }
}

void SampleBitMap::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    DRAWING_LOGI("register callback");
    renderCallback_.OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    // Callback must be initialized
    renderCallback_.DispatchTouchEvent = nullptr;
    renderCallback_.OnSurfaceChanged = nullptr;
    OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
}

SampleBitMap *SampleBitMap::GetInstance(std::string &id)
{
    if (g_instance.find(id) == g_instance.end()) {
        SampleBitMap *render = new SampleBitMap(id);
        g_instance[id] = render;
        return render;
    } else {
        return g_instance[id];
    }
}
