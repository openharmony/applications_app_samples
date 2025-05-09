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
  VALUE_500,
  VALUE_600,
  VALUE_700,
  VALUE_900,
  VALUE_1000
} from '../../pages/Index';

function drawMixedMode(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_mixed_mode]
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置目标像素颜色，即矩形的颜色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 将目标像素的画刷效果设置到Canvas中
  canvas.attachBrush(brush);
  // 创建矩形对象
  let rect: common2D.Rect = {
    left: VALUE_100,
    top: VALUE_100,
    right: VALUE_600,
    bottom: VALUE_600
  };
  // 绘制矩形（目标像素）
  canvas.drawRect(rect);
  // 设置源像素颜色，即圆形的颜色
  brush.setColor(0xFF, 0x00, 0x00, 0xFF);
  // 设置混合模式为叠加模式
  brush.setBlendMode(drawing.BlendMode.PLUS);
  // 将源像素的画刷效果设置到Canvas中
  canvas.attachBrush(brush);
  // 绘制圆（源像素）
  canvas.drawCircle(VALUE_600, VALUE_600, VALUE_300);
  // 去除填充效果
  canvas.detachBrush();
  // [End arkts_graphics_draw_mixed_mode]
}

function drawPathEffect(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_path_effect]
  // 创建画笔
  let pen = new drawing.Pen();
  // 设置线宽
  pen.setStrokeWidth(10.0);
  // 设置颜色
  pen.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 表示10px的实线，5px的间隔，2px的实线，5px的间隔，以此循环
  let intervals = [10, 5, 2, 5];
  // 设置虚线路径效果
  let effect = drawing.PathEffect.createDashPathEffect(intervals, 0);
  pen.setPathEffect(effect);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  // 创建矩形
  let rect: common2D.Rect = {
    left: VALUE_200,
    top: VALUE_200,
    right: VALUE_1000,
    bottom: VALUE_700
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除描边效果
  canvas.detachPen();
  // [End arkts_graphics_draw_path_effect]
}

function drawLinearGradient(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_linear_gradient]
  let startPt: common2D.Point = { x: VALUE_100, y: VALUE_100 };
  let endPt: common2D.Point = { x: VALUE_900, y: VALUE_900 };
  let colors = [0xFFFFFF00, 0xFFFF0000, 0xFF0000FF];
  // 创建线性渐变着色器
  let shaderEffect = drawing.ShaderEffect.createLinearGradient(startPt, endPt, colors, drawing.TileMode.CLAMP);
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置线性着色器
  brush.setShaderEffect(shaderEffect);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  let rect: common2D.Rect = {
    left: VALUE_100,
    top: VALUE_100,
    right: VALUE_900,
    bottom: VALUE_900
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除填充效果
  canvas.detachBrush();
  // [End arkts_graphics_draw_linear_gradient]
}

function drawPathGradient(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_path_gradient]
  let centerPt: common2D.Point = { x: VALUE_500, y: VALUE_500 };
  let colors = [0xFFFF0000, 0xFF00FF00, 0xFF0000FF];
  // 创建径向渐变着色器
  let shaderEffect = drawing.ShaderEffect.createRadialGradient(centerPt, VALUE_600, colors, drawing.TileMode.CLAMP);
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置径向渐变着色器
  brush.setShaderEffect(shaderEffect);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  let rect: common2D.Rect = {
    left: VALUE_100,
    top: VALUE_100,
    right: VALUE_900,
    bottom: VALUE_900
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除填充效果
  canvas.detachBrush();
  // [End arkts_graphics_draw_path_gradient]
}

function drawSectorGradient(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_sector_gradient]
  let centerPt: common2D.Point = { x: VALUE_500, y: VALUE_500 };
  let colors = [0xFF00FFFF, 0xFFFF00FF, 0xFFFFFF00];
  // 创建扇形渐变着色器
  let shaderEffect = drawing.ShaderEffect.createSweepGradient(centerPt, colors, drawing.TileMode.CLAMP, 0, 360);
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置扇形渐变着色器
  brush.setShaderEffect(shaderEffect);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  let rect: common2D.Rect = {
    left: VALUE_100,
    top: VALUE_100,
    right: VALUE_900,
    bottom: VALUE_900
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除填充效果
  canvas.detachBrush();
  // [End arkts_graphics_draw_sector_gradient]
}

