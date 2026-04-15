/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Logger from '../utils/Logger';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

let PUBLISH_ID = Math.floor(Math.random() * (65535 + 1));

class BindTargetData {
  deviceId: string = '';
}

class DeviceNameChangeData {
  deviceName: string = '';
}

class DiscoverFailureData {
  reason: number = 0;
}

class DiscoverSuccessData {
  device: distributedDeviceManager.DeviceBasicInfo = {
    deviceId: '',
    deviceName: '',
    deviceType: '',
    networkId: ''
  };
}

class PublishInfoType {
  publishId: number = PUBLISH_ID;
  mode: 0x55 = 0x55;
  freq: number = 2;
  ranging: boolean = false;
}

interface PublishDeviceDiscoveryCapable extends distributedDeviceManager.DeviceManager {
  publishDeviceDiscovery?: (publishInfo: PublishInfoType) => void;
}

const bindParam: Record<string, string | number> = {
  'bindType': 1, // 认证类型： 1 - 无帐号PIN码认证
  'targetPkgName': 'com.samples.camera',
  'appName': 'CameraSample',
  'appOperation': 'appOperationsReason',
  'customDescription': 'customDescription'
};

const discoverParam: Record<string, number> = {
  'discoverTargetType': 1
};

const filterOptions: Record<string, number> = {
  'availableStatus': 0
};
const TAG = 'RemoteDeviceModel';

class RemoteDeviceModel {
  deviceManager?: distributedDeviceManager.DeviceManager;
  private publishInfoObj: PublishInfoType = {
    publishId: PUBLISH_ID,
    mode: 0x55,
    freq: 2,
    ranging: false
  }
  private static dmInstance: RemoteDeviceModel = new RemoteDeviceModel();
  private distributedDeviceManager?: distributedDeviceManager.DeviceManager;
  private unTrustDeviceList: distributedDeviceManager.DeviceBasicInfo[] = [];
  private trustDeviceList: distributedDeviceManager.DeviceBasicInfo[] = [];

  constructor() {
  }

  static getInstance(): RemoteDeviceModel {
    if (RemoteDeviceModel.dmInstance === undefined) {
      RemoteDeviceModel.dmInstance = new RemoteDeviceModel();
    }
    return RemoteDeviceModel.dmInstance;
  }

  createRemoteDeviceModel() {
    if (this.distributedDeviceManager === undefined) {
      try {
        this.distributedDeviceManager = distributedDeviceManager.createDeviceManager('com.samples.camera');
      } catch (e) {
        Logger.error(TAG, `createdistributedDeviceManager fail,${JSON.stringify(e)}`);
      }
    } else {
      return;
    }
  }

  async createDeviceManager(): Promise<void> {
    if (typeof (this.deviceManager) != 'undefined') {
      return;
    }
    this.deviceManager = await new Promise<distributedDeviceManager.DeviceManager>((resolve) => {
      resolve({} as distributedDeviceManager.DeviceManager);
    });
  }

  publishDeviceDiscovery(): void {
    let publishInfo = this.publishInfoObj;
    try {
      let publishManager = this.deviceManager as PublishDeviceDiscoveryCapable | undefined;
      publishManager?.publishDeviceDiscovery?.(publishInfo);
    } catch (error) {
      Logger.error(TAG, `publishDeviceDiscoveryfail,${JSON.stringify(error)}`);
    }
  }

  /**
   * deviceId是否在可信列表
   * @param deviceId
   * @returns
   */
  isDeviceIdInTrustList(deviceId: string) {
    return this.trustDeviceList.some(item => item.deviceId === deviceId);
  };

  isDeviceIdInUnTrustList(deviceId: string) {
    return this.unTrustDeviceList.some(item => item.deviceId === deviceId);
  };

