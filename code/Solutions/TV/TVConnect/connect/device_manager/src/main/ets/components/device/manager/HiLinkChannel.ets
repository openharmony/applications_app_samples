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
import {
  InfDevicesBusiness,
  InfDeviceState,
  SubProtocolType,
  InfControl,
  InfDeviceInfo,
  Logger,
  InfIpInfo
} from '@ohos/common';
import { ChannelInterface } from './ChannelInterface';
import DeviceManagerFactory from './DeviceManager';
import { ControlOption, QueryInfoOption, QueryOption } from './DeviceManagerInterface';

export default class HiLinkChannel implements ChannelInterface {
  getDevicesBusiness(protocolType?: SubProtocolType): InfDevicesBusiness | undefined {
    if (protocolType == undefined) {
      protocolType = SubProtocolType.iot_connect;
    }
    return DeviceManagerFactory.getDeviceManager().getDevicesBusiness(protocolType);
  }

  queryDeviceInfo(option: QueryInfoOption): Promise<InfDeviceInfo> {
    let business = this.getDevicesBusiness(option.protocolType);
    if (business == undefined) {
      return Promise.reject('DevicesBusiness is undefined');
    }
    return business.queryDeviceInfo();
  }

  queryIpInfo(option: QueryInfoOption): Promise<InfIpInfo> {
    let business = this.getDevicesBusiness(option.protocolType);
    if (business == undefined) {
      return Promise.reject('DevicesBusiness is undefined');
    }
    return business.queryIpInfo();
  }

  controlDevice(option: ControlOption): Promise<boolean> {
    Logger.info('HiLinkChannel controlDevice', `===>option ${JSON.stringify(option)}`);
    let business = this.getDevicesBusiness(option.protocolType);
    if (business == undefined) {
      return Promise.reject('DevicesBusiness is undefined');
    }
    let cmd = new DeviceControlCmd(option.serviceId, option.controlJson);
    return business.controlDevice(cmd);
  }

  queryDeviceState(option: QueryOption): Promise<InfDeviceState[]> {
    Logger.info('HiLinkChannel queryDeviceState', `===>option ${JSON.stringify(option)}`);
    let business = this.getDevicesBusiness(option.protocolType);
    if (business == undefined) {
      return Promise.reject('DevicesBusiness is undefined');
    }
    return business.queryDeviceState(option.sids);
  }

  queryDeviceAllServices(option: QueryOption): Promise<InfDeviceState[]> {
    let business = this.getDevicesBusiness(option.protocolType);
    if (business == undefined) {
      return Promise.reject('DevicesBusiness is undefined');
    }
    return business.queryDeviceAllServices();
  }
};

class DeviceControlCmd implements InfControl {
  public serviceId: string;
  public dataJson: string;

  constructor(serviceId: string, dataJson: string) {
    this.serviceId = serviceId;
    this.dataJson = dataJson;
  }

  getServiceId(): string {
    return this.serviceId;
  }

  getDataJson(): string {
    return this.dataJson;
  }
}