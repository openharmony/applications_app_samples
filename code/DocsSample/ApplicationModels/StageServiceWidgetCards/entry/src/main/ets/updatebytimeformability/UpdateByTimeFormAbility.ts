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

// [Start update_by_time_form_ability]
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';

const TAG: string = 'UpdateByTimeFormAbility';
const FIVE_MINUTE: number = 5;
const DOMAIN_NUMBER: number = 0xFF00;

export default class UpdateByTimeFormAbility extends FormExtensionAbility {
  // [StartExclude update_by_time_form_ability]
  onAddForm(want: Want): formBindingData.FormBindingData {
    // Called to return a FormBindingData object.
    let formData = {};
    return formBindingData.createFormBindingData(formData);
  }

  onUpdateForm(formId: string): void {
    // Called to notify the form provider to update a specified form.
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}`);
    let formData = {
      title: 'Title Update.', // 和卡片布局中对应
      detail: 'Description update success.' // 和卡片布局中对应
    };
    let obj2 = formBindingData.createFormBindingData(formData);

    formProvider.updateForm(formId, obj2).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG, 'Operation updateForm failed. Cause: ' + error);
    });
  }

  // [EndExclude update_by_time_form_ability]
  onFormEvent(formId: string, message: string): void {
    // Called when a specified message event defined by the form provider is triggered.
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
    try {
      // 设置过5分钟后更新卡片内容
      formProvider.setFormNextRefreshTime(formId, FIVE_MINUTE, (err: BusinessError) => {
        if (err) {
          hilog.error(DOMAIN_NUMBER, TAG,
            `Failed to setFormNextRefreshTime. Code: ${err.code}, message: ${err.message}`);
          return;
        } else {
          hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in setFormNextRefreshTiming.');
        }
      });
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG,
        `Failed to setFormNextRefreshTime. Code: ${(err as BusinessError).code},
         message: ${(err as BusinessError).message}`);
    }
    ;
  }
  // [StartExclude update_by_time_form_ability]
  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
  // [EndExclude update_by_time_form_ability]
}
// [End update_by_time_form_ability]