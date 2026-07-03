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
import { Callback } from '@ohos.base';
import { InfDevice } from './InfDevice';
import { SubProtocolType } from './TypeEnum';

export declare interface InfDevicesDiscover {

  /**
   * 开始扫描
   * @param options
   * @param callback 扫描到匹配设备后回调，从广播中解析设备信息和从设备库中筛选出设备，都包含在扫描逻辑中
   */
  startScan(options: ScanOptions | null, callback: Callback<InfDevice>): void;

  stopScan(): void;

  isScanEnable(): boolean;
}


export interface ScanOptions {
  filterOption: SubProtocolType[];
}