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

void SampleGraphics::DrawBrushBasic(OH_Drawing_Canvas *canvas)
{
    // 创建画刷
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 设置填充颜色为红色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    // 开启抗锯齿效果
    OH_Drawing_BrushSetAntiAlias(brush, true);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect* rect1 = OH_Drawing_RectCreate(0, 0, value300_, value300_);
    // 绘制矩形1
    OH_Drawing_CanvasDrawRect(canvas, rect1);
    OH_Drawing_CanvasDetachBrush(canvas);
    // 复制画刷
    OH_Drawing_Brush* brush_copy = OH_Drawing_BrushCopy(brush);
    
    // 画刷重置
    OH_Drawing_BrushReset(brush);
    // 设置透明度
    OH_Drawing_BrushSetAlpha(brush, rgbaHalf_);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect* rect2 = OH_Drawing_RectCreate(value400_, value400_, value700_, value700_);
    // 绘制矩形2
    OH_Drawing_CanvasDrawRect(canvas, rect2);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    OH_Drawing_CanvasAttachBrush(canvas, brush_copy);
    OH_Drawing_Rect* rect3 = OH_Drawing_RectCreate(value800_, value800_, value1100_, value1100_);
    // 绘制矩形3
    OH_Drawing_CanvasDrawRect(canvas, rect3);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_BrushDestroy(brush_copy);
    OH_Drawing_RectDestroy(rect1);
    OH_Drawing_RectDestroy(rect2);
    OH_Drawing_RectDestroy(rect3);
}

void SampleGraphics::DrawMixedMode(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_CanvasClear(canvas, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMin_, rgbaMin_, rgbaMin_));
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value600_, value600_);
    // 绘制矩形（目标像素）
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMin_, rgbaMin_, 0xFF));
    // 设置混合模式为叠加模式
    OH_Drawing_BrushSetBlendMode(brush, OH_Drawing_BlendMode::BLEND_MODE_PLUS);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Point *point = OH_Drawing_PointCreate(value600_, value600_);
    // 绘制圆（源像素）
    OH_Drawing_CanvasDrawCircle(canvas, point, value300_);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_PointDestroy(point);
}

void SampleGraphics::DrawShaderEffect1Line(OH_Drawing_Canvas *canvas)
{
    // 线性渐变着色器
    OH_Drawing_Point *startPt = OH_Drawing_PointCreate(value100_, value100_);
    OH_Drawing_Point *endPt = OH_Drawing_PointCreate(value300_, value300_);
    uint32_t colors[] = {
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMax_, rgbaMin_),
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_),
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMin_, rgbaMin_, rgbaMax_)};
    float pos[] = {0.0f, 0.5f, 1.0f};
    OH_Drawing_ShaderEffect *linearShaderEffect1 =
        OH_Drawing_ShaderEffectCreateLinearGradient(startPt, endPt, colors, pos, indexThree_,
            OH_Drawing_TileMode::CLAMP);
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 基于画刷设置着色器
    OH_Drawing_BrushSetShaderEffect(brush, linearShaderEffect1);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value300_, value300_);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 使用矩阵创建线性渐变着色器
    OH_Drawing_CanvasTranslate(canvas, value300_, 0.f);
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreate();
    OH_Drawing_MatrixScale(matrix, 2.0f, 1.0f, value200_, value200_);
    OH_Drawing_Point2D startPt2{value100_, value100_};
    OH_Drawing_Point2D endPt2{value300_, value300_};
    OH_Drawing_ShaderEffect *linearShaderEffect2 = OH_Drawing_ShaderEffectCreateLinearGradientWithLocalMatrix(
        &startPt2, &endPt2, colors, pos, indexThree_, OH_Drawing_TileMode::CLAMP, matrix);
    OH_Drawing_BrushSetShaderEffect(brush, linearShaderEffect2);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ShaderEffectDestroy(linearShaderEffect1);
    OH_Drawing_ShaderEffectDestroy(linearShaderEffect2);
    OH_Drawing_PointDestroy(startPt);
    OH_Drawing_PointDestroy(endPt);
    OH_Drawing_MatrixDestroy(matrix);
}

