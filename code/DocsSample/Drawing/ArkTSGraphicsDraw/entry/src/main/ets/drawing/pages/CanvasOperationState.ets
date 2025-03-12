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
import { VALUE_200, VALUE_300, VALUE_600 } from '../../pages/Index';


function drawClipOperation(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色为蓝色
  brush.setColor(0xFF, 0x00,  0x00, 0xFF);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 创建矩形对象
  let rect: common2D.Rect = { left: VALUE_200, top: VALUE_200, right: VALUE_600, bottom: VALUE_600 };
  // 裁剪矩形区域
  canvas.clipRect(rect);
  // 绘制圆形
  canvas.drawCircle(VALUE_300, VALUE_300, VALUE_300);
  // 去除填充效果
  canvas.detachBrush();
}

function drawTranslationOperation(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色为红色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 执行平移操作
  canvas.translate(VALUE_300, VALUE_300);
  // 绘制矩形
  canvas.drawRect({ left: VALUE_200, top: VALUE_200, right: VALUE_600, bottom: VALUE_600 });
  // 去除填充效果
  canvas.detachBrush();
}

function drawRotationOperation(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色为红色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 顺时针旋转45度
  canvas.rotate(45, VALUE_200, VALUE_200);
  // 绘制矩形
  canvas.drawRect({ left: VALUE_200, top: VALUE_200, right: VALUE_600, bottom: VALUE_600 });
  // 去除填充效果
  canvas.detachBrush();
}

function drawScaleOperation(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色为红色
  brush.setColor({ alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 });
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 执行放大操作
  canvas.scale(2, 2);
  // 绘制矩形
  canvas.drawRect({ left: VALUE_200, top: VALUE_200, right: VALUE_600, bottom: VALUE_600 });
  // 去除填充效果
  canvas.detachBrush();
}

function drawStateOperation(canvas: drawing.Canvas) {
  // 创建画笔
  let pen = new drawing.Pen();
  // 设置颜色为红色
  pen.setColor({ alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 });
  // 设置描边宽度为20px
  pen.setStrokeWidth(20);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  // 保存操作，当前是不存在放大等操作的，这个原始状态会被保存下来
  canvas.save();
  // x轴和y轴放行分别放大2倍
  canvas.scale(2, 2);
  // 绘制圆形，因为执行过放大操作，所以此时绘制的是大圆
  canvas.drawCircle(VALUE_300, VALUE_300, VALUE_200);
  // 恢复操作，恢复到没有放大的原始状态
  canvas.restore();
  // 绘制圆形，因为已经恢复到没有放大的原始状态，所以此时绘制的是小圆
  canvas.drawCircle(VALUE_300, VALUE_300, VALUE_200);
  // 去除描边效果
  canvas.detachPen();
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
    this.myRenderNode.addDrawFunction(drawClipOperation);
    this.myRenderNode.addDrawFunction(drawTranslationOperation);
    this.myRenderNode.addDrawFunction(drawRotationOperation);
    this.myRenderNode.addDrawFunction(drawScaleOperation);
    this.myRenderNode.addDrawFunction(drawStateOperation);
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
struct CanvasOperationState {
  private nodeController: MyNodeController = new MyNodeController();

  build() {
    Row() {
      Column() {
        // 将自定义NodeController进行显示
        NodeContainer(this.nodeController)
          .width('100%')
          .height('70%');
        Row() {
          Button($r('app.string.ClipOperation'))
            .onClick(() => {
              this.nodeController.setDrawIndex(0); // 点击绘制裁剪操作
            });
          Button($r('app.string.TranslationOperation'))
            .onClick(() => {
              this.nodeController.setDrawIndex(1); // 点击绘制平移操作
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')
        Row() {
          Button($r('app.string.RotationOperation'))
            .onClick(() => {
              this.nodeController.setDrawIndex(2); // 点击绘制旋转操作
            });
          Button($r('app.string.ScaleOperation'))
            .onClick(() => {
              this.nodeController.setDrawIndex(3); // 点击绘制缩放操作
            });
          Button($r('app.string.StateOperation'))
            .onClick(() => {
              this.nodeController.setDrawIndex(4); // 点击绘制画布状态操作
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')
      }
    }
  }
}