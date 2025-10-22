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
// [Start FormUpdate_page]
import { formHost } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';

let storage = new LocalStorage();

@Entry(storage)
@Component
struct Index {
  @State formId: string = '0';

  build() {
    Column() {
      Column() {
        FormComponent({
          id: 0,
          name: 'widget',
          bundle: 'com.samples.formupdatedemo', // 使用自己的bundlename
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: 2,
          temporary: false,
        })
          .size({
            width:200,
            height:200,
          })
          .borderColor(Color.Black)
          .borderRadius(10)
          .borderWidth(1)
          .onAcquired((form: FormCallbackInfo) => {
            console.log(`onAcquired: ${JSON.stringify(form)}`)
            this.formId = form.id.toString();
          })
          .onRouter(() => {
            console.log(`onRouter`)
          })
          .onError((error) => {
            console.error(`onError: ${JSON.stringify(error)}`)
          })
        // [StartExclude FormUpdate_page]
        Text(`formId:${this.formId}`)
          .fontSize(25)
          .margin(10)
        // [EndExclude FormUpdate_page]
        Button($r('app.string.button_update'))
          .onClick(() => {
            console.info(`click to check requestForm, formId: ${this.formId}`);
            // formId需要为实际需要刷新的卡片ID
            if (this.formId != null) {
              formHost.requestForm(this.formId).then(() => {
                console.info('EntryFormAbility requestForm success.');
              }).catch((error: BusinessError) => {
                console.error(`EntryFormAbility requestForm fail, code: ${error?.code}, message: ${error?.message}`);
                console.error(`EntryFormAbility requestForm fail, code: ${this.formId}`);
              })
            }
          })
          .margin(5)
          .width('50%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
// [End FormUpdate_page]