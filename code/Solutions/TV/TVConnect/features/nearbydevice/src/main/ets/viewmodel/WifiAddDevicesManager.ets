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

import { InfDevice, Logger, SubProtocolType } from '@ohos/common';
import DragSceneConstants from '../constants/DragSceneConstants';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { ConnectChangeAction, DeviceManagerFactory, QueryInfoOption } from '@ohos/device_manager';
import ScanModel, { ScanState } from './ScanModel';
import { ListDataSource } from '../util/ListDataSource';
import { AddDeviceItem } from './AddDeviceItem';
import IotDevice from '@ohos/connect_iot/src/main/ets/components/connect/iot/IotDevice';
import { preferences } from '@kit.ArkData';
import PreferenceModel from './PreferenceModel';
import { IpDeviceInfo } from './IpDeviceModel';

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

const TAG = 'WifiAddDevicesManager';

/**
 * 已发现设备和连接状态管理
 */
export class WifiAddDevicesManager {
  constructor() {
    DeviceManagerFactory.getDeviceManager()
      .registerConnectStateChanged('WifiScanDeviceChange', (data: ConnectChangeAction) => {
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

  // 已发现设备
  private devices: IotDevice[] = [];
  public showDevices: ListDataSource<AddDeviceItem> = new ListDataSource();
  // 正在连接的设备
  private currentConnectDevice: InfDevice | undefined;
  //当前连接设备的index
  private currentConnectIndex: number = -1;
  public scanModel: ScanModel = new ScanModel();
  private ssidMsg: Map<string, string> = new Map();
  public showSavedDevices: ListDataSource<IpDeviceInfo> = new ListDataSource();

  private resetConnectingDevice() {
    this.currentConnectDevice = undefined;
    this.currentConnectIndex = -1;
  }

  private setDisconnectState() {
    this.resetConnectingDevice();
  }

  async updateDeviceList() {
    let savedList = await PreferenceModel.getInstance().getAllIpDevices();
    Logger.debug(`WifiAddDevicesManager,'updateDeviceList===>updateDeviceList savedList: ${JSON.stringify(savedList)}`);
    const savedUdids = new Set<string>(savedList.map(item => item.udid));
    // 过滤设备
    Logger.debug(TAG, `updateDeviceList===>savedUdids = ${JSON.stringify(savedUdids)}`);
    const unsavedDevicesList = this.devices.filter(device => !savedUdids.has(device.getUnionCode()));
    Logger.debug(TAG, `updateDeviceList===>unsavedDevicesList = ${JSON.stringify(unsavedDevicesList)}`);
    this.showDevices.refreshData(unsavedDevicesList);
  }

  //开始扫描
  startScan(callback: Callback<InfDevice> | null = null) {
    Logger.debug(TAG, '===>WifiAddDevicesManager.ets', `startScan start`);
    this.stopScan();
    this.devices = [];
    this.showDevices.clearData();
    this.scanModel.currentScanState = ScanState.SCANNING;
    this.scanModel.startScan(DragSceneConstants.SCAN_TIME_OUT);
    DeviceManagerFactory.getDeviceManager()
      .startDeviceDiscover({
        filterOption: [SubProtocolType.virtual_sub]
      }, (_error, device: InfDevice) => {
        Logger.debug(TAG, '===>WifiAddDevicesManager.ets startDeviceDiscover callback ' + device.getUnionCode());
        Logger.debug(TAG, 'add device:' + device.getUnionCode());
        if (callback != null) {
          callback(device);
        }
        this.addDevice(device as AddDeviceItem);
      });
    setTimeout(() => {
      this.stopScan();
    }, DragSceneConstants.SCAN_TIME_OUT);
  }

  stopScan() {
    this.scanModel.currentScanState = ScanState.SCANNING_FINISH;
    DeviceManagerFactory.getDeviceManager().stopDeviceDiscovery();
  }

  addDevice(device: AddDeviceItem) {
    Logger.debug(TAG, `===>add device = ${JSON.stringify(device)}`);
    Logger.debug(TAG, `===>this.devices = ${JSON.stringify(this.devices)}`);
    if (!this.hasAdded(device)) {
      Logger.debug(TAG, `===>addDevice = ${JSON.stringify(device)}`);
      let data = this.transform(device);
      this.devices.push(device);
      this.showDevices.pushData(data);
      this.updateDeviceList(); // 更新设备列表
    } else {
      Logger.debug(TAG, '===>this device has added，device json = ' + JSON.stringify(device));
      this.updateDeviceList();
    }
  }

  public transform(device: AddDeviceItem): AddDeviceItem {
    let deviceName: string;
    if (!this.hasRepeatedName(device.getDeviceName())) {
      deviceName = device.getDeviceName() || device.getUnionCode();
    } else {
      deviceName = `${device.getDeviceName()}-${device.getRandomFlag()}`;
    }
    device.deviceName = deviceName;
    return device;
  }

  private hasRepeatedName(deviceName: string): boolean {
    if (this.devices.findIndex(item => item.getDeviceName() == deviceName) == -1) {
      return false;
    }
    return true;
  }

  hasAdded(device: IotDevice): boolean {
    const result = this.devices.find((infDevice) => infDevice.getUnionCode() == device.getUnionCode());
    return result != undefined;
  }

  /**
   * 连接设备
   * @param index
   */
  connect(unionCode: string, callback: Callback<ConnectType>) {
    let findIndex = this.devices.findIndex(item => (item.getUnionCode() == unionCode));
    if (findIndex < 0) {
      return;
    }
    const device = this.devices[findIndex];
    DeviceManagerFactory.getDeviceManager().connectDevice(device, (error, type) => {
      Logger.debug('WifiAddDeviceManager',
        `===>connectDevice callback${JSON.stringify(error)}, type = ${JSON.stringify(type)}`);
      if (error) {
        callback(ConnectType.DISCONNECT);
        this.connectFailed();
        return;
      }
      if (type == ConnectType.ONLINE) {
        callback(ConnectType.ONLINE);
      } else if (type == ConnectType.CONNECTING) {
        callback(ConnectType.CONNECTING);
        this.currentConnectDevice = this.devices[findIndex];
        this.currentConnectIndex = findIndex;
      } else if (type == ConnectType.OFFLINE) {
        callback(ConnectType.DISCONNECT);
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

  setSsidMsg(ssidKey: string, ssidValue: string) {
    this.ssidMsg.set(ssidKey, ssidValue);
  }

  configureNetwork(data: Record<string, string>): Promise<boolean> {
    return DeviceManagerFactory.getDeviceManager().configureNetwork(data);
  }

  queryDeviceSn(): Promise<string> {
    return new Promise(async (resolve, reject) => {
      if (this.currentConnectDevice == undefined) {
        reject(new Error('device not connect'));
        return;
      }
      let queryOption: QueryInfoOption = {
        unionCode: this.currentConnectDevice.getUnionCode(),
        deviceId: '',
        productId: this.currentConnectDevice.getProductID(),
        protocolType: this.currentConnectDevice.getSubProtocolType(),
      };
      try {
        let info = await DeviceManagerFactory.getDeviceManager().queryDeviceInfo(queryOption);
        Logger.debug('===>queryDeviceSn', `queryDeviceInfo info = ${JSON.stringify(info)}`);
        resolve(info.deviceInfo['sn']);
      } catch (error) {
        reject(error);
      }
    });
  }

  queryDeviceIp(): Promise<string> {
    return new Promise(async (resolve, reject) => {
      if (this.currentConnectDevice == undefined) {
        reject(new Error('device not connect'));
        return;
      }
      let queryOption: QueryInfoOption = {
        unionCode: this.currentConnectDevice.getUnionCode(),
        deviceId: '',
        productId: this.currentConnectDevice.getProductID(),
        protocolType: this.currentConnectDevice.getSubProtocolType(),
      };
      try {
        let info = await DeviceManagerFactory.getDeviceManager().queryIpInfo(queryOption);
        Logger.debug('===>WifiAddDeviceManager', `queryDeviceIp info = ${JSON.stringify(info)}`);
        resolve(info.ipInfo['getIp']);
      } catch (error) {
        reject(error);
      }
    });

  }
}