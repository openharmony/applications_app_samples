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

import { Device, InfDevice, Logger, ProtocolType, SubProtocolType } from '@ohos/common';
import { getImageFromDevice } from '../../util/CommonUtil';

const TAG: string = 'VirtualDevice';

/**
 * 虚拟设备，测试时使用
 */
export default class VirtualDevice implements InfDevice {
  public randomFlag: string;
  public device: Device;
  public imageResource: string | Resource;

  private constructor(randomFlag: string, device: Device) {
    this.randomFlag = randomFlag;
    this.device = device;
    this.imageResource = getImageFromDevice(device);
    Logger.debug(TAG, '查询到资源地址:' + this.imageResource);
  }

  getDeviceName(): string {
    return this.device.deviceName;
  }

  getImageResource(): string | Resource {
    return this.imageResource;
  }

  getLibDevice(): Device {
    return this.device;
  }

  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.virtual_sub;
  }

  getProtocolType(): ProtocolType {
    return ProtocolType.VIRTUAL;
  }


  getSignalStrength(): number {
    return Math.floor(Math.random() * -99) - 1;
  }

  getUnionCode(): string {
    return this.device.productId + this.randomFlag;
  }

  getProductID(): string {
    return this.device.productId;
  }

  getRandomFlag(): string {
    return this.randomFlag;
  }

  /**
   * 生成一个随机的虚拟设备
   * @returns
   */
  static generateVirtualDevice(device: Device): VirtualDevice {
    return new VirtualDevice(generateRandomFourDigitNumber().toString(), device);
  }
};


function generateRandomFourDigitNumber(): number {
  return Math.floor(1000 + Math.random() * 9000);
}