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

// [Start widget_event_router_entry_ability]
// entry/src/main/ets/widgetevententryability/WidgetEventRouterEntryAbility.ts
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'WidgetEventRouterEntryAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class WidgetEventRouterEntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleFormRouterEvent(want, 'onCreate');
  }

  handleFormRouterEvent(want: Want, source: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, `handleFormRouterEvent ${source}, Want: ${JSON.stringify(want)}`);
    if (want.parameters && want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
      let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY].toString();
      // want.parameters.params 对应 postCardAction() 中 params 内容
      let message: string = (JSON.parse(want.parameters?.params as string))?.routerDetail;
      hilog.info(DOMAIN_NUMBER, TAG, `UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData: Record<string, string> = {
        'routerDetail': message + ' ' + source + ' UIAbility', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData);
      formProvider.updateForm(curFormId, formMsg).then((data) => {
        hilog.info(DOMAIN_NUMBER, TAG, 'updateForm success.', JSON.stringify(data));
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN_NUMBER, TAG, `updateForm failed, error code: ${error.code}, error message: ${error.message}`);
      });
    }
  }

  // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onNewWant Want:', JSON.stringify(want));
    this.handleFormRouterEvent(want, 'onNewWant');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {

    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, `Failed to load the content. error code: ${err.code}, error message: ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }
}

// [End widget_event_router_entry_ability]