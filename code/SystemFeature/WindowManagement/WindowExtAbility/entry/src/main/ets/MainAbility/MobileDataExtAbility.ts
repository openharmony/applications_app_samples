/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import { UIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import Logger from '../feature/Logger';


const TAG: string = 'MobileDataExtAbility'

export default class MobileDataExtAbility extends UIExtensionAbility {
  onCreate() {
    Logger.info(TAG, `WlanExtAbility onCreate`);
  }

  onForeground() {
    Logger.info(TAG, `WlanExtAbility onForeground`);
  }

  onBackground() {
    Logger.info(TAG, `WlanExtAbility onBackground`);
  }

  onDestroy() {
    Logger.info(TAG, `WlanExtAbility onDestroy`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    Logger.info(TAG, `WlanExtAbility session create, want: ${JSON.stringify(want)}}`);
    session.loadContent('pages/MobileData');
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Logger.info(TAG, `WlanExtAbility onSessionDestroy`);
  }
}