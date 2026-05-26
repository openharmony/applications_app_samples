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
import { Device } from '@ohos/common/index';
import { getImageFromDevice, InfDevice, ProtocolType, SubProtocolType } from '@ohos/common/index';

export default class BleDevice implements InfDevice {
  public signalStrength: number;
  public macAddress: string;
  public productID: string = '';
  public randomFlag: string = '';
  public libDevice: Device;
  public imageResource: string | Resource;

  constructor(signalStrength: number,
    macAddress: string,
    randomFlag: string,
    device: Device) {
    this.signalStrength = signalStrength;
    this.macAddress = macAddress;
    this.randomFlag = randomFlag;
    this.libDevice = device;
    this.imageResource = getImageFromDevice(device);
  }

  getDeviceName(): string {
    return this.libDevice.deviceName;
  }

  getImageResource(): string | Resource {
    return this.imageResource;
  }

  getLibDevice(): Device {
    return this.libDevice;
  }

  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.ble_open;
  }


  getProtocolType(): ProtocolType {
    return ProtocolType.BLE;
  }

  getSignalStrength(): number {
    return this.signalStrength;
  }

  getUnionCode(): string {
    return this.productID + this.randomFlag;
  }

  getProductID(): string {
    return this.productID;
  };

  getRandomFlag(): string {
    return this.randomFlag;
  };
};