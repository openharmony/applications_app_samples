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
import { Logger } from '@ohos/common';
import Point from '../../../../../viewmodel/Point';
import { ControllerInformation } from '../../model/req/ControllerDevReq';


/**
 * 隧道场景的数据
 */

const TAG = 'TunnelSceneModel';

@Observed
export default class TunnelSceneModel {
  /**
   * 已发现设备
   */
  public discoverDevices: Array<TunnelDevice> = [];
  //当前设备数
  public currentDevicesNum: number = 0;
  //感知设备坑位
  public sensingDeviceSlots: Array<TunnelSlot> = [new TunnelSlot(TunnelDeviceType.Sensing)];
  //控制设备坑位
  public controlDeviceSlots: Array<TunnelSlot> =
    [new TunnelSlot(TunnelDeviceType.WindMachine), new TunnelSlot(TunnelDeviceType.Light),
      new TunnelSlot(TunnelDeviceType.Siren)];
  //正在拖拽的设备的类型
  public currentDraggingDeviceType: TunnelDeviceType | undefined;
  //正在拖拽的设备的unionCode
  public currentDraggingDevice: TunnelDevice | undefined;
  //所有的设备是否都填充完成
  public isFillComplete: boolean = false;
  //是否已执行场景
  public isSetFinish: boolean = false;

  reset() {
    this.discoverDevices.length = 0;
    this.currentDraggingDeviceType = undefined;
    this.currentDraggingDevice = undefined;
    this.currentDevicesNum = 0;
  }

  /**
   * 检查slot填充状态
   */
  checkFillState() {
    const unset = this.controlDeviceSlots.find((slot: TunnelSlot) => !slot.hasInset());
    const unsetSensing = this.sensingDeviceSlots.find((slot: TunnelSlot) => !slot.hasInset());
    this.isFillComplete = !unset && !unsetSensing;
  }

  /**
   * 添加设备
   * @param device
   */
  addDevice(device: TunnelDevice) {
    if (this.hasAdded(device)) {
      return;
    }
    Logger.debug(TAG, '添加设备：' + JSON.stringify(device));
    this.discoverDevices.push(device);
    this.currentDevicesNum = this.discoverDevices.length;
  }

  /**
   * 每种类型的设备，也只准添加一次
   * @param device
   * @returns
   */
  hasAdded(device: TunnelDevice): boolean {
    const duplicateType = this.discoverDevices.find((infDevice) => infDevice.type == device.type);
    if (duplicateType && device.snList) {
      duplicateType.addSn(device.snList[0]);
      if (device.point.hasAllotted) {
        device.point.hasAllotted = false;
      }
      return true;
    }
    const duplicateUnionCode =
      this.discoverDevices.find((infDevice) => infDevice.getUnionCode() == device.getUnionCode());
    return duplicateUnionCode != undefined;
  }
}

@Observed
export class TunnelDevice {
  public unionCode: string;
  public desc: string | Resource;
  public type: TunnelDeviceType;
  public isInset: boolean = false;
  public isDragging: boolean = false;
  public image: Resource;
  public point: Point;
  //一个设备，可能关联多个sn号
  public snList: Array<string>;

  getUnionCode(): string {
    return this.unionCode;
  }

  constructor(unionCode: string, desc: string | Resource, type: TunnelDeviceType, point: Point, snList: Array<string>) {
    this.unionCode = unionCode;
    this.desc = desc;
    this.type = type;
    this.image = getTunnelDeviceImage(type);
    this.point = point;
    this.snList = snList;
  }

  addSn(sn: string) {
    if (this.snList) {
      this.snList.push(sn);
    }
  }
}

@Observed
export class TunnelSlot {
  public type: TunnelDeviceType;
  public device: TunnelDevice | undefined;

  constructor(type: TunnelDeviceType) {
    this.type = type;
  }

  hasInset(): boolean {
    return this.device != undefined && this.device.isInset;
  }

  setDevice(device: TunnelDevice) {
    if (this.device != null) {
      this.device.isInset = false;
    }
    this.device = device;
    this.device.isInset = true;
  }
}


export enum TunnelDeviceType {
  Sensing, //传感器
  WindMachine, //风机
  Light, //隧道灯
  Siren, //报警器
  Unknown, //未知
}

export function getTypeByIndex(index: number): TunnelDeviceType {
  if (index < 0) {
    index = 0;
  }
  index = index % 4;
  switch (index) {
    case 0:
      return TunnelDeviceType.Sensing;
    case 1:
      return TunnelDeviceType.WindMachine;
    case 2:
      return TunnelDeviceType.Light;
    case 3:
    default:
      return TunnelDeviceType.Siren;
  }
}


export function getTunnelDeviceName(type: TunnelDeviceType): Resource {
  switch (type) {
    case TunnelDeviceType.Sensing:
      return $r('app.string.tunnel_device_sensing');
    case TunnelDeviceType.WindMachine:
      return $r('app.string.tunnel_device_wind_machine');
    case TunnelDeviceType.Light:
      return $r('app.string.tunnel_device_light');
    case TunnelDeviceType.Siren:
    case TunnelDeviceType.Unknown:
      return $r('app.string.tunnel_device_siren');
  }
}

export function getTunnelDeviceImage(type: TunnelDeviceType): Resource {
  switch (type) {
    case TunnelDeviceType.Sensing:
      return $r('app.media.svg_tunnel_sensing');
    case TunnelDeviceType.WindMachine:
      return $r('app.media.svg_tunnel_wind');
    case TunnelDeviceType.Light:
      return $r('app.media.svg_tunnel_light');
    case TunnelDeviceType.Siren:
    case TunnelDeviceType.Unknown:
      return $r('app.media.svg_tunnel_siren');
  }
}

/**
 * 判断是否是感知设备
 * @param type
 * @returns
 */
export function isSensing(type: TunnelDeviceType): boolean {
  return type == TunnelDeviceType.Sensing;
}

export function getTunnelDeviceTypeByType(typeName: string): TunnelDeviceType {
  switch (typeName) {
    case 'lamp': //隧道灯
      return TunnelDeviceType.Light;
    case 'fan': //风机
      return TunnelDeviceType.WindMachine;
    case 'alarmLight': //报警灯
      return TunnelDeviceType.Siren;
  }
  return TunnelDeviceType.Unknown;
}

export function getControlInformation(isON: boolean, type: TunnelDeviceType): ControllerInformation {
  return new ControllerInformation(isON ? '1' : '0');
}
