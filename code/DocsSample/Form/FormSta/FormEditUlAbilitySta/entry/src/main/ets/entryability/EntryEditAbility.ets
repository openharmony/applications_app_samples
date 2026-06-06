'use static'

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

// [Start FormEditUIAbilitySta_EntryEditAbility]
// entry/src/main/ets/entryability/EntryEditAbility.ets
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { PreferencesUtil } from '../common/PreferencesUtil';
import preferences from '@ohos.data.preferences';
import { AppStorage } from '@ohos.arkui.stateManagement';

const DOMAIN = 0x0000;
const TAG: string = 'EntryEditAbility';

export default class EntryEditAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const formId: string | undefined = want?.parameters?.['formId'] as string;

    hilog.info(DOMAIN, 'testTag', 'onCreate form id is' + formId)
    if (formId) {
      // 存储被编辑的卡片ID，后续编辑卡片会用
      let util = PreferencesUtil.getInstance();
      let preferences = util.getPreferences(this.context) as preferences.Preferences;
      util.preferencesPut(preferences, formId);
    }
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, TAG, `Failed to set colorMode. code: ${err?.code}, message: ${err?.message}`);
    }
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 热启动编辑页时刷新被编辑的卡片ID
    const formId: string | undefined = want?.parameters?.['formId'] as string;
    hilog.info(DOMAIN, TAG, 'onNewWant form id is' + formId)
    if (formId) {
      // 初始化首选项数据库
      let util = PreferencesUtil.getInstance();
      let preferences = util.getPreferences(this.context) as preferences.Preferences;
      util.preferencesPut(preferences, formId);
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/FormEditIndex', (err) => {
      if (err && err.code) {
        hilog.error(DOMAIN, TAG, `Failed to load the content. Code: ${err?.code}, message: ${err?.message}`);
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
    });
    AppStorage.setOrCreate('windowStage', this.context);
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }
}

// [End FormEditUIAbilitySta_EntryEditAbility]