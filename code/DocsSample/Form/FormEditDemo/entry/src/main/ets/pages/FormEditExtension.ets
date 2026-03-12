/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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
import { common, UIExtensionContentSession } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { formBindingData, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ExtensionEvent } from '../model/ExtensionEvent';
import { PreferencesUtil } from '../common/PreferencesUtil';
import { FormData } from '../common/CommonData';

const TAG: string = 'FormEditDemo[Extension] -->';
let storage: LocalStorage = ExtensionEvent.getStorage();

@Entry(storage)
@Component
struct FormEditExtension {
  @State message1: string = '北京';
  @State message2: string = '上海';
  private formId: string = storage.get('formId') as string;
  private previewFormId: string = storage.get('previewFormId') as string;
  private session: UIExtensionContentSession =
    storage.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  private extensionEvent: ExtensionEvent = storage.get<ExtensionEvent>('extensionEvent') as ExtensionEvent;
  // 在API version 22以前，需要通过import LiveFormExtensionContext from 'application/LiveFormExtensionContext'; 导入LiveFormExtensionContext。
  // 该导入方式在DevEco Studio中标红，但不影响编译运行，可以直接使用LiveFormExtensionContext。在API version 22及以后，支持通过import { common } from '@kit.AbilityKit';
  // 导入LiveFormExtensionContext，并通过common.LiveFormExtensionContext的方式使用。
  private context: common.FormEditExtensionContext | undefined =
    storage.get<common.FormEditExtensionContext>('context');

  updateForm(message: string) {
    if (!this.formId && !this.previewFormId) {
      return;
    }
    if (this.context) {
      let util = PreferencesUtil.getInstance();
      let preferences = util.getPreferences(this.context) as preferences.Preferences;
      util.preferencesPut(preferences, this.formId, new FormData(this.formId, message));
    }
    let param: Record<string, string> = {
      'message': message
    }
    let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    try {
      // 刷新被编辑卡片的信息
      formProvider.updateForm(this.formId, obj, (error: BusinessError) => {
        if (error) {
          console.error(TAG, `callback error, code: ${error.code}, message: ${error.message})`);
          return;
        }
        console.info(TAG, `formProvider updateForm success`);
      });
    } catch (error) {
      console.error(TAG, `catch error, Code: ${error.code}, Message: ${error.message}`);
    }
    if (!this.previewFormId) {
      console.error(TAG, 'previewFormId is empty');
      return;
    }
    try {
      // 刷新预览卡片的信息
      formProvider.updateForm(this.previewFormId, obj, (error: BusinessError) => {
        if (error) {
          console.error(TAG, `callback error, code: ${error.code}, message: ${error.message})`);
          return;
        }
        console.info(TAG, `formProvider updateForm success`);
      });
    } catch (error) {
      console.error(TAG, `catch error, Code: ${error.code}, Message: ${error.message}`);
    }
  }

  onPageShow() {
    console.info(`${TAG} onPageShow. extensionEvent`);
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
            console.info(`${TAG} Button1 onClick ${storage.get('message')}`);
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
            console.info(`${TAG} Button2 onClick`);
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
            console.info(`${TAG} Button onClick`);
            // 拉起二级编辑页
            this.extensionEvent?.startFormEditSecondPage();
          })
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}

// [End FormEditDemo_FormEditExtension]