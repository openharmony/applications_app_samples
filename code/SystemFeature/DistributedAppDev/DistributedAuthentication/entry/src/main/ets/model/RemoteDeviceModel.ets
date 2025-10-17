/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import promptAction from '@ohos.promptAction';
import logger from '../common/Logger';

interface dataType {
  action?: distributedDeviceManager.DeviceStateChange;
  device: distributedDeviceManager.DeviceBasicInfo;
  subscribeId?: number;
}

class RemoteDeviceModel {
  private static dmInstance: RemoteDeviceModel = new RemoteDeviceModel();
  trustedDeviceList: Array<distributedDeviceManager.DeviceBasicInfo> = [];
  discoverList: Array<distributedDeviceManager.DeviceBasicInfo> = [];
  localDevice: distributedDeviceManager.DeviceBasicInfo | undefined = undefined;
  deviceManager: distributedDeviceManager.DeviceManager | undefined = undefined;
  isSupportRange: boolean = false;

  static getInstance(): RemoteDeviceModel {
    if (RemoteDeviceModel.dmInstance === undefined) {
      RemoteDeviceModel.dmInstance = new RemoteDeviceModel();
    }
    return RemoteDeviceModel.dmInstance!;
  }

  constructor() {
  }

  // [Start create_device_manager]
  async createDeviceManager(): Promise<void> {
    if (typeof (this.deviceManager) != 'undefined') {
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] deviceManager.createDeviceManager begin');
    try {
      let dmInstance = distributedDeviceManager.createDeviceManager('com.samples.devicemanager');
      this.deviceManager = dmInstance
      // [StartExclude create_device_manager]
      this.getLocalDeviceInfo();
      this.registerDeviceStateListener();
      this.getTrustedDeviceList();
      // [EndExclude create_device_manager]
      logger.info(`[DeviceManager.RemoteDeviceModel] createDeviceManager callback returned,
      value= ${JSON.stringify(this.deviceManager)}`);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      logger.error(`[DeviceManager.RemoteDeviceModel] createDeviceManager throw error,
      error=${e} message=${e.message}`);
    }
    logger.info('[DeviceManager.RemoteDeviceModel] distributedDeviceManager.createDeviceManager end');
  }
  // [End create_device_manager]

