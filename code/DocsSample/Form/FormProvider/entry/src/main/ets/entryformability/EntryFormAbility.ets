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
 
import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import hilog from '@ohos.hilog';
import formProvider from '@ohos.app.form.formProvider';


const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    console.log(`FormExtensionAbility onAddForm, want: ${want.abilityName}`);

    let formData = '';
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string) {
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    let nowTime = new Date()
    let hour_ = nowTime.getHours().toString()
    let minute_ = nowTime.getMinutes().toString()
    let second_ = nowTime.getSeconds().toString()

    class FormDataClass {
      hour: string = hour_;
      minute: string = minute_;
      second: string = second_;
    }

    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: Base.BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
    })
  }

  onChangeFormVisibility(newStatus: Record<string, number>) {
  }

  onFormEvent(formId: string, message: string) {
    let nowTime = new Date()
    let hour_ = nowTime.getHours().toString()
    let minute_ = nowTime.getMinutes().toString()
    let second_ = nowTime.getSeconds().toString()

    class FormDataClass {
      hour: string = hour_;
      minute: string = minute_;
      second: string = second_;
    }

    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: Base.BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
    })
  }

  onRemoveForm(formId: string) {
  }

  onAcquireFormState(want: Want) {
    return formInfo.FormState.READY;
  }
};