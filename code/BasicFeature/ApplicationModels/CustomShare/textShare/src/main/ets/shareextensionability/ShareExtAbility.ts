/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import ShareExtensionAbility from '@ohos.app.ability.ShareExtensionAbility';
import Logger from '../model/Logger';

  const TAG: string = '[Sample_ShareExtensionAbility]';

export default class ShareExtAbility extends ShareExtensionAbility {
  storage: LocalStorage;
  message: string;
  onCreate() {
    Logger.info(TAG, 'onCreate');
  }

  onForeground() {
    Logger.info(TAG, 'onForeground');
  }

  onBackground() {
    Logger.info(TAG, 'onBackground');
  }

  onSessionCreate(want, session) {
    Logger.info(TAG, `onSessionCreate, want: ${JSON.stringify(want)},`, `session: ${session}`);
    this.message = want.parameters.shareMessages;
    this.storage = new LocalStorage(
      {
        'session': session,
        'messages': this.message
      });
    session.loadContent('pages/ShareExtenIndex', this.storage);
  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy');
  }

  onSessionDestroy(session) {
    Logger.info(TAG, 'onSessionDestroy');
  }
};
