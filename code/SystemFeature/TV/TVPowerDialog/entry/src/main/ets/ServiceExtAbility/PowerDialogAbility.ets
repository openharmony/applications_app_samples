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
import { AbilityConstant, UIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import Logger from '../common/Logger';


export default class PowerUIExtensionExtAbility extends UIExtensionAbility {
  /**
   * Lifecycle function, called back when a service extension is started for initialization.
   */
  onCreate(want: AbilityConstant.LaunchParam) {
    Logger.info('PowerUIExtensionExtAbility onCreate');
    globalThis.extensionContext = this.context;
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    globalThis.abilityWant = want;
    try {
      let storage: LocalStorage = new LocalStorage({
        'session': session
      } as Record<string, UIExtensionContentSession>);
      Logger.info('PowerUIExtensionExtAbility loadContent in');
      session.loadContent('pages/powerDialog', storage);
      session.setWindowBackgroundColor('#00000000');
      globalThis.session = session;
    } catch (exception) {
      Logger.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
    }

  }

  /**
   * Lifecycle function, called back before a service extension is destroyed.
   */
  onDestroy() {

  }
};