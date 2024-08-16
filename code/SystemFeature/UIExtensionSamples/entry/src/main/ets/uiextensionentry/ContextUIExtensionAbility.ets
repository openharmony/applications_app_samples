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

import { UIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[UIExtAbility]';
const DOMAIN: number = 0xFF00;

export default class ContextUIExtensionAbility extends UIExtensionAbility {
  onCreate() {
    hilog.info(DOMAIN, TAG, 'UIExtAbility onCreate');
  }

  onForeground() {
    hilog.info(DOMAIN, TAG, `UIExtAbility onForeground`);
  }

  onBackground() {
    hilog.info(DOMAIN, TAG, `UIExtAbility onBackground`);
  }

  onDestroy() {
    hilog.info(DOMAIN, TAG, `UIExtAbility onDestroy`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    hilog.info(DOMAIN, TAG, `UIExtAbility onSessionCreate, want: ${JSON.stringify(want)}`);

    let param: Record<string, UIExtensionContentSession> = {
      'session': session
    };

    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('uiextensionpages/UIExtensionContextPage', storage);
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    hilog.info(DOMAIN, TAG, `UIExtAbility onSessionDestroy`);
  }
};