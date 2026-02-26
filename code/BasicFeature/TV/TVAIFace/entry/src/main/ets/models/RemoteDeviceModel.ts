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

import { distributedDeviceManager as deviceManager } from '@kit.DistributedServiceKit';
import { BusinessError } from '@ohos.base';
import { Logger } from '../utils/log';

class BindTargetData {
  public deviceId: string = '';
}

class DeviceNameChangeData {
  public deviceName: string = '';
}

class DiscoverFailureData {
  public reason: number = 0;
}

class discoverSuccessData {
  device: deviceManager.DeviceBasicInfo = {
    deviceId: '',
    deviceName: '',
    deviceType: '',
    networkId: ''
  };
}

const bindParam: Record<string, string | number> = {
  'bindType': 1, // 认证类型： 1 - 无帐号PIN码认证
  'targetPkgName': 'com.ohos.aiface',
  'appName': 'applications_ai_face',
  'appOperation': 'appOperationsReason',
  'customDescription': 'customDescription'
};

const discoverParam: Record<string, number> = {
  'discoverTargetType': 1
};

const filterOptions: Record<string, number> = {
  'availableStatus': 0
};
const TAG: string = 'RemoteDeviceModel';

/**
 * 用到的api
 * @ohos.distributedDeviceManager
* 注册和解除注册设备上下线变化监听
 * 发现周边不可信设备
 * 认证和取消认证设备
 * 查询可信设备列表
 *
 * 单例模式
 */
class RemoteDeviceModel {
  private static dmInstance: RemoteDeviceModel = new RemoteDeviceModel();
  private deviceManager: deviceManager.DeviceManager;
  private unTrustDeviceList: Array<deviceManager.DeviceBasicInfo> = [];
  private trustDeviceList: Array<deviceManager.DeviceBasicInfo> = [];

  constructor() {
  }

  static getInstance(): RemoteDeviceModel {
    if (RemoteDeviceModel.dmInstance === undefined) {
      RemoteDeviceModel.dmInstance = new RemoteDeviceModel();
    }
    return RemoteDeviceModel.dmInstance;
  }

