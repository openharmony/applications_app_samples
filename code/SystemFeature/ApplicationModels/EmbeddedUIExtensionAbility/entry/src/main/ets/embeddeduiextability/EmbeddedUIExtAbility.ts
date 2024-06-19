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

import EmbeddedUIExtensionAbility from '@ohos.app.ability.EmbeddedUIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import Logger from '../model/Logger';

const TAG: string = 'ExampleEmbeddedAbility'
export default class ExampleEmbeddedAbility extends EmbeddedUIExtensionAbility {
  onCreate() {
    Logger.info(TAG, `onCreate`);
  }

  onForeground() {
    Logger.info(TAG, `onForeground`);
  }

  onBackground() {
    Logger.info(TAG, `onBackground`);
  }

  onDestroy() {
    Logger.info(TAG, `onDestroy`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    Logger.info(TAG, `onSessionCreate, want: ${JSON.stringify(want)}}`);
    let param: Record<string, UIExtensionContentSession> = {
      'session': session
    };
    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('pages/extension', storage);
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Logger.info(TAG, `onSessionDestroy`);
  }
}