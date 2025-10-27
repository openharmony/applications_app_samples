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

// [Start liveform_Constants]
// entry/src/main/ets/common/Constants.ets
// 动效相关常量的开发
export class Constants {
  // 互动卡片动效超范围，左侧偏移百分比 = 偏移值/卡片宽度
  public static readonly OVERFLOW_LEFT_RATIO: number = 0.1;

  // 互动卡片动效超范围，上侧偏移百分比 = 偏移值/卡片高度
  public static readonly OVERFLOW_TOP_RATIO: number = 0.15;

  // 互动卡片动效超范围，宽度放大百分比
  public static readonly OVERFLOW_WIDTH_RATIO: number = 1.2;

  // 互动卡片动效超范围，高度放大百分比
  public static readonly OVERFLOW_HEIGHT_RATIO: number = 1.3;

  // 互动卡片动效超范围，动效时长
  public static readonly OVERFLOW_DURATION: number = 3500;
}
// [End liveform_Constants]