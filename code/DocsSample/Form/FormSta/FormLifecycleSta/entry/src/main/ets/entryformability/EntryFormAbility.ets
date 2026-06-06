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

// [Start import_entry_form_abilitySta]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formInfo from '@ohos.app.form.formInfo';
import Want from '@ohos.app.ability.Want';
import { Configuration } from '@ohos.app.ability.Configuration';
import hilog from '@ohos.hilog';

// [End import_entry_form_abilitySta]

// [Start entry_form_abilitySta]
// entry/src/main/ets/entryformability/EntryFormAbility.ets

const DOMAIN = 0x0000;

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
  hilog.info(DOMAIN, 'testTag', 'OnAcquireFormState register success');
  return formInfo.FormState.READY;
}

function onAcquireFormDataCallback(formId: string): Record<string, Object> {
  hilog.info(DOMAIN, 'testTag', 'onAcquireFormDataCallback success');
  let param: Record<string, Object> = {};
  param = {
    'title':'onAcquireFormData'
  };
  return param;
}

function onShareFormCallback(formId: string): Record<string, Object> {
  hilog.info(DOMAIN, 'testTag', 'onAcquireFormDataCallback success');
  let param: Record<string, Object> = {};
  param = {
    'title':'onShareForm'
  };
  return param;
}

export default class EntryFormAbility extends FormExtensionAbility {
  constructor() {
    hilog.info(DOMAIN, 'testTag', 'constructor register call');
    try {
      this.onStop = () => {
        hilog.info(DOMAIN, 'testTag', 'OnStop callback success');
      }
      hilog.info(DOMAIN, 'testTag', 'OnStop register success');
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `OnStop catch error code: ${err?.code}, message: ${err?.message}`);
    }

    this.onAcquireFormState = onAcquireFormStateCallback;
    this.onAcquireFormData = onAcquireFormDataCallback;
    this.onShareForm = onShareFormCallback;
  }

  onAddForm(want: Want) : formBindingData.FormBindingData {
    // 卡片使用方创建卡片时触发，卡片提供方需要返回卡片数据绑定类
    let param: Record<string, string> = {};
    param = {
      'title1':'description'
    };
    let data:formBindingData.FormBindingData  = formBindingData.createFormBindingData(param);
    hilog.info(DOMAIN, 'testTag', `onAddForm testing FormBindingData`);
    return data;
  }

  onCastToNormalForm(formId: string): void {
    // 当前卡片使用方不会涉及该场景，无需实现该回调函数
    hilog.info(DOMAIN, 'testTag', 'onCastToNormalForm testing');
  }

  onUpdateForm(formId: string): void {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN, 'testTag', 'onUpdateForm testing');
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    // 卡片使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    hilog.info(DOMAIN, 'testTag', 'onChangeFormVisibility testing');
  }

  onFormEvent(formId: string, message: string): void {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN, 'testTag', `onFormEvent testing ${message}`);
  }

  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    hilog.info(DOMAIN, 'testTag', 'onRemoveForm testing');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后10秒内无操作将会被清理。
    hilog.info(DOMAIN, 'testTag', 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void {
    hilog.info(DOMAIN, 'testTag', 'onFormLocationChanged testing');
  }
}

// [End entry_form_abilitySta]