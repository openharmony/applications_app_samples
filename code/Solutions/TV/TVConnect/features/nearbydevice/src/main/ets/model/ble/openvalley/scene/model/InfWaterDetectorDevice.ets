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
import { Device, getImageFromDevice, InfDevice, ProtocolType, SubProtocolType } from '@ohos/common/index';
import { DeviceType } from '@ohos/common';

export default class InfWaterDetectorDevice implements InfDevice {
  public signalStrength: number = 0;
  public macAddress: string = '';
  public productID: string = '';
  public randomFlag: string = '';
  public libDevice: Device = new Device();
  public imageResource: string | Resource = getImageFromDevice(new Device());
  ;

  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.wifi_open;
  }

  getProtocolType(): ProtocolType {
    return ProtocolType.WIFI;
  }

  getDesc(): Resource {
    throw new Error('Method not implemented.');
  }

  getDeviceType(): DeviceType {
    throw new Error('Method not implemented.');
  }

  getUnionCode(): string {
    throw new Error('Method not implemented.');
  }

  //获取信号强度
  getSignalStrength(): number {
    throw new Error('Method not implemented.');
  }

  getDeviceName(): string {
    return this.libDevice.deviceName;
  }

  getImageResource(): string | Resource {
    return this.imageResource;
  }

  getLibDevice(): Device {
    return new Device();
  }

  getProductID(): string {
    return this.productID;
  };

  getRandomFlag(): string {
    return this.randomFlag;
  };
};