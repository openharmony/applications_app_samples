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

import wifiManager from '@ohos.wifiManager';
import WifiDevice from './WifiDevice';
import { Callback } from '@ohos.base';
import WifiConstants from './constants/WifiConstants';
import WifiDevicesController from './WifiDevicesController';
import { Device, DeviceLibraryAccess, EnvManager, Logger } from '@ohos/common';
import { InfDevice, InfDevicesDiscover, ProtocolType, ScanOptions } from '@ohos/common/Index';

export default class WifiDevicesDiscover implements InfDevicesDiscover {
  public controller: WifiDevicesController;

  constructor(controller: WifiDevicesController) {
    this.controller = controller;
  }

  isScanEnable(): boolean {
    return EnvManager.getInstance().isProtocolEnable(ProtocolType.WIFI);
  }

  startScan(options: ScanOptions, callback: Callback<InfDevice>) {
    setTimeout(async () => {
      console.log('delay 1s');
      if (wifiManager.isWifiActive() == false) {
        throw Error('wifi is not open');
      } else {
        //api10后系统自动触发扫描WiFi，无需手动扫描

        //Oh-AA…AA-BB…BB-XYYYYYRRRR

        let wifiDevices: WifiDevice[] = [];
        let wifiScanInfos = wifiManager.getScanInfoList();
        for (let wifiScanInfo of wifiScanInfos) {
          Logger.debug('发现wifi设备:' + wifiScanInfo.ssid);
          let exp: RegExp = new RegExp(WifiConstants.wifiScanRegStr);
          //使用正则表达式和wifi加密方式过滤可信设备
          if (exp.test(wifiScanInfo.ssid) &&
            wifiScanInfo.securityType == wifiManager.WifiSecurityType.WIFI_SEC_TYPE_OPEN) {
            let deviceInfo: Device | null = null;
            deviceInfo = await DeviceLibraryAccess.queryDevice(WifiDevice.getDeviceIdFromSsid(wifiScanInfo.ssid));
            //未在设备库注册(从设备库查询不到)的设备，需要被过滤掉
            if (deviceInfo != undefined) {
              let wifiDevice = new WifiDevice(wifiScanInfo.ssid, wifiScanInfo.rssi, deviceInfo);
              wifiDevices.push(wifiDevice);
            }
          }
        }
        //按信号强度降序排序可信设备列表
        wifiDevices.sort((a, b) => {
          return b.rssi - a.rssi;
        });
        //排序完成后调用回调函数
        wifiDevices.forEach((device) => {
          callback(device);
        });
      }
    }, 1000);
  }


  stopScan() {
    //wifiManger暂未实现停止扫描功能，置空
  }

  getRandomInt(max: number) {
    return Math.floor(Math.random() * max);
  }
};

function getRandomInt(max: number) {
  return Math.floor(Math.random() * max);
}