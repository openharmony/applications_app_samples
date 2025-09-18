/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import { CanvasRenderingContext2D, px2vp } from '@ohos.arkui.component';
import { Observed, Track } from '@ohos.arkui.stateManagement';
import componentUtils from '@ohos.arkui.componentUtils';
import { RaisedCircleSetPositionXYType } from '../types/RaisedCircleTypes';
import { getChamferXY as utilGetChamferXY, getMinWidth as utilGetMinWidth } from './Functions';

/**
 * 悬浮的球和凸起的球 选中时大小需要小于正常尺寸
 * 6 则是多余的尺寸
 */
export const SURPLUSRADIUS = 6;

interface CircleClassConstructorType {
  width: number;
  height: number;
  menuLength: number;
}

/**
 * 基础类
 */
@Observed
class CircleClass {
  // 宽度
  @Track
  public width: number;
  // 高度
  @Track
  public height: number;
  // 记录tabs有几个菜单
  @Track
  public menuLength: number = 0;

  constructor(options: CircleClassConstructorType) {
    this.width = options.width;
    this.height = options.height;
    this.menuLength = options.menuLength;
  }

  /**
   * 获取兼容性的半径
   * @returns {number}
   */
  getMinWidth(): number {
    return utilGetMinWidth(this.width, this.height, this.menuLength);
  }

  /**
   * 获取菜单选项的中间点
   * @param {number} index - 当前选中菜单的下标
   * @returns {number}
   */
  getMenuCenterX(index: number): number {
    let itemWidth = this.width / this.menuLength;
    let basicsX = itemWidth * index;
    // 获取当前选项的中间点所以用 宽度 /2
    let centerXWidth = itemWidth / 2;
    return basicsX + centerXWidth;
  }
}

/**
 * 凹槽使用类
 */
@Observed
export class ConcaveCircle extends CircleClass {
  // X的定位
  @Track
  public positionX: number = 0;
  // Y的定位
  @Track
  public positionY: number = 0;
  // 旧的定位
  public oldPositionX: number = 0;
  public oldPositionY: number = 0;
  // 悬浮球半径
  @Track
  public circleRadius: number = 0;
  @Track
  public circleDiameter: number = 0;

  constructor(context: CanvasRenderingContext2D, menuLength: number) {
    super({
      width: context.width,
      height: context.height,
      menuLength: menuLength
    });
    this.initCircleRadius();
    this.resetXY();
  }

  /**
   * 设置悬浮球半径 -- 比正常半径要小一圈
   */
  initCircleRadius(): void {
    // 半径
    this.circleRadius = this.getMinWidth() / 2 - SURPLUSRADIUS;
    // 直径
    this.circleDiameter = this.circleRadius * 2;
  }

  /**
   * 初始化 X Y
   */
  resetXY(): void {
    this.positionY = -this.circleRadius;
    this.positionX = this.getAutoPositionX(0);
    this.oldPositionX = 0;
    this.oldPositionY = 0;
  }

  /**
   * 根据选项自动获取距离 X 值
   * @param {number} index 当球选中项的下标
   * @returns {number}
   */
  getAutoPositionX(index: number): number {
    return this.getMenuCenterX(index) - this.circleRadius;
  }

  /**
   * 设置坐标
   * @param {RaisedCircleSetPositionXYType} obj
   */
  setPositionXY(position: RaisedCircleSetPositionXYType): void {
    if (position.x || position.x === 0) {
      this.oldPositionX = this.positionX;
      this.positionX = position.x as number;
    }
    if (position.y || position.y === 0) {
      this.oldPositionY = this.positionY;
      this.positionY = position.y as number;
    }
  }
}

/**
 * 凸起使用类
 */
@Observed
export class ChamferInfo extends CircleClass {
  //悬浮球直径
  @Track
  public circleDiameter: number = 0;
  //悬浮球半径
  @Track
  public circleRadius: number = 0;
  //偏移量
  @Track
  public circleOffsetX: number = 0;
  @Track
  public circleOffsetY: number = 0;
  //悬浮球左右两边倒角坐标
  @Track
  public chamferXY: [number, number] = [0, 0];
  //悬浮球两侧倒角半径
  @Track
  public chamferRadius: number;

  constructor(context: componentUtils.ComponentInfo, menuLength: number, chamferRadius: number = 30) {
    super({
      width: px2vp(context.size.width),
      height: px2vp(context.size.height),
      menuLength: menuLength
    });
    this.initCircleRadius();
    //设置倒角半径
    this.chamferRadius = chamferRadius;
    this.getChamferXY();
  }

  /**
   * 设置悬浮球直径
   */
  initCircleRadius(): void {
    this.circleDiameter = this.getMinWidth();
    // 获取半径
    this.circleRadius = this.circleDiameter / 2;

    this.circleOffsetX = this.circleRadius;
    // 悬浮球y轴偏移直径的三分之一
    this.circleOffsetY = this.circleDiameter / 3;
  }

  /**
   * 获取两边倒角中心位置
   */
  getChamferXY(): void {
    this.chamferXY = utilGetChamferXY(this.circleDiameter, this.chamferRadius);
  }
}