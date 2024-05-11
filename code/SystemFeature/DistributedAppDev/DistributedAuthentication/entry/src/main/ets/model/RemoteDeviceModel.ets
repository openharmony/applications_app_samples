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
import { BusinessError } from '@ohos.base';
import DeviceManager from '@ohos.distributedHardware.deviceManager';
import { GlobalContext, getGlobalObject, setGlobalObject } from '../common/GlobalThis'

// the value is in scope [0, 65535]
let SUBSCRIBE_ID = 100;
// DeviceManager sa id
const PUBLISH_ID = 4802;

class discoverFailCallBackDataType {
  subscribeId: number = 0;
  reason: number = 0
}

class filterOptionsType {
  filter_op: string = 'AND';
  filters: Array<filterType> = []
}

class extraInfoType {
  targetPkgName: string = '';
  appName: string = '';
  appDescription: string = '';
  business: string = ''
}

class authParamType {
  authType: number = 1;
  appIcon: string = '';
  appThumbnail: string = '';
  extraInfo: Object = new Object();
}

class infoType {
  subscribeId: number = 0;
  mode: 0xAA = 0xAA;
  medium: number = 0;
  freq: number = 0;
  isSameAccount: boolean = false;
  isWakeRemote: boolean = false;
  capability: number = 0
}

class filterType {
  type: string = '';
  value: number = 0
}

class publishInfoType {
  publishId: number = PUBLISH_ID;
  mode: 0x55 = 0x55;
  freq: number = 2;
  ranging: boolean = false
}

interface dataType {
  action?: deviceManager.DeviceStateChangeAction;
  device: deviceManager.DeviceInfo;
  subscribeId?: number;
}


class RemoteDeviceModel {
  private static dmInstance: RemoteDeviceModel = new RemoteDeviceModel();
  trustedDeviceList: Array<deviceManager.DeviceInfo> = [];
  discoverList: Array<deviceManager.DeviceInfo> = [];
  localDevice: deviceManager.DeviceInfo | undefined = undefined;
  deviceManager?: deviceManager.DeviceManager;
  isSupportRange: boolean = false;
  private publishInfoObj: publishInfoType = {
    publishId: PUBLISH_ID,
    mode: 0x55,
    freq: 2,
    ranging: this.isSupportRange
  }
  private infoObj: infoType = {
    subscribeId: SUBSCRIBE_ID,
    mode: 0xAA,
    medium: 0,
    freq: 2,
    isSameAccount: false,
    isWakeRemote: true,
    capability: 0
  }
  private extraInfoObj: extraInfoType = {
    targetPkgName: 'ohos.samples.etsdevicemanager',
    appName: 'eTSDeviceManger',
    appDescription: 'eTSDeviceManger Ability',
    business: '0'
  }
  private authParamObj: authParamType = {
    authType: 1,
    appIcon: '',
    appThumbnail: '',
    extraInfo: this.extraInfoObj
  }

  static getInstance(): RemoteDeviceModel {
    if (RemoteDeviceModel.dmInstance === undefined) {
      RemoteDeviceModel.dmInstance = new RemoteDeviceModel();
    }
    return RemoteDeviceModel.dmInstance!;
  }

  constructor() {
  }

  async createDeviceManager(): Promise<void> {
    if (typeof (this.deviceManager) != 'undefined') {
      return;
    }

    logger.info('[DeviceManager.RemoteDeviceModel] deviceManager.createDeviceManager begin');
    let self = this;
    await new Promise((resolve: (value: deviceManager.DeviceManager) => void, reject: (reason: Error) => void) => {
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

  setIsSupportRange(value: boolean): void {
    this.isSupportRange = value;
  }

  publishDeviceDiscovery(): void {
    if (typeof (this.deviceManager) == 'undefined') {
      logger.error('[DeviceManager.RemoteDeviceModel] deviceManager has not initialized');
      constant.showToast('deviceManager has not initialized');
      return;
    }

    this.deviceManager.on('publishSuccess', (data: Object) => {
      logger.error('[DeviceManager.RemoteDeviceModel] publishSuccess publishId = ' + JSON.stringify(data));
      constant.showToast('subscribe publishSuccess failed');
    })

    this.deviceManager.on('publishFail', (data: Object) => {
      logger.error('[DeviceManager.RemoteDeviceModel] publishFail publishId = ' + JSON.stringify(data));
      constant.showToast('subscribe publishFail failed');
    })

    logger.info('[DeviceManager.RemoteDeviceModel] publishDeviceDiscovery ' + PUBLISH_ID);
    let publishInfo = this.publishInfoObj;
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

  deviceStateChangeActionOnline(device: deviceManager.DeviceInfo): void {
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

  deviceStateChangeActionOffline(device: deviceManager.DeviceInfo): void {
    logger.info('[DeviceManager.RemoteDeviceModel] offline, this.trustedDeviceList.length=' +
    this.trustedDeviceList.length);
    let list: Array<deviceManager.DeviceInfo> = [];
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
    this.deviceManager.on('deviceStateChange', (data: dataType) => {
      if (data == null) {
        return;
      }
      logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data));
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange ONLINE');
          self.deviceStateChangeActionOnline(data.device!);
          break;
        case deviceManager.DeviceStateChangeAction.READY:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange READY');
          break;
        case deviceManager.DeviceStateChangeAction.OFFLINE:
          logger.info('[DeviceManager.RemoteDeviceModel] deviceStateChange OFFLINE');
          self.deviceStateChangeActionOffline(data.device!);
          break;
        default:
          break;
      }
    })
  }

  deviceFound(data: dataType): void {
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId == data.device!.deviceId) {
        logger.info('[DeviceManager.RemoteDeviceModel] device founded ignored');
        return;
      }
    }
    this.discoverList[this.discoverList.length] = data.device!;
    AppStorage.SetOrCreate('discoverDeviceList', this.discoverList);
    logger.info('[DeviceManager.RemoteDeviceModel] deviceFound self.discoverList=' + this.discoverList);
  }

