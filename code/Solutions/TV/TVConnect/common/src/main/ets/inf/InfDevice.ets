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
import { ProtocolType, SubProtocolType } from './TypeEnum';
import { CommonConstants } from '../constants/CommonConstants';
import { Device } from '../database/entity/Device';

/**
 * 包含具体的设备信息，还有在设备库中的设备信息
 */
export declare interface InfDevice {

  //唯一code，相同unionCode在界面上只会显示一个
  getUnionCode(): string;

  //获取信号强度
  getSignalStrength(): number;

  //获取设备名
  getDeviceName(): string;

  //获取缩略图片
  getImageResource(): Resource | string;

  //获取它在设备库中的数据模型
  getLibDevice(): Device | null;

  //获取ProductID
  getProductID(): string;

  //ProductID相同时，用于区分不同设备
  getRandomFlag(): string;

  /**
   * 返回连接协议，ble或者是wifi，对应InfDevicesController的getName()
   * @returns
   */
  getProtocolType(): ProtocolType;

  /**
   * 获取子协议类型
   * @returns
   */
  getSubProtocolType(): SubProtocolType;
}

export function getImageFromDevice(libDevice: Device): string | Resource {
  if (!libDevice.deviceIcons || libDevice.deviceIcons.length < 2 || isEmpty(libDevice.deviceIcons[1])) {
    return CommonConstants.DEFAULT_DEVICE_ICON;
  } else {
    return libDevice.deviceIcons[1];
  }
}

function isEmpty(str: string | undefined | null): boolean {
  return str === undefined || str === null || str.trim().length === 0;
}