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

import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formInfo from '@ohos.app.form.formInfo';
import type Want from '@ohos.app.ability.Want';

export default class WidgetCalleeFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    class DataObj1 {
      formId: string = '';
    }

    let dataObj1 = new DataObj1();
    if (want.parameters && want.parameters['ohos.extra.param.key.form_identity'] !== undefined) {
      let formId: string = want.parameters['ohos.extra.param.key.form_identity'].toString();
      dataObj1.formId = formId;
    }
    let obj1 = formBindingData.createFormBindingData(dataObj1);
    return obj1;
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}