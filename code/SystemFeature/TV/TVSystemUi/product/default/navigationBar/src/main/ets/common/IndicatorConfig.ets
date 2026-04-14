/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

export default class IndicatorStyle {
  /**
   * 圆点尺寸
   */
  public static readonly indicatorSize = '5.5vp';

  /**
   * 圆点圆角半径
   */
  public static readonly indicatorBorderRadius = '3vp';

  /**
   * 圆点距离顶部尺寸
   */
  public static readonly indicatorTopMargin = '3.5vp';

  /**
   * 圆点距离右侧尺寸
   */
  public static readonly indicatorRightMargin = '37.5vp';
}

/**
 * 颜色类型
 */
export class IndicatorType {
  /**
   * 默认不显示
   */
  public static readonly TYPE_NONE = 0;

  /**
   * 相机：橙色
   * 浅色：#ED6F21
   * 深色：#DB6B42
   */
  public static readonly TYPE_ORANGE = 1;

  /**
   * 麦克风：绿色
   * 浅色：#64BB5C
   * 深色：#5BA854
   */
  public static readonly TYPE_GREEN = 2;

  /**
   * 位置：蓝色
   * 浅色：#0A59F7
   * 深色：#317AF7
   */
  public static readonly TYPE_BLUE = 3;
}
