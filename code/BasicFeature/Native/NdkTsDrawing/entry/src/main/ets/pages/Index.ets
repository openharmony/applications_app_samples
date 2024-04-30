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

import { NodeController, FrameNode, RenderNode, DrawContext } from "@ohos.arkui.node";
import { UIContext } from '@ohos.arkui.UIContext';
import drawing from "@ohos.graphics.drawing";
import common2D from "@ohos.graphics.common2D";
import display from '@ohos.display';
import image from '@ohos.multimedia.image';

const TAG = 'DrawingTSSample';
let screen = display.getDefaultDisplaySync();
let screenWidth: number = screen.width;
let screenHeight: number = screen.height;

let canvas_: drawing.Canvas;
let pixelMap_: image.PixelMap | undefined;

class MyRenderNode extends RenderNode {
  // 在RenderNode的draw中使用drawing自定义绘制
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let height_ = 600;
    let width_ = 600;
    let len = height_ / 4;
    let aX = width_ / 3;
    let aY = height_ / 6;
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
    path.close()

    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    let pen = new drawing.Pen();
    pen.setAntiAlias(true);
    let pen_color : common2D.Color = { alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 };
    pen.setColor(pen_color);
    pen.setStrokeWidth(10.0);

    // 将Pen画笔设置到canvas中
    canvas.attachPen(pen);

    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    let brush = new drawing.Brush();
    let brush_color : common2D.Color = { alpha: 0xFF, red: 0x00, green: 0xFF, blue: 0x00 };
    brush.setColor(brush_color);

    // 将Brush画刷设置到canvas中
    canvas.attachBrush(brush);

    // 绘制path
    canvas.drawPath(path);

    // 绘制完成后清空画布上已设置的画笔和画刷
    canvas.detachBrush();
    canvas.detachPen();
  }
}
// 创建一个MyRenderNode对象
const newNode = new MyRenderNode();
// 定义newNode的像素格式
newNode.frame = { x: 0, y: 0, width: screenWidth, height: screenHeight };


class TextRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let brush = new drawing.Brush();
    brush.setColor({alpha: 255, red: 255, green: 0, blue: 0});
    let font = new drawing.Font();
    font.setSize(50);
    const textBlob = drawing.TextBlob.makeFromString("Hello World", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachBrush(brush);
    canvas.drawTextBlob(textBlob, 60, screenHeight / 4);
    canvas.detachBrush();
  }
}
// 创建一个TextRenderNode对象
const textNode = new TextRenderNode();
// 定义textNode的像素格式
textNode.frame = { x: 0, y: 0, width: screenWidth, height: screenHeight };

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.frame = { x: 0, y: 0, width: 10, height: 500 };
      renderNode.pivot = { x: 50, y: 50 };
    }
    return this.rootNode;
  }

  addNode(node: RenderNode): void {
    if (this.rootNode === null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.appendChild(node);
    }
  }

  clearNodes(): void {
    if (this.rootNode === null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.clearChildren();
    }
  }
}

@Entry
@Component
struct RenderTest {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Column() {
      // 离屏绘制
      Row() {
        Canvas(this.context)
          .width('100%')
          .onReady(()=>{
            this.CreateBitmapCanvas();
          })
      }
      .height('40%')
      Row() {
        Button("Draw Rect")
          .margin({ bottom: 20, right: 12 })
          .onClick(() => {
            if (canvas_ === null || canvas_ === undefined) {
              return;
            }
            this.drawImage();
          })
      }
      .height('10%')
      // 使用RenderNode的能力进行绘制
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
        Button("Draw Path")
          .margin({ bottom: 20, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes();
            this.myNodeController.addNode(newNode);
          })
        Button("Draw Text")
          .margin({ bottom: 20, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes();
            this.myNodeController.addNode(textNode);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }

  public async CreateBitmapCanvas() {
    const color : ArrayBuffer = new ArrayBuffer(screenWidth * screenHeight * 4);
    let opts : image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height:screenHeight, width: screenWidth}};
    pixelMap_ = await image.createPixelMap(color, opts);
    if (pixelMap_ === null || pixelMap_ === undefined) {
      console.log(TAG, 'create pixelMap error');
      return;
    }

    // 创建离屏canvas，与pixelMap绑定
    canvas_ = new drawing.Canvas(pixelMap_);
    if (canvas_ === null || canvas_ === undefined) {
      console.log(TAG, 'create canvas_ error');
      return;
    }
    console.log(TAG, 'create canvas_ success');
    // 调用自定义函数绘制
    drawCase(canvas_);
  }

  // 将离屏绘制好的bitmap绘制到屏幕上
  public async drawImage() {
    if (pixelMap_ === null) {
      console.error(TAG, 'draw image pixelMap_ is null');
      return;
    }
    console.log(TAG, 'drawImage success');
    this.context.drawImage(pixelMap_, 0, 100);
  }
}

async function drawCase(canvas: drawing.Canvas) {
  let pen = new drawing.Pen();
  pen.setStrokeWidth(5);
  pen.setColor({alpha: 255, red: 255, green: 0, blue: 0});
  canvas.attachPen(pen);
  canvas.drawRect({ left : 200, right : 500, top : 50, bottom : 300});
  canvas.detachPen();
}