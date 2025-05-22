/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

// [Start import_entry_form_ability]
// [Start update_form_interface]
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
// [StartExclude update_form_interface]
import { Configuration, Want } from '@kit.AbilityKit';
// [EndExclude update_form_interface]
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End import_entry_form_ability]

// [Start form_extension_ability_interface]
const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

// [Start form_extension_lifecycle_interface]
export default class EntryFormAbility extends FormExtensionAbility {
  // [StartExclude update_form_interface]
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onAddForm');
    hilog.info(DOMAIN_NUMBER, TAG, want.parameters?.[formInfo.FormParam.NAME_KEY] as string);
    // Called to return a FormBindingData object.
    let formData = {};
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string): void {
    // 使用方将临时卡片转换为常态卡片触发，提供方需要做相应的处理
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onCastToNormalForm');
  }

  onUpdateForm(formId: string): void {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onUpdateForm');
    let obj: Record<string, string> = {
      'title': 'titleOnUpdateForm',
      'detail': 'detailOnUpdateForm'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).catch((error: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] updateForm, error:' + JSON.stringify(error));
    });
  }

  onChangeFormVisibility(newStatus: Record<string, number>): void {
    // 使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onChangeFormVisibility');
  }

  // [EndExclude update_form_interface]
  onFormEvent(formId: string, message: string): void {
    // Called when a specified message event defined by the form provider is triggered.
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
    // [StartExclude form_extension_lifecycle_interface]
    class FormDataClass {
      title: string = 'Title Update.'; // 和卡片布局中对应
      detail: string = 'Description update success.'; // 和卡片布局中对应
    }

    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
    });
    // [EndExclude form_extension_lifecycle_interface]
  }

  // [StartExclude update_form_interface]
  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
  }

  // [StartExclude form_extension_lifecycle_interface]
  onConfigurationUpdate(config: Configuration) {
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后10秒内无操作将会被清理。
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onConfigurationUpdate:' + JSON.stringify(config));
  }
  // [EndExclude form_extension_lifecycle_interface]

  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
  // [EndExclude update_form_interface]
}
// [End form_extension_ability_interface]
// [End update_form_interface]
// [End form_extension_lifecycle_interface]