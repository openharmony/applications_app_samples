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
import { BaseInterface } from './BaseInterface';
import { CommonConstants } from '../common/CommonConstants';
import { SizeMode } from './SizeMode';

/**
 * 自定义背景条属性
 *
 */
export class IndicatorBarAttribute {
  // background模式背景条
  public static readonly BACKGROUNDBAR: IndicatorBarAttribute =
    new IndicatorBarAttribute(backgroundBar, SizeMode.Padding, 20, 10, 0, 1, VerticalAlign.Center);
  // thinstrip模式背景条
  public static readonly THINSTRIP: IndicatorBarAttribute =
    new IndicatorBarAttribute(thinStrip, SizeMode.Normal, 0, CommonConstants.THINSTRIP_INDICATOR_HEIGHT, 0, 1,
      VerticalAlign.Bottom);
  // 自定义背景条组件
  private innerIndicatorBar: (index: BaseInterface) => void;
  // 尺寸模式
  private innerSizeMode: SizeMode;
  // 1. 尺寸模式为正常模式，表示背景条宽度，值为0时与页签宽度保持一致
  // 2. 尺寸模式为内边距模式，表示背景条与页签项之间的左右边距
  private innerWidth: number;
  // 1. 尺寸模式为正常模式，表示背景条高度，值为0时与页签高度保持一致
  // 2. 尺寸模式为内边距模式，表示背景条与页签项之间的上下边距
  private innerHeight: number
  // 背景条最大偏移(<0: 无上限, >=0: innerMaxIndicatorBarLeft)
  private innerMaxIndicatorBarLeft: number;
  // 背景条宽度扩展比例
  private innerIndicatorExpand: number;
  // 背景条垂直布局
  private innerBarAlign: VerticalAlign;

  constructor(indicatorBar: (index: BaseInterface) => void, sizeMode: SizeMode = SizeMode.Normal,
    indicatorWidth: number = 0, indicatorHeight: number = 0, maxIndicatorBarLeft: number = -1,
    indicatorExpand: number = 1, barAlign: VerticalAlign = VerticalAlign.Center) {
    this.innerIndicatorBar = indicatorBar;
    this.innerSizeMode = sizeMode;
    this.innerWidth = indicatorWidth;
    this.innerHeight = indicatorHeight;
    this.innerBarAlign = barAlign;
    this.innerIndicatorExpand = indicatorExpand;
    this.innerMaxIndicatorBarLeft = maxIndicatorBarLeft;
  }

  get indicatorBar(): (index: BaseInterface) => void {
    return this.innerIndicatorBar;
  }

  set maxIndicatorBarLeft(left: number) {
    this.innerMaxIndicatorBarLeft = left;
  }

  get maxIndicatorBarLeft(): number {
    return this.innerMaxIndicatorBarLeft;
  }

  get barAlign(): VerticalAlign {
    return this.innerBarAlign;
  }

  get indicatorExpand(): number {
    return this.innerIndicatorExpand;
  }

  get sizeMode(): SizeMode {
    return this.innerSizeMode;
  }

  get indicatorWidth(): number {
    return this.innerWidth;
  }

  get indicatorHeight(): number {
    return this.innerHeight;
  }
}

@Builder
function backgroundBar($$: BaseInterface) {
  Column()
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor(CommonConstants.BACKGROUND_INDICATOR_COLOR)
    .borderRadius(CommonConstants.BACKGROUND_INDICATOR_BORDER_RADIUS)
}

@Builder
function thinStrip($$: BaseInterface) {
  Column()
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FORTY_PERCENT)
    .backgroundColor(CommonConstants.THINSTRIP_INDICATOR_COLOR)
    .borderRadius(CommonConstants.THINSTRIP_INDICATOR_BORDER_RADIUS)
}