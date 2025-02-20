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

export class CanvasRenderNodeCropping extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let startX = 100.0;
    let startY = 100.0;
    let w = screenWidth / 8;
    let h = screenWidth / 8;
    let textSize = screenWidth / 25;
    let font = new drawing.Font();
    font.setSize(textSize);
    let text = getContext().resourceManager.getStringSync($r('app.string.crop'));
    const textBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, startX, startY - textSize);

    // 画布裁剪矩形 交集（INTERSECT）
    let brush1 = new drawing.Brush();
    brush1.setColor(0xFF, 0x00, 0x00, 0xFF);
    canvas.attachBrush(brush1);
    canvas.save();
    let rect1: common2D.Rect = { left: startX, top: startY, right: startX + w, bottom: startY + h };
    canvas.clipRect(rect1);
    canvas.drawCircle(startX + w, startY + h, w);
    canvas.restore();
    canvas.detachBrush();

    // 画布裁剪矩形 差集（DIFFERENCE）
    let brush2 = new drawing.Brush();
    brush2.setColor(0xFF, 0x00, 0x00, 0xFF);
    canvas.attachBrush(brush2);
    canvas.save();
    let rect2: common2D.Rect = { left: startX + 2 * w, top: startY, right: startX + 3 * w, bottom: startY + h };
    canvas.clipRect(rect2, drawing.ClipOp.DIFFERENCE);
    canvas.drawCircle(startX + 3 * w, startY + h, w);
    canvas.restore();
    canvas.drawCircle(startX + 6 * w, startY + h, w); // 原始图
    canvas.detachBrush();
  }
}

export class CanvasRenderNodeMatrix extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let startX = 100.0;
    let startY = 100.0 + screenWidth / 3;
    let textSize = screenWidth / 25;
    let font = new drawing.Font();
    font.setSize(textSize);
    let text2 = getContext().resourceManager.getStringSync($r('app.string.scaling'));
    let startBlob = drawing.TextBlob.makeFromString(text2, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(startBlob, startX, startY + textSize);
    // 矩阵变换-缩放
    let pen = new drawing.Pen();
    pen.setColor({alpha:0xFF, red:0xFF, green:0x00, blue:0x00});
    pen.setStrokeWidth(20);
    canvas.attachPen(pen);
    canvas.save();
    canvas.scale(1.5, 1.5)
    canvas.drawCircle(startX + 60, startY + textSize + 100, 60);
    canvas.restore();
    canvas.drawCircle(startX + 60, startY + textSize + 100, 60);
    canvas.detachPen();

    let startX2: number = startX + screenWidth / 3;
    let text3 = getContext().resourceManager.getStringSync($r('app.string.translation_and_rotation'));
    let startBlob2 = drawing.TextBlob.makeFromString(text3, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(startBlob2, startX2, startY + textSize);
    // 矩阵变换-平移和旋转
    canvas.attachPen(pen);
    canvas.save();
    canvas.translate(150, 150); // 平移
    canvas.rotate(15, startX + screenWidth / 2, startY + textSize + 100); // 旋转
    canvas.drawRect({left: startX2, top: startY + textSize + 50,
      right: startX2 + 200, bottom: startY + textSize + 200});
    canvas.restore();
    canvas.drawRect({left: startX2, top: startY + textSize + 50,
      right: startX2 + 200, bottom: startY + textSize + 200});
    canvas.detachPen();
  }
}

export class CanvasRenderNodeCombination extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let startX = 100.0;
    let startY = 100.0+screenWidth;
    let w = screenWidth / 8;
    let h = screenWidth / 8;
    let textSize = screenWidth / 25;
    let font = new drawing.Font();
    font.setSize(textSize);
    let text4 = getContext().resourceManager.getStringSync($r('app.string.tailor_and_translation'));
    let startBlob = drawing.TextBlob.makeFromString(text4, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(startBlob, startX, startY - textSize);
    // 裁剪+矩阵——矩形裁剪+平移
    let brush1 = new drawing.Brush();
    brush1.setColor(0xFF, 0x00, 0x00, 0xFF);
    canvas.attachBrush(brush1);
    canvas.save();
    let rect1: common2D.Rect = { left: startX, top: startY, right: startX + w, bottom: startY + h };
    canvas.translate(100, 100); // 平移
    canvas.clipRect(rect1); // 裁剪
    canvas.drawCircle(startX + w, startY + h, w);
    canvas.restore();
    canvas.drawCircle(startX + 3 * w, startY + h, w);
    canvas.detachBrush();
  }
}
