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

export class Constants {
  static readonly NODE_CONTAINER_ID = 'canvas'; // 组件NodeContainer的id
  static readonly INIT_LINE_STROKE_WIDTH: number = 40; // 画笔初始线宽
  static readonly DIVIDER_STROKE_WIDTH: number = 1; // 分割线宽度
  static readonly LAYOUT_WEIGHT: number = 1; // 组件自动分配剩余空间的layoutWeight值
  static readonly THRESHOLD: number = 30; // 线宽列表项扩大触摸热区的尺寸阈值
  // 组件id
  static readonly CONTAINER_ID: string = '__container__'; // 相对容器布局时父容器默认id
  static readonly TOP_BUTTON_LINE_ID: string = 'topButtonLine'; // 页面顶部按钮容器id
  static readonly BOTTOM_PEN_SHAPE_ID: string = 'bottomPenShape'; // 页面底部涂鸦组件id
}