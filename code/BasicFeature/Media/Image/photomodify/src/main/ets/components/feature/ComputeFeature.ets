/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { logger } from '../util/Logger';

/**
 * 计算尺寸和坐标的变化
 * 输入值：
 *
 *
 * 输出值：
 *
 *
 *
 * 两个四边形，
 * 一个是外部的四边形，宽高和父容器相同
 * 二哥是内部的四边形，四个角就是内部四个点的圆心
 * 两个四边形中心点相同
 *
 * 内部核心参数：
 * 中心点：
 * width
 * height
 *
 */
export default class ComputeFeature {
  /**
   * 初始化参数
   */
  // 容器宽高
  containerWidth: number = 0;
  containerHeight: number = 0;
  imageWidth: number = 0;
  imageHeight: number = 0;
  materialWidth: number = 0;
  materialHeight: number = 0;

  // 素材最大和最小尺寸
  minScale = 0.5;
  maxMaterialWidth: number = 0;
  maxMaterialHeight: number = 0;
  minMaterialWidth: number = 0;
  minMaterialHeight: number = 0;

  // 拖拽点的半径
  dotRadius: number = 0;

  // 初始化素材中心点，一般也是父容器的中心点
  initX: number = 0;
  initY: number = 0;
  x: number = 0;
  y: number = 0;
  fontSize: number = 0;

  // 拖拽动作相关
  currentType: NodeType = NodeType.LEFT_TOP;
  dragStartWidth: number = 0;
  dragStartHeight: number= 0;
  dragStartFontSize: number= 0;
  dragStartX: number= 0;
  dragStartY: number= 0;

  setMaterialAndImageSize(cw: number, ch: number, iw: number, ih: number): void {
    this.containerWidth = cw;
    this.containerHeight = ch;
    this.imageWidth = iw;
    this.imageHeight = ih;
    this.maxMaterialWidth = Math.min(this.containerWidth, this.imageWidth);
    this.maxMaterialHeight = Math.min(this.containerHeight, this.imageHeight);
    this.initX = this.containerWidth / 2;
    this.initY = this.containerHeight / 2;
    this.x = this.initX;
    this.y = this.initY;
    logger.debug('初始化中心点：x=' + this.x + ',y=' + this.y);
  }

  setOriginMaterialSize(w: number, y: number): void {
    this.materialWidth = w;
    this.materialHeight = y;
    this.minMaterialHeight = this.minScale * this.materialHeight;
    this.minMaterialWidth = this.minScale * this.materialWidth;
    logger.debug('setMaterialSize，w=' + w + ',h+' + y);
  }

  setFontSize(fontSize: number): void {
    this.fontSize = fontSize;
  }

  startDrag(nodeType: NodeType): void {
    this.currentType = nodeType;
    this.dragStartWidth = this.materialWidth;
    this.dragStartHeight = this.materialHeight;
    this.dragStartFontSize = this.fontSize;
    this.dragStartX = this.x;
    this.dragStartY = this.y;
    logger.debug('startDrag，w=' + this.dragStartWidth + ',h+' + this.dragStartHeight);
  }

  /**
   * 素材的拖拽
   */
  onDragMaterial(dx: number, dy: number): void {
    this.x = this.x + dx;
    this.y = this.y + dy;
  }

  /**
   * 拖拽三个边角
   * @param dx
   * @param dy
   * @param callback
   */
  onDrag(dx: number, dy: number, callback: (w: number, h: number, scale: number, fontSize: number) => void): void {
    let width: number = 0;
    let height: number = 0;
    switch (this.currentType) {
      case NodeType.RIGHT_TOP:
        width = this.dragStartWidth + 2 * dx;
        break;
      case NodeType.LEFT_BOTTOM:
        width = this.dragStartWidth - 2 * dx;
        break;
      case NodeType.RIGHT_BOTTOM:
        width = this.dragStartWidth + 2 * dx;
        break;
    }
    const scaleTmp: number = this.materialWidth / this.dragStartWidth;
    height = this.dragStartHeight * scaleTmp;
    this.adjustMaxMin(width, height);
    const scale: number = this.materialWidth / this.dragStartWidth;
    // 计算
    this.fontSize = this.dragStartFontSize * scale;
    callback(this.materialWidth, this.materialHeight, scale, this.fontSize);
  }

  /**
   * 拖拽中心点
   */
  onDragCenter(dx: number, dy: number, callback: (x: number, y: number) => void): void {
    const minX: number = this.initX - this.imageWidth / 2 + this.materialWidth / 2;
    const maxX: number = this.initX + this.imageWidth / 2 - this.materialWidth / 2;
    const minY: number = this.initY - this.imageHeight / 2 + this.materialHeight / 2;
    const maxY: number = this.initY + this.imageHeight / 2 - this.materialHeight / 2;
    const tempX: number = this.dragStartX + dx;
    if (dx > 0) {
      this.x = Math.min(tempX, maxX);
    } else {
      this.x = Math.max(tempX, minX);
    }
    const tempY: number = this.dragStartY + dy;
    if (dy > 0) {
      this.y = Math.min(tempY, maxY);
    } else {
      this.y = Math.max(tempY, minY);
    }
    logger.debug('修改中心点：x=' + this.x + ',y=' + this.y);
    callback(this.x, this.y);
  }

  endDrag(): void {
    this.currentType = NodeType.LEFT_TOP;
    this.dragStartWidth = 0;
    this.dragStartHeight = 0;
    this.dragStartFontSize = 0;
    this.dragStartX = 0;
    this.dragStartY = 0;
  }

  /**
   * 校准最大值、最小值
   */
  adjustMaxMin(w: number, h: number): void {
    w = Math.max(w, this.minMaterialWidth);
    w = Math.min(w, this.containerWidth);
    // 放大时，不能超过image边界
    if (w > this.materialWidth) {
      const dx: number = Math.abs(this.x - this.initX);
      const maxW: number = this.imageWidth / 2 - dx;
      // 素材宽度的1/2，不能大于图片2/1 - 中心坐标差
      w = Math.min(w, maxW * 2);
    }
    if (h > this.materialHeight) {
      const dy: number = Math.abs(this.y - this.initY);
      const maxH: number = this.imageHeight / 2 - dy;
      h = Math.min(h, maxH * 2);
    }
    this.materialWidth = w;
    h = Math.max(h, this.minMaterialHeight);
    h = Math.min(h, this.containerHeight);
    this.materialHeight = h;
  }
}

export enum NodeType {
  LEFT_TOP,
  RIGHT_TOP,
  LEFT_BOTTOM,
  RIGHT_BOTTOM,
  // 中间素材的拖拽
  CENTER_MATERIAL
}


