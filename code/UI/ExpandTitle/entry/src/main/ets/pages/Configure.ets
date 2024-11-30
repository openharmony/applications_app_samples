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

export class Configure {
  // 标题栏常规高度
  public static readonly NORMAL_TITLE_HEIGHT: number = 80;
  // 标题栏扩展高度
  public static readonly EXPAND_TITLE_HEIGHT: number = 100;
  // 扩展后标题继续下拉阈值
  public static readonly CONTINUE_PULL_THRESHOLD: number = 90;
  // 动效时长
  public static readonly ANIMATION_DURATION: number = 120;
  // 标题缩放系数
  public static readonly TITLE_SCALE_MAX_VALUE: number = 1.2;
}