void SampleGraphics::DrawShaderEffect2Line(OH_Drawing_Canvas *canvas)
{
    uint32_t colors[] = {
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMax_, rgbaMin_),
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_),
        OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMin_, rgbaMin_, rgbaMax_)};
    float pos[] = {0.0f, 0.5f, 1.0f};
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value300_, value300_);
    
    // 径向渐变着色器
    OH_Drawing_Point *centerPt = OH_Drawing_PointCreate(value200_, value200_);
    OH_Drawing_ShaderEffect *radialShaderEffect =
        OH_Drawing_ShaderEffectCreateRadialGradient(centerPt, value200_, colors, pos, indexThree_,
            OH_Drawing_TileMode::REPEAT);
    OH_Drawing_BrushSetShaderEffect(brush, radialShaderEffect);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 扇形渐变着色器
    OH_Drawing_CanvasTranslate(canvas, value300_, 0.f);
    OH_Drawing_ShaderEffect* sweepShaderEffect =
        OH_Drawing_ShaderEffectCreateSweepGradient(centerPt, colors, pos, indexThree_, OH_Drawing_TileMode::CLAMP);
    OH_Drawing_BrushSetShaderEffect(brush, sweepShaderEffect);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 双圆锥渐变着色器
    OH_Drawing_CanvasTranslate(canvas, value300_, 0.f);
    OH_Drawing_Point2D pt3{value200_, value200_};
    OH_Drawing_ShaderEffect *twoPointShaderEffect = OH_Drawing_ShaderEffectCreateTwoPointConicalGradient(
        &pt3, value30_, &pt3, value100_, colors, pos, indexThree_, OH_Drawing_TileMode::CLAMP, nullptr);
    OH_Drawing_BrushSetShaderEffect(brush, twoPointShaderEffect);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ShaderEffectDestroy(radialShaderEffect);
    OH_Drawing_ShaderEffectDestroy(sweepShaderEffect);
    OH_Drawing_ShaderEffectDestroy(twoPointShaderEffect);
}

void SampleGraphics::DrawShaderEffect(OH_Drawing_Canvas *canvas)
{
    // 线性渐变着色器
    DrawShaderEffect1Line(canvas);
    OH_Drawing_CanvasTranslate(canvas, -value300_, value300_);
    DrawShaderEffect2Line(canvas);
}

void SampleGraphics::DrawColorFilter(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetAntiAlias(brush, true);
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value300_, value300_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    OH_Drawing_CanvasTranslate(canvas, 0.f, value300_);
    // 创建luma亮度颜色滤波器
    OH_Drawing_ColorFilter* lumaColorFilter = OH_Drawing_ColorFilterCreateLuma();
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    OH_Drawing_FilterSetColorFilter(filter, lumaColorFilter);
    OH_Drawing_BrushSetFilter(brush, filter);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 绘制经过luma亮度颜色滤波器效果的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    OH_Drawing_CanvasTranslate(canvas, 0.f, value300_);
    const float matrix[20] = {
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 0.5f, 0.5f, 0,
    0, 0, 0.5f, 0.5f, 0
    };
    // 创建5*4矩阵颜色滤波器
    OH_Drawing_ColorFilter* matrixColorFilter = OH_Drawing_ColorFilterCreateMatrix(matrix);
    // 创建从SRGB转换到线性颜色空间的颜色滤波器
    OH_Drawing_ColorFilter* s2lColorFilter = OH_Drawing_ColorFilterCreateSrgbGammaToLinear();
    // 创建从线性颜色空间转换到SRGB的颜色滤波器
    OH_Drawing_ColorFilter* l2sColorFilter = OH_Drawing_ColorFilterCreateLinearToSrgbGamma();
    // 创建合成滤波器
    OH_Drawing_ColorFilter* composeColorFilter1 =
        OH_Drawing_ColorFilterCreateCompose(matrixColorFilter, s2lColorFilter);
    OH_Drawing_ColorFilter* composeColorFilter2 =
        OH_Drawing_ColorFilterCreateCompose(composeColorFilter1, l2sColorFilter);
    OH_Drawing_FilterSetColorFilter(filter, composeColorFilter1);
    OH_Drawing_BrushSetFilter(brush, filter);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 绘制经过合成颜色滤波器效果的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_ColorFilterDestroy(matrixColorFilter);
    OH_Drawing_ColorFilterDestroy(lumaColorFilter);
    OH_Drawing_ColorFilterDestroy(s2lColorFilter);
    OH_Drawing_ColorFilterDestroy(l2sColorFilter);
    OH_Drawing_ColorFilterDestroy(composeColorFilter1);
    OH_Drawing_ColorFilterDestroy(composeColorFilter2);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
}

void SampleGraphics::DrawMaskFilterBrush(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetAntiAlias(brush, true);
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    // 创建模糊蒙版滤波器
    OH_Drawing_MaskFilter *maskFilter = OH_Drawing_MaskFilterCreateBlur(OH_Drawing_BlurType::NORMAL, 20, true);
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    OH_Drawing_FilterSetMaskFilter(filter, maskFilter);
    // 设置画刷的滤波器效果
    OH_Drawing_BrushSetFilter(brush, filter);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value600_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_MaskFilterDestroy(maskFilter);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
}
