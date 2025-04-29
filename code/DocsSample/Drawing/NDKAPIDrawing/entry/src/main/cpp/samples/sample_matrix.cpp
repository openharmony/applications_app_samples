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
#include "common/log_common.h"

void SampleGraphics::DrawMatrixBasic(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 创建矩阵对象
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreate();
    // 设置矩阵(平移)
    OH_Drawing_MatrixSetMatrix(matrix, indexOne_, 0, value300_, 0, indexOne_, value300_, 0, 0, indexOne_);
    OH_Drawing_Point2D src{value300_, value300_};
    OH_Drawing_Point2D dst;
    // 源点坐标变换为目标点坐标
    OH_Drawing_MatrixMapPoints(matrix, &src, &dst, indexOne_);
    SAMPLE_LOGI("DrawMatrixBasic-->point(src) x=%{public}f,y=%{public}f", src.x, src.y);
    SAMPLE_LOGI("DrawMatrixBasic-->point(dst) x=%{public}f,y=%{public}f", dst.x, dst.y);
    OH_Drawing_Rect *rect2 = OH_Drawing_RectCreate(0, 0, 0, 0);
    // 源矩形变换为目标矩形
    OH_Drawing_MatrixMapRect(matrix, rect, rect2);
    SAMPLE_LOGI("DrawMatrixBasic-->rect(src) left=%{public}f,top=%{public}f,right=%{public}f,bottom=%{public}f",
        OH_Drawing_RectGetLeft(rect), OH_Drawing_RectGetTop(rect), OH_Drawing_RectGetRight(rect),
        OH_Drawing_RectGetBottom(rect));
    SAMPLE_LOGI("DrawMatrixBasic-->rect(dst) left=%{public}f,top=%{public}f,right=%{public}f,bottom=%{public}f",
        OH_Drawing_RectGetLeft(rect2), OH_Drawing_RectGetTop(rect2), OH_Drawing_RectGetRight(rect2),
        OH_Drawing_RectGetBottom(rect2));
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix *matrix2 = OH_Drawing_MatrixCreate();
    // 逆矩阵
    OH_Drawing_MatrixInvert(matrix2, matrix);
    SAMPLE_LOGI(
        "matrix2(%{public}f,%{public}f,%{public}f,%{public}f,%{public}f,%{public}f,%{public}f,%{public}f,%{public}f)",
        OH_Drawing_MatrixGetValue(matrix, 0), OH_Drawing_MatrixGetValue(matrix, indexOne_),
        OH_Drawing_MatrixGetValue(matrix, indexTwo_), OH_Drawing_MatrixGetValue(matrix, indexThree_),
        OH_Drawing_MatrixGetValue(matrix, indexFour_), OH_Drawing_MatrixGetValue(matrix, indexFive_),
        OH_Drawing_MatrixGetValue(matrix, indexSix_), OH_Drawing_MatrixGetValue(matrix, indexSeven_),
        OH_Drawing_MatrixGetValue(matrix, indexNine_));
    // 重置矩阵
    OH_Drawing_MatrixReset(matrix);
    OH_Drawing_CanvasDetachBrush(canvas);
    // 释放对象
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_RectDestroy(rect2);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_MatrixDestroy(matrix2);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawTranslationOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 创建在水平和垂直方向分别平移300px的矩阵对象
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreateTranslation(value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawPreTranslationOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreate();
    // 旋转
    OH_Drawing_MatrixRotate(matrix, value45_, value300_, value300_);
    // 左乘平移（先平移后旋转）
    OH_Drawing_MatrixPreTranslate(matrix, value200_, value200_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawPostTranslationOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreate();
    // 旋转
    OH_Drawing_MatrixRotate(matrix, value45_, value300_, value300_);
    // 右乘平移（先旋转后平移）
    OH_Drawing_MatrixPostTranslate(matrix, value200_, value200_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawRotationOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 创建旋转的矩阵对象
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreateRotation(value45_, value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawPreRotationOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreate();
    // 平移
    OH_Drawing_MatrixTranslate(matrix, value200_, value200_);
    // 左乘旋转（先旋转后平移）
    OH_Drawing_MatrixPreRotate(matrix, value45_, value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawPostRotationOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreate();
    // 平移
    OH_Drawing_MatrixTranslate(matrix, value200_, value200_);
    // 右乘旋转（先平移后旋转）
    OH_Drawing_MatrixPostRotate(matrix, value45_, value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawScaleOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 创建缩放的矩阵对象
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreateScale(2, 2, value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_MatrixDestroy(matrix);
}

void SampleGraphics::DrawPreScaleOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreateTranslation(value100_, value100_);
    // 左乘缩放（先缩放后平移）
    OH_Drawing_MatrixPreScale(matrix, indexTwo_, indexTwo_, value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_MatrixDestroy(matrix);
}

void SampleGraphics::DrawPostScaleOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreateTranslation(value100_, value100_);
    // 右乘缩放（先平移后缩放）
    OH_Drawing_MatrixPostScale(matrix, indexTwo_, indexTwo_, value300_, value300_);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_MatrixDestroy(matrix);
}

void SampleGraphics::DrawConcatOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix* matrix1 = OH_Drawing_MatrixCreateTranslation(value100_, value100_);
    OH_Drawing_Matrix* matrix2 = OH_Drawing_MatrixCreate();
    OH_Drawing_Matrix* matrix3 = OH_Drawing_MatrixCreate();
    OH_Drawing_MatrixScale(matrix2, indexTwo_, indexTwo_, value300_, value300_);
    OH_Drawing_MatrixConcat(matrix3, matrix2, matrix1);
    OH_Drawing_CanvasConcatMatrix(canvas, matrix3);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_MatrixDestroy(matrix1);
    OH_Drawing_MatrixDestroy(matrix2);
    OH_Drawing_MatrixDestroy(matrix3);
}
