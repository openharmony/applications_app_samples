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
import { InfDeviceInfo, InfDeviceState, InfIpInfo } from '@ohos/common';
import { ControlOption, QueryInfoOption, QueryOption } from './DeviceManagerInterface';

export interface ChannelInterface {
  /**
   * 控制设备
   * @param option
   * @returns
   */
  controlDevice(option: ControlOption): Promise<boolean>;

  /**
   * 查询
   * @param option
   * @param sids
   * @returns
   */
  queryDeviceState(option: QueryOption): Promise<InfDeviceState[]>;

  /**
   * 查询
   * @param option
   * @param sids
   * @returns
   */
  queryDeviceAllServices(option: QueryOption): Promise<InfDeviceState[]>;

  /**
   * 查询设备信息
   * @param option
   * @param sids
   * @returns
   */
  queryDeviceInfo(option: QueryInfoOption): Promise<InfDeviceInfo>;

  queryIpInfo(option: QueryInfoOption): Promise<InfIpInfo>;
}