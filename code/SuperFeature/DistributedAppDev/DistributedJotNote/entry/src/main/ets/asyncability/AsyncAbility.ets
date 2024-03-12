/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import Logger from '../utils/Logger';

const TAG = '[testTag_AsyncAbility]: ';

export default class AsyncAbility extends UIAbility {
  contentStorage?: LocalStorage;

  handleContinueParam(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 迁移应用启动时（onCreate）&应用热启动时（onNewWant）:恢复保存的迁移数据
    if (launchParam.launchReason == AbilityConstant.LaunchReason.CONTINUATION) {
      // 从want中恢复迁移数据
      let testDate = want?.parameters?.testDate;

      AppStorage.setOrCreate<string>('testDate', testDate as string);

      //显式调用页面恢复
      this.contentStorage = new LocalStorage();
      Logger.info(TAG, 'handleContinueParam() ： ready to restore');
      this.context.restoreWindowStage(this.contentStorage);
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'onCreate : Ability onCreate');

    // 调用原因为迁移时，设置状态为可迁移，应对冷启动情况(保证迁移连续性)
    if (launchParam.launchReason == AbilityConstant.LaunchReason.CONTINUATION) {
      this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
        Logger.info(TAG, `setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
      });
    }

    // 迁移应用启动时恢复保存的迁移数据
    this.handleContinueParam(want, launchParam);
  }

  async setAsyncWant(wantParam: Record<string, Object>) {
    Logger.info(TAG, 'setAsyncWant : onContinue setWant start');

    let testDate: string = AppStorage.get<string>('testDate') as string;
    wantParam['testDate'] = testDate;
    Logger.info(TAG, `onContinue testDate ${testDate}`);

    Logger.info(TAG, 'setAsyncWant : onContinue setWant end');
  }

  onContinue(wantParam: Record<string, Object>): Promise<AbilityConstant.OnContinueResult> {
    Logger.info(TAG, 'onContinue : wantParam.version,wantParam.targetDevice : ' + wantParam.version + wantParam.targetDevice);
    return this.setAsyncWant(wantParam).then(() => {
      return AbilityConstant.OnContinueResult.AGREE;
    });
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'Ability onNewWant');
    Logger.info(TAG, 'onNewWant, want:' + want.abilityName);
    Logger.info(TAG, 'onNewWant, launchParams:' + JSON.stringify(launchParams));
    Logger.info(TAG, `onNewWant, want: ${want.abilityName}`);
    Logger.info(TAG, `onNewWant, launchParam: ${JSON.stringify(launchParams)}`);

    // 调用原因为迁移时，设置状态为可迁移，应对热启动情况（保证迁移连续性）
    if (launchParams.launchReason == AbilityConstant.LaunchReason.CONTINUATION) {
      this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
        Logger.info(`setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
      });
    }

    //应用热启动时：恢复保存的迁移数据
    this.handleContinueParam(want, launchParams);
    Logger.info(TAG, 'onNewWant end')
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Page_AsyncAbility', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageRestore(windowStage: window.WindowStage) {
    Logger.info(TAG, 'onWindowStageRestore, pageStack_isON: ' + AppStorage.get<boolean>('pageStack_isON'));
    if (AppStorage.get<boolean>('pageStack_isON') == false) {
      Logger.info(TAG, 'onWindowStageRestore : ' + 'no pageStack');
      windowStage.loadContent('pages/Page_AsyncAbility', (err, data) => {
        if (err.code) {
          Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
          return;
        }
        Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
      });
    } else {
      Logger.info(TAG, 'onWindowStageRestore : have pageStack');
    }
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
  }
}
