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
import {
  abilityAccessCtrl,
  AbilityConstant, ConfigurationConstant, Permissions, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const domain = 0x0000;

export default class EntryAbility extends UIAbility {
  public onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(domain, 'testTag', '%{public}s', 'Ability onCreate');
    if (want.abilityName !== undefined) {
      hilog.info(domain, launchParam.launchReason.toString(), '%{public}s', 'Ability onCreate');
    }
  }

  public onDestroy(): void {
    hilog.info(domain, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  requestPermission() {
    //开启授权
    let permissions: Array<Permissions> = ["ohos.permission.ACCESS_BLUETOOTH"];
    let context: Context = this.context;
    let atManager: abilityAccessCtrl.AtManager =
      abilityAccessCtrl.createAtManager(); // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) { // 用户授权，可以继续访问目标操作
        } else { // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          return;
        }
      } // 授权成功
    })
  }

  public onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(domain, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 请求访问蓝牙权限
    this.requestPermission();

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(domain, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(domain, 'testTag', 'Succeeded in loading the content.');
    });
  }

  public onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(domain, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  public onForeground(): void {
    // Ability has brought to foreground
    hilog.info(domain, 'testTag', '%{public}s', 'Ability onForeground');
  }

  public onBackground(): void {
    // Ability has back to background
    hilog.info(domain, 'testTag', '%{public}s', 'Ability onBackground');
  }
}