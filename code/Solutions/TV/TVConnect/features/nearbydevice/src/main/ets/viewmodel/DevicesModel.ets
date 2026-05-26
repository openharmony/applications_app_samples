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
import { InfDevice, Logger, SubProtocolType, ProtocolType } from '@ohos/common';
import DragSceneConstants from '../constants/DragSceneConstants';
import PositionComputerUtil from '../util/PositionComputingUtil';
import { DeviceItemSource } from '../util/DataSource';
import DeviceItem from './DeviceItem';
import { ConnectState } from './DevicesManager';
import Point from './Point';


/**
 * 已发现和连接的设备ui状态
 */
@Observed
export default class DevicesModel {
  private maxDevicesNum: number = DragSceneConstants.MAX_DEVICE_NUM;
  public currentDevicesNum: number = 0;
  public devicesArray: DeviceItem[] = [];
  //已经添加的设备名，如果有重复的deviceName,加上RRRR(SSID后四位)
  public hasAddDeviceName: string[] = [];
  // 当前连接状态
  public currentConnectState: ConnectState = ConnectState.NOT_START;
  //待连接设备列表
  public toBeConnectDeviceList: DeviceItem[] = [];
  public toBeConnectDeviceByOrderSource: DeviceItemSource = new DeviceItemSource();
  //正在连接或者已连接设备
  public connectingDevice: DeviceItem | undefined;

  public reset(filter: boolean = false) {
    this.currentDevicesNum = 0;
    this.devicesArray = [];
    this.hasAddDeviceName = [];
    this.toBeConnectDeviceList = [];

    // 发现重置数组时，如果当前有设备处于连接状态，处于连接状态的设备需要加到设备数组中，并更新设备的状态
    if (filter && this.connectingDevice != undefined) {
      // 已连接设备的数组index 设置为0
      this.connectingDevice.index = DragSceneConstants.DEFAULT_INDEX;
      // 位置信息更新
      this.connectingDevice.point = this.genPointByIndex(DragSceneConstants.DEFAULT_INDEX);
      this.devicesArray.push(this.connectingDevice);
      this.currentDevicesNum = this.devicesArray.length;
      this.hasAddDeviceName.push(this.connectingDevice.name as string);
    }
  }

  /**
   * 重置当前的连接设备
   */
  public resetConnectingDevice() {
    this.connectingDevice = undefined;
  }

  /**
   * 修改当前连接状态
   * @param state
   */
  public changeConnectState(state: ConnectState) {
    this.currentConnectState = state;
  }

  public getConnectedDeviceIcon(): string | Resource {
    if (this.connectingDevice) {
      return this.connectingDevice.image;
    } else {
      return $r('app.media.ic_device');
    }
  }

  public isConnectedDeviceVirtual(): boolean {
    if (this.connectingDevice) {
      return this.connectingDevice.isVirtual;
    } else {
      return false;
    }
  }

  /**
   * 修改设备的连接状态
   * @param index
   * @param state
   */
  public changeDeviceConnectState(index: number, state: ConnectState) {
    if (index < 0) {
      return;
    }
    const item: DeviceItem = this.devicesArray[index];
    item.connectState = state;
    this.updateDeviceList();
  }

  /**
   * 更新设备列表
   */
  private updateDeviceList() {
    // 判断数据中是否有已连接设备
    let connectingDevice = this.devicesArray.find((item) => item.connectState != ConnectState.NOT_START);
    // 有则替换当前连接设备
    this.connectingDevice = connectingDevice ? connectingDevice : this.connectingDevice;
    if (!this.connectingDevice) {
      // 已连接设备为空时同步连接状态
      this.currentConnectState = ConnectState.NOT_START;
    }
    // 过滤已连接的设备
    this.toBeConnectDeviceList = this.devicesArray.filter((item) => item.connectState == ConnectState.NOT_START &&
      item.name !== this.connectingDevice?.name);
    this.orderDeviceList(this.toBeConnectDeviceList).forEach((item, index) => {
      Logger.info(`===>Debug item: ${JSON.stringify(item)}, index: ${index}`);
    });
    this.toBeConnectDeviceByOrderSource.setData(this.orderDeviceList(this.toBeConnectDeviceList));
  }

  /**
   * 排序
   */
  private orderDeviceList(deviceList: Array<DeviceItem>, isDesc: boolean = true): Array<DeviceItem> {
    let priorityMap: Map<ProtocolType, number> = this.getPriorityMap();
    let deviceListByOrder = deviceList.sort((a: DeviceItem, b: DeviceItem) => {
      // 先比较设备类型优先级： eth > ble/wifi/iot > unknown > virtual
      let aPriority = priorityMap.get(a.protocolType) as number;
      let bPriority = priorityMap.get(b.protocolType) as number;
      if (a.protocolType !== b.protocolType) {
        return aPriority - bPriority;
      }

      // 同设备类型比较信号强度
      if (isDesc) {
        return b.signalStrength - a.signalStrength;
      }
      return a.signalStrength - b.signalStrength;
    });
    return deviceListByOrder;
  }

  /**
   * 获取设备类型对应优先级的map
   * 数值越高优先级越低
   * @returns
   */
  private getPriorityMap(): Map<ProtocolType, number> {
    let priorityMap: Map<ProtocolType, number> = new Map();
    priorityMap.set(ProtocolType.ETHERNET, 0);
    priorityMap.set(ProtocolType.WIFI, 1);
    priorityMap.set(ProtocolType.BLE, 1);
    priorityMap.set(ProtocolType.UNKNOWN, 2);
    priorityMap.set(ProtocolType.VIRTUAL, 3);
    return priorityMap;
  }

  /**
   * 当发现可连接设备时，添加待连接设备
   * @param device
   */
  public addDevice(device: InfDevice): boolean {
    if (this.currentDevicesNum >= this.maxDevicesNum) {
      Logger.debug('===>has added the max number devices');
      return false;
    }
    Logger.debug('===>pre add device');

    let index: number = this.currentDevicesNum;
    let item: DeviceItem = this.transform(index, device);
    item.point = this.genPointByIndex(index);
    Logger.debug('===>generate point:dx=' + item.point.x + ',dy=' + item.point.y);
    this.devicesArray.push(item);
    this.updateDeviceList(); // 更新设备列表

    this.currentDevicesNum = this.devicesArray.length;
    Logger.debug('devices length = ' + this.devicesArray.length);
    return true;
  }

  public transform(index: number, device: InfDevice): DeviceItem {
    let deviceName: string;
    if (!this.hasRepeatedName(device.getDeviceName())) {
      deviceName = device.getDeviceName() || device.getUnionCode();
    } else {
      deviceName = `${device.getDeviceName()}-${device.getRandomFlag()}`;
    }
    return new DeviceItem(index, device.getImageResource(), deviceName,
      device.getSubProtocolType() == SubProtocolType.virtual_sub, device.getSignalStrength(), device.getProtocolType());
  }

  private hasRepeatedName(deviceName: string): boolean {
    if (this.hasAddDeviceName.indexOf(deviceName) == -1) {
      this.hasAddDeviceName.push(deviceName);
      return false;
    }
    return true;
  }

  /**
   * 根据拖拽初始参数生成偏移度
   * @param index
   */
  public genPointByIndex(index: number): Point {
    return PositionComputerUtil.getInstance().getPointByIndex(index);
  }
}