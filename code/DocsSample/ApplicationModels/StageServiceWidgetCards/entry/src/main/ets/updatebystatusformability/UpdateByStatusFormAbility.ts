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

import type Base from '@ohos.base';
import dataPreferences from '@ohos.data.preferences';
import formInfo from '@ohos.app.form.formInfo';
import formProvider from '@ohos.app.form.formProvider';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import hilog from '@ohos.hilog';
import type Want from '@ohos.app.ability.Want';

const TAG: string = 'UpdateByStatusFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class UpdateByStatusFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    let formId: string = '';
    let isTempCard: boolean;
    if (want.parameters) {
      formId = JSON.stringify(want.parameters[formInfo.FormParam.IDENTITY_KEY]);
      isTempCard = want.parameters[formInfo.FormParam.TEMPORARY_KEY] as boolean;
      if (isTempCard === false) { // 如果为常态卡片，直接进行信息持久化
        hilog.info(DOMAIN_NUMBER, TAG, 'Not temp card, init db for:' + formId);
        let promise: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(this.context, 'myStore');
        promise.then(async (storeDB: dataPreferences.Preferences) => {
          hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
          await storeDB.put('A' + formId, 'false');
          await storeDB.put('B' + formId, 'false');
          await storeDB.flush();
        }).catch((err: Base.BusinessError) => {
          hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
        });
      }
    }
    let formData: Record<string, Object | string> = {};
    return formBindingData.createFormBindingData(formData);
  }

  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoveForm, formId:' + formId);
    let promise = dataPreferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
      await storeDB.delete('A' + formId);
      await storeDB.delete('B' + formId);
    }).catch((err: Base.BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
    });
  }

  // 如果在添加时为临时卡片，则建议转为常态卡片时进行信息持久化
  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm, formId:' + formId);
    let promise: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB: dataPreferences.Preferences) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
      await storeDB.put('A' + formId, 'false');
      await storeDB.put('B' + formId, 'false');
      await storeDB.flush();
    }).catch((err: Base.BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
    });
  }

  onUpdateForm(formId: string): void {
    let promise: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB: dataPreferences.Preferences) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences from onUpdateForm.');
      let stateA = await storeDB.get('A' + formId, 'false');
      let stateB = await storeDB.get('B' + formId, 'false');
      // A状态选中则更新textA
      if (stateA === 'true') {
        let param: Record<string, string> = {
          'textA': 'AAA'
        };
        let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
        await formProvider.updateForm(formId, formInfo);
      }
      // B状态选中则更新textB
      if (stateB === 'true') {
        let param: Record<string, string> = {
          'textB': 'BBB'
        };
        let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
        await formProvider.updateForm(formId, formInfo);
      }
      hilog.info(DOMAIN_NUMBER, TAG, `Update form success stateA:${stateA} stateB:${stateB}.`);
    }).catch((err: Base.BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
    });
  }

  onFormEvent(formId: string, message: string): void {
    // 存放卡片状态
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormEvent formId:' + formId + 'msg:' + message);
    let promise: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB: dataPreferences.Preferences) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
      let msg: Record<string, string> = JSON.parse(message);
      if (msg.selectA !== undefined) {
        hilog.info(DOMAIN_NUMBER, TAG, 'onFormEvent selectA info:' + msg.selectA);
        await storeDB.put('A' + formId, msg.selectA);
      }
      if (msg.selectB !== undefined) {
        hilog.info(DOMAIN_NUMBER, TAG, 'onFormEvent selectB info:' + msg.selectB);
        await storeDB.put('B' + formId, msg.selectB);
      }
      await storeDB.flush();
    }).catch((err: Base.BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
    });
  }
}