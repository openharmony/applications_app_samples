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
import dataShare from '@ohos.data.dataShare';
import { getPersistentConditionID } from '../../common/StatePersistence';

const TAG = '[sample_entryFormAbility]';
let dataShareHelper;

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want) {
    // Called to return a FormBindingData object.
    Logger.info(TAG, `onAddForm want: ${JSON.stringify(want)}`);
    let subscriberId = '110000';
    try {
      let persistentConditionID = getPersistentConditionID(this.context);
      if (typeof persistentConditionID === 'string' && persistentConditionID !== '') {
        subscriberId = persistentConditionID;
        Logger.info(TAG, `get persistentConditionID: ${persistentConditionID}`);
      } else {
        Logger.error(TAG, `get persistentConditionID error : ${typeof persistentConditionID} subscriberId is ${subscriberId}`);
      }
    } catch (err) {
      Logger.error(TAG, `get persistentConditionID: ${JSON.stringify(err)}`);
    }
    let template = {
      predicates: {
        'list': `select cityTemperature as cityTemperature, cityName as cityName from TBL00 where cityId = ${subscriberId}`
      },
      scheduler: ''
    };
    dataShare.createDataShareHelper(this.context, 'datashareproxy://ohos.samples.formextability', {
      isProxy: true
    }).then((data) => {
      dataShareHelper = data;
      dataShareHelper.addTemplate('datashareproxy://ohos.samples.formextability/test', subscriberId, template);
    });
    let formData = {};
    let proxies = [
      {
        'key': 'datashareproxy://ohos.samples.formextability/test',
        'subscriberId': subscriberId
      }
    ];
    let formBinding = {
      data: JSON.stringify(formData),
      proxies: proxies
    };
    Logger.info(TAG, `formBinding: ${JSON.stringify(formBinding)}`);
    return formBinding;
  }

  onCastToNormalForm(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId) {
    // Called to notify the form provider to update a specified form.
  }

  onChangeFormVisibility(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onFormEvent(formId, message) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
};