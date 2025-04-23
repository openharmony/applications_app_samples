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

OH_Drawing_Path* SampleGraphics::DrawPathBasicTriangle(float startX, float startY, int32_t w)
{
    // 创建路径对象
    OH_Drawing_Path *path = OH_Drawing_PathCreate();
    // 设置填充路径规则
    OH_Drawing_PathSetFillType(path, OH_Drawing_PathFillType::PATH_FILL_TYPE_EVEN_ODD);
    // 移动到起始点
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    // 添加线段
    OH_Drawing_PathLineTo(path, startX + value15_, startY + value150_);
    OH_Drawing_PathLineTo(path, startX + w - value15_, startY + value150_);
    // 闭合路径
    OH_Drawing_PathClose(path);
    // 判断路径是否包含坐标点
    SAMPLE_LOGI("PathBasic-->contains:%{public}d",
        OH_Drawing_PathContains(path, startX + value30_, startY + value100_) ? 1 : 0);
    // 判断路径是否闭合
    SAMPLE_LOGI("PathBasic-->isClosed:%{public}d", OH_Drawing_PathIsClosed(path, false) ? 1 : 0);
    // 获取路径长度
    SAMPLE_LOGI("PathBasic-->getLength:%{public}f", OH_Drawing_PathGetLength(path, false));
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(0, 0, 0, 0);
    // 获取边界
    OH_Drawing_PathGetBounds(path, rect);
    SAMPLE_LOGI("PathBasic-->getBounds:left=%{public}f,top=%{public}f,right=%{public}f,bottom=%{public}f",
        OH_Drawing_RectGetLeft(rect), OH_Drawing_RectGetTop(rect), OH_Drawing_RectGetRight(rect),
        OH_Drawing_RectGetBottom(rect));
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreate();
    // 获取变换矩阵
    OH_Drawing_PathGetMatrix(path, false, value50_, matrix, OH_Drawing_PathMeasureMatrixFlags::GET_POSITION_MATRIX);
    OH_Drawing_Point2D point{startX + value30_, startY + value150_};
    OH_Drawing_Point2D tangent{0, 0};
    // 获取坐标点和切线
    OH_Drawing_PathGetPositionTangent(path, false, 1, &point, &tangent);
    SAMPLE_LOGI("PathBasic-->tangent.x=%{public}f,tangent.y=%{public}f", tangent.x, tangent.y);
    OH_Drawing_MatrixDestroy(matrix);
    return path;
}

