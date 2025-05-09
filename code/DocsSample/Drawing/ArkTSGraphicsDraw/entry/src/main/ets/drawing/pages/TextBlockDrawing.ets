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

import { UIContext, NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI';
import { common2D, drawing } from '@kit.ArkGraphics2D';
import { VALUE_100, VALUE_200, VALUE_300, VALUE_900 } from '../../pages/Index';

function drawBaseText(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_base_text]
  // 创建字型对象
  const font = new drawing.Font();
  // 设置字体大小
  font.setSize(100);
  // 创建字块对象
  const textBlob = drawing.TextBlob.makeFromString('Hello world', font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
  // 绘制字块
  canvas.drawTextBlob(textBlob, VALUE_200, VALUE_300);
  // [End arkts_graphics_draw_base_text]
}

function drawStrokeText(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_stroke_text]
  // 创建画笔
  let pen = new drawing.Pen();
  // 设置抗锯齿
  pen.setAntiAlias(true);
  // 设置描边线宽
  pen.setStrokeWidth(3.0);
  // 设置描边颜色
  pen.setColor(0xFF, 0xFF,  0x00, 0x00);
  // 创建字型对象
  const font = new drawing.Font();
  // 设置字体大小
  font.setSize(100);
  // 添加画笔描边效果
  canvas.attachPen(pen);
  // 创建字块对象
  const textBlob = drawing.TextBlob.makeFromString('Hello world', font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
  // 绘制字块
  canvas.drawTextBlob(textBlob, VALUE_200, VALUE_300);
  // 去除描边效果
  canvas.detachPen();
  // [End arkts_graphics_draw_stroke_text]
}

function drawGradientText(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_gradient_text]
  let startPt: common2D.Point = { x: VALUE_100, y: VALUE_100 };
  let endPt: common2D.Point = { x: VALUE_900, y: VALUE_900 };
  let colors = [0xFFFFFF00, 0xFFFF0000, 0xFF0000FF];
  // 创建线性渐变着色器
  let shaderEffect = drawing.ShaderEffect.createLinearGradient(startPt, endPt, colors, drawing.TileMode.CLAMP);
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置着色器
  brush.setShaderEffect(shaderEffect);
  // 添加画刷填充效果
  canvas.attachBrush(brush);
  // 创建字型
  const font = new drawing.Font();
  // 设置字体大小
  font.setSize(VALUE_200);
  // 创建字块
  const textBlob = drawing.TextBlob.makeFromString('Hello world', font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
  // 绘制字块
  canvas.drawTextBlob(textBlob, VALUE_100, VALUE_300);
  // 去除填充效果
  canvas.detachBrush();
  // [End arkts_graphics_draw_gradient_text]
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
  private rootNode: FrameNode | null = null;
  private myRenderNode = new MyRenderNode();

  constructor() {
    super();
    // 添加绘制函数
    this.myRenderNode.addDrawFunction(drawBaseText);
    this.myRenderNode.addDrawFunction(drawStrokeText);
    this.myRenderNode.addDrawFunction(drawGradientText);
  }

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }

    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      this.myRenderNode.backgroundColor = 0xffffffff; // 白色背景
      this.myRenderNode.frame = { x: 0, y: 0, width: 4800, height: 4800 };
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
struct TextBlobDrawing {
  private nodeController: MyNodeController = new MyNodeController();

  build() {
    Row() {
      Column() {
        // 将自定义NodeController进行显示
        NodeContainer(this.nodeController)
          .width('100%')
          .height('70%');
        Row() {
          Button($r('app.string.BaseText'))
            .onClick(() => {
              this.nodeController.setDrawIndex(0); // 点击绘制基本文字
            });
          Button($r('app.string.StrokeText'))
            .onClick(() => {
              this.nodeController.setDrawIndex(1); // 点击绘制描边文字
            });
          Button($r('app.string.GradientText'))
            .onClick(() => {
              this.nodeController.setDrawIndex(2); // 点击绘制渐变文字
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')
      }
    }
  }
}