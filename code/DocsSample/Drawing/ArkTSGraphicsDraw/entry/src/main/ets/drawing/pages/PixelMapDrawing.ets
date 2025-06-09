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

import { DrawContext, FrameNode, NodeController, RenderNode, UIContext } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import { image } from '@kit.ImageKit';
import { VALUE_100, VALUE_200 } from '../../pages/Index';

let pixelMap: image.PixelMap;

function drawImage(canvas: drawing.Canvas) {
  // Start arkts_graphics_draw_image]
  // 图片宽高
  let width = 600;
  let height = 400;
  // 字节长度，RGBA_8888每个像素占4字节
  let bytelength = width * height * 4;
  const color: ArrayBuffer = new ArrayBuffer(bytelength);
  let bufferArr = new Uint8Array(color);
  for (let i = 0; i < bufferArr.length; i += 4) {
    // 遍历并编辑每个像素，从而形成红绿蓝相间的条纹
    bufferArr[i] = 0x00;
    bufferArr[i+1] = 0x00;
    bufferArr[i+2] = 0x00;
    bufferArr[i+3] = 0xFF;
    let n = Math.floor(i / 80) % 3;
    if (n == 0) {
      bufferArr[i] = 0xFF;
    } else if (n == 1) {
      bufferArr[i+1] = 0xFF;
    } else {
      bufferArr[i+2] = 0xFF;
    }
  }
  // 设置像素属性
  let opts: image.InitializationOptions =
    { editable: true, pixelFormat: image.PixelMapFormat.RGBA_8888, size: { height: height, width: width } };
  // 创建PixelMap
  pixelMap = image.createPixelMapSync(color, opts);
  // 为了使图片完全显示，修改绘制起点参数为（0，0）
  canvas.drawImage(pixelMap, 0, 0);
  // End arkts_graphics_draw_image]
}

function editPixel(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_edit_pixel]
  // 设置编辑区域的宽高
  let innerWidth = 400;
  let innerHeight = 200;
  // 编辑区域的字节长度，RGBA_8888每个像素占4字节
  let innerByteLength = innerWidth * innerHeight * 4;
  const innerColor: ArrayBuffer = new ArrayBuffer(innerByteLength);
  let innerBufferArr = new Uint8Array(innerColor);
  for (let i = 0; i < innerBufferArr.length; i += 4) {
    // 编辑区域的像素都设置为黑白相间条纹
    let n = Math.floor(i / 80) % 2;
    if (n == 0) {
      innerBufferArr[i] = 0x00;
      innerBufferArr[i+1] = 0x00;
      innerBufferArr[i+2] = 0x00;
    } else {
      innerBufferArr[i] = 0xFF;
      innerBufferArr[i+1] = 0xFF;
      innerBufferArr[i+2] = 0xFF;
    }
    innerBufferArr[i+3] = 0xFF;
  }
  // 设置编辑区域的像素、宽高、偏移量等
  const area: image.PositionArea = {
    pixels: innerColor,
    offset: 0,
    stride: innerWidth * 4,
    region: { size: { height: innerHeight, width: innerWidth }, x: 100, y: 100 }
  };
  // 编辑位图，形成中间的黑白相间条纹
  pixelMap.writePixelsSync(area);
  // 为了使图片完全显示，修改绘制起点参数为（0，0）
  canvas.drawImage(pixelMap, 0, 0);
  // [End arkts_graphics_draw_edit_pixel]
}

// 自定义RenderNode
class MyRenderNode extends RenderNode {
  private drawFunctions: ((canvas: drawing.Canvas) => void)[] = []; // 存储绘制函数的数组
  private currentDrawIndex: number = 0; // 当前绘制函数的下标

  // 添加绘制函数的接口
  addDrawFunction(func: (canvas: drawing.Canvas) => void) {
    this.drawFunctions.push(func);
  }

  // 设置当前绘制函数的下标
  setDrawIndex(index: number) {
    if (index >= 0 && index < this.drawFunctions.length) {
      this.currentDrawIndex = index;
      this.invalidate(); // 触发重绘
    }
  }

  async draw(context: DrawContext) {
    const canvas = context.canvas;
    const drawFunction = this.drawFunctions[this.currentDrawIndex];
    if (drawFunction) {
      drawFunction(canvas);
    }
  }
}

// 自定义NodeController
class MyNodeController extends NodeController {
  private myRenderNode = new MyRenderNode();
  private rootNode: FrameNode | null = null;

  constructor() {
    super();
    // 添加绘制函数
    this.myRenderNode.addDrawFunction(drawImage);
    this.myRenderNode.addDrawFunction(editPixel);
  }

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }

    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      this.myRenderNode.backgroundColor = 0xffffffff; // 白色背景
      this.myRenderNode.frame = {
        x: 0,
        y: 0,
        width: 4800,
        height: 4800
      };
      this.myRenderNode.pivot = { x: 0.2, y: 0.8 };
      this.myRenderNode.scale = { x: 1, y: 1 };
      renderNode.appendChild(this.myRenderNode);
      renderNode.clipToFrame = true;
    }
    return this.rootNode;
  }

  // 暴露设置绘制函数下标的方法
  setDrawIndex(index: number) {
    this.myRenderNode.setDrawIndex(index);
  }
}

@Entry
@Component
struct ImageDrawing {
  private nodeController: MyNodeController = new MyNodeController();

  build() {
    Row() {
      Column() {
        // 将自定义NodeController进行显示
        NodeContainer(this.nodeController)
          .width('100%')
          .height('70%');
        Row() {
          Button($r('app.string.PixelMap'))
            .onClick(() => {
              this.nodeController.setDrawIndex(0); // 点击绘制位图
            });
          Button($r('app.string.EditMiddlePixel'))
            .onClick(() => {
              this.nodeController.setDrawIndex(1); // 点击编辑位图像素
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')
      }
    }
  }
}