  getLocalDeviceInfo(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] getLocalDeviceInfo begin');
    let deviceId: string = this.deviceManager.getLocalDeviceId();
    let deviceName: string = this.deviceManager.getLocalDeviceName();
    let deviceType: number = this.deviceManager.getLocalDeviceType();
    let networkId: string = this.deviceManager.getLocalDeviceNetworkId();
    logger.info('[DeviceManager.RemoteDeviceModel] getLocalDeviceInfo deviceType: ' + deviceType);
    this.localDevice = {
      deviceId,
      deviceName,
      deviceType: deviceType.toString(),
      networkId
    };
    AppStorage.setOrCreate('localDevice', this.localDevice);
    logger.info('[DeviceManager.RemoteDeviceModel] getLocalDeviceInfo end localDevice = ' +
    JSON.stringify(this.localDevice));
  }

  // [Start get_available_device_list]
  getTrustedDeviceList(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] getTrustedDeviceList begin');
    try {
      this.trustedDeviceList = this.deviceManager.getAvailableDeviceListSync();
      // [StartExclude get_available_device_list]
      AppStorage.setOrCreate('trustedDeviceList', this.trustedDeviceList);
      // [EndExclude get_available_device_list]
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      logger.error('[DeviceManager.RemoteDeviceModel] getTrustedDeviceList error: ${error}' + error.toString());
      promptAction.showToast({
        message: 'getTrustedDeviceList failed'
      });
    }
  }
  // [End get_available_device_list]

  deviceStateChangeActionOnline(device: distributedDeviceManager.DeviceBasicInfo): void {
    this.trustedDeviceList[this.trustedDeviceList.length] = device;
    logger.info('[DeviceManager.RemoteDeviceModel] online, device list = ' + JSON.stringify(this.trustedDeviceList));
    for (let i = this.discoverList.length - 1; i >= 0; i--) {
      if (this.discoverList[i].deviceId == device.deviceId) {
        this.discoverList.splice(i, 1);
        break;
      }
    }
    for (let j = 0; j < this.trustedDeviceList.length; j++) {
      if (this.trustedDeviceList[j].deviceId === device.deviceId) {
        this.trustedDeviceList[j] = device;
        break;
      }
    }
    AppStorage.setOrCreate('discoverDeviceList', this.discoverList);
    AppStorage.setOrCreate('trustedDeviceList', this.trustedDeviceList);
  }

  deviceStateChangeActionOffline(device: distributedDeviceManager.DeviceBasicInfo): void {
    logger.info('[DeviceManager.RemoteDeviceModel] offline, this.trustedDeviceList.length=' +
    this.trustedDeviceList.length);
    let list: Array<distributedDeviceManager.DeviceBasicInfo> = [];
    for (let i = 0; i < this.trustedDeviceList.length; i++) {
      if (this.trustedDeviceList[i].deviceId !== device.deviceId) {
        list.push(this.trustedDeviceList[i]);
      }
    }
    this.trustedDeviceList = list;
    AppStorage.setOrCreate('trustedDeviceList', this.trustedDeviceList);
    logger.info('[DeviceManager.RemoteDeviceModel] offline, device list=' + JSON.stringify(this.trustedDeviceList));
  }

  // [Start device_state_change]
  registerDeviceStateListener(): void {
    logger.info('[DeviceManager.RemoteDeviceModel] registerDeviceStateListener');
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }

    // [StartExclude device_state_change]
    let self = this;
    // [EndExclude device_state_change]
    try {
      this.deviceManager.on('deviceStateChange', (data: dataType) => {
      if (data == null) {
        return;
      }
      logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data));
      switch (data.action) {
        case distributedDeviceManager.DeviceStateChange.AVAILABLE:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange ONLINE');
          // [StartExclude device_state_change]
          self.deviceStateChangeActionOnline(data.device!);
          // [EndExclude device_state_change]
          break;
        case distributedDeviceManager.DeviceStateChange.UNAVAILABLE:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange OFFLINE');
          // [StartExclude device_state_change]
          self.deviceStateChangeActionOffline(data.device!);
          // [EndExclude device_state_change]
          break;
        default:
          break;
        }
      })
    } catch(err) {
      let e: BusinessError = err as BusinessError;
      logger.error('[DeviceManager.RemoteDeviceModel] deviceStateChange failed err: ' + e.toString());
    }
  }
  // [End device_state_change]

  deviceFound(data: dataType): void {
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId == data.device!.deviceId) {
        logger.info('[DeviceManager.RemoteDeviceModel] device founded ignored');
        return;
      }
    }
    this.discoverList[this.discoverList.length] = data.device!;
    AppStorage.setOrCreate('discoverDeviceList', this.discoverList);
    logger.info('[DeviceManager.RemoteDeviceModel] deviceFound self.discoverList=' + this.discoverList);
  }

  private getFilterOptions(): Record<string, number> {
    let filterOptions: Record<string, number> = {};
    let filterOptionsMap = AppStorage.get('filterOptions') as Map<string, number>;
    let authFormName = AppStorage.get("authFormName") as string;
    let isOnlineName = AppStorage.get("isOnlineName") as string;
    let isTrustedName = AppStorage.get("isTrustedName") as string;
    let rangeName = AppStorage.get("rangeName") as string;
    let authForm = filterOptionsMap.get(authFormName);
    let isOnline = filterOptionsMap.get(isOnlineName);
    let isTrusted = filterOptionsMap.get(isTrustedName);
    let range = filterOptionsMap.get(rangeName);
    
    if(authForm == 1){
      filterOptions['authorizationType'] = 1;
    }else if(authForm == 2) {
      filterOptions['authorizationType'] = 2;
    }else if(authForm == 3) {
      filterOptions['authorizationType'] = 0;
    }

    if(isOnline == 1){
      filterOptions['availableStatus'] = 1;
    }else if(isOnline == 2) {
      filterOptions['availableStatus'] = 0;
    }

    if(isTrusted == 1){
      filterOptions['authenticationStatus'] = 1;
    }else if(isTrusted == 2) {
      filterOptions['authenticationStatus'] = 0;
    }

    if(range == 1){
      filterOptions['discoverDistance'] = 50;
    }else if(range == 2) {
      filterOptions['discoverDistance'] = 80;
    }else if(range == 3) {
      filterOptions['discoverDistance'] = 100;
    }

    return filterOptions;
  }

  // [Start start_discovering]
  startDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }
    let self = this;
    try {
      this.deviceManager.on('discoverSuccess', (data) => {
        if (data == null) {
          return;
        }
        logger.info('[DeviceManager.RemoteDeviceModel] deviceFound data=' + JSON.stringify(data));
        self.deviceFound(data);
      })
      this.deviceManager.on('discoverFailure', (data) => {
        logger.info('[DeviceManager.RemoteDeviceModel] discoverFail data=' + JSON.stringify(data));
      })
      // [StartExclude start_discovering]
      this.deviceManager.on('serviceDie', () => {
        logger.error('[DeviceManager.RemoteDeviceModel] serviceDie');
      })

      this.discoverList = [];
      AppStorage.setOrCreate('discoverDeviceList', this.discoverList);
      // [EndExclude start_discovering]
      let discoverParam: Record<string, number> = {
        'discoverTargetType': 1
      };
      let filterOptions: Record<string, number> = this.getFilterOptions();
      logger.info('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery filterOptions = ' + JSON.stringify(filterOptions));
      if (Object.entries(filterOptions).length == 0) {
        this.deviceManager.startDiscovering(discoverParam);
      } else {
        this.deviceManager.startDiscovering(discoverParam, filterOptions);
      }
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      logger.error('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery failed err: ' + e.toString());
    }
  }
  // [End start_discovering]

  stopDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }
    logger.info('[DeviceManager.RemoteDeviceModel] stopDeviceDiscovery');
    try {
      this.deviceManager.stopDiscovering();
      this.deviceManager.off('discoverSuccess');
      this.deviceManager.off('discoverFailure');
    } catch (e) {
      logger.error('[DeviceManager.RemoteDeviceModel] stopDeviceDiscovery failed err: ' + e.toString());
    }
  }

  unregisterDeviceListCallback(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }
    try {
      this.stopDeviceDiscovery();
      this.deviceManager.off('deviceStateChange');
      this.deviceManager.off('serviceDie');
      this.trustedDeviceList = [];
      this.discoverList = [];
    } catch (e) {
      logger.error('[DeviceManager.RemoteDeviceModel] stopDeviceDiscovery failed err: ' + e.toString());
    }
  }

  // [Start bind_target]
  authenticateDevice(device: distributedDeviceManager.DeviceBasicInfo): void {
    logger.info('[DeviceManager.RemoteDeviceModel] authenticateDevice ' + JSON.stringify(device));
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }

    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        continue;
      }

      let bindParam: Record<string, number | string> = {
        'bindLevel': 3,
        'bindType': 1, // PIN码认证
        'targetPkgName': 'ohos.samples.etsdevicemanager',
        'appName': 'DeviceManager',
      };
      try {
        this.deviceManager.bindTarget(device.deviceId, bindParam, (err: BusinessError, data: Object) => {
          if (err) {
            logger.error('[DeviceManager.RemoteDeviceModel] authenticateDevice error:' + JSON.stringify(err));
            return;
          }
          logger.info('[DeviceManager.RemoteDeviceModel] authenticateDevice succeed:' + JSON.stringify(data));
        })
      } catch (err) {
        let e: BusinessError = err as BusinessError;
        logger.error('[DeviceManager.RemoteDeviceModel] authenticateDevice failed err: ' + e.toString());
      }
    }
  }
  // [End bind_target]

  unAuthenticateDevice(device: distributedDeviceManager.DeviceBasicInfo): void {
    logger.info('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice ' + JSON.stringify(device));
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      promptAction.showToast({
        message: 'deviceManager has not initialized'
      });
      return;
    }

    for (let i = 0; i < this.trustedDeviceList.length; i++) {
      if (this.trustedDeviceList[i].deviceId != device.deviceId) {
        continue;
      }
      try {
        this.deviceManager.unbindTarget(device.deviceId)
      } catch (e) {
        logger.error('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice failed err: ' + e.toString());
      }
    }
  }
}

export default RemoteDeviceModel.getInstance();