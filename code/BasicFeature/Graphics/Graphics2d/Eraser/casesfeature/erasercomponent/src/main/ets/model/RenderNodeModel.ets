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

import { common2D, drawing } from '@kit.ArkGraphics2D';
import { DrawContext, FrameNode, NodeController, RenderNode, Size } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';

/**
 * MyRenderNode类，初始化画笔和绘制路径
 */
export class MyRenderNode extends RenderNode {
  path: drawing.Path = new drawing.Path(); // 新建路径对象，用于绘制手指移动轨迹
  pen: drawing.Pen = new drawing.Pen(); // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
  blendMode: drawing.BlendMode = drawing.BlendMode.SRC_OVER; // 画笔的颜色混合模式
  lineStrokeWidth: number = 0; // 画笔线宽

  constructor() {
    super();
    // 设置画笔颜色
    const penColor: common2D.Color = {
      alpha: 0xFF,
      red: 0xFA,
      green: 0x64,
      blue: 0x00
    };
    this.pen.setColor(penColor);
    // 设置画笔开启反走样，可以使得图形的边缘在显示时更平滑
    this.pen.setAntiAlias(true);
    // 开启画笔的抖动绘制效果。抖动绘制可以使得绘制出的颜色更加真实。
    this.pen.setDither(true);
    // 设置画笔绘制转角的样式为圆头
    this.pen.setJoinStyle(drawing.JoinStyle.ROUND_JOIN);
    // 设置画笔线帽的样式，即画笔在绘制线段时在线段头尾端点的样式为半圆弧
    this.pen.setCapStyle(drawing.CapStyle.ROUND_CAP);
  }

  // RenderNode进行绘制时会调用draw方法
  draw(context: DrawContext): void {
    const canvas = context.canvas;
    // 设置画笔的颜色混合模式，根据不同的混合模式实现涂鸦和擦除效果
    this.pen.setBlendMode(this.blendMode);
    // 设置画笔的线宽，单位px
    this.pen.setStrokeWidth(this.lineStrokeWidth);
    // 将Pen画笔设置到canvas中
    canvas.attachPen(this.pen);
    // 绘制path
    canvas.drawPath(this.path);
  }
}

/**
 * MyImageRenderNode类，绘制和记录画布图案的pixelMap
 */
export class MyImageRenderNode extends RenderNode {
  pixelMapHistory: image.PixelMap[] = []; // 记录每次绘制后画布的pixelMap
  cacheStack: image.PixelMap[] = []; // 记录撤销时从pixelMapHistory中出栈的pixelMap，恢复时使用

  // RenderNode进行绘制时会调用draw方法
  draw(context: DrawContext): void {
    const canvas = context.canvas;
    if (this.pixelMapHistory.length !== 0) {
      // 使用drawImage绘制pixelMapHistory栈顶的pixelMap
      canvas.drawImage(this.pixelMapHistory[this.pixelMapHistory.length - 1], 0, 0);
    }
  }
}

/**
 * NodeController的子类MyNodeController
 */
export class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null; // 根节点
  rootRenderNode: RenderNode | null = null; // 从NodeController根节点获取的RenderNode，用于添加和删除新创建的MyRenderNode实例

  // MyNodeController实例绑定的NodeContainer创建时触发，创建根节点rootNode并将其挂载至NodeContainer
  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode !== null) {
      this.rootRenderNode = this.rootNode.getRenderNode();
    }
    return this.rootNode;
  }

  // 绑定的NodeContainer布局时触发，获取NodeContainer的宽高
  aboutToResize(size: Size): void {
    if (this.rootRenderNode !== null) {
      // NodeContainer布局完成后设置rootRenderNode的背景透明
      this.rootRenderNode.backgroundColor = 0X00000000;
      // rootRenderNode的位置从组件NodeContainer的左上角(0,0)坐标开始，大小为NodeContainer的宽高
      this.rootRenderNode.frame = {
        x: 0,
        y: 0,
        width: size.width,
        height: size.height
      };
    }
  }

  // 添加节点
  addNode(node: RenderNode): void {
    if (this.rootNode === null) {
      return;
    }
    if (this.rootRenderNode !== null) {
      this.rootRenderNode.appendChild(node);
    }
  }

  // 清空节点
  clearNodes(): void {
    if (this.rootNode === null) {
      return;
    }
    if (this.rootRenderNode !== null) {
      this.rootRenderNode.clearChildren();
    }
  }
}