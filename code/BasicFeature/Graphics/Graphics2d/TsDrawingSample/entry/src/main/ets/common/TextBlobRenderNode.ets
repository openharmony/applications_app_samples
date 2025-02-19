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
import image from '@ohos.multimedia.image';
import display from '@ohos.display';

let screen = display.getDefaultDisplaySync();
let screenWidth: number = screen.width;

export class TextBlobRenderNode extends RenderNode {
  private pMap: image.PixelMap | undefined = undefined;

  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let startX = 20.0;
    let startY = 600.0;
    let fontTitle = new drawing.Font();
    fontTitle.setSize(screenWidth / 25);
    let text = getContext().resourceManager.getStringSync($r('app.string.DrawTextBlob'));
    const stringImage = drawing.TextBlob.makeFromString(text,
      fontTitle, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringImage, screenWidth / 3, 550.0);
    let text1 = getContext().resourceManager.getStringSync($r('app.string.DrawBaseTextBlob'));
    const stringBasicText = drawing.TextBlob.makeFromString(text1,
      fontTitle, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringBasicText, startX, startY);
    // 基本字块绘制
    const font1 = new drawing.Font();
    font1.setSize(100);
    const textBlob1 = drawing.TextBlob.makeFromString('Hello world', font1, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob1, 100, 720);

    let text2 = getContext().resourceManager.getStringSync($r('app.string.FontWithPen'));
    const stringTextPen = drawing.TextBlob.makeFromString(text2,
      fontTitle, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringTextPen, startX, startY + 280);
    // 文字描边
    let pen1 = new drawing.Pen();
    pen1.setAntiAlias(true);
    pen1.setStrokeWidth(3.0);
    pen1.setColor(0xFF, 0xFF, 0x00, 0x00);
    const font2 = new drawing.Font();
    font2.setSize(100);
    canvas.attachPen(pen1);
    const textBlob2 = drawing.TextBlob.makeFromString('Hello world', font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob2, 100, 1000);
    canvas.detachPen();

    let text3 = getContext().resourceManager.getStringSync($r('app.string.TextGradient'));
    const stringTextShader = drawing.TextBlob.makeFromString(text3,
      fontTitle, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(stringTextShader, startX, startY + 520);

    // 文字渐变
    let startPt: common2D.Point = { x: 100, y: 100 + 1000 };
    let endPt: common2D.Point = { x: 900, y: 900 + 1000 };
    let colors = [0xFFFFFF00, 0xFFFF0000, 0xFF0000FF];
    let shaderEffect = drawing.ShaderEffect.createLinearGradient(startPt, endPt, colors, drawing.TileMode.CLAMP);
    let brush2 = new drawing.Brush();
    brush2.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush2);
    const font3 = new drawing.Font();
    font3.setSize(200);
    const textBlob3 = drawing.TextBlob.makeFromString('Hello world', font3, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob3, 100, 1300);
    canvas.detachBrush();
  }
}