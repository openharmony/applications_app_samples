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
#include <native_window/external_window.h>
#include <native_drawing/drawing_bitmap.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_path.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_typography.h>
#include "common/log_common.h"

enum DrawType {
    NONE,
    PATH,
    RECT,
    TEXT
};

static void NativeOnDrawPath(OH_Drawing_Canvas *canvas, int32_t width, int32_t height)
{
    // native node draw function
    int len = height / 8;
    float aX = width / 4;
    float aY = height / 8;
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

static void NativeOnDrawRect(OH_Drawing_Canvas *canvas)
{
    // 创建一个左上角坐标为(150, 200)，右下角坐标为(400, 700)的矩形
    OH_Drawing_Rect *cRect = OH_Drawing_RectCreate(150, 200, 400, 700);
    
    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    OH_Drawing_Pen *cPen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(cPen, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0x00, 0x00));
    OH_Drawing_PenSetWidth(cPen, 10.0f); // pen width 10
    // 将Pen画笔设置到canvas中
    OH_Drawing_CanvasAttachPen(canvas, cPen);
    
    OH_Drawing_CanvasDrawRect(canvas, cRect);
    
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(cPen);
    OH_Drawing_RectDestroy(cRect);
}

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
    double fontSize = width / 30;
    OH_Drawing_SetTextStyleFontSize(txtStyle, fontSize);
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);
    OH_Drawing_SetTextStyleBaseLine(txtStyle, TEXT_BASELINE_ALPHABETIC);
    OH_Drawing_SetTextStyleFontHeight(txtStyle, 1);
    // 设置字体类型等
    const char *fontFamilies[] = {"Roboto"};
    OH_Drawing_SetTextStyleFontFamilies(txtStyle, 1, fontFamilies);
    OH_Drawing_SetTextStyleFontStyle(txtStyle, FONT_STYLE_NORMAL);
    OH_Drawing_SetTextStyleLocale(txtStyle, "en");
    OH_Drawing_TypographyCreate *handler =
        OH_Drawing_CreateTypographyHandler(typoStyle, OH_Drawing_CreateFontCollection());
    OH_Drawing_TypographyHandlerPushTextStyle(handler, txtStyle);
    // 设置文字内容
    const char *text = "Hello World Drawing\n";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    OH_Drawing_TypographyHandlerPopTextStyle(handler);
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width / 10.0, height / 4.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, canvas, position[0], position[1]);
}

// 开发者提供的native方法，入参有且仅有如下两个，开发者不需进行变更。
// napi_env 为当前运行的上下文
// napi_callback_info 记录了一些信息，包括从ArkTS侧传递过来参数等。
static napi_value OnDraw(napi_env env, napi_callback_info info)
{
    size_t argc = 5;
    napi_value args[5] = {nullptr};
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
    
    if (drawOption == PATH) {
        NativeOnDrawPath(canvas, width, height);
    } else if (drawOption == RECT) {
        NativeOnDrawRect(canvas);
    } else if (drawOption == TEXT) {
        NativeOnDrawText(canvas, width, height);
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
