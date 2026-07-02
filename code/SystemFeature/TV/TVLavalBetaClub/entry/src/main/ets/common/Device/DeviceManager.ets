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
import deviceInfo from '@ohos.deviceInfo';
import LogManager from '../Log/LogManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';

const TAG = 'DeviceManager';

export default class DeviceManager {
  private static manager: DeviceManager;
  private BOOT_HARDWARE_KEY = 'ohos.boot.hardware';

  public static shareInstance(): DeviceManager {
    if (!DeviceManager.manager) {
      DeviceManager.manager = new DeviceManager();
    }
    return DeviceManager.manager;
  }

  public getUdid(): string {
    let udid = deviceInfo.udid;
    LogManager.hilogIWithTag(TAG, `udid: ${JSON.stringify(udid)}`);
    return udid ? udid : '';
  }


  public getDisplayVersion(): string {
    let displayVersion = deviceInfo.displayVersion;
    LogManager.hilogIWithTag(TAG, `displayVersion: ${JSON.stringify(displayVersion)}`);
    return displayVersion ? displayVersion : '';
  }

  public getHardwareModel(): string {
    let hardwareModel = deviceInfo.hardwareModel;
    LogManager.hilogIWithTag(TAG, `hardwareModel: ${JSON.stringify(hardwareModel)}`);
    return hardwareModel ? hardwareModel : '';
  }

  public getBootloaderVersion(): string {
    let bootloaderVersion = deviceInfo.bootloaderVersion;
    LogManager.hilogIWithTag(TAG, `bootloaderVersion: ${JSON.stringify(bootloaderVersion)}`);
    return bootloaderVersion ? bootloaderVersion : '';
  }

  public getDeviceType(): string {
    let deviceType = deviceInfo.deviceType;
    LogManager.hilogIWithTag(TAG, `deviceType: ${JSON.stringify(deviceType)}`);
    return deviceType ? deviceType : '';
  }

  public getProductModel(): string {
    let productModel = deviceInfo.productModel;
    LogManager.hilogIWithTag(TAG, `productModel: ${JSON.stringify(productModel)}`);
    return productModel ? productModel : '';
  }

  public getBootHardware(): string {
    let bootHardware = systemParameterEnhance.getSync(this.BOOT_HARDWARE_KEY, 'default');
    LogManager.hilogIWithTag(TAG, `bootHardware: ${JSON.stringify(bootHardware)}`);
    return bootHardware ? bootHardware : '';
  }
};