/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import FormExtension from '@ohos.app.form.FormExtensionAbility';
import formInfo from '@ohos.application.formInfo';
import commonEvent from '@ohos.commonEventManager';
import formBindingData from '@ohos.application.formBindingData';
import Logger from '../util/Logger';

function publish(options): void {
  commonEvent.publish('music.event', options, (err) => {
    if (err.code) {
      Logger.error('FormAbility publish error. Cause:' + JSON.stringify(err));
      return;
    }
    Logger.info('FormAbility publish success');
  });
}

export default class FormAbility extends FormExtension {
  onAddForm(want): formBindingData.FormBindingData {
    Logger.info('FormAbility ServiceAbility onCreate');
    let formData = {};
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormal(formId): void {
    Logger.info('FormAbility onCastToNormal, formId: ${formId}');
  }

  onUpdateForm(formId): void {
    Logger.info(' FormAbility onUpdate, formId: ${formId}');
  }

  onFormEvent(formId, message): void {
    Logger.info('FormAbility onEvent, formId = ${formId}, message: ${JSON.stringify(message)}');
    let msgObj = JSON.parse(message);
    let params = msgObj.params;
    let msg: string = params.message;
    let options = {
      data: msg
    };
    publish(options);
  }

  onRemoveForm(formId): void {
    Logger.info('FormAbility onDestroy, formId = ${formId}');
    let options = {
      data: 'delete'
    };
    publish(options);
  }

  onAcquireFormState(want): formInfo.FormState {
    Logger.info('FormAbility onAcquireFormState');
    return formInfo.FormState.READY;
  }
}