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

import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import Log from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogDecorator';
import settings from '@ohos.settings';
import CatchError from '../../../../../../../common/utils/src/main/ets/default/baseUtil/CatchError';
import display from '@ohos.display';
import statfs from '@ohos.file.statvfs';
import { wifiManager } from '@kit.ConnectivityKit';
import access from '@ohos.bluetooth.access';
import deviceInfo from '@ohos.deviceInfo';
import BytesFormatManager from '../../common/BytesFormatManager';
import hidebug from '@ohos.hidebug';
import ethKit from '@ohos.net.ethernet';
import { JSON } from '@kit.ArkTS';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const CATCHMAC = 'catchMacAddress'

interface DeviceInfoItem {
  settingAlias: string;
  settingTitle: string;
  settingValue: string;
}

/**
 * about device service class
 */
export class AboutDeviceModel extends BaseModel {
  private urivar: string;

  private deviceInfo: DeviceInfoItem[] = [
    {
      settingAlias: 'model',
      settingTitle: '',
      settingValue: ''
    },
    {
      settingAlias: 'companyInfo',
      settingTitle: '',
      settingValue: ''
    },
    {
      settingAlias: 'deviceId',
      settingTitle: '',
      settingValue: '00000000000000'
    },
    {
      settingAlias: 'softwareVersion',
      settingTitle: '',
      settingValue: ''
    }
  ]
  private deviceUsedBytes: string = '';

  constructor() {
    super();
    this.urivar = this.getUri();
  }

  /**
   * Get Uri
   */
  @Log
  @CatchError(`datashare:///com.ohos.settingsdata.DataAbility/${ConfigData.SETTINGSDATA_DEVICE_NAME}`)
  public getUri(): string {
    return settings.getUriSync(ConfigData.SETTINGSDATA_BRIGHTNESS);
  }

  /**
   * Read local file
   */
  @Log
  public getAboutDeviceInfoListener(): DeviceInfoItem[] {
    return this.deviceInfo;
  }

  getDeviceMarketName(): string {
    let deviceEMarketName = deviceInfo.marketName
    return deviceEMarketName;
  }

  /**
   * Get system name from SettingsData
   */
  @Log
  @CatchError(ConfigData.DEVICE_NAME)
  getDeviceName(): string {
    let deviceName = deviceInfo.productModel
    return deviceName;
  }

  /**
   * Set system name to SettingsData
   */
  @Log
  @CatchError('')
  setDeviceName(name: string): string {
    let deviceName = name
    return deviceName
  }

  getSoftwareVersion(): string {
    let softwareVersion = systemParameterEnhance.getSync('const.product.software.version')
    return softwareVersion
  }

  getDisplayDPI(): string {
    let displayWidth = display.getDefaultDisplaySync().width
    let displayheight = display.getDefaultDisplaySync().height
    return displayWidth + 'X' + displayheight
  }

  //处理器
  getHardwareModel(): string {
    let hardwareModel = deviceInfo.hardwareModel
    return hardwareModel
  }

  //屏幕刷新率
  getDisplayRefreshRate(): string {
    let displayRefreshRate = display.getDefaultDisplaySync().refreshRate.toString()
    return displayRefreshRate;
  }

  getDeviceTotalBytes(): string {
    const path: string = (globalThis.settingsAbilityContext.filesDir) as string
    let deviceTotalBytes = BytesFormatManager(statfs.getTotalSizeSync(path))
    return deviceTotalBytes
  }

  getDeviceUsedBytes(): string {
    const path: string = (globalThis.settingsAbilityContext.filesDir) as string
    const totalSize = statfs.getTotalSizeSync(path)
    const freeSize = statfs.getFreeSizeSync(path)
    let deviceUsedBytes = BytesFormatManager(totalSize - freeSize)
    return deviceUsedBytes
  }

  getRuntimeMemory(): string {
    let runtimeMemory: string = '';
    try {
      runtimeMemory = BytesFormatManager(Number(hidebug.getSystemMemInfo().totalMem) * 1024)
    } catch (error) {
      console.error('AboutDeviceModel getRuntimeMemory failed, error: ' + error);
    }
    return runtimeMemory;
  }

  getDeviceSerial(): string {
    let deviceSerial = deviceInfo.serial
    console.log('hmlog-->', '序列号：' + deviceSerial)
    return deviceSerial
  }

  async getWifiMac() {
    try {
      let wifiMac = await wifiManager.getLinkedInfo()
      AppStorage.setOrCreate('wifiMac', wifiMac.macAddress)

    } catch (err) {
    }
  }

  getDeviceMacAddress(): string {
    try {
      let wifiMac = wifiManager.getDeviceMacAddress()
      console.log('hmlog-->', 'wifimac:' + wifiMac)
      let wifiMacadress = JSON.stringify(wifiMac).replace(/"/g, '')
      return wifiMacadress.toUpperCase();

    } catch (err) {
      return '';
    }
  }

  getBluetoothMac(): string {
    try {
      let bluetoothMac = access.getLocalAddress().toUpperCase();
      return bluetoothMac
    } catch (err) {
      return '';
    }
  }

  @Log
  @CatchError(CATCHMAC)
  async getEthMac(): Promise<string> {
    try {
      let ethMac = await ethKit.getMacAddress();
      console.log('eth mac', ethMac[0].macAddress);
      return ethMac[0].macAddress
    } catch (BusinessError) {
      console.log('eth mac error:', JSON.stringify(BusinessError));
      return '';
    }
  }
}

let aboutDeviceModel = new AboutDeviceModel();

export default aboutDeviceModel as AboutDeviceModel;
