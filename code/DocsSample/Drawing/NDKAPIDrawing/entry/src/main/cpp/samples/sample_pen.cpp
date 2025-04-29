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

#include <native_drawing/drawing_image.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_point.h>
#include <native_drawing/drawing_region.h>
#include <native_drawing/drawing_round_rect.h>
#include <native_drawing/drawing_sampling_options.h>
#include <native_drawing/drawing_pixel_map.h>
#include <native_drawing/drawing_text_blob.h>
#include <native_drawing/drawing_shader_effect.h>
#include <native_drawing/drawing_gpu_context.h>
#include <native_drawing/drawing_surface.h>
#include <native_drawing/drawing_path_effect.h>
#include <native_drawing/drawing_color_filter.h>
#include <native_drawing/drawing_filter.h>
#include <native_drawing/drawing_image_filter.h>
#include <native_drawing/drawing_mask_filter.h>
#include <native_drawing/drawing_matrix.h>
#include "sample_graphics.h"

void SampleGraphics::DrawPenBasic(OH_Drawing_Canvas *canvas)
{
    // 创建画笔对象
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // 设置画笔描边颜色为红色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, value20_);
    // 设置抗锯齿
    OH_Drawing_PenSetAntiAlias(pen, true);
    // 在画布中设置画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect* rect1 = OH_Drawing_RectCreate(value100_, value100_, value400_, value400_);
    // 绘制矩形1
    OH_Drawing_CanvasDrawRect(canvas, rect1);
    OH_Drawing_CanvasDetachPen(canvas);
    // 复制画笔
    OH_Drawing_Pen* pen_copy = OH_Drawing_PenCopy(pen);
    
    // 画刷重置
    OH_Drawing_PenReset(pen);
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, value20_);
    // 设置透明度
    OH_Drawing_PenSetAlpha(pen, rgbaHalf_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect* rect2 = OH_Drawing_RectCreate(value500_, value500_, value800_, value800_);
    // 绘制矩形2
    OH_Drawing_CanvasDrawRect(canvas, rect2);
    OH_Drawing_CanvasDetachPen(canvas);
    
    OH_Drawing_CanvasAttachPen(canvas, pen_copy);
    OH_Drawing_Rect* rect3 = OH_Drawing_RectCreate(value900_, value900_, value1200_, value1200_);
    // 绘制矩形3
    OH_Drawing_CanvasDrawRect(canvas, rect3);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_PenDestroy(pen_copy);
    OH_Drawing_RectDestroy(rect1);
    OH_Drawing_RectDestroy(rect2);
    OH_Drawing_RectDestroy(rect3);
}

void SampleGraphics::DrawPenLinearGradient(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Point *startPt = OH_Drawing_PointCreate(value120_, value120_);
    OH_Drawing_Point *endPt = OH_Drawing_PointCreate(value1000_, value1000_);
    uint32_t colors[] = {
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMax_, rgbaMin_),
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_),
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMin_, rgbaMin_, rgbaMax_)};
    float pos2 = 0.5f;
    float pos[] = {0.0f, pos2, 1.0f};
    // 创建线性渐变着色器效果
    OH_Drawing_ShaderEffect *shaderEffect =
        OH_Drawing_ShaderEffectCreateLinearGradient(startPt, endPt, colors, pos, 3, OH_Drawing_TileMode::CLAMP);
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetWidth(pen, value150_);
    // 基于画笔设置着色器效果
    OH_Drawing_PenSetShaderEffect(pen, shaderEffect);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value200_, value200_, value1000_, value1000_);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ShaderEffectDestroy(shaderEffect);
    OH_Drawing_PointDestroy(startPt);
    OH_Drawing_PointDestroy(endPt);
}

void SampleGraphics::DrawMiterLimit(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    uint32_t color = OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_);
    OH_Drawing_PenSetColor(pen, color);
    float width = value50_;
    OH_Drawing_PenSetWidth(pen, width);
    OH_Drawing_PenSetAntiAlias(pen, true);
    // 设置画笔转角样式
    OH_Drawing_PenSetJoin(pen, OH_Drawing_PenLineJoinStyle::LINE_MITER_JOIN);
    // 设置折角尖角的限制值
    OH_Drawing_PenSetMiterLimit(pen, value15_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Path* path = OH_Drawing_PathCreate();
    float aX = value100_;
    float aY = value100_;
    float bX = value100_;
    float bY = value800_;
    float cX = value200_;
    float cY = value100_;
    OH_Drawing_PathMoveTo(path, aX, aY);
    OH_Drawing_PathLineTo(path, bX, bY);
    OH_Drawing_PathLineTo(path, cX, cY);
    OH_Drawing_CanvasDrawPath(canvas, path);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_PathDestroy(path);
}

void SampleGraphics::DrawStroke(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    uint32_t color = OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_);
    OH_Drawing_PenSetColor(pen, color);
    float width = value50_;
    OH_Drawing_PenSetWidth(pen, width);
    OH_Drawing_PenSetAntiAlias(pen, true);
    // 设置画笔线帽样式
    OH_Drawing_PenSetCap(pen, OH_Drawing_PenLineCapStyle::LINE_ROUND_CAP);
    // 设置画笔转角样式
    OH_Drawing_PenSetJoin(pen, OH_Drawing_PenLineJoinStyle::LINE_BEVEL_JOIN);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建路径
    OH_Drawing_Path* path = OH_Drawing_PathCreate();
    float aX = value100_;
    float aY = value100_;
    float bX = value100_;
    float bY = value800_;
    float cX = value800_;
    float cY = value800_;
    float dX = value800_;
    float dY = value100_;
    // 到起始点
    OH_Drawing_PathMoveTo(path, aX, aY);
    // 绘制直线
    OH_Drawing_PathLineTo(path, bX, bY);
    OH_Drawing_PathLineTo(path, cX, cY);
    OH_Drawing_PathLineTo(path, dX, dY);
    OH_Drawing_CanvasDrawPath(canvas, path);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_PathDestroy(path);
}

void SampleGraphics::DrawPathEffect(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    // 表示10px的实线，5px的间隔，2px的实线，5px的间隔，以此循环
    float intervals[] = {value10_, 5, 2, 5};
    // 创建虚线路径效果
    int count = 4;
    OH_Drawing_PathEffect *pathEffect = OH_Drawing_CreateDashPathEffect(intervals, count, 0.0);
    OH_Drawing_PenSetPathEffect(pen, pathEffect);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_PathEffectDestroy(pathEffect);
}

void SampleGraphics::DrawImageFilter(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetAntiAlias(pen, true);
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value20_);
    // 创建图像滤波器实现模糊效果
    OH_Drawing_ImageFilter *imageFilter =
        OH_Drawing_ImageFilterCreateBlur(value20_, value20_, OH_Drawing_TileMode::CLAMP, nullptr);
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    // 为滤波器对象设置图像滤波器
    OH_Drawing_FilterSetImageFilter(filter, imageFilter);
    // 设置画笔的滤波器效果
    OH_Drawing_PenSetFilter(pen, filter);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_ImageFilterDestroy(imageFilter);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
}

void SampleGraphics::DrawMaskFilterPen(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetAntiAlias(pen, true);
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value20_);
    // 创建蒙版滤波器
    OH_Drawing_MaskFilter *maskFilter = OH_Drawing_MaskFilterCreateBlur(OH_Drawing_BlurType::NORMAL, value20_, true);
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    OH_Drawing_FilterSetMaskFilter(filter, maskFilter);
    // 设置画笔的滤波器效果
    OH_Drawing_PenSetFilter(pen, filter);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value600_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_MaskFilterDestroy(maskFilter);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
}
