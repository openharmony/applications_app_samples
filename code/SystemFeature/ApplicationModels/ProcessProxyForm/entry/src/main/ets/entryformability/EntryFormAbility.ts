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

import formInfo from '@ohos.app.form.formInfo';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import Logger from '../../common/Logger';

const TAG = '[Sample_EntryFormAbility]';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want) {
    Logger.info(TAG, `onAddForm want: ${JSON.stringify(want)}`);
    let formData = {};
    let formProxies = [
      {
        'key': 'cityName',
        'subscriberId': '110000'
      },
      {
        'key': 'cityTemper',
        'subscriberId': '110000'
      }
    ];
    let formBinding = {
      data: JSON.stringify(formData),
      proxies: formProxies
    };
    Logger.info(TAG, `onAddForm return formBinding: ${JSON.stringify(formBinding)}`);
    return formBinding;
  }

  onCastToNormalForm(formId) {
    Logger.info(TAG, `onCastToNormalForm formId: ${JSON.stringify(formId)}`);
  }

  onUpdateForm(formId) {
    Logger.info(TAG, `onUpdateForm formId: ${JSON.stringify(formId)}`);
  }

  onChangeFormVisibility(newStatus) {
    Logger.info(TAG, `onChangeFormVisibility newStatus: ${JSON.stringify(newStatus)}`);
  }

  onFormEvent(formId, message) {
    Logger.info(TAG, `onFormEvent formId: ${JSON.stringify(formId)}`, `message: ${JSON.stringify(message)}`);
  }

  onRemoveForm(formId) {
    Logger.info(TAG, `onRemoveForm formId: ${JSON.stringify(formId)}`);
  }

  onAcquireFormState(want) {
    Logger.info(TAG, `onAcquireFormState want: ${JSON.stringify(want)}`);
    return formInfo.FormState.READY;
  }
};