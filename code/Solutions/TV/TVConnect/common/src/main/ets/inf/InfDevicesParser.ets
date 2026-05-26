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
import { InfBroadcastData } from './InfBroadcastData';
import { InfDevice } from './InfDevice';

export declare interface InfDevicesParser {

  /**
   * 从设备库筛选设备
   * @param device
   * @returns
   */
  filterFromLibrary(device: InfDevice): boolean;

  /**
   * 从广播数据中，解析出设备信息
   * @param object
   * @returns 解析成功：InfBroadcastData，解析失败返回null
   */
  parserFromBroadcast(data: ArrayBuffer): InfBroadcastData | null;
}