  private getFilterOptions(): Object {
    let filterOptions = new filterOptionsType();
    logger.info('currentFilterOptions' + JSON.stringify(getGlobalObject('filterOptions')));
    let currentFilterOptions = getGlobalObject('filterOptions') as Map<string, number>;
    let deviceTypeName = getGlobalObject("deviceTypeName") as string;
    let authFormName = getGlobalObject("authFormName") as string;
    let isOnlineName = getGlobalObject("isOnlineName") as string;
    let isTrustedName = getGlobalObject("isTrustedName") as string;
    let rangeName = getGlobalObject("rangeName") as string;
    let currentDeviceType = currentFilterOptions.get(deviceTypeName)
    let currentAuthForm = currentFilterOptions.get(authFormName)
    let currentIsOnline = currentFilterOptions.get(isOnlineName)
    let currentIsTrusted = currentFilterOptions.get(isTrustedName)
    let currentRange = currentFilterOptions.get(rangeName)
    if (currentIsOnline !== 0) {
      filterOptions.filters.push({
        type: "credible",
        value: currentIsOnline == 1 ? 1 : 0
      });
    }

    if (currentIsTrusted != 0) {
      filterOptions.filters.push({
        type: "isTrusted",
        value: currentIsTrusted == 1 ? 1 : 0
      });
    }

    if (currentDeviceType != 0) {
      let deviceType = 0;
      if (currentDeviceType == 1) {
        deviceType = deviceManager.DeviceType.TABLET;
      }
      ;
      if (currentDeviceType == 2) {
        deviceType = deviceManager.DeviceType.PHONE;
      }
      ;
      if (currentDeviceType == 3) {
        deviceType = deviceManager.DeviceType.UNKNOWN_TYPE;
      }
      ;
      filterOptions.filters.push({
        type: "deviceType",
        value: deviceType
      });
    }

    if (currentAuthForm != 0) {
      let authForm = -1;
      if (currentAuthForm == 1) {
        authForm = 1;
      }
      if (currentAuthForm == 2) {
        authForm = 2;
      }
      if (currentAuthForm == 3) {
        authForm = 0;
      }
      filterOptions.filters.push({
        type: "authForm",
        value: authForm
      });
    }

    if (currentRange != 0) {
      let range = 0;
      if (currentRange == 1) {
        range = 50;
      }
      if (currentRange == 2) {
        range = 80;
      }
      if (currentRange == 3) {
        range = 100;
      }
      filterOptions.filters.push({
        type: "range",
        value: range
      });
    }
    if (filterOptions.filters.length == 0) {
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
    this.infoObj.subscribeId = SUBSCRIBE_ID
    let info = this.infoObj;
    logger.info('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery ' + SUBSCRIBE_ID);
    this.discoverList = [];
    AppStorage.SetOrCreate('discoverDeviceList', this.discoverList);

    let filterOptions = this.getFilterOptions();
    logger.info('[DeviceManager.RemoteDeviceModel] startDeviceDiscovery filterOptions = ' + JSON.stringify(filterOptions));
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

  authenticateDevice(device: deviceManager.DeviceInfo): void {
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
      let authParam = this.authParamObj;
      try {
        this.deviceManager.authenticateDevice(device, authParam, (err: BusinessError, data: Object) => {
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

  unAuthenticateDevice(device: deviceManager.DeviceInfo): void {
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
        this.deviceManager.unAuthenticateDevice(device)
      } catch (e) {
        logger.error('[DeviceManager.RemoteDeviceModel] unAuthenticateDevice failed err: ' + e.toString());
      }
    }
  }
}

export default RemoteDeviceModel.getInstance();