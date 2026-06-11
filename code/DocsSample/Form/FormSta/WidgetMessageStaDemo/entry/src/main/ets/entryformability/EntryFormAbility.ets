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

// [Start update_by_message_form_ability]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import Want from '@ohos.app.ability.Want';
import { Configuration } from '@ohos.app.ability.Configuration';
import { BusinessError } from '@ohos.base';
import { AppStorage } from '@ohos.arkui.stateManagement';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;

class FormDataClass {
  title: string = 'Title Update.'; // 和卡片布局中对应
  detail: string = 'Description update success.'; // 和卡片布局中对应
}

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
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
      hilog.error(DOMAIN_NUMBER, TAG, `OnStop catch error code: ${err?.code}, message: ${err?.message}`);
    }

    this.onAcquireFormState = onAcquireFormStateCallback;
  }

  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.error(DOMAIN_NUMBER, TAG, 'onAddForm testing');
    // Called to return a FormBindingData object.
    let wants = want?.parameters;
    let formId = '';
    if (wants) {
      formId = wants['ohos.extra.param.key.form_identity'] as string;
    }
    let param: Record<string, string> = {};
    param = {
      'title1': '武汉2*2'
    };
    let data: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    return data;
  }

  // [StartExclude update_by_message_form_ability]
<<<<<<< HEAD
  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm testing');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onUpdateForm callback, formid:${formId}`);
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onChangeFormVisibility testing');
  }

  // [EndExclude update_by_message_form_ability]
  onFormEvent(formId: string, message: string): void {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${message}`);

    // 请根据业务替换为实际刷新的卡片数据
    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG,
        `FormAbility updateForm success. code: ${error?.code}, message: ${error.message}`);
    });
  }

  // [StartExclude update_by_message_form_ability]
  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoveForm testing');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void {
=======
  onCastToNormalForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm testing');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>) {
    hilog.info(DOMAIN_NUMBER, TAG, `onUpdateForm callback, formid:${formId}`);
  }

  onChangeFormVisibility(newStatus: Record<string, int>) {
    hilog.info(DOMAIN_NUMBER, TAG, 'onChangeFormVisibility testing');
  }

  // [EndExclude update_by_message_form_ability]
  onFormEvent(formId: string, message: string) {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${message}`);

    // 请根据业务替换为实际刷新的卡片数据
    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG,
        `FormAbility updateForm success. code: ${error?.code}, message: ${error.message}`);
    });
  }

  // [StartExclude update_by_message_form_ability]
  onRemoveForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoveForm testing');
  }

  onConfigurationUpdate(newConfig: Configuration) {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation) {
>>>>>>> 39476b51603fbaab6d787ff04a4d26c885e22a28
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormLocationChanged testing');
  }

  // [EndExclude update_by_message_form_ability]
}

// [End update_by_message_form_ability]