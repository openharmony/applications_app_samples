/*
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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import bundle from '@ohos.bundle';
import bundleManager from '@ohos.bundle.bundleManager';
import accessControl from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import Logger from '../common/Logger';

const DOMAIN = 0x0000;
let appId: string = 'com.example.kvstoresamples';
let abilityContext: common.UIAbilityContext; // 声明全局变量

export default class EntryAbility extends UIAbility {
  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus;
    // 获取应用程序的accessTokenID
    let tokenId: number;
    let bundleInfo: bundleManager.BundleInfo;
    bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
    // 校验应用是否被授予权限
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
    return grantStatus;
  }

  /* 权限校验入口 */
  async checkPermissions(): Promise<void> {
    const permissions: Permissions[] = ['ohos.permission.DISTRIBUTED_DATASYNC'];
    // 检查权限授予情况
    let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(permissions[0]);

    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      // 已获得授权
      Logger.info('testTag', '%{public}s', 'Permission already granted.');
    } else {
      // 未获得授权，需向用户申请授权
      let atManager = abilityAccessCtrl.createAtManager();
      try {
        atManager.requestPermissionsFromUser(this.context, permissions, (err, data) => {
          Logger.info(`data::${JSON.stringify(data)}`);
          Logger.info(`data::${data.permissions[0]}`);
          Logger.info(`data::${data.authResults.toString()}`);
        });
      } catch(err) {
        Logger.error(`Fail to restore data. Code:${err.code},message:${err.message}`);
        return;
      }
    }
  }

  static getContext(): common.UIAbilityContext {
    return abilityContext;
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    abilityContext = this.context; // 获取Ability的context
    this.checkPermissions();
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    // Ability is destroying, release resources for this ability
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });

    globalThis.requestPermissions = async () => {
      let permissions: string[] = [ 'ohos.permission.DISTRIBUTED_DATASYNC' ];
      let needGrantPermission = false;
      let accessManger = accessControl.createAtManager();
      Logger.info('[JSDemo]: app permission get bundle info');
      let bundleInfo = await bundle.getApplicationInfo(appId, 0, 100);
      Logger.info(`[JSDemo]: app permission query permission ${bundleInfo.accessTokenId.toString()}`);
      for (const permission of permissions) {
        Logger.info(`[JSDemo]: app permission query grant status ${permission}`);
        try {
          let grantStatus = await accessManger.verifyAccessToken(bundleInfo.accessTokenId, permission);
          if (grantStatus === accessControl.GrantStatus.PERMISSION_DENIED) {
            needGrantPermission = true;
            break;
          }
        } catch (err) {
          Logger.error(`[JSDemo]: app permission query grant status error ${permission} ${JSON.stringify(err)}`);
          needGrantPermission = true;
          break;
        }
      }
      if (needGrantPermission) {
        Logger.info('[JSDemo]: app permission needGrantPermission');
        try {
          await globalThis.abilityContext.requestPermissionsFromUser(permissions);
        } catch (err) {
          Logger.error(`[JSDemo]: app permission ${JSON.stringify(err)}`);
        }
      } else {
        Logger.info('[JSDemo]: app permission already granted');
      }
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}