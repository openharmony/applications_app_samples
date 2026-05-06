/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start calendarEvent_entryAbilityImport]
import { abilityAccessCtrl, AbilityConstant, common, PermissionRequestResult, Permissions, UIAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { calendarManager } from '@kit.CalendarKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End calendarEvent_entryAbilityImport]

// [Start calendarEvent_entryAbility]
const DOMAIN = 0x0000;

export let calendarMgr: calendarManager.CalendarManager | null = null;

export let mContext: common.UIAbilityContext | null = null;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 主窗口已创建，请为此Ability设置主页
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
    mContext = this.context;
    const permissions: Permissions[] = ['ohos.permission.READ_CALENDAR', 'ohos.permission.WRITE_CALENDAR'];
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(mContext, permissions).then((result: PermissionRequestResult) => {
      hilog.info(DOMAIN, 'testTag', 'get Permission success');
      calendarMgr = calendarManager.getCalendarManager(mContext);
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', 'get Permission error, Cause: %{public}s', JSON.stringify(error));
    })
  }

  onWindowStageDestroy(): void {
    // 主窗口已销毁，释放 UI 相关资源
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability 进入前台
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability 进入后台
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
// [End calendarEvent_entryAbility]