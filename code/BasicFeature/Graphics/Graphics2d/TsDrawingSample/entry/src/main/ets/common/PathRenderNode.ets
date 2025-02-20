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

import { RenderNode, DrawContext } from '@ohos.arkui.node';
import drawing from '@ohos.graphics.drawing';
import common2D from '@ohos.graphics.common2D';
import display from '@ohos.display';

let screen = display.getDefaultDisplaySync();
let screenWidth: number = screen.width;

export class PathRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let startX = 80.0;
    let startY = 50.0;
    let font = new drawing.Font();
    font.setSize(screenWidth / 20);
    let text = getContext().resourceManager.getStringSync($r('app.string.PathWithBrush'));
    const textBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY);
    // 路径填充
    let brush = new drawing.Brush();
    let brush_color: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0x00,
      blue: 0xFF
    };
    brush.setColor(brush_color);
    canvas.attachBrush(brush);
    let len = 120.0;
    let aX = 150.0;
    let aY = 80.0;
    let dX = aX - len * Math.sin(18.0);
    let dY = aY + len * Math.cos(18.0);
    let cX = aX + len * Math.sin(18.0);
    let cY = dY;
    let bX = aX + (len / 2.0);
    let bY = aY + Math.sqrt((cX - dX) * (cX - dX) + (len / 2.0) * (len / 2.0));
    let eX = aX - (len / 2.0);
    let eY = bY;
    let cPath = new drawing.Path();
    cPath.moveTo(aX, aY);
    cPath.lineTo(bX, bY);
    cPath.lineTo(cX, cY);
    cPath.lineTo(dX, dY);
    cPath.lineTo(eX, eY);
    cPath.close();
    canvas.drawPath(cPath);
    canvas.detachBrush();

    let startX2 = 380.0;
    let startY2 = 50.0;
    let font2 = new drawing.Font();
    font2.setSize(screenWidth / 20);
    let text1 = getContext().resourceManager.getStringSync($r('app.string.PathWithPen'));
    const textBlob2 = drawing.TextBlob.makeFromString(text1, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob2, startX2, startY2);
    // 路径描边
    let cPen = new drawing.Pen();
    cPen.setAntiAlias(true);
    let cPenColor: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0x00,
      blue: 0xFF
    };
    cPen.setColor(cPenColor);
    cPen.setStrokeWidth(10.0);
    canvas.attachPen(cPen);
    let cPath2 = new drawing.Path();
    const centerX = 450.0;
    const centerY = 180.0;
    const outerRadius = 80; // 外圆半径
    const innerRadius = 30; // 内圆半径
    const points = 5; // 五角星的角数
    for (let i = 0; i < points * 2; i++) {
      const angle = (i * Math.PI) / points; // 计算角度
      const radius = i % 2 === 0 ? outerRadius : innerRadius; // 交替使用外圆半径和内圆半径
      const x = centerX + radius * Math.cos(angle + 60.0);
      const y = centerY + radius * Math.sin(angle + 60.0);
      if (i === 0) {
        cPath2.moveTo(x, y);
      } else {
        cPath2.lineTo(x, y);
      }
    }
    cPath2.close();
    canvas.drawPath(cPath2);
    canvas.detachPen();

    let startX3 = 80.0;
    let startY3 = 330.0;
    let font3 = new drawing.Font();
    font3.setSize(screenWidth / 20);
    let text2 = getContext().resourceManager.getStringSync($r('app.string.CurveClose'));
    const textBlob3 = drawing.TextBlob.makeFromString(text2, font3, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob3, startX3, startY3);
    // 曲线闭合
    let cPath3 = new drawing.Path();
    cPath3.moveTo(100.0, 380.0);
    cPath3.rCubicTo(200.0, 200.0, 200.0, 100.0, 200.0, 50.0);
    cPath3.close();
    let cPen2 = new drawing.Pen();
    cPen2.setAntiAlias(true);
    let cPen2Color: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0x00,
      blue: 0xFF
    };
    cPen2.setColor(cPen2Color);
    cPen2.setStrokeWidth(8.0);
    canvas.attachPen(cPen2);
    let qBrush = new drawing.Brush();
    let qBrushColor: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0xFF,
      blue: 0xFF
    };
    qBrush.setColor(qBrushColor);
    canvas.attachBrush(qBrush);
    canvas.drawPath(cPath3);
    canvas.detachPen();
    canvas.detachBrush();

    let startX4 = 350.0;
    let startY4 = 330.0;
    let font4 = new drawing.Font();
    font4.setSize(screenWidth / 20);
    let text3 = getContext().resourceManager.getStringSync($r('app.string.CurveNotClose'));
    const textBlob4 = drawing.TextBlob.makeFromString(text3, font4, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob4, startX4, startY4);
    // 曲线未闭合
    let cPen3 = new drawing.Pen();
    let cPen3Color: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0x00,
      blue: 0xFF
    };
    cPen3.setColor(cPen3Color);
    cPen3.setStrokeWidth(8.0);
    canvas.attachPen(cPen3);
    let path2 = new drawing.Path();
    path2.moveTo(400.0, 350.0);
    path2.cubicTo(400.0, 420.0, 550.0, 380.0, 450.0, 500.0);
    canvas.drawPath(path2);
    canvas.detachPen();

    let startX5 = 320.0;
    let startY5 = 550.0;
    let font5 = new drawing.Font();
    font5.setSize(screenWidth / 20);
    let text4 = getContext().resourceManager.getStringSync($r('app.string.ComplexPath'));
    const textBlob5 = drawing.TextBlob.makeFromString(text4, font5, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob5, startX5, startY5);

    // 复杂路径
    // 小猫的脸
    let pen = new drawing.Pen();
    let penColor: common2D.Color = {
      alpha: 0xFF,
      red: 0xFF,
      green: 0xCC,
      blue: 0x00
    };
    pen.setColor(penColor);
    pen.setStrokeWidth(10.0);
    canvas.attachPen(pen);
    let path = new drawing.Path();
    path.addCircle(380.0, 750.0, 100.0, drawing.PathDirection.CLOCKWISE);
    canvas.drawPath(path);
    canvas.detachPen();

    // 小猫耳朵
    let earX1 = 280.0;
    let earY1 = 560.0;

    let ePath = new drawing.Path();
    ePath.moveTo(earX1, earY1);
    ePath.lineTo(earX1 + 10.0, earY1 + 150.0);
    ePath.moveTo(earX1, earY1);
    ePath.lineTo(earX1 + 80.0, earY1 + 90.0);
    canvas.attachPen(pen);
    canvas.drawPath(ePath);

    let earX2 = 480.0;
    let earY2 = 550.0;
    let ePath2 = new drawing.Path();
    ePath2.moveTo(earX2, earY2);
    ePath2.lineTo(earX2 - 80.0, earY2 + 100.0);
    ePath2.moveTo(earX2, earY2);
    ePath2.lineTo(earX2 - 10.0, earY2 + 150.0);
    canvas.drawPath(ePath2);

    // 小猫胡须
    let clen = 150.0;
    let musLX1 = 330.0;
    let musLY1 = 750.0;
    let mLPath = new drawing.Path();
    mLPath.moveTo(musLX1, musLY1);
    mLPath.lineTo(musLX1 - clen, musLY1 - 20.0);
    canvas.drawPath(mLPath);

    let musLX2 = 330.0;
    let musLY2 = 770.0;
    let mLPath2 = new drawing.Path();
    mLPath2.moveTo(musLX2, musLY2);
    mLPath2.lineTo(musLX2 - clen, musLY2);
    canvas.drawPath(mLPath2);

    let musLX3 = 330.0;
    let musLY3 = 790.0;
    let mLPath3 = new drawing.Path();
    mLPath3.moveTo(musLX3, musLY3);
    mLPath3.lineTo(musLX3 - clen, musLY3 + 20.0);
    canvas.drawPath(mLPath3);

    let musRX1 = 420.0;
    let musRY1 = 750.0;
    let mRPath = new drawing.Path();
    mRPath.moveTo(musRX1, musRY1);
    mRPath.lineTo(musRX1 + clen, musRY1 - 20.0);
    canvas.drawPath(mRPath);

    let musRX2 = 420.0;
    let musRY2 = 770.0;
    let mRPath2 = new drawing.Path();
    mRPath2.moveTo(musRX2, musRY2);
    mRPath2.lineTo(musRX2 + clen, musRY2);
    canvas.drawPath(mRPath2);

    let musRX3 = 420.0;
    let musRY3 = 790.0;
    let mRPath3 = new drawing.Path();
    mRPath3.moveTo(musRX3, musRY3);
    mRPath3.lineTo(musRX3 + clen, musRY3 + 20.0);
    canvas.drawPath(mRPath3);
    canvas.detachPen();

    // 小猫眼睛
    let ePen = new drawing.Pen();
    let ePenColor: common2D.Color = {
      alpha: 0xFF,
      red: 0xFF,
      green: 0xCC,
      blue: 0x00
    };
    ePen.setColor(ePenColor);
    ePen.setStrokeWidth(8.0);
    canvas.attachPen(ePen);
    let ovalPath = new drawing.Path();
    let rect: common2D.Rect = {
      left: 320.0,
      top: 700.0,
      right: 360.0,
      bottom: 720.0
    };
    ovalPath.addArc(rect, 180, 360);
    ovalPath.addArc(rect, 0, 180);
    canvas.attachPen(ePen);
    canvas.drawPath(ovalPath);
    let rect2: common2D.Rect = {
      left: 400.0,
      top: 700.0,
      right: 440.0,
      bottom: 720.0
    };
    ovalPath.addOval(rect2, 5, drawing.PathDirection.COUNTER_CLOCKWISE);
    canvas.drawPath(ovalPath);
    canvas.detachPen();
  }
}

