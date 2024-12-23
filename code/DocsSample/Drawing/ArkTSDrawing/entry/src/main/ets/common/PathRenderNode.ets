/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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


import { RenderNode } from '@kit.ArkUI'
import { common2D, drawing } from '@kit.ArkGraphics2D'

class PathRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let height_ = 1200;
    let width_ = 600;
    let len = height_ / 4;
    let aX = width_ / 2;
    let aY = height_ / 4;
    let dX = aX - len * Math.sin(18.0);
    let dY = aY + len * Math.cos(18.0);
    let cX = aX + len * Math.sin(18.0);
    let cY = dY;
    let bX = aX + (len / 2.0);
    let bY = aY + Math.sqrt((cX - dX) * (cX - dX) + (len / 2.0) * (len / 2.0));
    let eX = aX - (len / 2.0);
    let eY = bY;

    // 创建一个path对象，然后使用接口连接成一个五角星形状
    let path = new drawing.Path();

    // 指定path的起始位置
    path.moveTo(aX, aY);

    // 用直线连接到目标点
    path.lineTo(bX, bY);
    path.lineTo(cX, cY);
    path.lineTo(dX, dY);
    path.lineTo(eX, eY);

    // 闭合形状，path绘制完毕
    path.close();

    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    let pen = new drawing.Pen();
    pen.setAntiAlias(true);
    let penColor: common2D.Color = {
      alpha: 0xFF,
      red: 0xFF,
      green: 0x00,
      blue: 0x00
    }
    pen.setColor(penColor);
    pen.setStrokeWidth(10.0);

    // 将Pen画笔设置到canvas中
    canvas.attachPen(pen);

    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    let brush = new drawing.Brush();
    let brushColor: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0xFF,
      blue: 0x00
    }
    brush.setColor(brushColor);

    // 将Brush画刷设置到canvas中
    canvas.attachBrush(brush);

    // 绘制path
    canvas.drawPath(path);
  }
}

export default PathRenderNode;