void SampleGraphics::DrawPathBasic(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value100_;
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetAntiAlias(pen, true);
    float penWidth = 3.f;
    OH_Drawing_PenSetWidth(pen, penWidth);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    
    // 三角形1
    OH_Drawing_Path *path = DrawPathBasicTriangle(startX, startY, w);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 三角形2
    // 复制路径
    OH_Drawing_Path *path_copy = OH_Drawing_PathCopy(path);
    OH_Drawing_Matrix *matrix_translate = OH_Drawing_MatrixCreateTranslation(w, 0);
    // 对路径进行矩阵变换
    OH_Drawing_PathTransform(path_copy, matrix_translate);
    OH_Drawing_CanvasDrawPath(canvas, path_copy);
    
    // 三角形3
    OH_Drawing_Path *path_third = OH_Drawing_PathCreate();
    // 对路径进行矩阵变换
    OH_Drawing_PathTransformWithPerspectiveClip(path_copy, matrix_translate, path_third, false);
    OH_Drawing_CanvasDrawPath(canvas, path_third);
    
    // 三角形4
    OH_Drawing_Path *path_fourth = OH_Drawing_PathCreate();
    OH_Drawing_PathOffset(path, path_fourth, w * indexThree_, 0);
    OH_Drawing_CanvasDrawPath(canvas, path_fourth);
    
    // 梯形
    startX += indexFour_ * w;
    OH_Drawing_Path *path_fifth = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(path_fifth, startX + value15_, startY);
    OH_Drawing_PathLineTo(path_fifth, startX + value15_, startY + value100_);
    OH_Drawing_PathLineTo(path_fifth, startX + w - value15_, startY + value100_);
    OH_Drawing_PathTransform(path_fourth, matrix_translate);
    // 将两个路径合并（取差集）
    OH_Drawing_PathOp(path_fifth, path_fourth, OH_Drawing_PathOpMode::PATH_OP_MODE_REVERSE_DIFFERENCE);
    OH_Drawing_CanvasDrawPath(canvas, path_fifth);
    
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PathDestroy(path);
    OH_Drawing_PathDestroy(path_copy);
    OH_Drawing_PathDestroy(path_third);
    OH_Drawing_PathDestroy(path_fourth);
    OH_Drawing_PathDestroy(path_fifth);
    OH_Drawing_MatrixDestroy(matrix_translate);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawPathTo1Line(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value100_;
    OH_Drawing_Path *path = OH_Drawing_PathCreate();
    
    // 线段
    OH_Drawing_PathMoveTo(path, startX + value15_, startY + value70_);
    OH_Drawing_PathLineTo(path, startX + w - value15_, startY + value70_);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 弧线
    startX += w;
    OH_Drawing_PathReset(path);
    float startDeg = 60;
    float sweepDeg = -240;
    OH_Drawing_PathArcTo(path, startX + value15_, startY + value30_, startX + w - value15_, startY + value150_,
        startDeg, sweepDeg);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 二阶贝塞尔曲线
    startX += w;
    OH_Drawing_PathReset(path);
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    OH_Drawing_PathQuadTo(path, startX + value30_, startY + value100_, startX + w - value15_, startY + value150_);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 二阶贝塞尔曲线(带权重)
    startX += w;
    OH_Drawing_PathReset(path);
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    float weight = 5.f;
    OH_Drawing_PathConicTo(path, startX + value30_, startY + value100_, startX + w - value15_, startY + value150_,
        weight);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 三阶贝塞尔曲线
    startX += w;
    OH_Drawing_PathReset(path);
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    OH_Drawing_PathCubicTo(path, startX + value30_, startY + value120_, startX + w - value30_, startY + value30_,
        startX + w - value15_, startY + value150_);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    OH_Drawing_PathDestroy(path);
}

void SampleGraphics::DrawPathTo2Line(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value300_;
    OH_Drawing_Path *path = OH_Drawing_PathCreate();
    
    // 线段
    OH_Drawing_PathMoveTo(path, startX, startY);
    OH_Drawing_PathRMoveTo(path, value15_, value70_);
    OH_Drawing_PathRLineTo(path, w - value30_, 0);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 二阶贝塞尔曲线
    startX += w;
    OH_Drawing_PathReset(path);
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    OH_Drawing_PathRQuadTo(path, value30_, value100_, w - value10_, value150_);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 二阶贝塞尔曲线(带权重)
    startX += w;
    OH_Drawing_PathReset(path);
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    float weight = 5.f;
    OH_Drawing_PathRConicTo(path, value30_, value100_, w - value15_, value150_, weight);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    // 三阶贝塞尔曲线
    startX += w;
    OH_Drawing_PathReset(path);
    OH_Drawing_PathMoveTo(path, startX + value15_, startY);
    OH_Drawing_PathRCubicTo(path, value30_, value120_, w - value30_, value30_, w - value10_, value150_);
    OH_Drawing_CanvasDrawPath(canvas, path);
    
    OH_Drawing_PathDestroy(path);
}

void SampleGraphics::DrawPathTo(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetAntiAlias(pen, true);
    float penWidth = 3.f;
    OH_Drawing_PenSetWidth(pen, penWidth);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    
    DrawPathTo1Line(canvas);
    OH_Drawing_CanvasTranslate(canvas, 0, value200_);
    DrawPathTo2Line(canvas);
    
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::DrawPathAdd1Line(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value100_;
    // 圆
    OH_Drawing_Path *pathCircle = OH_Drawing_PathCreate();
    float radius = 40;
    float startYAdded = 60;
    OH_Drawing_PathAddCircle(pathCircle, startX + w / indexTwo_, startY + startYAdded, radius, PATH_DIRECTION_CCW);
    OH_Drawing_CanvasDrawPath(canvas, pathCircle);
    OH_Drawing_PathDestroy(pathCircle);
    // 矩形
    startX += w;
    OH_Drawing_Path *pathRect = OH_Drawing_PathCreate();
    OH_Drawing_PathAddRect(pathRect, startX + value10_, startY + value30_, startX + w - value10_,
        startY + value90_, PATH_DIRECTION_CCW);
    OH_Drawing_CanvasDrawPath(canvas, pathRect);
    OH_Drawing_PathDestroy(pathRect);
    // 椭圆
    startX += w;
    OH_Drawing_Path *pathOval = OH_Drawing_PathCreate();
    OH_Drawing_Rect *rectOval = OH_Drawing_RectCreate(startX + value10_, startY + value30_,
        startX + w - value10_, startY + value90_);
    OH_Drawing_PathAddOval(pathOval, rectOval, OH_Drawing_PathDirection::PATH_DIRECTION_CW);
    OH_Drawing_CanvasDrawPath(canvas, pathOval);
    OH_Drawing_RectDestroy(rectOval);
    OH_Drawing_PathDestroy(pathOval);
    // 圆角矩形
    startX += w;
    OH_Drawing_Path *pathRoundRect = OH_Drawing_PathCreate();
    OH_Drawing_Rect *rectRoundRect = OH_Drawing_RectCreate(startX + value10_, startY + value30_,
        startX + w - value10_, startY + value90_);
    OH_Drawing_RoundRect *roundRect = OH_Drawing_RoundRectCreate(rectRoundRect, value20_, value20_);
    OH_Drawing_PathAddRoundRect(pathRoundRect, roundRect, PATH_DIRECTION_CCW);
    OH_Drawing_CanvasDrawPath(canvas, pathRoundRect);
    OH_Drawing_RectDestroy(rectRoundRect);
    OH_Drawing_PathDestroy(pathRoundRect);
    OH_Drawing_RoundRectDestroy(roundRect);
}

void SampleGraphics::DrawPathAdd2Line(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value100_;
    // 多边形
    OH_Drawing_Path *pathPolygon = OH_Drawing_PathCreate();
    float leftPointX = startX + value10_;
    float rightPointX = startX + w - value10_;
    float middlePointX = (leftPointX + rightPointX) / 2;
    OH_Drawing_Point2D points[] = {{middlePointX, startY + value30_}, {leftPointX, startY + value90_},
        {rightPointX, startY + value90_}};
    OH_Drawing_PathAddPolygon(pathPolygon, points, 3, true); // 3 is the size of point array
    OH_Drawing_CanvasDrawPath(canvas, pathPolygon);
    OH_Drawing_PathDestroy(pathPolygon);
    // 曲线
    startX += w;
    OH_Drawing_Rect *rectArc = OH_Drawing_RectCreate(startX - value30_, startY + value30_,
        startX + w - value10_, startY + value150_);
    OH_Drawing_Path *pathArc = OH_Drawing_PathCreate();
    OH_Drawing_PathAddArc(pathArc, rectArc, 0, -value90_);
    OH_Drawing_CanvasDrawPath(canvas, pathArc);
    OH_Drawing_RectDestroy(rectArc);
    OH_Drawing_PathDestroy(pathArc);
}

void SampleGraphics::DrawPathAdd3Line(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value100_;
    // 线段1
    OH_Drawing_Path *pathOuter1 = OH_Drawing_PathCreate();
    OH_Drawing_Path *pathInner1 = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(pathInner1, startX + value10_, startY);
    OH_Drawing_PathLineTo(pathInner1, startX + w - value10_, startY);
    OH_Drawing_Matrix *matrix1 = OH_Drawing_MatrixCreateTranslation(0, value50_);
    OH_Drawing_PathAddPath(pathOuter1, pathInner1, matrix1);
    OH_Drawing_CanvasDrawPath(canvas, pathOuter1);
    OH_Drawing_PathDestroy(pathOuter1);
    OH_Drawing_PathDestroy(pathInner1);
    OH_Drawing_MatrixDestroy(matrix1);
    // 线段2
    startX += w;
    OH_Drawing_Path *pathOuter2 = OH_Drawing_PathCreate();
    OH_Drawing_Path *pathInner2 = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(pathInner2, startX + value10_, startY + value50_);
    OH_Drawing_PathLineTo(pathInner2, startX + w - value10_, startY + value50_);
    OH_Drawing_PathAddPathWithMode(pathOuter2, pathInner2, OH_Drawing_PathAddMode::PATH_ADD_MODE_APPEND);
    OH_Drawing_CanvasDrawPath(canvas, pathOuter2);
    OH_Drawing_PathDestroy(pathOuter2);
    OH_Drawing_PathDestroy(pathInner2);
    // 线段3
    startX += w;
    OH_Drawing_Path *pathOuter3 = OH_Drawing_PathCreate();
    OH_Drawing_Path *pathInner3 = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(pathInner3, startX + value10_, startY);
    OH_Drawing_PathLineTo(pathInner3, startX + w - value10_, startY);
    OH_Drawing_PathAddPathWithOffsetAndMode(pathOuter3, pathInner3, 0, value50_,
        OH_Drawing_PathAddMode::PATH_ADD_MODE_APPEND);
    OH_Drawing_CanvasDrawPath(canvas, pathOuter3);
    OH_Drawing_PathDestroy(pathOuter3);
    OH_Drawing_PathDestroy(pathInner3);
    // 线段4
    startX += w;
    OH_Drawing_Path *pathOuter4 = OH_Drawing_PathCreate();
    OH_Drawing_Path *pathInner4 = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(pathInner4, startX + value10_, startY);
    OH_Drawing_PathLineTo(pathInner4, startX + w - value10_, startY);
    OH_Drawing_Matrix *matrix2 = OH_Drawing_MatrixCreateTranslation(0, value50_);
    OH_Drawing_PathAddPathWithMatrixAndMode(pathOuter4, pathInner4, matrix2,
        OH_Drawing_PathAddMode::PATH_ADD_MODE_APPEND);
    OH_Drawing_CanvasDrawPath(canvas, pathOuter4);
    OH_Drawing_PathDestroy(pathOuter4);
    OH_Drawing_PathDestroy(pathInner4);
    OH_Drawing_MatrixDestroy(matrix2);
}

void SampleGraphics::DrawPathAdd4Line(OH_Drawing_Canvas *canvas)
{
    int32_t w = width_ / indexFive_;
    float startX = 0;
    float startY = value100_;
    // 椭圆
    OH_Drawing_Path *pathOval = OH_Drawing_PathCreate();
    OH_Drawing_Rect *rectOval = OH_Drawing_RectCreate(startX + value10_, startY + value30_,
        startX + w - value10_, startY + value90_);
    OH_Drawing_PathAddOvalWithInitialPoint(pathOval, rectOval, 1, OH_Drawing_PathDirection::PATH_DIRECTION_CW);
    OH_Drawing_CanvasDrawPath(canvas, pathOval);
    OH_Drawing_RectDestroy(rectOval);
    OH_Drawing_PathDestroy(pathOval);
    // 矩形
    startX += w;
    OH_Drawing_Path *pathRect = OH_Drawing_PathCreate();
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(startX + value10_, startY + value30_,
        startX + w - value10_, startY + value90_);
    OH_Drawing_PathAddRectWithInitialCorner(pathRect, rect, PATH_DIRECTION_CCW, 1);
    OH_Drawing_CanvasDrawPath(canvas, pathRect);
    OH_Drawing_PathDestroy(pathRect);
    OH_Drawing_RectDestroy(rect);
}

void SampleGraphics::DrawPathAdd(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetAntiAlias(pen, true);
    float penWidth = 3.f;
    OH_Drawing_PenSetWidth(pen, penWidth);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    
    DrawPathAdd1Line(canvas);
    OH_Drawing_CanvasTranslate(canvas, 0, value200_);
    DrawPathAdd2Line(canvas);
    OH_Drawing_CanvasTranslate(canvas, 0, value200_);
    DrawPathAdd3Line(canvas);
    OH_Drawing_CanvasTranslate(canvas, 0, value200_);
    DrawPathAdd4Line(canvas);
    
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_PenDestroy(pen);
}

void SampleGraphics::BuildFromSvgString(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    char* str = "M150 130L30 300L270 300Z";
    OH_Drawing_Path* path = OH_Drawing_PathCreate();
    // 通过svg构建path
    OH_Drawing_PathBuildFromSvgString(path, str);
    OH_Drawing_CanvasDrawPath(canvas, path);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_PathDestroy(path);
}

void SampleGraphics::DrawStar(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    OH_Drawing_PenSetWidth(pen, value10_);
    OH_Drawing_PenSetJoin(pen, LINE_ROUND_JOIN);
    OH_Drawing_CanvasAttachPen(canvas, pen);
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMin_, rgbaMax_, rgbaMin_));
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    int len = value551_;
    float aX = value630_;
    float aY = value551_;
    float angle = 18.0f;
    float dX = aX - len * std::sin(angle);
    float dY = aY + len * std::cos(angle);
    float cX = aX + len * std::sin(angle);
    float cY = dY;
    float bX = aX + (len / 2.0);
    float bY = aY + std::sqrt((cX - dX) * (cX - dX) + (len / 2.0) * (len / 2.0));
    float eX = aX - (len / 2.0);
    float eY = bY;
    // 创建路径
    OH_Drawing_Path* path = OH_Drawing_PathCreate();
    // 到起始点
    OH_Drawing_PathMoveTo(path, aX, aY);
    // 绘制直线
    OH_Drawing_PathLineTo(path, bX, bY);
    OH_Drawing_PathLineTo(path, cX, cY);
    OH_Drawing_PathLineTo(path, dX, dY);
    OH_Drawing_PathLineTo(path, eX, eY);
    // 直线闭合，形成五角星
    OH_Drawing_PathClose(path);
    // 绘制闭合路径
    OH_Drawing_CanvasDrawPath(canvas, path);
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_PathDestroy(path);
}