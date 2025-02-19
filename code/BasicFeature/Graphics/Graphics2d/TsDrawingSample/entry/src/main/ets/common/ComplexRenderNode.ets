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

export class ComplexRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let startX = 100.0;
    let startY = 50.0;
    let font = new drawing.Font();
    font.setSize(screenWidth / 25);
    let text = getContext().resourceManager.getStringSync($r('app.string.ShaderEffect'));
    const stringShaderEffect = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringShaderEffect, startX, startY);
    // ShaderEffect
    let startPt: common2D.Point = { x: 100, y: 100 };
    let endPt: common2D.Point = { x: 400, y: 400 };
    let colors = [0xFFFFFF00, 0xFFFF0000, 0xFF0000FF];
    let shaderEffect = drawing.ShaderEffect.createLinearGradient(startPt, endPt, colors, drawing.TileMode.CLAMP);
    let brush = new drawing.Brush();
    brush.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush);
    let rect1: common2D.Rect = { left: 100, top: 100, right: 400, bottom: 400 };
    canvas.drawRect(rect1);
    canvas.detachBrush();

    let text2 = getContext().resourceManager.getStringSync($r('app.string.ImageFilter'));
    const stringImageFilter = drawing.TextBlob.makeFromString(text2, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringImageFilter, startX + 600, startY);
    // ImageFilter
    let pen = new drawing.Pen();
    pen.setStrokeWidth(10.0);
    pen.setColor(0xFF, 0xFF, 0x00, 0x00);
    let filter = drawing.ImageFilter.createBlurImageFilter(20, 20, drawing.TileMode.CLAMP);
    pen.setImageFilter(filter);
    canvas.attachPen(pen);
    let rect2: common2D.Rect = { left: 700, top: 100, right: 1000, bottom: 400 };
    canvas.drawRect(rect2);
    canvas.detachPen();

    let text3 = getContext().resourceManager.getStringSync($r('app.string.PathEffect'));
    const stringPathEffect = drawing.TextBlob.makeFromString(text3, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringPathEffect, startX, startY + 600);
    let iPen = new drawing.Pen();
    iPen.setStrokeWidth(10.0);
    let iPenColor: common2D.Color = {
      alpha: 0xFF,
      red: 0xFF,
      green: 0x00,
      blue: 0x00
    };
    iPen.setColor(iPenColor);
    canvas.attachPen(iPen);
    let intervals = [20.0, 10.0];
    let pathEffect = drawing.PathEffect.createDashPathEffect(intervals, 0);
    iPen.setPathEffect(pathEffect);
    canvas.attachPen(iPen);
    canvas.drawLine(100, 700, 400, 1000);
    canvas.detachPen();
  }
}
