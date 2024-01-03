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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import { logger } from '../util/Logger';

export default class NewUIExtAbility extends UIExtensionAbility {
  onCreate() {
    logger.info(`NewUIExtAbility onCreate`);
  }

  onDestroy() {
    logger.info(`NewUIExtAbility onDestroy`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    let param: Record<string, Object> = {
      'session': session,
      'want': want
    };

    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('pages/SendSyncExt', storage);
  }

  onForeground() {
    logger.info(`NewUIExtAbility onForeground`);
    // Ability has brought to foreground
  }

  onBackground() {
    logger.info(`NewUIExtAbility onBackground`);
    // Ability has back to background
  }
}


