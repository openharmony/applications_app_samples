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
import { InfDevice, Logger } from '@ohos/common';
import DevicesModel from './DevicesModel';
import DragSceneConstants from '../constants/DragSceneConstants';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { ConnectChangeAction, DeviceManagerFactory } from '@ohos/device_manager';

/**
 * 连接状态
 */
export enum ConnectState {
  //连接中
  CONNECTING,
  //未开始
  NOT_START,
  //连接成功
  CONNECT_SUCCESS,
  //连接失败
  CONNECT_FAILED
}

/**
 * 已发现设备和连接状态管理
 */
export default class DevicesManager {
  private static instance: DevicesManager = new DevicesManager();

  private constructor() {
    DeviceManagerFactory.getDeviceManager()
      .registerConnectStateChanged('NearbyDeviceManager', (data: ConnectChangeAction) => {
        let index = this.devices.findIndex((item) => item.getUnionCode() == data.unionCode);
        if (data.action == ConnectType.DISCONNECT) {
          if (index >= 0) {
            this.setDisconnectState();
          }
        } else if (data.action == ConnectType.OFFLINE) {
          // 离线做断连处理
          if (index >= 0) {
            this.setDisconnectState();
          }
        }
      });
  }

  static getInstance(): DevicesManager {
    return DevicesManager.instance;
  }

  //设备UI状态数据
  private devicesModel: DevicesModel = new DevicesModel();
  //已发现设备
  private devices: InfDevice[] = [];
  //正在连接的设备
  private currentConnectDevice: InfDevice | undefined;
  //当前连接设备的index
  private currentConnectIndex: number = -1;

  private resetConnectingDevice() {
    this.currentConnectDevice = undefined;
    this.currentConnectIndex = -1;
  }

  private setDisconnectState() {
    let index = this.currentConnectIndex;
    this.resetConnectingDevice();
    this.devicesModel.resetConnectingDevice();
    this.devicesModel.changeConnectState(ConnectState.NOT_START);
    this.devicesModel.changeDeviceConnectState(index, ConnectState.NOT_START);
  }

  getDeviceModel(): DevicesModel {
    this.reset();
    this.devicesModel = new DevicesModel();
    return this.devicesModel;
  }

  addDevice(device: InfDevice) {
    if (this.devices.length >= DragSceneConstants.MAX_DEVICE_NUM) {
      Logger.debug('===>has added max num devices');
      return;
    }
    if (!this.hasAdded(device)) {
      this.devicesModel!.addDevice(device);
      this.devices.push(device);
    } else {
      Logger.debug('===>this device has added，device json = ' + JSON.stringify(device));
    }
  }

  hasAdded(device: InfDevice): boolean {
    const result = this.devices.find((infDevice) => infDevice.getUnionCode() == device.getUnionCode());
    return result != undefined;
  }

  reset(filter: boolean = false) {
    this.devicesModel.reset(filter);
    this.devices = [];

    // 发现重置数组时，如果当前有设备处于连接状态，处于连接状态的设备需要加到设备数组中
    if (filter && this.currentConnectDevice != undefined) {
      this.devices.push(this.currentConnectDevice);
      this.currentConnectIndex = DragSceneConstants.DEFAULT_INDEX;
    }
  }

  /**
   * 连接设备
   * @param index
   */
  connect(index: number) {
    const device: InfDevice = this.devices[index];
    DeviceManagerFactory.getDeviceManager().connectDevice(device, (error, type) => {
      if (error != undefined) {
        Logger.error('DevicesManager', `connect error ${error?.message}`);
        this.connectFailed();
        return;
      }
      if (type == ConnectType.CONNECTING) {
        this.currentConnectDevice = device;
        this.currentConnectIndex = index;
        this.devicesModel.changeDeviceConnectState(index, ConnectState.CONNECTING);
        this.devicesModel.changeConnectState(ConnectState.CONNECTING);
      } else if (type == ConnectType.ONLINE) {
        this.devicesModel.changeConnectState(ConnectState.CONNECT_SUCCESS);
        this.devicesModel.changeDeviceConnectState(this.currentConnectIndex, ConnectState.CONNECT_SUCCESS);
      }
    });
  }

  connectFailed() {
    this.setDisconnectState();
  }

  getConnectingDevice(): InfDevice | undefined {
    return this.currentConnectDevice;
  }

  disconnect() {
    if (this.currentConnectDevice == undefined) {
      return;
    }
    DeviceManagerFactory.getDeviceManager().disconnect();
    this.setDisconnectState();
  }
};