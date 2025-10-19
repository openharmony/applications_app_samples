/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
// [Start JSForm_JsCardFormAbility_onAddForm]
// [Start JSForm_JsCardFormAbility_onRemoveForm]
// [Start JSForm_JsCardFormAbility_onUpdateForm]
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { formBindingData, FormExtensionAbility, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';

const TAG: string = 'JsCardFormAbility';
// [StartExclude JSForm_JsCardFormAbility_onUpdateForm]
const DATA_STORAGE_PATH: string = '/data/storage/el2/base/haps/form_store';
// [EndExclude JSForm_JsCardFormAbility_onUpdateForm]
const DOMAIN_NUMBER: number = 0xFF00;
// [StartExclude JSForm_JsCardFormAbility_onRemoveForm]
// [StartExclude JSForm_JsCardFormAbility_onUpdateForm]
let storeFormInfo = async (formId: string, formName: string, tempFlag: boolean, context: common.FormExtensionContext): Promise<void> => {
  // 此处仅对卡片ID：formId，卡片名：formName和是否为临时卡片：tempFlag进行了持久化
  let formInfo: Record<string, string | boolean | number> = {
    'formName': formName,
    'tempFlag': tempFlag,
    'updateCount': 0
  };
  try {
    const storage: preferences.Preferences = await preferences.getPreferences(context, DATA_STORAGE_PATH);
    // put form info
    await storage.put(formId, JSON.stringify(formInfo));
    hilog.info(DOMAIN_NUMBER, TAG, `[EntryFormAbility] storeFormInfo, put form info successfully, formId: ${formId}`);
    await storage.flush();
  } catch (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `[EntryFormAbility] failed to storeFormInfo, err: ${JSON.stringify(err as BusinessError)}`);
  }
}
// [EndExclude JSForm_JsCardFormAbility_onRemoveForm]
// [StartExclude JSForm_JsCardFormAbility_onAddForm]
let deleteFormInfo = async (formId: string, context: common.FormExtensionContext): Promise<void> => {
  try {
    const storage: preferences.Preferences = await preferences.getPreferences(context, DATA_STORAGE_PATH);
    // del form info
    await storage.delete(formId);
    hilog.info(DOMAIN_NUMBER, TAG, `[EntryFormAbility] deleteFormInfo, del form info successfully, formId: ${formId}`);
    await storage.flush();
  } catch (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `[EntryFormAbility] failed to deleteFormInfo, err: ${JSON.stringify(err as BusinessError)}`);
  };
};
// [EndExclude JSForm_JsCardFormAbility_onAddForm]
// [EndExclude JSForm_JsCardFormAbility_onUpdateForm]
export default class JsCardFormAbility extends FormExtensionAbility {
  // [StartExclude JSForm_JsCardFormAbility_onRemoveForm]
  // [StartExclude JSForm_JsCardFormAbility_onUpdateForm]
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN_NUMBER, TAG, '[JsCardFormAbility] onAddForm');

    if (want.parameters) {
      let formId = JSON.stringify(want.parameters['ohos.extra.param.key.form_identity']);
      let formName = JSON.stringify(want.parameters['ohos.extra.param.key.form_name']);
      let tempFlag = want.parameters['ohos.extra.param.key.form_temporary'] as boolean;
      // 将创建的卡片信息持久化，以便在下次获取/更新该卡片实例时进行使用
      // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
      storeFormInfo(formId, formName, tempFlag, this.context);
    }

    let obj: Record<string, string> = {
      'title': 'titleOnCreate',
      'detail': 'detailOnCreate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  }
  // [EndExclude JSForm_JsCardFormAbility_onRemoveForm]
  // [StartExclude JSForm_JsCardFormAbility_onAddForm]
  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
    deleteFormInfo(formId, this.context);
  }
  // [StartExclude JSForm_JsCardFormAbility_onRemoveForm]
  // [EndExclude JSForm_JsCardFormAbility_onUpdateForm]
  onUpdateForm(formId: string): void {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onUpdateForm');
    let obj: Record<string, string> = {
      'title': 'titleOnUpdate',
      'detail': 'detailOnUpdate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).catch((error: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] updateForm, error:' + JSON.stringify(error));
    });
  }
  // [EndExclude JSForm_JsCardFormAbility_onAddForm]
  // [EndExclude JSForm_JsCardFormAbility_onRemoveForm]
}
// [End JSForm_JsCardFormAbility_onAddForm]
// [End JSForm_JsCardFormAbility_onRemoveForm]
// [End JSForm_JsCardFormAbility_onUpdateForm]