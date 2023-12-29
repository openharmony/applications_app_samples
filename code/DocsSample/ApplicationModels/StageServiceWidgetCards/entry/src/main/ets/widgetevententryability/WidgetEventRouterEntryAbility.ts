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

import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import type Base from '@ohos.base';
import formBindingData from '@ohos.app.form.formBindingData';
import formInfo from '@ohos.app.form.formInfo';
import formProvider from '@ohos.app.form.formProvider';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import type Want from '@ohos.app.ability.Want';
import type window from '@ohos.window';

const TAG: string = 'WidgetEventRouterEntryAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class WidgetEventRouterEntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleFormRouterEvent(want);
  }

  handleFormRouterEvent(want: Want): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'handleFormRouterEvent, Want:', JSON.stringify(want));
    if (want.parameters && want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
      let curFormId = JSON.stringify(want.parameters[formInfo.FormParam.IDENTITY_KEY]);
      let message: string = JSON.stringify(want.parameters.routerDetail);
      hilog.info(DOMAIN_NUMBER, TAG, `UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData: Record<string, string> = {
        routerDetail: message + 'UIAbility.', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData);
      formProvider.updateForm(want.parameters[formInfo.FormParam.IDENTITY_KEY] + '', formMsg).then((data) => {
        hilog.info(DOMAIN_NUMBER, TAG, 'updateForm success.', JSON.stringify(data));
      }).catch((error: Base.BusinessError) => {
        hilog.info(DOMAIN_NUMBER, TAG, 'updateForm failed.', JSON.stringify(error));
      });
    }
  }

  // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onNewWant Want:', JSON.stringify(want));
    if (want.parameters && want.parameters[formInfo.FormParam.IDENTITY_KEY] !== undefined) {
      let curFormId = JSON.stringify(want.parameters[formInfo.FormParam.IDENTITY_KEY]);
      let message: string = JSON.stringify(want.parameters.routerDetail);
      hilog.info(DOMAIN_NUMBER, TAG, `UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData: Record<string, string> = {
        routerDetail: message + 'onNewWant UIAbility.', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData);
      formProvider.updateForm(want.parameters[formInfo.FormParam.IDENTITY_KEY] + '', formMsg).then((data) => {
        hilog.info(DOMAIN_NUMBER, TAG, 'updateForm success.', JSON.stringify(data));
      }).catch((error: Base.BusinessError) => {
        hilog.info(DOMAIN_NUMBER, TAG, 'updateForm failed.', JSON.stringify(error));
      });
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }
}