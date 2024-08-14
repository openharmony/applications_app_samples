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

import { BusinessError } from '@kit.BasicServicesKit';
import { UIAbility } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const TAG: string = '[OpenLinkAbility]';
const DOMAIN: number = 0xFF00;

export default class OpenLinkAbility extends UIAbility {
  onCreate(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'OpenLinkAbility onCreate');
  }

  onForeground() {
    hilog.info(DOMAIN, TAG, `OpenLinkAbility onForeground`);
  }

  onBackground() {
    hilog.info(DOMAIN, TAG, `OpenLinkAbility onBackground`);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, TAG, '%{public}s', 'OpenLinkAbility onWindowStageCreate');

    let windowClass: window.Window | undefined = undefined;
    windowStage.getMainWindow((err: BusinessError, data) => {
      const errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to obtain the main window. Cause code: ${err.code}, message: ${err.message}`);
        return;
      }
      windowClass = data;
      let systemBarProperties: window.SystemBarProperties = {
        statusBarColor: '#f1f3f5',
        navigationBarColor: '#f1f3f5',
      };
      try {
        windowClass.setWindowSystemBarProperties(systemBarProperties, (err: BusinessError) => {
          const errCode: number = err.code;
          if (errCode) {
            hilog.error(DOMAIN, TAG,
              `Failed to set the system bar properties. Cause code: ${err.code}, message: ${err.message}`);
            return;
          }
          hilog.info(DOMAIN, TAG, 'Succeeded in setting the system bar properties.');
        });
      } catch (exception) {
        hilog.error(DOMAIN, TAG,
          `Failed to set the system bar properties. Cause code: ${exception.code}, message: ${exception.message}`);
      }
    });

    windowStage.loadContent('pages/UniversalLinkIndex', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
    });
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, 'OpenLinkAbility onDestroy');
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, TAG, 'OpenLinkAbility onWindowStageDestroy');
  }
};