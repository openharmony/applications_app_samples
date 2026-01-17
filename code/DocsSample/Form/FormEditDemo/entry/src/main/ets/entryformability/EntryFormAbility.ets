/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { PreferencesUtil } from '../common/PreferencesUtil';
import { FormData } from '../common/CommonData';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    let editFormId: string = '';
    let formId: string = '';
    // 初始化首选项数据库
    let util = PreferencesUtil.getInstance();
    let preferences = util.getPreferences(this.context);
    if (want.parameters) {
      formId = want.parameters[formInfo.FormParam.IDENTITY_KEY] as string;
      editFormId = want.parameters['ohos.extra.param.key.edit_form_id'] as string;
    }
    // 如果是编辑页面的预览卡片需要在创建时把编辑的卡片信息更新到预览卡片上
    if (editFormId && preferences) {
      let formData: FormData = util.getValue(preferences, editFormId) as FormData;
      return formBindingData.createFormBindingData({
        'message': formData.text
      });
    }

    return formBindingData.createFormBindingData('');
  }

  onCastToNormalForm(formId: string) {
  }

  onUpdateForm(formId: string) {
  }

  onFormEvent(formId: string, message: string) {
  }

  onRemoveForm(formId: string) {
  }

  onAcquireFormState(want: Want) {
    return formInfo.FormState.READY;
  }
}