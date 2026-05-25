/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start update_by_formhost]
// [Start update_by_formprovider]
// entry/src/main/ets/pages/index.ets
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { formProvider, formHost } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;
let storage = new LocalStorage();

@Entry(storage)
@Component
struct Index {
  // [StartExclude update_by_formprovider]
  @State formId: string = '0';

  @Builder
  buildFormHostUpdate() {
    Column() {
      Text('FormHostUpdate')
      FormComponent({
        id: 0,
        name: 'widget',
        bundle: 'com.samples.formrefreshdemo', // 请开发者替换为实际的bundlename
        ability: 'EntryFormAbility',
        module: 'entry',
        dimension: 2,
        temporary: false,
      })
        .size({
          width: 200,
          height: 200,
        })
        .borderColor(Color.Black)
        .borderRadius(10)
        .borderWidth(1)
        .onAcquired((form: FormCallbackInfo) => {
          hilog.info(DOMAIN_NUMBER, TAG, `onAcquired: ${form.id}`)
          this.formId = form.id.toString();
        })
        .onRouter(() => {
          hilog.info(DOMAIN_NUMBER, TAG, `onRouter`)
        })
        .onError((error) => {
          hilog.error(DOMAIN_NUMBER, TAG, `onError: code: ${error?.errcode}, message: ${error?.msg}`)
        })
      // [StartExclude update_by_formhost]
      Text(`formId:${this.formId}`)
        .fontSize(25)
        .margin(10)
      // [EndExclude update_by_formhost]
      Button($r('app.string.button_update'))
        .onClick(() => {
          hilog.info(DOMAIN_NUMBER, TAG, `click to check requestForm, formId: ${this.formId}`);
          // formId需要为实际需要刷新的卡片ID
          if (this.formId != null) {
            formHost.requestForm(this.formId).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'EntryFormAbility requestForm success.');
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `EntryFormAbility requestForm fail, code: ${error?.code}, message: ${error?.message}`);
              hilog.error(DOMAIN_NUMBER, TAG, `EntryFormAbility requestForm fail, code: ${this.formId}`);
            })
          }
        })
        .margin(5)
        .width('50%')
    }
    .width('100%')
    .height('50%')
  }
  // [EndExclude update_by_formprovider]

  // [StartExclude update_by_formhost]
  @Builder
  buildFormProviderUpdate() {
    Column({ space: 20 }) {
      Text('FormProviderUpdate')
      Button('reloadForms')
        .onClick(() => {
          try {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let moduleName: string = 'entry';
            let abilityName: string = 'EntryFormAbility';
            let formName: string = 'ReloadByUIAbility';
            formProvider.reloadForms(context, moduleName, abilityName, formName).then((reloadNum: number) => {
              console.info(`reloadForms success, reload number: ${reloadNum}`);
            }).catch((error: BusinessError) => {
              console.error(`promise error, code: ${error.code}, message: ${error.message})`);
            });
          } catch (error) {
            console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
          }
        })
      Button('reloadAllForms')
        .onClick(() => {
          try {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            formProvider.reloadAllForms(context).then((reloadNum: number) => {
              console.info(`reloadAllForms success, reload number: ${reloadNum}`);
            }).catch((error: BusinessError) => {
              console.error(`promise error, code: ${error.code}, message: ${error.message})`);
            });
          } catch (error) {
            console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
          }
        })
    }
    .width('100%')
    .height('50%')
    .justifyContent(FlexAlign.Center)
  }
  // [EndExclude update_by_formhost]

  build() {
    Column() {
      // [StartExclude update_by_formhost]
      this.buildFormProviderUpdate()
      // [EndExclude update_by_formhost]
      // [StartExclude update_by_formprovider]
      this.buildFormHostUpdate()
      // [EndExclude update_by_formprovider]
    }
    .width('100%')
    .height('100%')
  }
}
// [End update_by_formprovider]
// [End update_by_formhost]