export class MyRenderNodePathBrush extends RenderNode {
  async draw(context: DrawContext) {
    // title
    const canvas = context.canvas;
    canvas.detachBrush();
    const startX = 200;
    const startY = 60;
    const w = screenWidth / 6;
    const font = new drawing.Font();
    font.setSize(30); // 30 font size
    let text5 = getContext().resourceManager.getStringSync($r('app.string.DrawPathWithBrush'));
    const textBlob =
      drawing.TextBlob.makeFromString(text5, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY);
    // set brush
    const brush = new drawing.Brush();
    const color: common2D.Color = {
      alpha: 0xFF,
      red: 0x44,
      green: 0x72,
      blue: 0xC3
    };
    brush.setColor(color);
    canvas.attachBrush(brush);
    // rect
    const pathRect = new drawing.Path();
    const rect: common2D.Rect = {
      left: w + 10,
      top: 100,
      right: w * 2 - 10,
      bottom: 160
    };
    pathRect.addRect(rect);
    canvas.drawPath(pathRect);
    // oval
    const pathOval = new drawing.Path();
    const rectOval: common2D.Rect = {
      left: w * 2 + 10,
      top: 100,
      right: w * 3 - 10,
      bottom: 160
    };
    pathOval.addOval(rectOval, 0);
    canvas.drawPath(pathOval);
    // roundRect
    const pathRoundRect = new drawing.Path();
    const rectRoundRect: common2D.Rect = {
      left: w * 3 + 10,
      top: 100,
      right: w * 4 - 10,
      bottom: 160
    };
    const roundRect = new drawing.RoundRect(rectRoundRect, 20, 20);
    pathRoundRect.addRoundRect(roundRect);
    canvas.drawPath(pathRoundRect);
    // polygon
    const pathPolygon = new drawing.Path();
    let points: common2D.Point[] = [];
    const point1: common2D.Point = { x: w * 4 + 10, y: 160 };
    const point2: common2D.Point = { x: w * 5 - 10, y: 160 };
    const point3: common2D.Point = { x: w * 9 / 2, y: 100 };
    points.push(point1);
    points.push(point2);
    points.push(point3);
    pathPolygon.addPolygon(points, true);
    canvas.drawPath(pathPolygon);
    // arc
    const pathArc = new drawing.Path();
    const rectArc: common2D.Rect = {
      left: w * 5 - 50,
      top: 100,
      right: w * 6 - 10,
      bottom: 220
    };
    pathArc.addArc(rectArc, 0, -90);
    canvas.drawPath(pathArc);
    // detach
    canvas.detachBrush();
  }
}