  createRemoteDeviceModel() {
    if (this.deviceManager === undefined) {
      try {
        this.deviceManager = deviceManager.createDeviceManager("com.ohos.aiface");
        Logger.info(TAG, 'createDeviceManager success');
      } catch (e) {
        Logger.err(TAG, `createDeviceManager fail,${JSON.stringify(e)}`);
      }
    } else {
      return;
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

  /**
   * deviceId是否在不可信列表
   * @param deviceId
   * @returns
   */
  isDeviceIdInUnTrustList(deviceId: string) {
    return this.unTrustDeviceList.some(item => item.deviceId === deviceId);
  };

  /**
   * 获取可信设备列表
   * 维护不可信设备列表（由于绑定方法只能由绑定端发起，被绑定方没有通知，所以维护不可信列表放在这里）
   * @returns
   */
  getAvailableDeviceList(): Array<deviceManager.DeviceBasicInfo> {
    try {
      this.trustDeviceList = this.deviceManager.getAvailableDeviceListSync();
      this.trustDeviceList.forEach(item => this.deleteDeviceIdInUnTrustList(item.deviceId));
      return this.trustDeviceList;
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, "getAvailableDeviceList errCode:" + e.code + ",errMessage:" + e.message);
    }
  }

  /**
   * 获取不可信设备列表
   * @returns
   */
  getUnTrustDeviceList(): Array<deviceManager.DeviceBasicInfo> {
    // Logger.info(TAG,'getUnTrustDeviceList: ' + JSON.stringify(this.unTrustDeviceList));
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
   * 开始发现设备
   */
  startDiscovering() {
    // 当有设备发现时，通过discoverSuccess回调通知给应用程序
    try {
      this.deviceManager.startDiscovering(discoverParam, filterOptions);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, "startDiscovering errCode:" + e.code + ",errMessage:" + e.message);
    }

    // 注册发现设备成功回调监听
    try {
      this.deviceManager.on('discoverSuccess', (data: discoverSuccessData) => {
        let tmp: deviceManager.DeviceBasicInfo = {
          deviceId: data.device.deviceId,
          deviceName: data.device.deviceName,
          deviceType: data.device.deviceType,
          networkId: data.device.networkId,
        };
        // 之前没有存过，且不是已认证设备才是需要认证的设备
        if (!this.isDeviceIdInUnTrustList(tmp.deviceId) && !this.isDeviceIdInTrustList(tmp.deviceId)) {
          this.unTrustDeviceList.push(tmp);
        }
        Logger.info(TAG, "discoverSuccess:" + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, "discoverSuccess errCode:" + e.code + ",errMessage:" + e.message);
    }

    // 注册设备名称变更回调，以便在设备名称改变时通知应用程序
    try {
      this.deviceManager.on('deviceNameChange', (data: DeviceNameChangeData) => {
        Logger.info(TAG, 'deviceNameChange on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'deviceNameChange errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 注册设备发现失败回调监听
    try {
      this.deviceManager.on('discoverFailure', (data: DiscoverFailureData) => {
        Logger.info(TAG, 'discoverFailure on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'discoverFailure errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 注册设备管理服务死亡回调，以便在服务死亡时通知应用程序
    try {
      this.deviceManager.on('serviceDie', () => {
        Logger.info(TAG, 'serviceDie on');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'serviceDie errCode:' + e.code + ',errMessage:' + e.message);
    }

  }

  /**
   * 停止发现设备
   */
  stopDiscovering() {
    try {
      this.deviceManager.stopDiscovering();
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, "stopDiscovering errCode:" + e.code + ",errMessage:" + e.message);
    }

    // 取消注册发现设备成功回调监听
    try {
      this.deviceManager.off('discoverSuccess', (data: discoverSuccessData) => {
        Logger.info(TAG, "discoverSuccess:" + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, "discoverSuccess errCode:" + e.code + ",errMessage:" + e.message);
    }

    // 取消注册设备名称变更回调，以便在设备名称改变时通知应用程序
    try {
      this.deviceManager.off('deviceNameChange', (data: DeviceNameChangeData) => {
        Logger.info(TAG, 'deviceNameChange on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'deviceNameChange errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 取消注册设备发现失败回调监听
    try {
      this.deviceManager.off('discoverFailure', (data: DiscoverFailureData) => {
        Logger.info(TAG, 'discoverFailure on:' + JSON.stringify(data));
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'discoverFailure errCode:' + e.code + ',errMessage:' + e.message);
    }

    // 取消注册设备管理服务死亡回调，以便在服务死亡时通知应用程序
    try {
      this.deviceManager.off('serviceDie', () => {
        Logger.info(TAG, 'serviceDie on');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'serviceDie errCode:' + e.code + ',errMessage:' + e.message);
    }

  }

  /**
   * 绑定设备
   * @param deviceId 设备Id
   */
  bindTarget(deviceId: string) {
    try {
      this.deviceManager.bindTarget(deviceId, bindParam, (err: BusinessError, data: BindTargetData) => {
        if (err) {
          Logger.err(TAG, 'bindTarget errCode:' + err.code + ',errMessage:' + err.message);
          return;
        }

      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'bindTarget errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  /**
   * 解绑设备
   * @param deviceId
   */
  unbindTarget(deviceId: string) {
    try {
      this.deviceManager.unbindTarget(deviceId);
      Logger.info(TAG, 'unBindTarget :' + deviceId);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.err(TAG, 'unbindTarget errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  /**
   * 资源释放
   */
  release() {
    // 释放实例
    try {
      deviceManager.releaseDeviceManager(this.deviceManager);
      Logger.info(TAG, 'releaseDeviceManager success');
    } catch (e) {
      Logger.err(TAG, `releaseDeviceManager fail,${JSON.stringify(e)}`);
    }
  }
}

export default RemoteDeviceModel.getInstance();