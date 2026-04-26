/**
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

export enum PartsDeviceState {
  /**
   * 新设备
   */
  STATE_NEW = 0,
  /**
   * 待自动连接设备
   */
  STATE_CONNECTED = 1,

  /**
   * 已连接设备
   */
  STATE_CONNECTING = 2,
  /**
   * 不支持设备
   */
  STATE_NOT_SUPPORT = 3,
}
