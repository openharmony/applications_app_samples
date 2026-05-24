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

// [Start update_by_onformevent]
// [Start update_by_onupdateform]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onAddForm');
    hilog.info(DOMAIN_NUMBER, TAG, want.parameters?.[formInfo.FormParam.NAME_KEY] as string);
    // 卡片使用方创建卡片时触发，卡片提供方需要返回卡片数据绑定类
    let obj: Record<string, string> = {
      'title': 'titleOnAddForm',
      'detail': 'detailOnAddForm'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onCastToNormalForm');
  }

  onUpdateForm(formId: string) {

    class FormDataClass {
      title: string = 'Title: ' + Math.random();
      detail: string = 'Description: ' + Math.random();
    }

    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. code: ${error.code}, message: ${error.message}`);
    });
  }

  onFormEvent(formId: string, message: string): void {
    // [StartExclude update_by_onformevent]
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onFormEvent');
    // [EndExclude update_by_onformevent]
    // [StartExclude update_by_onupdateform]
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${message}`);
    class FormDataClass {
      title: string = 'Title Update.'; // 和卡片布局中对应
      detail: string = 'Description update success.'; // 和卡片布局中对应
    }
    // 请根据业务替换为实际刷新的卡片数据
    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
    });
    // [EndExclude update_by_onupdateform]
  }

  onRemoveForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
  }

  onAcquireFormState(want: Want) {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onAcquireFormState');
    return formInfo.FormState.READY;
  }
}

// [End update_by_onupdateform]
// [End update_by_onformevent]
