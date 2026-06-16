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
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import PermissionManager from '../common/Permission/PermissionManager';
import UrlConstant from '../common/Constants/UrlConstant';
import KeyConstant from '../common/Constants/KeyConstant';
import fs from '@ohos.file.fs';
import LogManager from '../common/Log/LogManager';
import DeviceManager from '../common/Device/DeviceManager';
import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import KvManagerService from '../common/kvManager/KvManagerService';
import systemParameter from '@ohos.systemparameter';
import photoManager from '../manager/PhotoManager';
import { getAllMediaItems } from '../manager/loader/MediaTasks';
import { unregisterInputConsumer } from '../pages/IssueReporter/views/IssueReportSelectItem';
import { KeyCode } from '@kit.InputKit';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    this.initConfig();

    this.startRequestPermission();

    bundleManager.getApplicationInfo('com.samples.betaclub', bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT)
      .then((applicationInfo) => {
        AppStorage.setOrCreate<number>('appUid', applicationInfo.uid);
        LogManager.log(TAG, `getApplicationInfo success, uid: ${applicationInfo.uid}`);
      })
      .catch((err: BusinessError) => {
        LogManager.hilogEWithTag(TAG, `getApplicationInfo fail, err: ${err}`);
      });

    KvManagerService.createKV(this.context, 'com.samples.betaclub');
    KvManagerService.createStore(KeyConstant.KV_STORE_ID);
  }

  // 保护性验证，确认只能开发者手机使用
  private isValidate(): boolean {
    let bootHardware = DeviceManager.shareInstance().getBootHardware();
    let productModel = DeviceManager.shareInstance().getProductModel();
    return (bootHardware == 'uis7885') && ((productModel == 'LHT16') || (productModel == 'oriole'));
  }

  private startRequestPermission() {
    PermissionManager.shareInstance()
      .requestPermissions(this.context, ['ohos.permission.READ_MEDIA', 'ohos.permission.READ_IMAGEVIDEO']);
  }

  private initConfig() {
    getAllMediaItems('init', this.context);
    photoManager.init(this.context);
    // 应用启动，开启hilog抓取
    const url = systemParameter.getSync('persist.basic.betaclube.url');
    const productUrl = 'http://10.20.72.111:3470/';
    LogManager.hilogIWithTag(TAG, `initConfig url: ${JSON.stringify(url)}`);

    if (url) {
      UrlConstant.BASE_URL = url;
    } else {
      UrlConstant.BASE_URL = productUrl;
    }

    AppStorage.setOrCreate(KeyConstant.IS_SHOW_LOADING, false);

    AppStorage.setOrCreate(KeyConstant.IS_NEED_REFRESH, false);

    // 创建存放log文件夹
    fs.mkdir(this.context.cacheDir + '/' + 'cache_logs', (err) => {
      LogManager.hilogIWithTag(TAG, `initConfig mkdir log, err: ${JSON.stringify(err)}`);
    });

    // 创建附件文件夹
    fs.mkdir(this.context.cacheDir + '/' + KeyConstant.UPLOAD_ATTACHMENT_PATH_FOLDER, (err) => {
      LogManager.hilogIWithTag(TAG, `initConfig mkdir attachment , err: ${JSON.stringify(err)}`);
    });

    fs.mkdir(this.context.cacheDir + '/' + KeyConstant.CACHE_LOG_PATH_FOLDER, (err) => {
      LogManager.hilogIWithTag(TAG, `initConfig mkdir, err: ${JSON.stringify(err)}`);
    });

  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_LEFT);
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_RIGHT);
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_UP);
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_DOWN);
    unregisterInputConsumer(KeyCode.KEYCODE_ENTER);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_LEFT);
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_RIGHT);
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_UP);
    unregisterInputConsumer(KeyCode.KEYCODE_DPAD_DOWN);
    unregisterInputConsumer(KeyCode.KEYCODE_ENTER);
  }
};