export class MyRenderNodePathPen extends RenderNode {
  async draw(context: DrawContext) {
    // title
    const canvas = context.canvas;
    canvas.detachBrush();
    const startX = 200;
    const startY = 230;
    const w = screenWidth / 6;
    const font = new drawing.Font();
    font.setSize(30); // 30 font size
    let text6 = getContext().resourceManager.getStringSync($r('app.string.DrawPathWithPen'));
    const textBlob = drawing.TextBlob.makeFromString(text6,
      font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY);
    // set pen
    const pen = new drawing.Pen();
    const color: common2D.Color = {
      alpha: 0xFF,
      red: 0x44,
      green: 0x72,
      blue: 0xC3
    };
    pen.setColor(color);
    pen.setAntiAlias(true);
    pen.setStrokeWidth(3);
    canvas.attachPen(pen);
    // lineTo
    const pathLine = new drawing.Path();
    pathLine.moveTo(20, 290);
    pathLine.lineTo(w - 20, 290);
    canvas.drawPath(pathLine);
    // rect
    const pathRect = new drawing.Path();
    const rect: common2D.Rect = {
      left: w + 10,
      top: 260,
      right: w * 2 - 10,
      bottom: 320
    };
    pathRect.addRect(rect);
    canvas.drawPath(pathRect);
    // oval
    const pathOval = new drawing.Path();
    const rectOval: common2D.Rect = {
      left: w * 2 + 10,
      top: 260,
      right: w * 3 - 10,
      bottom: 320
    };
    pathOval.addOval(rectOval, 0);
    canvas.drawPath(pathOval);
    // roundRect
    const pathRoundRect = new drawing.Path();
    const rectRoundRect: common2D.Rect = {
      left: w * 3 + 10,
      top: 260,
      right: w * 4 - 10,
      bottom: 320
    };
    const roundRect = new drawing.RoundRect(rectRoundRect, 20, 20);
    pathRoundRect.addRoundRect(roundRect);
    canvas.drawPath(pathRoundRect);
    // polygon
    const pathPolygon = new drawing.Path();
    let points: common2D.Point[] = [];
    const point1: common2D.Point = { x: w * 4 + 10, y: 320 };
    const point2: common2D.Point = { x: w * 5 - 10, y: 320 };
    const point3: common2D.Point = { x: w * 9 / 2, y: 260 };
    points.push(point1);
    points.push(point2);
    points.push(point3);
    pathPolygon.addPolygon(points, true);
    canvas.drawPath(pathPolygon);
    // arc
    const pathArc = new drawing.Path();
    const rectArc: common2D.Rect = {
      left: w * 5 - 50,
      top: 260,
      right: w * 6 - 10,
      bottom: 380
    };
    pathArc.addArc(rectArc, 0, -90);
    canvas.drawPath(pathArc);
    // detach
    canvas.detachPen();
  }
}

