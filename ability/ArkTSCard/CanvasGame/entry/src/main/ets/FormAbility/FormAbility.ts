/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import FormExtension from '@ohos.app.form.FormExtensionAbility';
import formBindingData from '@ohos.app.form.formBindingData';
import formInfo from '@ohos.app.form.formInfo';
import Logger from '../model/Logger';

export default class FormAbility extends FormExtension {
  onCreate(want) {
    Logger.log(`[ArkTSCard] FormAbility onCreate, want: ${JSON.stringify(want)}`);
    let obj = {};
    let formData = formBindingData.createFormBindingData(obj);
    return formData;
  }

  onCastToNormal(formId) {
    Logger.log(`[ArkTSCard] ArkTSCard FormAbility onCastToNormal, formId: ${formId}`);
  }

  onUpdate(formId) {
    Logger.log(`[ArkTSCard] FormAbility onUpdate, formId: ${formId}`);
  }

  onVisibilityChange(newStatus) {
    Logger.log('[ArkTSCard] FormAbility onVisibilityChange');
  }

  onEvent(formId, message) {
    Logger.log(`[ArkTSCard] FormAbility onEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
  }

  onDestroy(formId) {
    Logger.log(`[ArkTSCard] FormAbility onDestroy, formId = ${formId}`);
  }

  onAcquireFormState(want) {
    Logger.log('[ArkTSCard] FormAbility onAcquireFormState');
    return formInfo.FormState.READY;
  }
};
