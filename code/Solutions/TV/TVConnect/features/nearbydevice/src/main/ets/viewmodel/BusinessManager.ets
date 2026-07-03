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
 * 设备业务管理
 */
import {
  InfControl,
  InfDevice,
  InfDeviceInfo,
  InfDevicesBusiness,
  InfDevicesController,
  InfDeviceState,
  InfIpInfo
} from '@ohos/common';
import { DeviceManagerFactory } from '@ohos/device_manager';

import DeviceDiscoverManager from './DeviceDiscoverManager';

/**
 * 从已知已注册设备中，进行服务调用
 */
export default class BusinessManager {
  constructor() {
  }

  /**
   * 查询设备状态
   */
  queryDeviceState(device: InfDevice, sids: string[]): Promise<InfDeviceState[]> {
    const business: InfDevicesBusiness = this.findBusiness(device);
    return business.queryDeviceState(sids);
  }

  /**
   * 查询设备所有服务
   */
  queryDeviceAllServices(device: InfDevice): Promise<Array<InfDeviceState>> {
    const business: InfDevicesBusiness = this.findBusiness(device);
    return business.queryDeviceAllServices();
  }

  /**
   * 查询设备信息
   */
  queryDeviceInfo(device: InfDevice): Promise<InfDeviceInfo> {
    const business: InfDevicesBusiness = this.findBusiness(device);
    return business.queryDeviceInfo();
  }

  /**
   * 查询Ip信息
   */
  queryIpInfo(device: InfDevice): Promise<InfIpInfo> {
    const business: InfDevicesBusiness = this.findBusiness(device);
    return business.queryIpInfo();
  }

  /**
   * 控制设备信息
   */
  controlDevice(device: InfDevice, control: InfControl): Promise<boolean> {
    const business: InfDevicesBusiness = this.findBusiness(device);
    return business.controlDevice(control);
  }

  private findBusiness(device: InfDevice): InfDevicesBusiness {
    let business = DeviceManagerFactory.getDeviceManager().getDevicesBusiness(device.getSubProtocolType());
    if (!business) {
      throw Error('BusinessManager, cant find this InfDevicesBusiness with ' + device.getSubProtocolType());
    } else {
      return business;
    }
  }
};