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

// [Start FormEditDemo_FormEditExtension]
// entry/src/main/ets/pages/FormEditExtension.ets
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { ExtensionEvent } from '../model/ExtensionEvent';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { formBindingData, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PreferencesUtil } from '../common/PreferencesUtil';
import { FormData } from '../common/CommonData';
import { preferences } from '@kit.ArkData';
import FormEditExtensionContext from 'application/FormEditExtensionContext';

const TAG: string = 'FormEditDemo[Extension] -->';
let storage: LocalStorage = ExtensionEvent.getStorage();
const DOMAIN = 0xFF00;

@Entry(storage)
@Component
struct FormEditExtension {
  context1 = this.getUIContext().getHostContext();
  @State message1: string = this.context1!.resourceManager.getStringSync($r('app.string.button_one').id);
  @State message2: string = this.context1!.resourceManager.getStringSync($r('app.string.button_two').id);
  private formId: string = storage.get('formId') as string;
  private previewFormId: string = storage.get('previewFormId') as string;
  private session: UIExtensionContentSession =
    storage.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  private extensionEvent: ExtensionEvent = storage.get<ExtensionEvent>('extensionEvent') as ExtensionEvent;
  private context: FormEditExtensionContext =
    storage.get<FormEditExtensionContext>('context') as FormEditExtensionContext;

  updateForm(message: string) {
    if (!this.formId && !this.previewFormId) {
      return;
    }
    let param: Record<string, string> = {
      'message': message
    }
    let util = PreferencesUtil.getInstance();
    let preferences = util.getPreferences(this.context) as preferences.Preferences;
    util.preferencesPut(preferences, this.formId, new FormData(this.formId, message));
    let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    try {
      formProvider.updateForm(this.formId, obj, (error: BusinessError) => {
        if (error) {
          hilog.error(DOMAIN, TAG, `callback error, code: ${error.code}, message: ${error.message})`);
          return;
        }
        hilog.info(DOMAIN, TAG, `formProvider updateForm success`);
      });
    } catch (error) {
      hilog.error(DOMAIN, TAG, `catch error, code: ${JSON.stringify(error)})`);
    }
    if (!this.previewFormId) {
      hilog.error(DOMAIN, TAG, 'previewFormId is empty');
      return;
    }
    try {
      formProvider.updateForm(this.previewFormId, obj, (error: BusinessError) => {
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

  onPageShow() {
    hilog.info(DOMAIN, TAG,
      `${TAG} onPageShow. extensionEvent: ${JSON.stringify(this.extensionEvent)}, session: ${JSON.stringify(this.session)}.`);
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
            hilog.info(DOMAIN, TAG, `${TAG} Button1 onClick ${storage.get('message')}`);
            this.updateForm(this.message1);
            storage.setOrCreate('message', this.message1);
          })
        Button($r('app.string.button_two'))
          .width('80%')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .onClick(() => {
            hilog.info(DOMAIN, TAG, `${TAG} Button2 onClick`);
            this.updateForm(this.message2);
            storage.setOrCreate('message', this.message2);
          })
        Button($r('app.string.button_three'))
          .width('80%')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .onClick(async () => {
            hilog.info(DOMAIN, TAG, `${TAG} Button onClick`);
            this.extensionEvent?.startFormEditSecondPage();
          })
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}

// [End FormEditDemo_FormEditExtension]