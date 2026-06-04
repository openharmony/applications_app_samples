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

// [Start EntryFormAbility]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { formProvider, formHost } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';
import { AppStorage } from '@ohos.arkui.stateManagement';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>("abilityContext");
  hilog.info(DOMAIN_NUMBER, TAG, 'OnAcquireFormState register success');
  return formInfo.FormState.READY;
}

export default class EntryFormAbility extends FormExtensionAbility {
  constructor() {
    hilog.info(DOMAIN_NUMBER, TAG, 'constructor register call');
    try {
      this.onStop = () => {
        hilog.info(DOMAIN_NUMBER, TAG, 'OnStop callback success');
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'OnStop register success');
    } catch (err) {
      hilog.info(DOMAIN_NUMBER, TAG, `OnStop catch error code: ${err?.code}, message: ${err?.message}`);
    }

    this.onAcquireFormState = onAcquireFormStateCallback;
  }

  onAddForm(want: Want): formBindingData.FormBindingData {
    // Called to return a FormBindingData object.
    let obj: Record<string, string> = {
      'title': 'Title: ' + Math.random(),
      'detail': 'Description: ' + Math.random()
    };
    const formData = '';
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string): void {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    // Called to notify the form provider to update a specified form.
    let obj: Record<string, string> = {
      'title': 'Title: ' + Math.random(),
      'detail': 'Description: ' + Math.random()
    };
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    // 更新卡片数据
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. code: ${error.code}, message: ${error.message}`);
    });
  }

  onFormEvent(formId: string, message: string): void {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId: string): void {
    // Called to notify the form provider that a specified form has been destroyed.
  }
}
// [End EntryFormAbility]