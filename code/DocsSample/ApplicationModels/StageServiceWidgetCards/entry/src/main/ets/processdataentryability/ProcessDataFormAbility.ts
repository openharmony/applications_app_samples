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

// [Start process_data_form_ability]
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

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
    // 卡片使用方查询卡片状态时触发该回调，默认返回初始状态。
    return formInfo.FormState.READY;
  }
}
// [End process_data_form_ability]