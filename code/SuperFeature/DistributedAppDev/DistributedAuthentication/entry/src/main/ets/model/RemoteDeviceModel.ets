/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import constant from '../common/Constant';
import deviceManager from '@ohos.distributedHardware.deviceManager';
import logger from '../common/Logger';

// the value is in scope [0, 65535]
let SUBSCRIBE_ID = 100;
// DeviceManager sa id
const PUBLISH_ID = 4802;

class RemoteDeviceModel {
  private static dmInstance: RemoteDeviceModel = undefined;
  trustedDeviceList: Array<deviceManager.DeviceInfo> = [];
  discoverList: Array<deviceManager.DeviceInfo> = [];
  localDevice: deviceManager.DeviceInfo = null;
  deviceManager;
  isSupportRange: boolean = false;

  static getInstance(): RemoteDeviceModel {
    if (this.dmInstance == undefined) {
      this.dmInstance = new RemoteDeviceModel();
    }
    return this.dmInstance;
  }

  constructor() {
  }

  async createDeviceManager(): Promise<void> {
    if (typeof (this.deviceManager) != 'undefined') {
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] deviceManager.createDeviceManager begin');
    let self = this;
    await new Promise((resolve, reject) => {
      deviceManager.createDeviceManager('ohos.samples.etsdevicemanager', (error, value) => {
        if (error) {
          reject(error);
          logger.error('[DeviceManager.RemoteDeviceModel] createDeviceManager failed.');
          return;
        }
        self.deviceManager = value;
        self.getLocalDeviceInfo();
        self.registerDeviceStateListener();
        self.getTrustedDeviceList();
        logger.info('[DeviceManager.RemoteDeviceModel] createDeviceManager callback success');
        resolve(value);
      })
    })
    logger.info('[DeviceManager.RemoteDeviceModel] deviceManager.createDeviceManager end');
  }