  /**
   * 获取可信设备列表
   * 维护不可信设备列表（由于绑定方法只能由绑定端发起，被绑定方没有通知，所以维护不可信列表放在这里）
   * @returns distributedDeviceManager.DeviceBasicInfo[]
   */
  getAvailableDeviceList(): distributedDeviceManager.DeviceBasicInfo[] {
    let result: distributedDeviceManager.DeviceBasicInfo[] = [];
    try {
      if (this.distributedDeviceManager) {
        const deviceList = this.distributedDeviceManager.getAvailableDeviceListSync();
        this.trustDeviceList = deviceList;
        this.trustDeviceList.forEach((item) => {
          this.deleteDeviceIdInUnTrustList(item.deviceId);
        });
        result = this.trustDeviceList;
      }
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'getAvailableDeviceList errCode:' + e.code + ',errMessage:' + e.message);
    }
    return result;
  }

  /**
   * 获取不可信设备列表
   * @returns
   */
  getUnTrustDeviceList(): distributedDeviceManager.DeviceBasicInfo[] {
    return this.unTrustDeviceList;
  }

  /**
   * 从不可信列表中移除设备
   */
  deleteDeviceIdInUnTrustList(deviceId: string) {
    if (this.isDeviceIdInUnTrustList(deviceId)) {
      this.unTrustDeviceList = this.unTrustDeviceList.filter(item => item.deviceId !== deviceId);
    }
  }

  /**
   * 获取可信设备的networkId
   * @returns
   */
  getNetWorkId(): string {
    if (this.distributedDeviceManager) {
      let networkId = this.distributedDeviceManager.getAvailableDeviceListSync()[0]?.networkId || '';
      return networkId;
    }
    return '';
  }

  /**
   * 获取可信设备的deviceId
   * @returns
   */
  getDeviceId(): string {
    if (this.distributedDeviceManager) {
      let deviceId = this.distributedDeviceManager.getAvailableDeviceListSync()[0]?.deviceId || '';
      return deviceId;
    }
    return '';
  }

  /**
   * 开始发现设备
   */
  startDiscovering() {
    // 当有设备发现时，通过discoverSuccess回调通知给应用程序
    try {
      this.distributedDeviceManager?.startDiscovering(discoverParam, filterOptions);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'startDiscovering errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 注册发现设备成功回调监听
    try {
      this.distributedDeviceManager?.on('discoverSuccess', (data: DiscoverSuccessData) => {
        let tmp: distributedDeviceManager.DeviceBasicInfo = {
          deviceId: data.device.deviceId,
          deviceName: data.device.deviceName,
          deviceType: data.device.deviceType,
          networkId: data.device.networkId,
        }
        // 之前没有存过，且不是已认证设备才是需要认证的设备
        if (!this.isDeviceIdInUnTrustList(tmp.deviceId) && !this.isDeviceIdInTrustList(tmp.deviceId)) {
          this.unTrustDeviceList.push(tmp);
        }
        Logger.info(TAG, 'discoverSuccess:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'discoverSuccess errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 注册设备名称变更回调，以便在设备名称改变时通知应用程序
    try {
      this.distributedDeviceManager?.on('deviceNameChange', (data: DeviceNameChangeData) => {
        Logger.info(TAG, 'deviceNameChange on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'deviceNameChange errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 注册设备发现失败回调监听
    try {
      this.distributedDeviceManager?.on('discoverFailure', (data: DiscoverFailureData) => {
        Logger.info(TAG, 'discoverFailure on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'discoverFailure errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 注册设备管理服务死亡回调，以便在服务死亡时通知应用程序
    try {
      this.distributedDeviceManager?.on('serviceDie', () => {
        Logger.info(TAG, 'serviceDie on');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'serviceDie errCode:' + e.code + ',errMessage:' + e.message);
    }

  }

  /**
   * 停止发现设备
   */
  stopDiscovering() {
    try {
      this.distributedDeviceManager?.stopDiscovering();
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'stopDiscovering errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 取消注册发现设备成功回调监听
    try {
      this.distributedDeviceManager?.off('discoverSuccess', (data: DiscoverSuccessData) => {
        Logger.info(TAG, 'discoverSuccess:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'discoverSuccess errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 取消注册设备名称变更回调，以便在设备名称改变时通知应用程序
    try {
      this.distributedDeviceManager?.off('deviceNameChange', (data: DeviceNameChangeData) => {
        Logger.info(TAG, 'deviceNameChange on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'deviceNameChange errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 取消注册设备发现失败回调监听
    try {
      this.distributedDeviceManager?.off('discoverFailure', (data: DiscoverFailureData) => {
        Logger.info(TAG, 'discoverFailure on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'discoverFailure errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 取消注册设备管理服务死亡回调，以便在服务死亡时通知应用程序
    try {
      this.distributedDeviceManager?.off('serviceDie', () => {
        Logger.info(TAG, 'serviceDie on');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'serviceDie errCode:' + e.code + ',errMessage:' + e.message);
    }

  }

  /**
   * 绑定设备
   * @param deviceId 设备Id
   */
  bindTarget(deviceId: string) {
    try {
      this.distributedDeviceManager?.bindTarget(deviceId, bindParam,
        async (err: BusinessError, data: BindTargetData) => {
          if (err) {
            Logger.error(TAG, 'bindTarget errCode:' + err.code + ',errMessage:' + err.message);
            return;
          }
          Logger.info('bindTarget result:' + JSON.stringify(data));
        });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'bindTarget errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  /**
   * 解绑设备
   * @param deviceId
   */
  unbindTarget(deviceId: string) {
    try {
      this.distributedDeviceManager?.unbindTarget(deviceId);
      Logger.info(TAG, 'unBindTarget :' + deviceId);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'unbindTarget errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  /**
   * 资源释放
   */
  release() {
    // 释放实例
    try {
      if (this.distributedDeviceManager) {
        distributedDeviceManager.releaseDeviceManager(this.distributedDeviceManager);
        Logger.info(TAG, 'releasedistributedDeviceManager success');
      }
    } catch (e) {
      Logger.error(TAG, `releasedistributedDeviceManager fail,${JSON.stringify(e)}`);
    }
  }
}

export default RemoteDeviceModel.getInstance();
