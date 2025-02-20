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

export class MyRenderNodePathBrush extends RenderNode {
  async draw(context: DrawContext) {
    // title
    const canvas = context.canvas;
    canvas.detachBrush();
    const startX = 200;
    const startY = 60;
    const dis = 1000;
    const w = screenWidth / 6;
    const font = new drawing.Font();
    font.setSize(screenWidth / 25);
    let text = getContext().resourceManager.getStringSync($r('app.string.DrawPathWithBrush'));
    const textBlob =
      drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY + dis);
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
      top: 100 + dis,
      right: w * 2 - 10,
      bottom: 160 + dis
    };
    pathRect.addRect(rect);
    canvas.drawPath(pathRect);
    // oval
    const pathOval = new drawing.Path();
    const rectOval: common2D.Rect = {
      left: w * 2 + 10,
      top: 100 + dis,
      right: w * 3 - 10,
      bottom: 160 + dis
    };
    pathOval.addOval(rectOval, 0);
    canvas.drawPath(pathOval);
    // roundrect
    const pathRoundRect = new drawing.Path();
    const rectRoundRect: common2D.Rect = {
      left: w * 3 + 10,
      top: 100 + dis,
      right: w * 4 - 10,
      bottom: 160 + dis
    };
    const roundRect = new drawing.RoundRect(rectRoundRect, 20, 20);
    pathRoundRect.addRoundRect(roundRect);
    canvas.drawPath(pathRoundRect);
    // polygon
    const pathPolygon = new drawing.Path();
    let points: common2D.Point[] = [];
    const point1: common2D.Point = { x: w * 4 + 10, y: 160 + dis };
    const point2: common2D.Point = { x: w * 5 - 10, y: 160 + dis };
    const point3: common2D.Point = { x: w * 9 / 2, y: 100 + dis };
    points.push(point1);
    points.push(point2);
    points.push(point3);
    pathPolygon.addPolygon(points, true);
    canvas.drawPath(pathPolygon);
    // arc
    const pathArc = new drawing.Path();
    const rectArc: common2D.Rect = {
      left: w * 5 - 50,
      top: 100 + dis,
      right: w * 6 - 10,
      bottom: 220 + dis
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
    const dis = 1000;
    const w = screenWidth / 6;
    const font = new drawing.Font();
    font.setSize(screenWidth / 25);
    let text1 = getContext().resourceManager.getStringSync($r('app.string.DrawPathWithPen'));
    const textBlob = drawing.TextBlob.makeFromString(text1,
      font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY + dis);
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
    // lineto
    const pathLine = new drawing.Path();
    pathLine.moveTo(20, 290 + dis);
    pathLine.lineTo(w - 20, 290 + dis);
    canvas.drawPath(pathLine);
    // rect
    const pathRect = new drawing.Path();
    const rect: common2D.Rect = {
      left: w + 10,
      top: 260 + dis,
      right: w * 2 - 10,
      bottom: 320 + dis
    };
    pathRect.addRect(rect);
    canvas.drawPath(pathRect);
    // oval
    const pathOval = new drawing.Path();
    const rectOval: common2D.Rect = {
      left: w * 2 + 10,
      top: 260 + dis,
      right: w * 3 - 10,
      bottom: 320 + dis
    };
    pathOval.addOval(rectOval, 0);
    canvas.drawPath(pathOval);
    // roundRect
    const pathRoundRect = new drawing.Path();
    const rectRoundRect: common2D.Rect = {
      left: w * 3 + 10,
      top: 260 + dis,
      right: w * 4 - 10,
      bottom: 320 + dis
    };
    const roundRect = new drawing.RoundRect(rectRoundRect, 20, 20);
    pathRoundRect.addRoundRect(roundRect);
    canvas.drawPath(pathRoundRect);
    // polygon
    const pathPolygon = new drawing.Path();
    let points: common2D.Point[] = [];
    const point1: common2D.Point = { x: w * 4 + 10, y: 320 + dis };
    const point2: common2D.Point = { x: w * 5 - 10, y: 320 + dis };
    const point3: common2D.Point = { x: w * 9 / 2, y: 260 + dis };
    points.push(point1);
    points.push(point2);
    points.push(point3);
    pathPolygon.addPolygon(points, true);
    canvas.drawPath(pathPolygon);
    // arc
    const pathArc = new drawing.Path();
    const rectArc: common2D.Rect = {
      left: w * 5 - 50,
      top: 260 + dis,
      right: w * 6 - 10,
      bottom: 380 + dis
    };
    pathArc.addArc(rectArc, 0, -90);
    canvas.drawPath(pathArc);
    // detach
    canvas.detachPen();
  }
}

