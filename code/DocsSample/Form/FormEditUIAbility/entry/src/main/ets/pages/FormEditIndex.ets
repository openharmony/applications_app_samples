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
// [Start FormEditUIAbility_FormEditIndex]
// entry/src/main/ets/pages/FormEditIndex.ets
import { formBindingData, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PreferencesUtil } from '../common/PreferencesUtil';
import { preferences } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xF811;
const TAG: string = 'FormEdit -->';

@Entry
@Component
struct FormEditIndex {
  @State message: string = 'Hello World';
  context1 = this.getUIContext().getHostContext();
  @State message1: string = this.context1!.resourceManager.getStringSync($r('app.string.button_one').id);
  @State message2: string = this.context1!.resourceManager.getStringSync($r('app.string.button_two').id);
  updateForm(message: string) {
    let util = PreferencesUtil.getInstance();
    let preferences = util.getPreferences(this.getUIContext().getHostContext() as Context) as preferences.Preferences;
    let formId: string = util.getValue(preferences) as string;
    if (!formId ) {
      hilog.info(DOMAIN, TAG, `1111111111`);
      return;
    }
    hilog.info(DOMAIN, TAG, `doy: formId: ${formId}, message: ${message}`)
    let param: Record<string, string> = {
      'message': message
    }
    let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    try {
      formProvider.updateForm(formId, obj, (error: BusinessError) => {
        if (error) {
          hilog.error(DOMAIN, TAG, `callback error, code: ${error.code}, message: ${error.message})`);
          return;
        }
        hilog.info(DOMAIN, TAG, `formProvider updateForm success`);
      });
    } catch (error) {
      hilog.error(DOMAIN, TAG, `catch error, code: ${JSON.stringify(error)})`);
    }
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.button_one'))
          .width('80%')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .onClick(() => {
            this.updateForm(this.message1);
          })
        Button($r('app.string.button_two'))
          .width('80%')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .onClick(() => {
            this.updateForm(this.message2);
          })
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

}
// [End FormEditUIAbility_FormEditIndex]