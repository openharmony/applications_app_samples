'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { Entry, Text, Column, ColumnOptions, Component, Button, ClickEvent } from '@ohos.arkui.component';
import { Tabs, TabContent, Color, FlexAlign  } from '@ohos.arkui.component';
import { FormComponent, FormInfo, FormDimension, FormCallbackInfo, $r } from '@ohos.arkui.component';
import { formProvider, formHost } from '@kit.FormKit';
import { State } from '@ohos.arkui.stateManagement'
import hilog from '@ohos.hilog'
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;

@Entry
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
        name: 'WidgetCard',
        bundle: 'com.zglee.app3', // 请开发者替换为实际的bundlename
        ability: 'EntryFormAbility',
        module: 'entry',
        dimension: FormDimension.Dimension_2_2,
        temporary: false,
      } as FormInfo)
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
        .onClick((e: ClickEvent) => {
          hilog.info(DOMAIN_NUMBER, TAG, `click to check requestForm, formId: ${this.formId}`);
          // formId需要为实际需要刷新的卡片ID
          if (this.formId != null) {
            formHost.requestForm(this.formId).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'EntryFormAbility requestForm success.');
            }).catch((error) => {
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
  }
  // [EndExclude update_by_formprovider]

  // [StartExclude update_by_formhost]
  @Builder
  buildFormProviderUpdate() {
    Column({ space: 20 } as ColumnOptions) {
      Text('FormProviderUpdate')
      Button('reloadForms')
        .onClick((e: ClickEvent) => {
          try {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let moduleName: string = 'entry';
            let abilityName: string = 'EntryFormAbility';
            let formName: string = 'WidgetCard' //'ReloadByUIAbility';
            formProvider.reloadForms(context, moduleName, abilityName, formName).then((reloadNum: int) => {
              console.info(`reloadForms success, reload number: ${reloadNum}`);
            }).catch((error) => {
              console.error(`promise error, code: ${error.code}, message: ${error.message})`);
            });
          } catch (error) {
            console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
          }
        })
      Button('reloadAllForms')
        .onClick((e: ClickEvent) => {
          try {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            formProvider.reloadAllForms(context).then((reloadNum: int) => {
              console.info(`reloadAllForms success, reload number: ${reloadNum}`);
            }).catch((error) => {
              console.error(`promise error, code: ${error.code}, message: ${error.message})`);
            });
          } catch (error) {
            console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
          }
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
  // [EndExclude update_by_formhost]

  build() {
    Column() {
      Tabs() {
        TabContent() {
          this.buildFormProviderUpdate()
        }.tabBar('formProvider').id('formProvider')
        TabContent() {
          this.buildFormHostUpdate()
        }.tabBar('formHost').id('formHost')
      }
      .width(360)
      .height(400)
      .backgroundColor('#F1F3F5')
      .id('tabsId')
    }.width('100%')
  }
}
