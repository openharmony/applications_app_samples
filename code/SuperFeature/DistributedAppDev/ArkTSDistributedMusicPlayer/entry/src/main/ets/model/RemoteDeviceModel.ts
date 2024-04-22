/*
* Copyright (c) 2022 Huawei Device Co., Ltd.
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

import deviceManager from '@ohos.distributedDeviceManager';
import Logger from '../model/Logger';

let SUBSCRIBE_ID: number = 100;
const RANDOM: number = 65536;
const TAG: string = 'RemoteDeviceModel';

export class RemoteDeviceModel {
  public deviceLists: Array<deviceManager.DeviceBasicInfo> = [];
  public discoverLists: Array<deviceManager.DeviceBasicInfo> = [];
  private callback: () => void = null;
  private authCallback: () => void = null;
  private deviceManager: deviceManager.DeviceManager = undefined;

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) === 'undefined') {
      Logger.info(TAG, 'deviceManager.createDeviceManager begin');
      try {
        this.deviceManager = deviceManager.createDeviceManager('ohos.samples.distributedmusicplayer');
        this.registerDeviceList(callback);
        Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`);
      } catch (error) {
        Logger.info(TAG, `createDeviceManager throw error, error=${error} message=${error.message}`);
      }
      Logger.info(TAG, 'deviceManager.createDeviceManager end');
    } else {
      this.registerDeviceList(callback);
    };
  };

  registerDeviceList(callback) {
    Logger.info(TAG, 'registerDeviceListCallback');
    this.callback = callback;
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized');
      this.callback();
      return;
    };

    Logger.info(TAG, 'getTrustedDeviceListSync begin');
    let list: deviceManager.DeviceBasicInfo[] = [];
    try {
      list = this.deviceManager.getAvailableDeviceListSync();
    } catch (error) {
      Logger.info(TAG, `getTrustedDeviceListSync throw error, error=${error} message=${error.message}`);
    };
    Logger.info(TAG, `getTrustedDeviceListSync end, deviceLists= ${JSON.stringify(list)}`);
    if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
      this.deviceLists = list;
    };
    this.callback();
    Logger.info(TAG, 'callback finished');

    try {
      this.deviceManager.on('deviceStateChange', (data) => {
        Logger.info(TAG, `deviceStateChange data= ${JSON.stringify(data)}`);
        switch (data.action) {
          case deviceManager.DeviceStateChange.AVAILABLE:
            this.discoverLists = [];
            this.deviceLists.push(data.device);
            Logger.info(TAG, `reday, updated device list= ${JSON.stringify(this.deviceLists)} `);
            let list: deviceManager.DeviceBasicInfo[] = [];
            try {
              list = this.deviceManager.getAvailableDeviceListSync();
            } catch (err) {
              Logger.info(TAG, `this err is ${JSON.stringify(err)}`);
            }
            Logger.info(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`);
            if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
              this.deviceLists = list;
            }
            this.callback();
            break;
          case deviceManager.DeviceStateChange.UNAVAILABLE:
            if (this.deviceLists.length > 0) {
              let list = [];
              for (let i = 0; i < this.deviceLists.length; i++) {
                if (this.deviceLists[i].deviceId !== data.device.deviceId) {
                  list[i] = data.device;
                };
              };
              this.deviceLists = list;
            };
            Logger.info(TAG, `offline, updated device list= ${JSON.stringify(this.deviceLists)}`);
            this.callback();
            break;
          default:
            break;
        };
      });
      this.deviceManager.on('discoverSuccess', (data) => {
        Logger.info(TAG, `discoverSuccess data= ${JSON.stringify(data)}`);
        Logger.info(TAG, `discoverSuccess this.deviceLists= ${this.deviceLists}, this.deviceLists.length= ${this.deviceLists.length}`);
        for (let i = 0;i < this.discoverLists.length; i++) {
          if (this.discoverLists[i].deviceId === data.device.deviceId) {
            Logger.info(TAG, 'device founded, ignored');
            return;
          };
        };
        this.discoverLists[this.discoverLists.length] = data.device;
        this.callback();
      });
      this.deviceManager.on('discoverFailure', (data) => {
        Logger.info(TAG, `discoverFailure data= ${JSON.stringify(data)}`);
      });
      this.deviceManager.on('serviceDie', () => {
        Logger.error(TAG, 'serviceDie');
      });
    } catch (error) {
      Logger.info(TAG, `on throw error, error=${error} message=${error.message}`);
    }

    let discoverParam = {
      'discoverTargetType': 1
    };
    let filterOptions = {
      'availableStatus': 0
    };
    Logger.info(TAG, `startDiscovering ${SUBSCRIBE_ID}`);
    try {
      if (this.deviceManager !== null) {
        this.deviceManager.startDiscovering(discoverParam, filterOptions);
      };
    } catch (error) {
      Logger.error(TAG, `startDiscovering throw error, error=${error} message=${error.message}`);
    };
  };

  authDevice(device, callback) {
    Logger.info(TAG, `authDevice ${device}`);
    if (device !== undefined) {
      for (let i = 0; i < this.discoverLists.length; i++) {
        if (this.discoverLists[i].deviceId === device.deviceId) {
          Logger.info(TAG, 'device founded, ignored');
          let bindParam = {
            bindLevel: 3,
            bindType: 1,
            targetPkgName: 'ohos.samples.distributedmusicplayer',
            appName: 'Music',
          };
          Logger.info(TAG, `authenticateDevice ${JSON.stringify(this.discoverLists[i])}`);
          try {
            this.deviceManager.bindTarget(device.deviceId, bindParam, (err, data) => {
              if (err) {
                Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`);
                this.authCallback = () => {
                };
                return;
              };
              Logger.info(TAG, `authenticateDevice succeed, data= ${JSON.stringify(data)}`);
              this.authCallback = callback;
            });
          } catch (error) {
            Logger.error(TAG, `authenticateDevice throw error, error=${JSON.stringify(error)} message=${error.message}`);
          }
        }
      }
    }
  };

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDiscovering ${SUBSCRIBE_ID}`);
    if (this.deviceManager === undefined) {
      return;
    };
    try {
      this.deviceManager.stopDiscovering();
      this.deviceManager.off('deviceStateChange');
      this.deviceManager.off('discoverSuccess');
      this.deviceManager.off('discoverFailure');
      this.deviceManager.off('serviceDie');
    } catch (error) {
      Logger.info(TAG, `stopDeviceDiscovery throw error, error=${error} message=${error.message}`);
    }
    this.deviceLists = [];
  };
}
