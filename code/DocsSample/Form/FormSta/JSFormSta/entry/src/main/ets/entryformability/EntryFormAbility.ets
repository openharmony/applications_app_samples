'use static'

/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start JSForm_JsCardFormAbility_importSta]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { common, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import { formBindingData, FormExtensionAbility, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';

// [End JSForm_JsCardFormAbility_importSta]
// [Start JSForm_JsCardFormAbility_FormExtensionAbilitySta]
// [Start JSForm_JsCardFormAbility_onAddFormSta]
// [Start JSForm_JsCardFormAbility_onRemoveFormSta]
// [Start JSForm_JsCardFormAbility_onUpdateFormSta]
// [Start JSForm_JsCardFormAbility_onFormEventSta]
// entry/src/main/ets/entryformability/EntryFormAbility.ets

const TAG: string = 'JsCardFormAbility';
// [StartExclude JSForm_JsCardFormAbility_onUpdateFormSta]
// [StartExclude JSForm_JsCardFormAbility_onFormEventSta]
const DATA_STORAGE_PATH: string = '/data/storage/el2/base/haps/form_store';
// [EndExclude JSForm_JsCardFormAbility_onFormEventSta]
// [EndExclude JSForm_JsCardFormAbility_onUpdateFormSta]
const DOMAIN_NUMBER: int = 0xFF00;
// [StartExclude JSForm_JsCardFormAbility_onFormEventSta]
// [StartExclude JSForm_JsCardFormAbility_onRemoveFormSta]
// [StartExclude JSForm_JsCardFormAbility_onUpdateFormSta]
let storeFormInfo =
  async (formId: string, formName: string, tempFlag: boolean, context: common.FormExtensionContext): Promise<void> => {
    // 此处仅对卡片ID：formId，卡片名：formName和是否为临时卡片：tempFlag进行了持久化
    let formInfo: Record<string, string | boolean | number> = {
      'formName': formName,
      'tempFlag': tempFlag,
      'updateCount': 0
    };
    try {
      const storage: preferences.Preferences = await preferences.getPreferences(context, DATA_STORAGE_PATH);
      await storage.put(formId, JSON.stringify(formInfo));
      hilog.info(DOMAIN_NUMBER, TAG, `storeFormInfo, put form info successfully, formId: ` + formId);
      await storage.flush();
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `failed to storeFormInfo code: ` + err?.code + 'message: ' + err?.message);
    }
  }
// [EndExclude JSForm_JsCardFormAbility_onRemoveFormSta]
// [StartExclude JSForm_JsCardFormAbility_onAddFormSta]
let deleteFormInfo = async (formId: string, context: common.FormExtensionContext): Promise<void> => {
  try {
    const storage: preferences.Preferences = await preferences.getPreferences(context, DATA_STORAGE_PATH);
    // del form info
    await storage.delete(formId);
    hilog.info(DOMAIN_NUMBER, TAG, `deleteFormInfo, del form info successfully, formId: ${formId}`);
    await storage.flush();
  } catch (err) {
    hilog.error(DOMAIN_NUMBER, TAG, `failed to deleteFormInfo, code: ` + err?.code + 'message: ' + err?.message);
  }
};

// [EndExclude JSForm_JsCardFormAbility_onAddFormSta]
// [EndExclude JSForm_JsCardFormAbility_onUpdateFormSta]
// [EndExclude JSForm_JsCardFormAbility_onFormEventSta]

export default class JsCardFormAbility extends FormExtensionAbility {
  // [StartExclude JSForm_JsCardFormAbility_onRemoveFormSta]
  // [StartExclude JSForm_JsCardFormAbility_onUpdateFormSta]
  // [StartExclude JSForm_JsCardFormAbility_onFormEventSta]
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN_NUMBER, TAG, '[JsCardFormAbility] onAddForm');

    if (want.parameters) {
      let formId = want?.parameters?.['ohos.extra.param.key.form_identity'] as string;
      let formName = want?.parameters?.['ohos.extra.param.key.form_name'] as string;
      let tempFlag = want?.parameters?.['ohos.extra.param.key.form_temporary'] as boolean;
      // 将创建的卡片信息持久化，以便在下次获取/更新该卡片实例时进行使用
      storeFormInfo(formId, formName, tempFlag, this.context);
    }

    let obj: Record<string, string> = {
      'title': 'titleOnCreate',
      'detail': 'detailOnCreate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  }

  // [EndExclude JSForm_JsCardFormAbility_onRemoveFormSta]
  // [StartExclude JSForm_JsCardFormAbility_onAddFormSta]
  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoveForm');
    // 删除之前持久化的卡片实例数据
    deleteFormInfo(formId, this.context);
  }

  // [StartExclude JSForm_JsCardFormAbility_onRemoveFormSta]
  // [EndExclude JSForm_JsCardFormAbility_onUpdateFormSta]
  onUpdateForm(formId: string): void {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则卡片提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN_NUMBER, TAG, 'onUpdateForm');
    let obj: Record<string, string> = {
      'title': 'titleOnUpdate',
      'detail': 'detailOnUpdate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, `formProvider updateForm success`);
    }).catch((error) => {
      hilog.error(DOMAIN_NUMBER, TAG, `promise error, code: ${error?.code}, message: ${error?.message}`);
    });
  }

  // [EndExclude JSForm_JsCardFormAbility_onFormEventSta]
  // [StartExclude JSForm_JsCardFormAbility_onUpdateFormSta]
  onFormEvent(formId: string, message: string): void {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormEvent');
    // 获取message事件中传递的detail参数
  }

  // [EndExclude JSForm_JsCardFormAbility_onAddFormSta]
  // [EndExclude JSForm_JsCardFormAbility_onRemoveFormSta]
  // [EndExclude JSForm_JsCardFormAbility_onUpdateFormSta]
}

// [End JSForm_JsCardFormAbility_onFormEventSta]
// [End JSForm_JsCardFormAbility_onAddFormSta]
// [End JSForm_JsCardFormAbility_onRemoveFormSta]
// [End JSForm_JsCardFormAbility_onUpdateFormSta]
// [End JSForm_JsCardFormAbility_FormExtensionAbilitySta]