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

import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Configuration, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CASES, CaseCardUtils } from '../widget/utils/CaseCardUtils';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';


const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  // 获取数据并利用formProvider.updateForm更新到卡片
  async getData(formId: string) {
    let detail: CASES[] = [];
    let message = '';
    try {
      let value = await this.context.resourceManager.getRawFileContent('CasesData.txt');
      console.log('decodeToStringdecodeToString')
      message = util.TextDecoder.create().decodeToString(value);
      detail = CaseCardUtils.formatData(message);
      hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onFormEvent' + 'result:' + message);
      hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] getData' + 'detail:' + JSON.stringify(detail));
      class FormDataClass {
        public detail: CASES[] = detail;
      }
      let formData = new FormDataClass();
      let formInfo = formBindingData.createFormBindingData(formData);
      await formProvider.updateForm(formId, formInfo);
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, `FormAbility updateForm failed: ${JSON.stringify(error)}`);
    }
  }

  onCastToNormalForm(formId: string): void {
    // 使用方将临时卡片转换为常态卡片触发，提供方需要做相应的处理
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onCastToNormalForm' + formId);
  }

  async onUpdateForm(formId: string): Promise<void> {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onUpdateForm');
    this.getData(formId);
  }

  onChangeFormVisibility(newStatus: Record<string, number>): void {
    // 使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onChangeFormVisibility');
  }


  async onFormEvent(formId: string, message: string): Promise<void> {
    this.getData(formId);
  }

  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
  }

  onConfigurationUpdate(config: Configuration) {
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后10秒内无操作将会被清理。
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onConfigurationUpdate:' + JSON.stringify(config));
  }

  onAcquireFormState(want: Want) {
    // 卡片提供方接收查询卡片状态通知接口，默认返回卡片初始状态。
    return formInfo.FormState.READY;
  }
}
