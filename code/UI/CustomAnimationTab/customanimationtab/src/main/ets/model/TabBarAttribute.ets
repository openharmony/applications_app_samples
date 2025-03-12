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
import { CommonConstants } from '../common/CommonConstants';

/**
 * 自定义页签条属性
 *
 */
export class TabBarAttribute {
  // 页签项宽度
  private innerBarItemWidth: Length | undefined;
  // 页签条边缘滑动效果
  private innerBarEdgeEffect: EdgeEffect;
  // 页签条高度
  private innerBarHeight: Length | undefined;
  // 是否可以滚动页签条(false则所有页签均分屏幕宽度)
  private innerScrollable: boolean;
  // 页签条位置
  private innerBarVertical: BarPosition;
  // 页签条边距
  private innerBarMargin: Margin | undefined;
  // 页签条背景颜色
  private innerBarBackgroundColor: ResourceColor;

  constructor(barItemWidth: Length | undefined = undefined, barHeight: Length | undefined = undefined,
    scrollable: boolean = true, barEdgeEffect: EdgeEffect = EdgeEffect.Spring,
    barVertical: BarPosition = BarPosition.Start,
    barMargin: Margin | undefined = undefined, barBackgroundColor: ResourceColor = Color.Transparent) {
    this.innerBarItemWidth = barItemWidth;
    this.innerBarHeight = barHeight;
    this.innerScrollable = scrollable;
    this.innerBarEdgeEffect = barEdgeEffect;
    this.innerBarVertical = barVertical;
    this.innerBarBackgroundColor = barBackgroundColor;
    this.innerBarMargin = barMargin;
  }

  get barItemWidth(): Length | undefined {
    return this.innerBarItemWidth;
  }

  get barHeight(): Length | undefined {
    return this.innerBarHeight;
  }

  get scrollable(): boolean {
    return this.innerScrollable;
  }

  get barEdgeEffect(): EdgeEffect {
    return this.innerBarEdgeEffect;
  }

  get barVertical(): BarPosition {
    return this.innerBarVertical;
  }

  get barBackgroundColor(): ResourceColor {
    return this.innerBarBackgroundColor;
  }

  get barMargin(): Margin | undefined {
    return this.innerBarMargin;
  }
}