export class MyRenderNodePathShade extends RenderNode {
  async draw(context: DrawContext) {
    // title
    const canvas = context.canvas;
    canvas.detachBrush();
    const startX = 200;
    const startY = 380;
    const w = screenWidth / 6;
    const font = new drawing.Font();
    font.setSize(30); // 30 font size
    let text7 = getContext().resourceManager.getStringSync($r('app.string.DrawPathWithShader'));
    const textBlob = drawing.TextBlob.makeFromString(text7,
      font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY);
    // rect
    const brushRect = new drawing.Brush();
    const startPt1: common2D.Point = { x: w * 3 / 2, y: 410 };
    const endPt1: common2D.Point = { x: w * 3 / 2, y: 470 };
    const shaderEffectRect =
      drawing.ShaderEffect.createLinearGradient(startPt1, endPt1, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushRect.setShaderEffect(shaderEffectRect);
    canvas.attachBrush(brushRect);
    const pathRect = new drawing.Path();
    const rect: common2D.Rect = {
      left: w + 10,
      top: 410,
      right: w * 2 - 10,
      bottom: 470
    };
    pathRect.addRect(rect);
    canvas.drawPath(pathRect);
    canvas.detachBrush();
    // oval
    const brushOval = new drawing.Brush();
    const startPt2: common2D.Point = { x: w * 5 / 2, y: 410 };
    const endPt2: common2D.Point = { x: w * 5 / 2, y: 470 };
    const shaderEffectOval =
      drawing.ShaderEffect.createLinearGradient(startPt2, endPt2, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushOval.setShaderEffect(shaderEffectOval);
    canvas.attachBrush(brushOval);
    const pathOval = new drawing.Path();
    const rectOval: common2D.Rect = {
      left: w * 2 + 10,
      top: 410,
      right: w * 3 - 10,
      bottom: 470
    };
    pathOval.addOval(rectOval, 0);
    canvas.drawPath(pathOval);
    canvas.detachBrush();
    // roundRect
    const brushRoundRect = new drawing.Brush();
    const startPt3: common2D.Point = { x: w * 7 / 2, y: 410 };
    const endPt3: common2D.Point = { x: w * 7 / 2, y: 470 };
    const shaderEffectRoundRect =
      drawing.ShaderEffect.createLinearGradient(startPt3, endPt3, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushRoundRect.setShaderEffect(shaderEffectRoundRect);
    canvas.attachBrush(brushRoundRect);
    const pathRoundRect = new drawing.Path();
    const rectRoundRect: common2D.Rect = {
      left: w * 3 + 10,
      top: 410,
      right: w * 4 - 10,
      bottom: 470
    };
    const roundRect = new drawing.RoundRect(rectRoundRect, 20, 20);
    pathRoundRect.addRoundRect(roundRect);
    canvas.drawPath(pathRoundRect);
    canvas.detachBrush();
    // polygon
    const brushPolygon = new drawing.Brush();
    const startPt4: common2D.Point = { x: w * 9 / 2, y: 410 };
    const endPt4: common2D.Point = { x: w * 9 / 2, y: 470 };
    const shaderEffectPolygon =
      drawing.ShaderEffect.createLinearGradient(startPt4, endPt4, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushPolygon.setShaderEffect(shaderEffectPolygon);
    canvas.attachBrush(brushPolygon);
    const pathPolygon = new drawing.Path();
    let points: common2D.Point[] = [];
    const point1: common2D.Point = { x: w * 4 + 10, y: 470 };
    const point2: common2D.Point = { x: w * 5 - 10, y: 470 };
    const point3: common2D.Point = { x: w * 9 / 2, y: 410 };
    points.push(point1);
    points.push(point2);
    points.push(point3);
    pathPolygon.addPolygon(points, true);
    canvas.drawPath(pathPolygon);
    canvas.detachBrush();
    // arc
    const brushArc = new drawing.Brush();
    const startPt5: common2D.Point = { x: w * 11 / 2, y: 410 };
    const endPt5: common2D.Point = { x: w * 6 - 10, y: 470 };
    const shaderEffectArc =
      drawing.ShaderEffect.createLinearGradient(startPt5, endPt5, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushArc.setShaderEffect(shaderEffectArc);
    canvas.attachBrush(brushArc);
    const pathArc = new drawing.Path();
    const rectArc: common2D.Rect = {
      left: w * 5 - 50,
      top: 410,
      right: w * 6 - 10,
      bottom: 530
    };
    pathArc.addArc(rectArc, 0, -90);
    canvas.drawPath(pathArc);
    canvas.detachBrush();
  }
}
