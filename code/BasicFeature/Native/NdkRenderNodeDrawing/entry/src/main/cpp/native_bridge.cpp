/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
#include <cmath>
#include <string>
#include "napi/native_api.h"
#include <bits/alltypes.h>
#include <multimedia/image_framework/image_mdk_common.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_window/external_window.h>
#include <native_drawing/drawing_bitmap.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_color_filter.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_pixel_map.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_path.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_register_font.h>
#include <native_drawing/drawing_filter.h>
#include <native_drawing/drawing_font.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_sampling_options.h>
#include <native_drawing/drawing_text_blob.h>
#include <native_drawing/drawing_text_declaration.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_drawing/drawing_types.h>
#include <native_drawing/drawing_typeface.h>
#include "common/log_common.h"

enum DrawType {
    NONE,
    PATH,
    TEXT,
    IMAGE
};

const int FONT_COUNT = 2;
const char *g_paths[FONT_COUNT] = {"system/fonts/NotoSans_KR_Bold.otf", "/system/fonts/HarmonyOS_Sans_Thin_Italic.ttf"};

static void NativeOnDrawPath(OH_Drawing_Canvas *canvas, int32_t width, int32_t height)
{
    // native node draw function
    int len = height / 4;
    float aX = width / 2;
    float aY = height / 6;
    float dX = aX - len * std::sin(18.0f);
    float dY = aY + len * std::cos(18.0f);
    float cX = aX + len * std::sin(18.0f);
    float cY = dY;
    float bX = aX + (len / 2.0);
    float bY = aY + std::sqrt((cX - dX) * (cX - dX) + (len / 2.0) * (len / 2.0));
    float eX = aX - (len / 2.0);
    float eY = bY;
    // 创建一个path对象，然后使用接口连接成一个五角星形状
    OH_Drawing_Path *cPath = OH_Drawing_PathCreate();
    // 指定path的起始位置
    OH_Drawing_PathMoveTo(cPath, aX, aY);
    // 用直线连接到目标点
    OH_Drawing_PathLineTo(cPath, bX, bY);
    OH_Drawing_PathLineTo(cPath, cX, cY);
    OH_Drawing_PathLineTo(cPath, dX, dY);
    OH_Drawing_PathLineTo(cPath, eX, eY);
    // 闭合形状，path绘制完毕
    OH_Drawing_PathClose(cPath);

    constexpr float penWidth = 10.0f; // pen width 10
    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    OH_Drawing_Pen *cPen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetAntiAlias(cPen, true);
    OH_Drawing_PenSetColor(cPen, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0x00, 0x00));
    OH_Drawing_PenSetWidth(cPen, penWidth);
    OH_Drawing_PenSetJoin(cPen, LINE_ROUND_JOIN);
    // 将Pen画笔设置到canvas中
    OH_Drawing_CanvasAttachPen(canvas, cPen);

    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    OH_Drawing_Brush *cBrush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(cBrush, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0xFF, 0x00));

    // 将Brush画刷设置到canvas中
    OH_Drawing_CanvasAttachBrush(canvas, cBrush);

    // 在画布上画path的形状，五角星的边框样式为pen设置，颜色填充为Brush设置
    OH_Drawing_CanvasDrawPath(canvas, cPath);
    
    // 绘制完成后将画笔和画刷从画布上清空并销毁
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_PenDestroy(cPen);
    OH_Drawing_BrushDestroy(cBrush);
    OH_Drawing_PathDestroy(cPath);
}