function drawColorFilter(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_color_filter]
  // 创建画刷
  let brush = new drawing.Brush();
  // 设置颜色
  brush.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 设置颜色矩阵
  let matrix: number[] = [
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 0.5, 0.5, 0,
    0, 0, 0.5, 0.5, 0
  ];
  // 创建5x4颜色矩阵的颜色滤波器
  let filter = drawing.ColorFilter.createMatrixColorFilter(matrix);
  // 设置颜色滤波器
  brush.setColorFilter(filter);
  // 设置画刷填充效果
  canvas.attachBrush(brush);
  let rect: common2D.Rect = {
    left: VALUE_300,
    top: VALUE_300,
    right: VALUE_900,
    bottom: VALUE_900
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除填充效果
  canvas.detachBrush();
  // [End arkts_graphics_draw_color_filter]
}

function drawImageFilter(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_image_filter]
  // 设置画笔
  let pen = new drawing.Pen();
  // 设置线宽
  pen.setStrokeWidth(10.0);
  // 设置颜色
  pen.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 创建模糊效果图像滤波器
  let filter = drawing.ImageFilter.createBlurImageFilter(20, 20, drawing.TileMode.CLAMP);
  // 设置图像滤波器
  pen.setImageFilter(filter);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  let rect: common2D.Rect = {
    left: VALUE_300,
    top: VALUE_300,
    right: VALUE_900,
    bottom: VALUE_900
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除描边效果
  canvas.detachPen();
  // [End arkts_graphics_draw_image_filter]
}

function drawMaskFilter(canvas: drawing.Canvas) {
  // [Start arkts_graphics_draw_mask_filter]
  // 创建画笔
  let pen = new drawing.Pen();
  // 设置线宽
  pen.setStrokeWidth(10.0);
  // 设置颜色
  pen.setColor(0xFF, 0xFF, 0x00, 0x00);
  // 创建模糊效果的蒙版滤波器
  let filter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.NORMAL, 20);
  // 设置模糊效果
  pen.setMaskFilter(filter);
  // 设置画笔描边效果
  canvas.attachPen(pen);
  let rect: common2D.Rect = {
    left: VALUE_300,
    top: VALUE_300,
    right: VALUE_900,
    bottom: VALUE_900
  };
  // 绘制矩形
  canvas.drawRect(rect);
  // 去除描边效果
  canvas.detachPen();
  // [End arkts_graphics_draw_mask_filter]
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
    this.myRenderNode.addDrawFunction(drawMixedMode);
    this.myRenderNode.addDrawFunction(drawPathEffect);
    this.myRenderNode.addDrawFunction(drawLinearGradient);
    this.myRenderNode.addDrawFunction(drawPathGradient);
    this.myRenderNode.addDrawFunction(drawSectorGradient);
    this.myRenderNode.addDrawFunction(drawColorFilter);
    this.myRenderNode.addDrawFunction(drawImageFilter);
    this.myRenderNode.addDrawFunction(drawMaskFilter);
  }

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }

    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      this.myRenderNode.backgroundColor = 0xff000000; // 黑色背景
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
    if (index === 0) {
      this.myRenderNode.backgroundColor = 0xff000000; // 混合模式效果需要使用黑色背景展示
    } else {
      this.myRenderNode.backgroundColor = 0xffffffff; // 其余模式使用白色背景
    }

  }
}

@Entry
@Component
struct ComplexEffect {
  private nodeController: MyNodeController = new MyNodeController();

  build() {
    Row() {
      Column() {
        // 将自定义NodeController进行显示
        NodeContainer(this.nodeController)
          .width('100%')
          .height('70%');
        Row() {
          Button($r('app.string.MixedMode'))
            .onClick(() => {
              this.nodeController.setDrawIndex(0); // 点击绘制混合模式
            });
          Button($r('app.string.PathEffect'))
            .onClick(() => {
              this.nodeController.setDrawIndex(1); // 点击绘制路径效果
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')

        Row() {
          Button($r('app.string.LinearGradient'))
            .onClick(() => {
              this.nodeController.setDrawIndex(2); // 点击绘制线性渐变着色器效果
            });
          Button($r('app.string.PathGradient'))
            .onClick(() => {
              this.nodeController.setDrawIndex(3); // 点击绘制径向渐变着色器效果
            });
          Button($r('app.string.SectorGradient'))
            .onClick(() => {
              this.nodeController.setDrawIndex(4); // 点击绘制扇形渐变着色器效果
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')

        Row() {
          Button($r('app.string.ColorFilter'))
            .onClick(() => {
              this.nodeController.setDrawIndex(5); // 点击绘制颜色滤波器效果
            });
          Button($r('app.string.ImageFilter'))
            .onClick(() => {
              this.nodeController.setDrawIndex(6); // 点击绘制图像滤波器效果
            });
          Button($r('app.string.MaskFilter'))
            .onClick(() => {
              this.nodeController.setDrawIndex(7); // 点击绘制蒙版滤波器效果
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('8%')
      }
    }
  }
}