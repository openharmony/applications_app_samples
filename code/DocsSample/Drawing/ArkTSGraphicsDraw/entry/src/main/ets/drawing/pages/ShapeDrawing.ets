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
import { common2D, drawing } from '@kit.ArkGraphics2D';
import {
  VALUE_100,
  VALUE_200,
  VALUE_300,
  VALUE_400,
  VALUE_500,
  VALUE_600,
  VALUE_630,
  VALUE_700,
  VALUE_800,
  VALUE_900,
  VALUE_1000,
  VALUE_1800
} from '../../pages/Index';

function drawPoint(canvas: drawing.Canvas) {
  // 设置画笔
  let pen = new drawing.Pen();
  // 设置颜色
  pen.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置线宽
  pen.setStrokeWidth(40);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  // 绘制5个点
  canvas.drawPoint(VALUE_200, VALUE_200);
  canvas.drawPoint(VALUE_400, VALUE_400);
  canvas.drawPoint(VALUE_600, VALUE_600);
  canvas.drawPoint(VALUE_800, VALUE_800);
  canvas.drawPoint(VALUE_1000, VALUE_1000);
  // 去除描边效果
  canvas.detachPen();
}

function drawArc(canvas: drawing.Canvas) {
  // 创建画笔
  let pen = new drawing.Pen();
  // 设置颜色
  pen.setColor({
    alpha: 0xFF,
    red: 0xFF,
    green: 0x00,
    blue: 0x00
  });
  // 设置线宽
  pen.setStrokeWidth(20);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  // 创建矩形对象
  const rect: common2D.Rect = {
    left: VALUE_100,
    top: VALUE_200,
    right: VALUE_1000,
    bottom: VALUE_600
  };
  // 绘制矩形
  canvas.drawArc(rect, 0, 180);
  // 去除描边效果
  canvas.detachPen();
}

function drawCircle(canvas: drawing.Canvas) {
  // 创建画笔
  let pen = new drawing.Pen();
  // 设置颜色
  pen.setColor({
    alpha: 0xFF,
    red: 0xFF,
    green: 0x00,
    blue: 0x00
  });
  // 设置线宽
  pen.setStrokeWidth(20);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  // 绘制圆
  canvas.drawCircle(VALUE_630, VALUE_630, VALUE_500);
  // 去除描边效果
  canvas.detachPen();
}

function drawPath(canvas: drawing.Canvas) {
  let height_ = VALUE_1800;
  let width_ = VALUE_1800;
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
  path.close();

  // 创建画笔对象
  let pen = new drawing.Pen();
  // 设置抗锯齿
  pen.setAntiAlias(true);
  // 设置描边颜色
  pen.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置线宽
  pen.setStrokeWidth(10.0);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置填充颜色
  brush.setColor(0xFF, 0x00, 0xFF, 0x00);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 绘制路径
  canvas.drawPath(path);
  // 去除填充效果
  canvas.detachBrush();
  // 去除描边效果
  canvas.detachPen();
}

function drawRegion(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 创建左上角的region1
  let region1 = new drawing.Region();
  region1.setRect(VALUE_100, VALUE_100, VALUE_600, VALUE_600);
  // 创建右下角的region2
  let region2 = new drawing.Region();
  region2.setRect(VALUE_300, VALUE_300, VALUE_900, VALUE_900);
  // 将两个区域以XOR的方式组合
  region1.op(region2, drawing.RegionOp.XOR);
  // 绘制区域
  canvas.drawRegion(region1);
  // 去除填充效果
  canvas.detachBrush();
}

function drawRect(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 绘制矩形
  canvas.drawRect(VALUE_200, VALUE_200, VALUE_1000, VALUE_700);
  // 去除填充效果
  canvas.detachBrush();
}

function drawRoundRect(canvas: drawing.Canvas) {
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  // 创建矩形对象
  let rect: common2D.Rect = {
    left: VALUE_200,
    top: VALUE_200,
    right: VALUE_1000,
    bottom: VALUE_700
  };
  console.info('rect:', rect.right);
  // 创建圆角矩形对象
  let rrect = new drawing.RoundRect(rect, 30, 30);
  // 绘制圆角矩形
  canvas.drawRoundRect(rrect);
  // 去除填充效果
  canvas.detachBrush();
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
    this.myRenderNode.addDrawFunction(drawPoint);
    this.myRenderNode.addDrawFunction(drawArc);
    this.myRenderNode.addDrawFunction(drawCircle);
    this.myRenderNode.addDrawFunction(drawPath);
    this.myRenderNode.addDrawFunction(drawRegion);
    this.myRenderNode.addDrawFunction(drawRect);
    this.myRenderNode.addDrawFunction(drawRoundRect);
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
struct ShapeDrawing {
  private nodeController: MyNodeController = new MyNodeController();

  build() {
    Row() {
      Column() {
        // 将自定义NodeController进行显示
        NodeContainer(this.nodeController)
          .width('100%')
          .height('70%');
        Row() {
          Button($r('app.string.Point'))
            .onClick(() => {
              this.nodeController.setDrawIndex(0); // 点击绘制点
            });
          Button($r('app.string.Arc'))
            .onClick(() => {
              this.nodeController.setDrawIndex(1); // 点击绘制圆弧
            });
          Button($r('app.string.Circle'))
            .onClick(() => {
              this.nodeController.setDrawIndex(2); // 点击绘制圆
            });
          Button($r('app.string.Path'))
            .onClick(() => {
              this.nodeController.setDrawIndex(3); // 点击绘制路径
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')

        Row() {
          Button($r('app.string.Region'))
            .onClick(() => {
              this.nodeController.setDrawIndex(4); // 点击绘制区域
            });
          Button($r('app.string.Rect'))
            .onClick(() => {
              this.nodeController.setDrawIndex(5); // 点击绘制矩形
            });
          Button($r('app.string.RoundRect'))
            .onClick(() => {
              this.nodeController.setDrawIndex(6); // 点击绘制圆角矩形
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')
      }
    }
  }
}