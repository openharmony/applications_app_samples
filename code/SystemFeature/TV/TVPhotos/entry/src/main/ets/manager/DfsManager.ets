/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { Context } from '@kit.AbilityKit';
import { fileIo as fs, fileUri, securityLabel } from '@kit.CoreFileKit';
import { BusinessError, Callback, distributedAccount } from '@kit.BasicServicesKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import Logger from '../common/Logger';
import { promptAction } from '@kit.ArkUI';

const TAG = 'DfsPresenter';
const BUNDLE_NAME = 'com.samples.album';

@Observed
class DfsManager {
  private dmInstance: distributedDeviceManager.DeviceManager | undefined;
  connectedDevice: distributedDeviceManager.DeviceBasicInfo | undefined = undefined;
  private deviceStatusListener: fs.DfsListeners = {
    onStatus: (networkId: string, status: number): void => {
      Logger.info(TAG, `dfs status: ${status}`);
    }
  }

  isConnected(): boolean {
    return this.connectedDevice !== undefined;
  }

  getDmInstance() {
    return this.dmInstance;
  }

  //发现附近设备
  startDiscovering() {
    if (!this.dmInstance) {
      Logger.error(TAG, `startFindDistributedDevice dmInstance is error`);
      return;
    }
    try {
      let discoverParam: Record<string, number> = {
        'discoverTargetType': 1
      };
      let filterOptions: Record<string, number> = {
        'availableStatus': 0
      };
      this.dmInstance.startDiscovering(discoverParam, filterOptions);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'startDiscovering errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  stopDiscovering() {
    if (!this.dmInstance) {
      Logger.error(TAG, `stopDiscovering dmInstance is error`);
      return;
    }
    try {
      this.dmInstance.stopDiscovering();
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'stopDiscovering errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  // 绑定设备
  bindDevice(device: distributedDeviceManager.DeviceBasicInfo, callback: Callback<boolean>): void {
    let bindParam: Record<string, string | number> = {
      'bindType': 1, // 认证类型： 1 - 无账号PIN码认证
      'targetPkgName': BUNDLE_NAME,
      'appName': BUNDLE_NAME,
      'appOperation': '',
      'customDescription': ''
    };
    try {
      this.dmInstance?.bindTarget(device.deviceId, bindParam, (err: BusinessError, data) => {
        if (err) {
          Logger.error(TAG, `bindTarget failed , err = ${err}`);
        }
        if (data) {
          Logger.info(TAG, `bindTarget success: + ${JSON.stringify(data)}`);
          callback(true);
        }
      });
    } catch (err) {
      Logger.error(TAG, `bindTarget err: + ${JSON.stringify(err)}`);
    }


  }

  unBindDevice(device: distributedDeviceManager.DeviceBasicInfo) {
    if (!this.dmInstance) {
      Logger.error(TAG, `unBindDevice dmInstance is error`);
      return;
    }
    try {
      this.dmInstance.unbindTarget(device.deviceId)
      Logger.info(TAG, 'unBindDevice success');
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'unBindDevice errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  init() {
    this.dmInstance = distributedDeviceManager.createDeviceManager(BUNDLE_NAME);
  }

  getAvailableDevices(): distributedDeviceManager.DeviceBasicInfo[] {
    let deviceList: distributedDeviceManager.DeviceBasicInfo[] = []
    if (!this.dmInstance) {
      Logger.error(TAG, `getAvailableDevices dmInstance is error`);
      return deviceList;
    }
    try {
      deviceList = this.dmInstance.getAvailableDeviceListSync();
      Logger.info(TAG, `AvailableDeviceList = ${JSON.stringify(deviceList)}`)
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG, 'getAvailableDevices errCode:' + e.code + ',errMessage:' + e.message);
    }
    return deviceList;
  }

  //复制文件到分布式目录
  copyFileToDfsDir(srcUri: string, destUri: string, context: Context) {
    Logger.error(TAG, `copyFileToDfsDir src: ${srcUri} , destUri:${destUri}`);
    // 将沙箱路径下的文件拷贝到分布式路径下
    fs.copy(srcUri, destUri).then(() => {
      Logger.error("Succeeded in copying---. ");
      let name = new fileUri.FileUri(destUri).name;
      let path = context.distributedFilesDir + '/' + name;
      // 设置文件的数据等级为s0
      securityLabel.setSecurityLabel(path, "s0").then(() => {
        Logger.error(TAG, ` setSecurityLabel success`);

      }).catch((err: BusinessError) => {
        Logger.error(TAG, ` setSecurityLabel failed , err = ${JSON.stringify(err)}`);
      });
    }).catch((error: BusinessError) => {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
    })
  }

  //删除分布式目录中文件
  deleteDfsPhotoFile(uri: string, context: Context) {
    let name = new fileUri.FileUri(uri).name;
    let path = context.distributedFilesDir + '/' + name;
    try {
      fs.unlinkSync(path);
    } catch (err) {
      Logger.error(TAG, ` unlink file failed, err = ${JSON.stringify(err)}`);
    }
  }

  // 挂载分布式目录
  connectDfs(device: distributedDeviceManager.DeviceBasicInfo): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {

      // 访问并挂载公共文件目录
      fs.connectDfs(device.networkId, this.deviceStatusListener).then(async () => {
        Logger.info(TAG, `connectDfs success `);
        this.connectedDevice = device;
        resolve(true);
        promptAction.showToast({
          message: $r('app.string.dfs_connect_success')
        });
      }).catch((error: BusinessError) => {
        let err: BusinessError = error as BusinessError;
        resolve(false);
        Logger.error(TAG, `Failed to connectDfs Code: ${err.code}, message: ${err.message}`);
        promptAction.showToast({
          message: $r('app.string.dfs_connect_failed')
        });
      });
    })
  }

  /**
   * 检查当前登录分布式账号信息
   * @returns Promise<boolean>
   */
  async checkAccountLogin(): Promise<boolean> {
    try {
      let accountInfo = await distributedAccount.getDistributedAccountAbility().getOsAccountDistributedInfo();
      Logger.error(TAG, 'getOsAccountDistributedInfo success , accountInfo: ' + JSON.stringify(accountInfo));
      return true;
    } catch (err) {
      Logger.error(TAG, 'getOsAccountDistributedInfo exception: ' + JSON.stringify(err));
    }
    return false;
  }

  /**
   * 登录分布式账号
   * @returns Promise<void>
   */
  async accountLogin(): Promise<boolean> {
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGIN',
    };
    try {
      await distributedAccount.getDistributedAccountAbility().setOsAccountDistributedInfo(distributedInfo);
      Logger.error(TAG, `accountLogin success}`)
      return true;
    } catch (err) {
      Logger.error(TAG, `accountLogin is failed , err = ${JSON.stringify(err)}`)
    }
    return false;
  }
}

export let dfsManager = new DfsManager();
