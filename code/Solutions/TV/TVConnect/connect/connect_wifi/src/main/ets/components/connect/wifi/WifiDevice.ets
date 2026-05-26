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
import { Device } from '@ohos/common';
import { getImageFromDevice, InfDevice, ProtocolType, SubProtocolType } from '@ohos/common/Index';


export default class WifiDevice implements InfDevice {
  public vendor: string;
  public category: string;
  public productID: string;
  public uid: string;
  public ssid: string;
  public rssi: number;
  public dataEncKey?: ArrayBuffer;
  public libDevice: Device;
  public imageResource: string | Resource;

  constructor(ssid: string, rssi: number, device: Device) {
    this.vendor = '';
    this.category = '';
    this.productID = '';
    this.uid = '';
    this.parserDeviceFromSsid(ssid);
    this.ssid = ssid;
    this.rssi = rssi;
    this.libDevice = device;
    this.imageResource = getImageFromDevice(device);
  }

  getDeviceName(): string {
    return this.libDevice.deviceName;
  }

  getLibDevice(): Device {
    return this.libDevice;
  }

  getImageResource(): string | Resource {
    return this.imageResource;
  }

  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.wifi_open;
  }

  getProtocolType(): ProtocolType {
    return ProtocolType.WIFI;
  }

  getUnionCode(): string {
    //假设设备名由厂商名+大类名+唯一标识组成
    return this.vendor + ' ' + this.category + ' ' + this.uid;
  }

  getProductID(): string {
    return this.productID;
  };

  getRandomFlag(): string {
    return this.uid;
  };

  //获取信号强度
  getSignalStrength(): number {
    return this.rssi;
  }

  parserDeviceFromSsid(ssid: string) {
    let part: string[] = ssid.split('-');
    this.vendor = part[0];
    this.category = part[1];
    let str = part[2];
    this.productID = str.substring(1, 6);
    this.uid = str.substring(6);
  }

  static getDeviceIdFromSsid(ssid: string) {
    let part: string[] = ssid.split('-');
    let str = part[2];
    return str.substring(1, 6);
  }
};