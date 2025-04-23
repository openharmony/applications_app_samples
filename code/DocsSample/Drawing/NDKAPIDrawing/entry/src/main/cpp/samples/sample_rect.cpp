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

void SampleGraphics::DrawRectBasic(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_BrushSetAntiAlias(brush, true);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形对象
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(value200_, value200_, value500_, value500_);
    OH_Drawing_Rect* rect_copy = OH_Drawing_RectCreate(0, 0, 0, 0);
    OH_Drawing_RectCopy(rect, rect_copy);
    // 设置矩形left,right,top,bottom
    OH_Drawing_RectSetLeft(rect, value300_);
    OH_Drawing_RectSetTop(rect, value300_);
    OH_Drawing_RectSetRight(rect, value600_);
    OH_Drawing_RectSetBottom(rect, value600_);
    // 获取矩形left,right,top,bottom,width,height
    SAMPLE_LOGI(
        "left:%{public}f, right:%{public}f, top:%{public}f, bottom:%{public}f, width:%{public}f, height: %{public}f",
        OH_Drawing_RectGetLeft(rect), OH_Drawing_RectGetRight(rect), OH_Drawing_RectGetTop(rect),
        OH_Drawing_RectGetBottom(rect), OH_Drawing_RectGetWidth(rect), OH_Drawing_RectGetHeight(rect));
    SAMPLE_LOGI(
        "left:%{public}f, right:%{public}f, top:%{public}f, bottom:%{public}f, width:%{public}f, height: %{public}f",
        OH_Drawing_RectGetLeft(rect_copy), OH_Drawing_RectGetRight(rect_copy), OH_Drawing_RectGetTop(rect_copy),
        OH_Drawing_RectGetBottom(rect_copy), OH_Drawing_RectGetWidth(rect_copy), OH_Drawing_RectGetHeight(rect_copy));
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    OH_Drawing_CanvasDrawRect(canvas, rect_copy);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_RectDestroy(rect_copy);
}

void SampleGraphics::DrawRectIntersect(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_BrushSetAntiAlias(brush, true);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形对象
    OH_Drawing_Rect* rect1 = OH_Drawing_RectCreate(value200_, value200_, value500_, value500_);
    OH_Drawing_Rect* rect2 = OH_Drawing_RectCreate(value300_, value300_, value600_, value600_);
    // 取交集
    OH_Drawing_RectIntersect(rect1, rect2);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect1);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect1);
    OH_Drawing_RectDestroy(rect2);
}

void SampleGraphics::DrawRectJoin(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_BrushSetAntiAlias(brush, true);
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形对象
    OH_Drawing_Rect* rect1 = OH_Drawing_RectCreate(value200_, value200_, value500_, value500_);
    OH_Drawing_Rect* rect2 = OH_Drawing_RectCreate(value300_, value300_, value600_, value600_);
    // 取并集
    OH_Drawing_RectJoin(rect1, rect2);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect1);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect1);
    OH_Drawing_RectDestroy(rect2);
}

void SampleGraphics::DrawRoundRect(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(value100_, value100_, value900_, value600_);
    // 创建圆角矩形
    OH_Drawing_RoundRect* roundRect = OH_Drawing_RoundRectCreate(rect, value30_, value30_);
    OH_Drawing_RoundRectSetCorner(roundRect, OH_Drawing_CornerPos::CORNER_POS_TOP_LEFT, {value50_, value50_});
    OH_Drawing_Corner_Radii p = OH_Drawing_RoundRectGetCorner(roundRect, OH_Drawing_CornerPos::CORNER_POS_TOP_LEFT);
    SAMPLE_LOGI("top-left-corner:x=%{public}f, y:%{public}f", p.x, p.y);
    // 绘制圆角矩形
    OH_Drawing_CanvasDrawRoundRect(canvas, roundRect);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_RoundRectDestroy(roundRect);
}
