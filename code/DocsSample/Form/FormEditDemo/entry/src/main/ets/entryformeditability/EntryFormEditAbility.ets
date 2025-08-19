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

import { FormEditExtensionAbility } from '@kit.FormKit';
import { Want, UIExtensionContentSession } from '@kit.AbilityKit';
import { ExtensionEvent } from '../model/ExtensionEvent';

const TAG: string = 'FormEditDemo[EntryFormEditAbility] -->';
let storage: LocalStorage = ExtensionEvent.getStorage();

export default class EntryFormEditAbility extends FormEditExtensionAbility {

  onCreate() {
    console.info(`${TAG} onCreate`);
  }
  onForeground(): void {
    console.info(`${TAG} EntryFormEditAbility onForeground.....`);
  }
  onBackground(): void {
    console.info(`${TAG} EntryFormEditAbility onBackground......`);
  }
  onDestroy(): void {
    console.info(`${TAG} EntryFormEditAbility onDestroy......`);
  }
  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    console.info(`${TAG} onSessionCreate start..... want: ${JSON.stringify(want)}`);
    const formId: string | undefined = want.parameters?.cardId as string;
    const previewFormId: string | undefined = want.parameters?.previewCardId as string;

    if (formId) {
      console.info(`${TAG} form id is ${formId}`);
      storage.setOrCreate('formId', formId);
    }
    if (previewFormId) {
      console.info(`${TAG} preview form id is ${previewFormId}`);
      storage.setOrCreate('previewFormId', previewFormId);
    }
    let extensionEvent: ExtensionEvent = new ExtensionEvent();
    extensionEvent.setStartSecondPage((): void => this.startSecondPage());
    storage.setOrCreate('extensionEvent', extensionEvent);
    try {
      session.loadContent('pages/FormEditExtension', storage);
    } catch (e) {
      console.error(`${TAG} EntryFormEditAbility loadContent err, want: ${JSON.stringify(e)}`);
    }
  }
  onSessionDestroy(session: UIExtensionContentSession) {
    console.info(`${TAG} onSessionDestroy`);
  }
  private startSecondPage() {
    const bundleName: string = this.context.extensionAbilityInfo.bundleName;
    const secPageAbilityName: string = 'FormEditSecPageAbility';
    console.info(`${TAG} startSecondPage. bundleName: ${bundleName}, secPageAbilityName: ${secPageAbilityName}.`);
    try {
      this.context.startSecondPage({
        bundleName: bundleName,
        parameters: {
          'secPageAbilityName': secPageAbilityName
        }
      })
      console.info(`${TAG} startSecondPage success!`);
    } catch (err) {
      console.error(`${TAG} startSecondPage failed, err: ${JSON.stringify(err)}`);
    }
  }
};