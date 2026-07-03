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

export default class DragSceneConstants {
  /**
   * 变更角度
   */
  public static readonly MODIFY_ANGLE: number = 40;
  /**
   * 最大显示设备数量
   */
  public static readonly MAX_DEVICE_NUM: number = 16;
  /**
   * 设备控制区的大小
   */
  public static readonly DEVICE_CIRCULAR_SIZE: number = 230;
  /**
   * 设备之间最小间隔，单位px
   */
  public static readonly DEVICE_MIN_SPACE: Resource = $r('app.string.device_min_space');
  /**
   * 待连接设备背景尺寸
   */
  public static readonly DEVICE_ITEM_BG_SIZE: Resource = $r('app.string.vp_60');
  /**
   * 待连接设备图标尺寸
   */
  public static readonly DEVICE_ITEM_IC_SIZE: Resource = $r('app.string.device_item_ic_size');
  /**
   * 待连接设备间距
   */
  public static readonly DEVICE_ITEM_PADDING: Resource = $r('app.string.vp_5');
  /**
   * 待连接设备文本大小
   */
  public static readonly DEVICE_ITEM_NAME_SIZE: Resource = $r('app.string.device_item_name_size');
};