export class MyRenderNodePathShader extends RenderNode {
  async draw(context: DrawContext) {
    // title
    const canvas = context.canvas;
    canvas.detachBrush();
    const startX = 200;
    const startY = 380;
    const dis = 1000;
    const w = screenWidth / 6;
    const font = new drawing.Font();
    font.setSize(screenWidth / 25);
    let text2 = getContext().resourceManager.getStringSync($r('app.string.DrawPathWithShader'));
    const textBlob = drawing.TextBlob.makeFromString(text2,
      font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY + dis);
    // rect
    const brushRect = new drawing.Brush();
    const startPt1: common2D.Point = { x: w * 3 / 2, y: 410 + dis };
    const endPt1: common2D.Point = { x: w * 3 / 2, y: 470 + dis };
    const shaderEffectRect =
      drawing.ShaderEffect.createLinearGradient(startPt1, endPt1, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushRect.setShaderEffect(shaderEffectRect);
    canvas.attachBrush(brushRect);
    const pathRect = new drawing.Path();
    const rect: common2D.Rect = {
      left: w + 10,
      top: 410 + dis,
      right: w * 2 - 10,
      bottom: 470 + dis
    };
    pathRect.addRect(rect);
    canvas.drawPath(pathRect);
    canvas.detachBrush();
    // oval
    const brushOval = new drawing.Brush();
    const startPt2: common2D.Point = { x: w * 5 / 2, y: 410 + dis };
    const endPt2: common2D.Point = { x: w * 5 / 2, y: 470 + dis };
    const shaderEffectOval =
      drawing.ShaderEffect.createLinearGradient(startPt2, endPt2, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushOval.setShaderEffect(shaderEffectOval);
    canvas.attachBrush(brushOval);
    const pathOval = new drawing.Path();
    const rectOval: common2D.Rect = {
      left: w * 2 + 10,
      top: 410 + dis,
      right: w * 3 - 10,
      bottom: 470 + dis
    };
    pathOval.addOval(rectOval, 0);
    canvas.drawPath(pathOval);
    canvas.detachBrush();
    // roundrect
    const brushRoundRect = new drawing.Brush();
    const startPt3: common2D.Point = { x: w * 7 / 2, y: 410 + dis };
    const endPt3: common2D.Point = { x: w * 7 / 2, y: 470 + dis };
    const shaderEffectRoundRect =
      drawing.ShaderEffect.createLinearGradient(startPt3, endPt3, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushRoundRect.setShaderEffect(shaderEffectRoundRect);
    canvas.attachBrush(brushRoundRect);
    const pathRoundRect = new drawing.Path();
    const rectRoundRect: common2D.Rect = {
      left: w * 3 + 10,
      top: 410 + dis,
      right: w * 4 - 10,
      bottom: 470 + dis
    };
    const roundRect = new drawing.RoundRect(rectRoundRect, 20, 20 + dis);
    pathRoundRect.addRoundRect(roundRect);
    canvas.drawPath(pathRoundRect);
    canvas.detachBrush();
    // polygon
    const brushPolygon = new drawing.Brush();
    const startPt4: common2D.Point = { x: w * 9 / 2, y: 410 + dis };
    const endPt4: common2D.Point = { x: w * 9 / 2, y: 470 + dis };
    const shaderEffectPolygon =
      drawing.ShaderEffect.createLinearGradient(startPt4, endPt4, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushPolygon.setShaderEffect(shaderEffectPolygon);
    canvas.attachBrush(brushPolygon);
    const pathPolygon = new drawing.Path();
    let points: common2D.Point[] = [];
    const point1: common2D.Point = { x: w * 4 + 10, y: 470 + dis };
    const point2: common2D.Point = { x: w * 5 - 10, y: 470 + dis };
    const point3: common2D.Point = { x: w * 9 / 2, y: 410 + dis };
    points.push(point1);
    points.push(point2);
    points.push(point3);
    pathPolygon.addPolygon(points, true);
    canvas.drawPath(pathPolygon);
    canvas.detachBrush();
    // arc
    const brushArc = new drawing.Brush();
    const startPt5: common2D.Point = { x: w * 11 / 2, y: 410 + dis };
    const endPt5: common2D.Point = { x: w * 6 - 10, y: 470 + dis };
    const shaderEffectArc =
      drawing.ShaderEffect.createLinearGradient(startPt5, endPt5, [0xFFF8FA12, 0xFFACC3DD], drawing.TileMode.CLAMP);
    brushArc.setShaderEffect(shaderEffectArc);
    canvas.attachBrush(brushArc);
    const pathArc = new drawing.Path();
    const rectArc: common2D.Rect = {
      left: w * 5 - 50,
      top: 410 + dis,
      right: w * 6 - 10,
      bottom: 530 + dis
    };
    pathArc.addArc(rectArc, 0, -90);
    canvas.drawPath(pathArc);
    canvas.detachBrush();
  }
}