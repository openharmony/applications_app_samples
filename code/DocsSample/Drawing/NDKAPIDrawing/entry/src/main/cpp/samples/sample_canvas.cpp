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

void SampleGraphics::DrawCreateCanvas(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Bitmap* bitmap = OH_Drawing_BitmapCreate();
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    uint64_t width = width_ / 2;
    uint64_t height = height_ / 2;
    OH_Drawing_BitmapBuild(bitmap, width, height, &cFormat);
    // 创建一个canvas对象
    OH_Drawing_Canvas* newCanvas = OH_Drawing_CanvasCreate();
    // 将画布与bitmap绑定，画布画的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(newCanvas, bitmap);
    // 使用红色清除画布内容
    OH_Drawing_CanvasClear(newCanvas, OH_Drawing_ColorSetArgb(rgbaHalf_, rgbaMax_, rgbaMin_, rgbaMin_));
    // 获取画布宽高
    SAMPLE_LOGI("Canvas-->width=%{public}d,height=%{public}d", OH_Drawing_CanvasGetWidth(newCanvas),
        OH_Drawing_CanvasGetHeight(newCanvas));
    OH_Drawing_CanvasDrawBitmap(canvas, bitmap, 0, 0);
    OH_Drawing_CanvasDestroy(newCanvas);
    OH_Drawing_BitmapDestroy(bitmap);
}

void SampleGraphics::DrawCanvasConcatMatrix(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value600_, value500_);
    // 绘制原始矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix *matrix1 = OH_Drawing_MatrixCreateTranslation(value300_, value300_);
    // 对画布进行矩阵操作
    OH_Drawing_CanvasConcatMatrix(canvas, matrix1);
    // 绘制变换后的矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_Matrix *matrix2 = OH_Drawing_MatrixCreate();
    OH_Drawing_CanvasGetTotalMatrix(canvas, matrix2);
    SAMPLE_LOGI("Canvas-->MatrixIsEqual=%{public}d", OH_Drawing_MatrixIsEqual(matrix1, matrix2) ? 1 : 0);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix1);
    OH_Drawing_MatrixDestroy(matrix2);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawClipOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, 0xff0000ff);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value200_, value200_, value1000_, value1000_);
    // 裁剪矩形区域
    OH_Drawing_CanvasClipRect(canvas, rect, OH_Drawing_CanvasClipOp::INTERSECT, true);
    OH_Drawing_Rect* rect2 = OH_Drawing_RectCreate(0, 0, 0, 0);
    OH_Drawing_CanvasGetLocalClipBounds(canvas, rect2);
    SAMPLE_LOGI("Canvas-->ClipBounds:top=%{public}f,left=%{public}f,right=%{public}f,bottom=%{public}f",
        OH_Drawing_RectGetTop(rect2), OH_Drawing_RectGetLeft(rect2), OH_Drawing_RectGetRight(rect2),
        OH_Drawing_RectGetBottom(rect2));
    OH_Drawing_Path *path = OH_Drawing_PathCreate();
    OH_Drawing_PathAddCircle(path, value200_, value200_, value400_, PATH_DIRECTION_CCW);
    // 裁剪圆形区域
    OH_Drawing_CanvasClipPath(canvas, path, OH_Drawing_CanvasClipOp::DIFFERENCE, true);
    // 绘制背景
    OH_Drawing_CanvasDrawBackground(canvas, brush);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_PathDestroy(path);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_RectDestroy(rect2);
}

void SampleGraphics::CanvasSaveOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 保存当前画布状态
    OH_Drawing_CanvasSave(canvas);
    // 平移
    OH_Drawing_CanvasTranslate(canvas, 0.f, value200_);
    // 保存当前画布状态
    OH_Drawing_CanvasSave(canvas);
    // 获取画布状态数量
    SAMPLE_LOGI("Canvas-->saveCount=%{public}d", OH_Drawing_CanvasGetSaveCount(canvas));
    // 放大
    OH_Drawing_CanvasScale(canvas, 2.f, 2.f);
    OH_Drawing_Point* point = OH_Drawing_PointCreate(value300_, value300_);
    // 绘制圆形（经过放大和移动）
    OH_Drawing_CanvasDrawCircle(canvas, point, value100_);
    // 恢复操作
    OH_Drawing_CanvasRestore(canvas);
    // 绘制圆形（仅经过移动）
    OH_Drawing_CanvasDrawCircle(canvas, point, value100_);
    // 恢复操作至最初状态
    OH_Drawing_CanvasRestoreToCount(canvas, 0);
    // 绘制圆形（原始状态）
    OH_Drawing_CanvasDrawCircle(canvas, point, value100_);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_PointDestroy(point);
}

void SampleGraphics::CanvasSaveLayerOperation(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush* brush1 = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush1, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush1);
    OH_Drawing_Brush* brush2 = OH_Drawing_BrushCreate();
    // 创建图像滤波器实现模糊效果
    OH_Drawing_ImageFilter *imageFilter =
        OH_Drawing_ImageFilterCreateBlur(value30_, value30_, OH_Drawing_TileMode::CLAMP, nullptr);
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    OH_Drawing_FilterSetImageFilter(filter, imageFilter);
    OH_Drawing_BrushSetFilter(brush2, filter);
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(0.f, 0.f, width_, height_);
    // 保存当前画布状态
    OH_Drawing_CanvasSaveLayer(canvas, rect, brush2);
    OH_Drawing_Point* point1 = OH_Drawing_PointCreate(value300_, value300_);
    // 绘制圆形（经过模糊操作）
    OH_Drawing_CanvasDrawCircle(canvas, point1, value100_);
    // 恢复操作
    OH_Drawing_CanvasRestore(canvas);
    OH_Drawing_Point* point2 = OH_Drawing_PointCreate(value300_, value700_);
    // 绘制圆形
    OH_Drawing_CanvasDrawCircle(canvas, point2, value100_);
    OH_Drawing_CanvasDetachBrush(canvas);
    // 释放对象
    OH_Drawing_ImageFilterDestroy(imageFilter);
    OH_Drawing_BrushDestroy(brush1);
    OH_Drawing_BrushDestroy(brush2);
    OH_Drawing_PointDestroy(point1);
    OH_Drawing_PointDestroy(point2);
    OH_Drawing_RectDestroy(rect);
}

void SampleGraphics::DrawRegion(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 矩形区域1
    OH_Drawing_Region *region1 = OH_Drawing_RegionCreate();
    OH_Drawing_Rect *rect1 = OH_Drawing_RectCreate(value100_, value100_, value600_, value600_);
    OH_Drawing_RegionSetRect(region1, rect1);
    // 矩形区域2
    OH_Drawing_Region *region2 = OH_Drawing_RegionCreate();
    OH_Drawing_Rect *rect2 = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    OH_Drawing_RegionSetRect(region2, rect2);
    // 两个矩形区域组合
    OH_Drawing_RegionOp(region1, region2, OH_Drawing_RegionOpMode::REGION_OP_MODE_XOR);
    OH_Drawing_CanvasDrawRegion(canvas, region1);
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RegionDestroy(region1);
    OH_Drawing_RegionDestroy(region2);
    OH_Drawing_RectDestroy(rect1);
    OH_Drawing_RectDestroy(rect2);
}