// 字体引擎提供的文字绘制能力，可指定字体，自带排版，支持字体退化
static void NativeOnDrawText(OH_Drawing_Canvas *canvas, int32_t width, int32_t height)
{
    // 选择从左到右/左对齐等排版属性
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextDirection(typoStyle, TEXT_DIRECTION_LTR);
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_JUSTIFY);

    // TEXT_ALIGN_JUSTIFY
    // 设置文字颜色，例如黑色
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    // 设置文字大小、字重等属性
    double fontSize = width / 16;
    OH_Drawing_SetTextStyleFontSize(txtStyle, fontSize);
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);
    OH_Drawing_SetTextStyleBaseLine(txtStyle, TEXT_BASELINE_ALPHABETIC);
    OH_Drawing_SetTextStyleFontHeight(txtStyle, 1);
    // 设置字体类型等
    for (int i = 0; i < FONT_COUNT; ++i) {
        OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateFontCollection();
        const char *fontFamily = "myFamilyName";
        const char *fontPath = g_paths[i];
        OH_Drawing_RegisterFont(fontCollection, fontFamily, fontPath);
        const char *myFontFamilies[] = {"myFamilyName"};
        OH_Drawing_SetTextStyleFontFamilies(txtStyle, 1, myFontFamilies);
        OH_Drawing_SetTextStyleFontStyle(txtStyle, FONT_STYLE_NORMAL);
        OH_Drawing_SetTextStyleLocale(txtStyle, "en");
        OH_Drawing_TypographyCreate *handler =
            OH_Drawing_CreateTypographyHandler(typoStyle, fontCollection);
        OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
        // 设置文字内容
        const char *text = "你好，This is the text for demonstration";
        OH_Drawing_TypographyHandlerAddText(handler, text);
        OH_Drawing_TypographyHandlerPopTextStyle(handler);
        OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
        // 设置页面最大宽度
        double maxWidth = width - 100;
        OH_Drawing_TypographyLayout(typography, maxWidth);
        // 设置文本在画布上绘制的起始位置
        double position[2] = {width / 10.0, height / 5.0 + fontSize * i * 2};
        // 将文本绘制到画布上
        OH_Drawing_TypographyPaint(typography, canvas, position[0], position[1]);
        // 销毁创建的资源
        OH_Drawing_DestroyTypography(typography);
        OH_Drawing_DestroyTypographyHandler(handler);
        OH_Drawing_DestroyFontCollection(fontCollection);
    }
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTextStyle(txtStyle);
}

static void NativeOnDrawTextBlob(OH_Drawing_Canvas *canvas, int32_t width, int32_t height)
{
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(0xff, 0xff, 0x00, 0x00));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 第一种textBlob创建方式，自主指定pos和glyphsID，要求用户有自排版能力，不支持字体退化
    const int textCount = 37;
    const uint16_t glyphs[FONT_COUNT][textCount] = {
        { 0, 3723, 21672, 53, 73, 74, 84, 1, 74, 84, 1, 85, 73, 70, 1, 85, 70, 89,
          85, 1, 71, 80, 83, 1, 69, 70, 78, 80, 79, 84, 85, 83, 66, 85, 74, 80, 79 },
        { 0, 0, 0, 139, 256, 260, 331, 1, 260, 331, 1, 339, 256, 226, 1, 339, 226,
          374, 339, 1, 247, 298, 327, 1, 222, 226, 288, 298, 290, 331, 339, 327, 187, 339, 260, 298, 290 },
    };
    float textSize = width / 16;
    for (int i = 0; i < FONT_COUNT; ++i) {
        OH_Drawing_TextBlobBuilder *builder = OH_Drawing_TextBlobBuilderCreate();
        OH_Drawing_Font *font = OH_Drawing_FontCreate();
        OH_Drawing_Typeface *typeface = OH_Drawing_TypefaceCreateFromFile(g_paths[i], 0);
        OH_Drawing_FontSetTypeface(font, typeface);
        OH_Drawing_FontSetTextSize(font, textSize);
        const OH_Drawing_RunBuffer *runBuffer = OH_Drawing_TextBlobBuilderAllocRunPos(builder, font, 37, nullptr);
        // 以下为计算每个字的坐标设置的数据，无具体含义
        const float posX = width / 10.0;
        const float posY = height / 2.0;
        const float shortX = 1.6;
        const float enlargeY = 1.2;
        const int numberTwo = 2;
        const int wrap = 23;
        for (int j = 0; j < textCount; ++j) {
            runBuffer->glyphs[j] = glyphs[i][j];
            // 此处在第wrap个字符处换行
            if (j < wrap) {
                // 自定义字体排版中的横坐标，数据可自由指定
                runBuffer->pos[j * numberTwo] = posX + textSize * j / shortX;
                // 自定义字体排版中的纵坐标，数据可自由指定
                runBuffer->pos[j * numberTwo + 1] = posY + enlargeY * textSize * i * numberTwo;
            } else {
                // 自定义字体排版中的横坐标，数据可自由指定
                runBuffer->pos[j * numberTwo] = posX + textSize * (j - wrap) / shortX;
                // 自定义字体排版中的纵坐标，数据可自由指定
                runBuffer->pos[j * numberTwo + 1] = posY + enlargeY * textSize * (i * numberTwo + 1);
            }
        }
        OH_Drawing_TextBlob *textBlob = OH_Drawing_TextBlobBuilderMake(builder);
        OH_Drawing_CanvasDrawTextBlob(canvas, textBlob, 0, 0);
        
        // 第二种textBlob创建方式，通过字符串创建，带有基础的排版，且不支持字体退化
        const float tempY = 1.3;
        OH_Drawing_TextBlob *stringTextBlob =
            OH_Drawing_TextBlobCreateFromString("你好，This is the text for demonstration", font, TEXT_ENCODING_UTF8);
        OH_Drawing_CanvasDrawTextBlob(canvas, stringTextBlob, posX, height / tempY + textSize * i);
        
        OH_Drawing_TextBlobDestroy(textBlob);
        OH_Drawing_TextBlobBuilderDestroy(builder);
        OH_Drawing_TextBlobDestroy(stringTextBlob);
        OH_Drawing_TypefaceDestroy(typeface);
        OH_Drawing_FontDestroy(font);
    }
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_BrushDestroy(brush);
}

