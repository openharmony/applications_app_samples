'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { Want } from '@kit.AbilityKit';
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Configuration } from '@ohos.app.ability.Configuration';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  constructor() {
    hilog.info(DOMAIN_NUMBER, TAG, 'constructor register call');
    try {
      this.onStop = () => {
        hilog.info(DOMAIN_NUMBER, TAG, 'OnStop callback success');
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'OnStop register success');
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `OnStop catch error code: ${err?.code}, message: ${err?.message}`);
    }
  }

  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN_NUMBER, TAG, 'onAddForm testing');
    let formData: Record<string, Object | string> = {};
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm testing');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onUpdateForm callback, formid:${formId}`);
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onChangeFormVisibility testing');
  }

  onFormEvent(formId: string, message: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormEvent testing');
  }

  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoveForm testing');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormLocationChanged testing');
  }
}