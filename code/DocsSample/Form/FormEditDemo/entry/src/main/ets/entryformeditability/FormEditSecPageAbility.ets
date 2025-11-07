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
// [Start FormEditDemo_FormEditSecPageAbility]
// entry/src/main/ets/entryformeditability/FormEditSecPageAbility.ets
import { FormEditExtensionAbility } from '@kit.FormKit';
import { Want, UIExtensionContentSession } from '@kit.AbilityKit';
import { ExtensionEvent } from '../model/ExtensionEvent';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'FormEditSecPageAbility';
const DOMAIN = 0xFF00;

export default class FormEditSecPageAbility extends FormEditExtensionAbility {
  public storage: LocalStorage = new LocalStorage();

  onCreate() {
    hilog.info(DOMAIN, TAG, `Ability onCreate`);
  }
  onForeground(): void {
    hilog.info(DOMAIN, TAG, `Ability onForeground`);
  }
  onBackground(): void {
    hilog.info(DOMAIN, TAG, `Ability onBackground`);
  }
  onDestroy(): void {
    hilog.info(DOMAIN, TAG, `Ability onDestroy`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    let extensionEvent: ExtensionEvent = new ExtensionEvent();
    this.storage.setOrCreate('extensionEvent', extensionEvent);
    this.storage.setOrCreate('session', session);
    this.storage.setOrCreate('context', this.context);

    try {
      session.loadContent('pages/FormEditSecPage', this.storage);
      hilog.info(DOMAIN, TAG, `loadContent first edit page success`);
    } catch (e) {
      hilog.error(DOMAIN, TAG, `EntryFormEditAbility loadContent err, want: ${e?.message}`);
    }
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    hilog.info(DOMAIN, TAG, `onSessionDestroy`);
  }

}
// [End FormEditDemo_FormEditSecPageAbility]