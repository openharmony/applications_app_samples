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

// [Start persistent_data_form_ability]
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { dataShare } from '@kit.ArkData';

export default class PersistentDataFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    let dataShareHelper;
    let subscriberId = '111';
    let template = {
      predicates: {
        'list': `select type from TBL00 where cityId = ${subscriberId}`
      },
      scheduler: ''
    };
    dataShare.createDataShareHelper(this.context, 'datashareproxy://com.samples.widgetupdatebyproxy', {
      isProxy: true
    }).then((data) => {
      dataShareHelper = data;
      dataShareHelper.addTemplate('datashareproxy://com.samples.widgetupdatebyproxy/test', subscriberId, template);
    });
    let formData = {};
    let proxies = [
      {
        key: 'datashareproxy://com.samples.widgetupdatebyproxy/test',
        subscriberId: subscriberId
      }
    ];

    let formBinding = {
      data: JSON.stringify(formData),
      proxies: proxies
    };
    return formBinding;
  }
  // [StartExclude persistent_data_form_ability]
  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
  // [EndExclude persistent_data_form_ability]
}
// [End persistent_data_form_ability]