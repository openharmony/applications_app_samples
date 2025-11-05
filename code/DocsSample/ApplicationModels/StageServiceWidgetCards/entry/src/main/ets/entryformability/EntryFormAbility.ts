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
// [Start update_by_message_form_ability]
// entry/src/main/ets/entryformability/EntryFormAbility.ts
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Configuration, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End import_entry_form_ability]

// [Start form_extension_ability_interface]
// [Start entry_form_ability]
// [Start update_form_interface]
const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

// [Start form_extension_lifecycle_interface]
export default class EntryFormAbility extends FormExtensionAbility {
  // [StartExclude update_form_interface]
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
    // [StartExclude update_by_message_form_ability]
    // 当前卡片使用方不会涉及该场景，无需实现该回调函数
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onCastToNormalForm');
  }

  onUpdateForm(formId: string): void {
    // [StartExclude update_by_message_form_ability]
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onUpdateForm');
    // [StartExclude update_by_message_form_ability]
    let obj: Record<string, string> = {
      'title': 'titleOnUpdateForm',
      'detail': 'detailOnUpdateForm'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).catch((error: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] updateForm, error:' + JSON.stringify(error));
    });
    // [EndExclude update_by_message_form_ability]
  }

  onChangeFormVisibility(newStatus: Record<string, number>): void {
    // [StartExclude update_by_message_form_ability]
    // 使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onChangeFormVisibility');
  }

  // [EndExclude update_form_interface]
  onFormEvent(formId: string, message: string): void {
    // [StartExclude update_by_message_form_ability]
    // 当卡片提供方的postCardAction接口的message事件被触发时调用
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${message}`);
    // [StartExclude form_extension_lifecycle_interface]
    // [StartExclude entry_form_ability]
    class FormDataClass {
      title: string = 'Title Update.'; // 和卡片布局中对应
      detail: string = 'Description update success.'; // 和卡片布局中对应
    }
    // [StartExclude update_by_message_form_ability]
    // 请根据业务替换为实际刷新的卡片数据
    // [EndExclude update_by_message_form_ability]
    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
    });
    // [EndExclude entry_form_ability]
    // [EndExclude form_extension_lifecycle_interface]
  }

  // [StartExclude update_form_interface]
  onRemoveForm(formId: string): void {
    // [StartExclude update_by_message_form_ability]
    // 删除卡片实例数据
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
    // [StartExclude update_by_message_form_ability]
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
    // [EndExclude update_by_message_form_ability]
  }

  // [StartExclude form_extension_lifecycle_interface]
  onConfigurationUpdate(config: Configuration) {
    // [StartExclude update_by_message_form_ability]
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后10秒内无操作将会被清理。
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onConfigurationUpdate:' + JSON.stringify(config));
  }
  // [EndExclude form_extension_lifecycle_interface]

  onAcquireFormState(want: Want): formInfo.FormState {
    // [StartExclude update_by_message_form_ability]
    // 调用后返回对象{@link FormState}.
    // [EndExclude update_by_message_form_ability]
    return formInfo.FormState.READY;
  }
  // [EndExclude update_form_interface]
}
// [End entry_form_ability]
// [End form_extension_ability_interface]
// [End update_form_interface]
// [End form_extension_lifecycle_interface]
// [End update_by_message_form_ability]