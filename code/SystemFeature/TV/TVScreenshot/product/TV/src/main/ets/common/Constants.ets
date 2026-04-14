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

/**
 * Constants 类集中管理整个应用中使用的字面量常量。
 * 业务背景：通过统一管理布局尺寸和业务逻辑间隔，确保应用在不同场景下表现一致。
 * 原理：采用静态常量属性，方便在工程各处通过类名直接访问，提升了代码的可维护性和重构效率。
 */
export default class Constants {
  // 定义布局相关的百分比宽度，确保 UI 容器能自适应父级空间。
  public static FULL_CONTAINER_WIDTH = '100%';
  public static FULL_CONTAINER_HEIGHT = '100%';
  
  // 截屏预览窗口的展示时长（毫秒）。
  // 这个数值经过人机交互平衡，既保证用户能看清截图，又不会长时间干扰主界面的操作。
  public static interval = 1600;
}
