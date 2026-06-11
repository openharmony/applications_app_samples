'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start update_by_status_form_ability]
// entry/src/main/ets/entryformability/EntryFormAbility.ets

import { Want } from '@kit.AbilityKit';
import preferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit';
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppStorage } from '@ohos.arkui.stateManagement';
import { Configuration } from '@ohos.app.ability.Configuration';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;

class JsonData {
  public selectA: boolean = false;
  public selectB: boolean = false;
}

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
  hilog.info(DOMAIN_NUMBER, TAG, 'OnAcquireFormState register success');
  return formInfo.FormState.READY;
}


export default class EntryFormAbility extends FormExtensionAbility {
  constructor() {
    hilog.info(DOMAIN_NUMBER, TAG, 'constructor register call');
    try {
      this.onStop = () => {
        hilog.info(DOMAIN_NUMBER, TAG, 'OnStop callback success');
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'OnStop register success');
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `OnStop catch error code: ${err?.code}, message: ${err?.message}`);
    }

    this.onAcquireFormState = onAcquireFormStateCallback;
  }

  onAddForm(want: Want): formBindingData.FormBindingData {
    let formId: string = '';
    let wants = want?.parameters;
    if (wants) {
      formId = wants[formInfo.FormParam.IDENTITY_KEY] as string;
      let promise: Promise<preferences.Preferences> = preferences.getPreferences(this.context, 'myStore');
      promise.then(async (storeDB: preferences.Preferences) => {
        hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
        await storeDB.put('A' + formId, 'false');
        await storeDB.put('B' + formId, 'false');
        await storeDB.flush();
      }).catch((err) => {
        hilog.error(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
      });
    }
    let formData: Record<string, Object | string> = {};
    return formBindingData.createFormBindingData(formData);
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    let promise: Promise<preferences.Preferences> = preferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB: preferences.Preferences) => {
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
    }).catch((err) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to get preferences. ${JSON.stringify(err)}`);
    });
  }

  onFormEvent(formId: string, message: string): void {
    // 存放卡片状态
    hilog.info(DOMAIN_NUMBER, TAG, `doy onFormEvent formId ${formId}, message ${message}`);
    let promise: Promise<preferences.Preferences> = preferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB: preferences.Preferences) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
      let msg: JsonData = JSON.parse<JsonData>(message, Type.from<JsonData>())!;
      if (msg.selectA !== undefined) {
        hilog.info(DOMAIN_NUMBER, TAG, `onFormEvent selectA info: ${msg.selectA}`);
        await storeDB.put('A' + formId, msg.selectA);
      }
      if (msg.selectB !== undefined) {
        hilog.info(DOMAIN_NUMBER, TAG, `onFormEvent selectB info: ${msg.selectB}`);
        await storeDB.put('B' + formId, msg.selectB);
      }
      await storeDB.flush();
    }).catch((err) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. code: ${err.code}, message: ${err.message}`);
    });
  }

  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onRemoveForm, formId: ${formId}`);
    let promise = preferences.getPreferences(this.context, 'myStore');
    promise.then(async (storeDB: preferences.Preferences) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded to get preferences.');
      await storeDB.delete('A' + formId);
      await storeDB.delete('B' + formId);
    }).catch((err) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to get preferences. code: ${err.code}, message: ${err.message}`);
    });
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormLocationChanged testing');
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onChangeFormVisibility testing');
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm testing');
  }
}

// [End update_by_status_form_ability]