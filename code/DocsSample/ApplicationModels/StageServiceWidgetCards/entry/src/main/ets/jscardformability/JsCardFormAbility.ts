/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

// [Start js_card_form_ability]
// [Start remove_form_interface]
// [Start update_form_interface]
import { common, Want } from '@kit.AbilityKit';
// [Start receive_message_interface]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
// [StartExclude receive_message_interface]
import { BusinessError } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';
import { Configuration } from '@kit.ArkUI';
// [EndExclude receive_message_interface]

const TAG: string = 'JsCardFormAbility';
// [StartExclude update_form_interface]
// [StartExclude receive_message_interface]
const DATA_STORAGE_PATH: string = '/data/storage/el2/base/haps/form_store';
// [EndExclude update_form_interface]
// [EndExclude receive_message_interface]
const DOMAIN_NUMBER: number = 0xFF00;

// [StartExclude remove_form_interface]
// [StartExclude update_form_interface]
// [StartExclude receive_message_interface]
let storeFormInfo =
  async (formId: string, formName: string, tempFlag: boolean, context: common.FormExtensionContext): Promise<void> => {
    // 此处仅对卡片ID：formId，卡片名：formName和是否为临时卡片：tempFlag进行了持久化
    let formInfo: Record<string, string | boolean | number> = {
      formName: formName,
      tempFlag: tempFlag,
      updateCount: 0
    };
    try {
      const storage: preferences.Preferences = await preferences.getPreferences(context, DATA_STORAGE_PATH);
      // put form info
      await storage.put(formId, JSON.stringify(formInfo));
      hilog.info(DOMAIN_NUMBER, TAG, `[EntryFormAbility] storeFormInfo, put form info successfully, formId: ${formId}`);
      await storage.flush();
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG,
        `[EntryFormAbility] failed to storeFormInfo, err: ${JSON.stringify(err as BusinessError)}`);
    }
    ;
  };

// [StartExclude js_card_form_ability]
// [EndExclude remove_form_interface]
let deleteFormInfo = async (formId: string, context: common.FormExtensionContext): Promise<void> => {
  try {
    const storage: preferences.Preferences = await preferences.getPreferences(context, DATA_STORAGE_PATH);
    // del form info
    await storage.delete(formId);
    hilog.info(DOMAIN_NUMBER, TAG, `[EntryFormAbility] deleteFormInfo, del form info successfully, formId: ${formId}`);
    await storage.flush();
  } catch (err) {
    hilog.error(DOMAIN_NUMBER, TAG,
      `[EntryFormAbility] failed to deleteFormInfo, err: ${JSON.stringify(err as BusinessError)}`);
  }
  ;
};
// [EndExclude js_card_form_ability]
// [EndExclude update_form_interface]
// [EndExclude receive_message_interface]
export default class JsCardFormAbility extends FormExtensionAbility {
  // [StartExclude remove_form_interface]
  // [StartExclude update_form_interface]
  // [StartExclude receive_message_interface]
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

    // 使用方创建卡片时触发，提供方需要返回卡片数据绑定类
    let obj: Record<string, string> = {
      title: 'titleOnCreate',
      detail: 'detailOnCreate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  }

  // [StartExclude js_card_form_ability]
  onCastToNormalForm(formId: string): void {
    // 使用方将临时卡片转换为常态卡片触发，提供方需要做相应的处理
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onCastToNormalForm');
  }

  // [EndExclude update_form_interface]
  onUpdateForm(formId: string): void {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onUpdateForm');
    let obj: Record<string, string> = {
      title: 'titleOnUpdate',
      detail: 'detailOnUpdate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).catch((error: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] updateForm, error:' + JSON.stringify(error));
    });
  }
  // [StartExclude update_form_interface]

  onChangeFormVisibility(newStatus: Record<string, number>): void {
    // 使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onChangeFormVisibility');
  }
  // [EndExclude receive_message_interface]

  onFormEvent(formId: string, message: string): void {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onFormEvent');
    // 获取message事件中传递的detail参数
    let msg: Record<string, string> = JSON.parse(message);
    if (msg.detail === 'message detail') {
      // do something
      hilog.info(DOMAIN_NUMBER, TAG, 'message info:' + msg.detail);
    }
  }
  // [StartExclude receive_message_interface]
  // [EndExclude remove_form_interface]
  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
    deleteFormInfo(formId, this.context);
  }
  // [StartExclude js_card_form_ability]

  onConfigurationUpdate(config: Configuration) {
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后5秒内无操作将会被清理。
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onConfigurationUpdate:' + JSON.stringify(config));
  }

  onAcquireFormState(want: Want) {
    // 卡片提供方接收查询卡片状态通知接口，默认返回卡片初始状态。
    return formInfo.FormState.READY;
  }
  // [EndExclude js_card_form_ability]
  // [EndExclude remove_form_interface]
  // [EndExclude update_form_interface]
  // [EndExclude receive_message_interface]
}
// [End js_card_form_ability]
// [End remove_form_interface]
// [End update_form_interface]
// [End receive_message_interface]