  getLocalDeviceInfo(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] getLocalDeviceInfo begin');
    this.localDevice = this.deviceManager.getLocalDeviceInfoSync();
    AppStorage.SetOrCreate('localDevice', this.localDevice);
    logger.info('[DeviceManager.RemoteDeviceModel] getLocalDeviceInfo end localDevice = ' +
      JSON.stringify(this.localDevice));
  }

  getTrustedDeviceList(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] getTrustedDeviceList begin');
    try {
      this.trustedDeviceList = this.deviceManager.getTrustedDeviceListSync();
      AppStorage.SetOrCreate('trustedDeviceList', this.trustedDeviceList);
    } catch (error) {
      logger.error('[DeviceManager.RemoteDeviceModel] getTrustedDeviceList error: ${error}' + error.toString());
      constant.showToast('getTrustedDeviceList failed');
    }
  }

  setIsSupportRange(value): void {
    this.isSupportRange = value;
  }

  publishDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }

    this.deviceManager.on('publishSuccess', (data) => {
      logger.error('[DeviceManager.RemoteDeviceModel] publishSuccess publishId = ' + JSON.stringify(data));
      constant.showToast('subscribe publishSuccess failed');
    })

    this.deviceManager.on('publishFail', (data) => {
      logger.error('[DeviceManager.RemoteDeviceModel] publishFail publishId = ' + JSON.stringify(data));
      constant.showToast('subscribe publishFail failed');
    })

    logger.info('[DeviceManager.RemoteDeviceModel] publishDeviceDiscovery ' + PUBLISH_ID);
    var publishInfo = {
      publishId: PUBLISH_ID,
      mode: 0x55,
      freq: 2,
      ranging: this.isSupportRange
    };
    try {
      this.deviceManager.publishDeviceDiscovery(publishInfo);
    } catch (error) {
      logger.error('[DeviceManager.RemoteDeviceModel] publishDeviceDiscovery error: ${error}' + error.toString());
      constant.showToast('publishDeviceDiscovery failed');
    }
  }

  unPublishDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager not init');
      return;
    }
    logger.info('[DeviceManager.RemoteDeviceModel] unPublishDeviceDiscovery begin');
    try {
      this.deviceManager.unPublishDeviceDiscovery(PUBLISH_ID);
      this.deviceManager.off('publishSuccess');
      this.deviceManager.off('publishFail');
    } catch (error) {
      logger.error('[DeviceManager.RemoteDeviceModel] publishDeviceDiscovery error: ' + error.toString());
      constant.showToast('unPublishDeviceDiscovery failed');
    }
  }

  deviceStateChangeActionOnline(device): void {
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
    AppStorage.SetOrCreate('discoverDeviceList', this.discoverList);
    AppStorage.SetOrCreate('trustedDeviceList', this.trustedDeviceList);
  }

  deviceStateChangeActionOffline(device): void {
    logger.info('[DeviceManager.RemoteDeviceModel] offline, this.trustedDeviceList.length=' +
      this.trustedDeviceList.length);
    let list = [];
    for (let i = 0; i < this.trustedDeviceList.length; i++) {
      if (this.trustedDeviceList[i].deviceId !== device.deviceId) {
        list.push(this.trustedDeviceList[i]);
      }
    }
    this.trustedDeviceList = list;
    AppStorage.SetOrCreate('trustedDeviceList', this.trustedDeviceList);
    logger.info('[DeviceManager.RemoteDeviceModel] offline, device list=' + JSON.stringify(this.trustedDeviceList));
  }

  registerDeviceStateListener(): void {
    logger.info('[DeviceManager.RemoteDeviceModel] registerDeviceStateListener');
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }

    let self = this;
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data == null) {
        return;
      }
      logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data));
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange ONLINE');
          self.deviceStateChangeActionOnline(data.device);
          break;
        case deviceManager.DeviceStateChangeAction.READY:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange READY');
          break;
        case deviceManager.DeviceStateChangeAction.OFFLINE:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange OFFLINE');
          self.deviceStateChangeActionOffline(data.device);
          break;
        default:
          break;
      }
    })
  }

  deviceFound(data): void {
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId == data.device.deviceId) {
        logger.info('[DeviceManager.RemoteDeviceModel] device founded ignored');
        return;
      }
    }
    this.discoverList[this.discoverList.length] = data.device;
    AppStorage.SetOrCreate('discoverDeviceList', this.discoverList);
    logger.info('[DeviceManager.RemoteDeviceModel] deviceFound self.discoverList=' + this.discoverList);
  }

  private getFilterOptions(): Object {
    let filterOptions = {
      "filter_op": "AND",
      "filters": []
    };

    if (globalThis.filterOptions[globalThis.isOnlineName] != 0) {
      filterOptions['filters'].push({
        "type": "credible",
        "value": globalThis.filterOptions[globalThis.isOnlineName] == 1 ? 1 : 0
      });
    }

    if (globalThis.filterOptions[globalThis.isTrustedName] != 0) {
      filterOptions['filters'].push({
        "type": "isTrusted",
        "value": globalThis.filterOptions[globalThis.isTrustedName] == 1 ? 1 : 0
      });
    }

    if (globalThis.filterOptions[globalThis.deviceTypeName] != 0) {
      let deviceType = 0;
      if (globalThis.filterOptions[globalThis.deviceTypeName] == 1) {
        deviceType = deviceManager.DeviceType.TABLET;
      };
      if (globalThis.filterOptions[globalThis.deviceTypeName] == 2) {
        deviceType = deviceManager.DeviceType.PHONE;
      };
      if (globalThis.filterOptions[globalThis.deviceTypeName] == 3) {
        deviceType = deviceManager.DeviceType.UNKNOWN_TYPE;
      };
      filterOptions['filters'].push({
        "type": "deviceType",
        "value": deviceType
      });
    }

    if (globalThis.filterOptions[globalThis.authFormName] != 0) {
      let authForm = -1;
      if (globalThis.filterOptions[globalThis.authFormName] == 1) {
        authForm = 1;
      }
      if (globalThis.filterOptions[globalThis.authFormName] == 2) {
        authForm = 2;
      }
      if (globalThis.filterOptions[globalThis.authFormName] == 3) {
        authForm = 0;
      }
      filterOptions['filters'].push({
        "type": "authForm",
        "value": authForm
      });
    }

    if (globalThis.filterOptions[globalThis.rangeName] != 0) {
      let range = 0;
      if (globalThis.filterOptions[globalThis.rangeName] == 1) {
        range = 50;
      }
      if (globalThis.filterOptions[globalThis.rangeName] == 2) {
        range = 80;
      }
      if (globalThis.filterOptions[globalThis.rangeName] == 3) {
        range = 100;
      }
      filterOptions['filters'].push({
        "type": "range",
        "value": range
      });
    }
    if (filterOptions['filters'].length == 0) {
      return '';
    }
    return filterOptions;
  }

  startDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }
    let self = this;
    this.deviceManager.on('deviceFound', (data) => {
      if (data == null) {
        return;
      }
      logger.info('[DeviceManager.RemoteDeviceModel] deviceFound data=' + JSON.stringify(data));
      self.deviceFound(data);
    })
    this.deviceManager.on('discoverFail', (data) => {
      logger.info('[DeviceManager.RemoteDeviceModel] discoverFail data=' + JSON.stringify(data));
    })
    this.deviceManager.on('serviceDie', () => {
      logger.error('[DeviceManager.RemoteDeviceModel] serviceDie');
    })

    SUBSCRIBE_ID = Math.floor(65536 * Math.random())
    let info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 0,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    };
    logger.info('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery ' + SUBSCRIBE_ID);
    this.discoverList = [];
    AppStorage.SetOrCreate('discoverDeviceList', this.discoverList);

    let filterOptions = this.getFilterOptions();
    logger.info('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery filterOptions = ' +
      JSON.stringify(filterOptions));
    try {
      if (filterOptions == '') {
        this.deviceManager.startDeviceDiscovery(info);
      } else {
        this.deviceManager.startDeviceDiscovery(info, JSON.stringify(filterOptions));
      }
    } catch (e) {
      logger.error('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery failed err: ' + e.toString());
    }
  }

  stopDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }
    logger.info('[DeviceManager.RemoteDeviceModel] stopDeviceDiscovery ' + SUBSCRIBE_ID);
    try {
      this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
      this.deviceManager.off('deviceFound');
      this.deviceManager.off('discoverFail');
    } catch (e) {
      logger.error('[DeviceManager.RemoteDeviceModel] stopDeviceDiscovery failed err: ' + e.toString());
    }
  }

  unregisterDeviceListCallback(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
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

  authenticateDevice(device): void {
    logger.info('[DeviceManager.RemoteDeviceModel] authenticateDevice ' + JSON.stringify(device));
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }

    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        continue;
      }
      let extraInfo = {
        'targetPkgName': 'ohos.samples.etsdevicemanager',
        'appName': 'eTSDeviceManger',
        'appDescription': 'eTSDeviceManger Ability',
        'business': '0'
      };
      let authParam = {
        'authType': 1,
        'appIcon': '',
        'appThumbnail': '',
        'extraInfo': extraInfo
      };
      try {
        this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
          if (err) {
            logger.info('[DeviceManager.RemoteDeviceModel] authenticateDevice error:' + JSON.stringify(err));
            return;
          }
          logger.info('[DeviceManager.RemoteDeviceModel] authenticateDevice succeed:' + JSON.stringify(data));
        })
      } catch (e) {
        logger.error('[DeviceManager.RemoteDeviceModel] authenticateDevice failed err: ' + e.toString());
      }
    }
  }

  unAuthenticateDevice(device): void {
    logger.info('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice ' + JSON.stringify(device));
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }

    for (let i = 0; i < this.trustedDeviceList.length; i++) {
      if (this.trustedDeviceList[i].deviceId != device.deviceId) {
        continue;
      }
      try {
        this.deviceManager.unAuthenticateDevice(device, (err, data) => {
          if (err) {
            logger.info('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice error:' + JSON.stringify(err));
            return;
          }
          logger.info('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice succeed:' + JSON.stringify(data));
        })
      } catch (e) {
        logger.error('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice failed err: ' + e.toString());
      }
    }
  }
}

export default RemoteDeviceModel.getInstance();