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

/**
 * 动效属性，提供了必需的动效属性，后续添加属性可通过继承该类实现
 *
 */
export class AnimationAttribute {
  // 背景条左边距，即：背景条左侧离tab组件左侧的距离
  public left: number = 0;
  // 背景条宽度
  public indicatorBarWidth: number = 0;
  // 背景条高度
  public indicatorBarHeight: number = 0;
}