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

import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import hilog from '@ohos.hilog';
import type Want from '@ohos.app.ability.Want';

const TAG: string = 'ProcessDataFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class ProcessDataFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    let formData: Record<string, Object> = {};
    let proxies: formBindingData.ProxyData[] = [
      {
        key: 'datashareproxy://com.samples.widgetupdatebyproxy/weather',
        subscriberId: '11'
      }
    ];
    let formBinding = formBindingData.createFormBindingData(formData);
    formBinding.proxies = proxies;
    hilog.info(DOMAIN_NUMBER, TAG, 'onAddForm');
    return formBinding;
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}