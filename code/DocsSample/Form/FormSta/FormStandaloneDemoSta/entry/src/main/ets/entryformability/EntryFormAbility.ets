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

import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formInfo from '@ohos.app.form.formInfo';
import formProvider from '@ohos.app.form.formProvider';
import Want from '@ohos.app.ability.Want';
import { Configuration } from '@ohos.app.ability.Configuration';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { AppStorage } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';

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
    let wants = want?.parameters;
    let formId = '';
    if (wants) {
      formId = wants['ohos.extra.param.key.form_identity'] as string;
    }
    let param: Record<string, string> = {};
    param = {
      'title1':'description'
    };
    let data:formBindingData.FormBindingData  = formBindingData.createFormBindingData(param);
    return data;
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN, 'testTag', 'onCastToNormalForm testing');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void  {
    hilog.info(DOMAIN, 'testTag', `onUpdateForm callback, formid:${formId}`);
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void  {
    hilog.info(DOMAIN, 'testTag', 'onChangeFormVisibility testing');
  }

  onFormEvent(formId: string, message: string): void  {
    hilog.info(DOMAIN, 'testTag', `onFormEvent testing ${message}`);
  }

  onRemoveForm(formId: string): void  {
    hilog.info(DOMAIN, 'testTag', 'onRemoveForm testing');
  }

  onConfigurationUpdate(newConfig: Configuration): void  {
    hilog.info(DOMAIN, 'testTag', 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void  {
    hilog.info(DOMAIN, 'testTag', 'onFormLocationChanged testing');
  }
}