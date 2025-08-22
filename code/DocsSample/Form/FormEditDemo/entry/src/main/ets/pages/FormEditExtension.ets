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

import { UIExtensionContentSession } from '@kit.AbilityKit';
import { ExtensionEvent } from '../model/ExtensionEvent';
import { formBindingData, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'FormEditDemo[Extension] -->';
let storage: LocalStorage = ExtensionEvent.getStorage();

@Entry(storage)
@Component
struct FormEditExtension {
  @State message1: string = 'message one';
  @State message2: string = 'message two';
  private formId: string | undefined = storage.get('formId')
  private previewFormId: string | undefined = storage.get('previewFormId')
  private session: UIExtensionContentSession | undefined = storage.get<UIExtensionContentSession>('session');
  private extensionEvent: ExtensionEvent | undefined = storage.get<ExtensionEvent>('extensionEvent');
  updateForm(message: string) {
    let param: Record<string, string> = {
      'message': message
    }
    let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    if (!this.formId) {
      console.error(TAG, 'formId is empty');
      return;
    }
    try {
      formProvider.updateForm(this.formId, obj, (error: BusinessError) => {
        if (error) {
          console.error(TAG, `callback error, code: ${error.code}, message: ${error.message})`);
          return;
        }
        console.log(TAG, `formProvider updateForm success`);
      });
    } catch (error) {
      console.error(TAG, `catch error, code: ${JSON.stringify(error)})`);
    }
    if (!this.previewFormId) {
      console.error(TAG, 'previewFormId is empty');
      return;
    }
    try {
      formProvider.updateForm(this.previewFormId, obj, (error: BusinessError) => {
        if (error) {
          console.error(TAG, `callback error, code: ${error.code}, message: ${error.message})`);
          return;
        }
        console.log(TAG, `formProvider updateForm success`);
      });
    } catch (error) {
      console.error(TAG, `catch error, code: ${JSON.stringify(error)})`);
    }
  }
  onPageShow() {
    console.info(`${TAG} onPageShow. extensionEvent: ${JSON.stringify(this.extensionEvent)}, session: ${JSON.stringify(this.session)}.`);
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
            this.extensionEvent?.startFormEditSecondPage();
          })
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}