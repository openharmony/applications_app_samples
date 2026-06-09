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
// entry/src/main/ets/entryformability/UpdateByMessageFormAbility.ts
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Configuration, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import common from '@ohos.app.ability.common';
import { AppStorage } from '@ohos.arkui.stateManagement';

const TAG: string = 'UpdateByMessageFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  hilog.info(DOMAIN_NUMBER, TAG, 'OnAcquireFormState register success');
  return formInfo.FormState.READY;
}

export default class UpdateByMessageFormAbility extends FormExtensionAbility {
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
    hilog.info(DOMAIN_NUMBER, TAG, '[UpdateByMessageFormAbility] onAddForm');
    hilog.info(DOMAIN_NUMBER, TAG, want.parameters?.[formInfo.FormParam.NAME_KEY] as string);
    // 卡片使用方创建卡片时触发，卡片提供方需要返回卡片数据绑定类
    let obj: Record<string, string> = {
      'title': 'Title: ' + Math.random(),
      'detail': 'Description: ' + Math.random()
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  }

  onCastToNormalForm(formId: string): void {
    // [StartExclude update_by_message_form_ability]
    // 当前卡片使用方不会涉及该场景，无需实现该回调函数
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[UpdateByMessageFormAbility] onCastToNormalForm');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN_NUMBER, TAG, '[UpdateByMessageFormAbility] onUpdateForm');
    let obj: Record<string, string> = {
      'title': 'Title: ' + Math.random(),
      'detail': 'Description: ' + Math.random()
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).catch((err) => {
      hilog.info(DOMAIN_NUMBER, TAG,
        `[UpdateByMessageFormAbility] updateForm, code: ${err?.code}, message: ${err?.message}`);
    });
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    // [StartExclude update_by_message_form_ability]
    // 卡片使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[UpdateByMessageFormAbility] onChangeFormVisibility');
  }

  // [EndExclude update_form_interface]
  onFormEvent(formId: string, message: string): void {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${message}`);
    // 请根据业务替换为实际刷新的卡片数据
    let obj: Record<string, string> = {
      'title': 'Title: ' + Math.random(),
      'detail': 'Description: ' + Math.random()
    };
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((err) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. code: ${err?.code}, message: ${err?.message}`);
    });
  }

  // [StartExclude update_form_interface]
  onRemoveForm(formId: string): void {
    // [StartExclude update_by_message_form_ability]
    // 删除卡片实例数据
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[UpdateByMessageFormAbility] onRemoveForm');
    // [StartExclude update_by_message_form_ability]
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
    // [EndExclude update_by_message_form_ability]
  }

  onConfigurationUpdate(config: Configuration): void {
    // [StartExclude update_by_message_form_ability]
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后10秒内无操作将会被清理。
    // [EndExclude update_by_message_form_ability]
    hilog.info(DOMAIN_NUMBER, TAG, '[UpdateByMessageFormAbility] onConfigurationUpdate');
  }
}

// [End update_by_message_form_ability]