static void NativeOnDrawPixelMap(OH_Drawing_Canvas *canvas, NativePixelMap *native)
{
    OH_Drawing_CanvasSave(canvas);
    OH_Drawing_PixelMap *pixelMap = OH_Drawing_PixelMapGetFromNativePixelMap(native);
    OH_Drawing_SamplingOptions *sampling = OH_Drawing_SamplingOptionsCreate(FILTER_MODE_NEAREST, MIPMAP_MODE_NONE);
    OH_Drawing_Rect *src = OH_Drawing_RectCreate(0, 0, 550, 564);
    OH_Drawing_Rect *dst = OH_Drawing_RectCreate(25, 300, 300, 582);
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_CanvasDrawPixelMapRect(canvas, pixelMap, src, dst, sampling);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 设置样式，绘制时生效
    const float array[] = {
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 1, 0,
    };
    OH_Drawing_ColorFilter *colorFilter = OH_Drawing_ColorFilterCreateMatrix(array);
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    OH_Drawing_FilterSetColorFilter(filter, colorFilter);
    OH_Drawing_BrushSetFilter(brush, filter);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_CanvasTranslate(canvas, 300.f, 0.f);
    OH_Drawing_CanvasDrawPixelMapRect(canvas, pixelMap, src, dst, sampling);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_CanvasRestore(canvas);
    OH_Drawing_FilterDestroy(filter);
    OH_Drawing_ColorFilterDestroy(colorFilter);
    OH_Drawing_SamplingOptionsDestroy(sampling);
    OH_Drawing_RectDestroy(src);
    OH_Drawing_RectDestroy(dst);
}

// 开发者提供的native方法，入参有且仅有如下两个，开发者不需进行变更。
// napi_env 为当前运行的上下文
// napi_callback_info 记录了一些信息，包括从ArkTS侧传递过来参数等。
static napi_value OnDraw(napi_env env, napi_callback_info info)
{
    size_t argc = 6;
    napi_value args[6] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t id;
    napi_get_value_int32(env, args[0], &id);
    void *temp = nullptr;
    napi_unwrap(env, args[1], &temp);

    OH_Drawing_Canvas *canvas = reinterpret_cast<OH_Drawing_Canvas *>(temp);
    int32_t width;
    napi_get_value_int32(env, args[2], &width); // 2 means the second argument
    int32_t height;
    napi_get_value_int32(env, args[3], &height); // 3 means the third argument
    int32_t drawOption;
    napi_get_value_int32(env, args[4], &drawOption); // 4 means the forth argument
    NativePixelMap *nativePixelMap = OH_PixelMap_InitNativePixelMap(env, args[5]); // 5 means the forth argument
    
    if (drawOption == PATH) {
        NativeOnDrawPath(canvas, width, height);
    } else if (drawOption == TEXT) {
        NativeOnDrawText(canvas, width, height);
        NativeOnDrawTextBlob(canvas, width, height);
    } else if (drawOption == IMAGE) {
        NativeOnDrawPixelMap(canvas, nativePixelMap);
    }
    return nullptr;
}

static napi_value GetNodeDescriptors(napi_env env, napi_callback_info info) { return nullptr; }

EXTERN_C_START
// Init将在exports上挂上Add/NativeCallArkTS这些native方法，此处的exports就是开发者import之后获取到的ArkTS对象。
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"nativeGetNodeDescriptors", nullptr, GetNodeDescriptors, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"nativeOnDraw", nullptr, OnDraw, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    // 在exports这个ArkTs对象上，挂载native方法
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
