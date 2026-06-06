'use static'

/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start set_form_next_refreshtimeSta]
// entry/src/main/ets/EntryFormAbility/EntryFormAbility.ets

import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formInfo from '@ohos.app.form.formInfo';
import formProvider from '@ohos.app.form.formProvider';
import Want from '@ohos.app.ability.Want';
import { Configuration } from '@ohos.app.ability.Configuration';
import { BusinessError } from '@ohos.base';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'EntryFormAbility';
const FIVE_MINUTE: int = 5;
const DOMAIN_NUMBER: int = 0xFF00;

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
  hilog.info(DOMAIN_NUMBER, TAG, 'OnAcquireFormState register success');
  return formInfo.FormState.READY;
}

function onAcquireFormDataCallback(formId: string): Record<string, Object> {
  hilog.info(DOMAIN_NUMBER, TAG, 'onAcquireFormDataCallback success');
  let param: Record<string, Object> = {};
  param = {
    'title': 'onAcquireFormData'
  };
  return param;
}

function onShareFormCallback(formId: string): Record<string, Object> {
  hilog.info(DOMAIN_NUMBER, TAG, 'onShareFormCallback success');
  let param: Record<string, Object> = {};
  param = {
    'title': 'onShareForm'
  };
  return param;
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
    this.onAcquireFormData = onAcquireFormDataCallback;
    this.onShareForm = onShareFormCallback;
  }

  onAddForm(want: Want): formBindingData.FormBindingData {
    // 卡片使用方创建卡片时触发，返回卡片数据绑定类
    hilog.info(DOMAIN_NUMBER, TAG, `onAddForm`);
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
    hilog.info(DOMAIN_NUMBER, TAG, `onAddForm testing FormBindingData`);
    return data;
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm testing');
  }

  // [StartExclude set_form_next_refreshtimeSta]
  onUpdateForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onUpdateForm, formId = ${formId}`);
    let formData: Record<string, string> = {
      'title': 'Title Update.', // 和卡片布局中对应
      'detail': 'Description update success.' // 和卡片布局中对应
    };
    let obj2 = formBindingData.createFormBindingData(formData);

    formProvider.updateForm(formId, obj2).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. code: ${error?.code}, message: ${error?.message}`);
    });
  }

  // [EndExclude set_form_next_refreshtimeSta]

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onChangeFormVisibility');
  }

  onFormEvent(formId: string, message: string): void {
    // 当卡片提供方的postCardAction接口的message事件被触发时调用
    hilog.info(DOMAIN_NUMBER, TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${message}`);
    try {
      // 设置过5分钟后更新卡片内容
      formProvider.setFormNextRefreshTime(formId, FIVE_MINUTE, (err: BusinessError | null) => {
        if (err && err.code != 0) {
          hilog.error(DOMAIN_NUMBER, TAG, `setFormNextRefreshTime. Code: ${err?.code}, message: ${err?.message}`);
          return;
        } else {
          hilog.info(DOMAIN_NUMBER, TAG, `setFormNextRefreshTime success`);
        }
      });
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, `setFormNextRefreshTime fail. Code: ${error?.code}, message: ${error?.message}`);
    }
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

  onAcquireFormStateFn(want: Want): formInfo.FormState {
    // 卡片使用方查询卡片状态时触发该回调，默认返回初始状态。
    return formInfo.FormState.READY;
  }
}

// [End set_form_next_refreshtimeSta]