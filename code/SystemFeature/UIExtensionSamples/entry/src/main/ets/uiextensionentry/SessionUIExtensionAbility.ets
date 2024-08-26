/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';

const TAG: string = 'SessionUIExtensionAbility';
const DOMAIN: number = 0xFF00;

export default class SessionUIExtensionAbility extends UIExtensionAbility {
  onCreate() {
    hilog.info(DOMAIN, TAG, 'MyUIExtensionAbility onCreate');
  }

  onDestroy() {
    hilog.info(DOMAIN, TAG, 'MyUIExtensionAbility onDestroy');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    let param: Record<string, Object> = {
      'session': session,
      'want': want
    };

    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('uiextensionpages/UIExtensionContentSessionPage', storage);
  }

  onForeground() {
    hilog.info(DOMAIN, TAG, 'MyUIExtensionAbility onForeground');
  }

  onBackground() {
    hilog.info(DOMAIN, TAG, 'MyUIExtensionAbility onBackground');
  }
}


