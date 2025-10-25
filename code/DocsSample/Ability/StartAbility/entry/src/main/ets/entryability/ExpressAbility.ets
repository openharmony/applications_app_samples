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

// [Start express_ability]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const TAG = 'ExpressAbility';
const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private windowStage: window.WindowStage | null = null;

  private uri?: string;
  private expressNo?: string;
  // [Start express_ability_on_create]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, `onCreate, want=${JSON.stringify(want)}`);
    super.onCreate(want, launchParam);
    this.parseWant(want);
  }
  // [End express_ability_on_create]

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, `onNewWant, want=${JSON.stringify(want)}`);
    super.onNewWant(want, launchParam);
    this.parseWant(want);
    if (!this.windowStage) {
      hilog.error(DOMAIN, TAG, 'windowStage is null');
      this.context.terminateSelf();
      return;
    }
    this.loadPage(this.windowStage);
  }

  private parseWant(want: Want): void {
    this.uri = want.uri as string | undefined;
    this.expressNo = want.parameters?.expressNo as string | undefined;
  }

  private loadPage(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, `loadPage, uri=${this.uri}`);
    if (this.uri === 'express://queryExpress') {
      // 构建快递查询参数
      const storage: LocalStorage = new LocalStorage({
        'expressNo': this.expressNo
      } as Record<string, Object>);
      // 拉起快递查询页面
      windowStage.loadContent('pages/QueryExpressPage', storage)
    } else {
      // 默认拉起首页
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s',
            JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
      });
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, `onDestroy`);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, `onWindowStageCreate`);
    this.windowStage = windowStage;
    this.loadPage(this.windowStage);
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
// [End express_ability]