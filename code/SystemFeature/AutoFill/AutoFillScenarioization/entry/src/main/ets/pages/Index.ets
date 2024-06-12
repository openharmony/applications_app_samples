/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import { autoFillManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'autoFill';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Index {
  @State inputTxt: string = '';

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text($r('app.string.scenarioization'))
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(28)
      }.margin({ top: '1.8%', left: '5.9%' }).height('7.2%')


      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          Row() {
            Text($r('app.string.settingType'))
              .margin(10)
              .fontColor(Color.Black)
              .fontSize(18)
              .textAlign(TextAlign.Start)
              .width('80%')
              .margin({ top: 5, left: -45 })
          }

          Row() {
            TextInput({ placeholder: $r('app.string.phone_Number'), text: this.inputTxt })
              .contentType(ContentType.FULL_PHONE_NUMBER)
              .height('7%')
              .width('90%')
              .fontWeight(FontWeight.Bolder)
              .placeholderColor($r('app.color.placeholderColor'))
              .backgroundColor($r('app.color.backgroundColor'))
              .id('password1')
              .fontSize(16)
              .borderStyle(BorderStyle.Solid)
              .enableAutoFill(true)
              .borderRadius(25)
              .onChange(() => {
              })
              .margin({ top: 20 })
          }
        }
      }
      .margin({ top: '2.1%' })

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          Row() {
            Text($r('app.string.setTypeName'))
              .margin(10)
              .fontColor(Color.Black)
              .fontSize(18)
              .textAlign(TextAlign.Start)
              .width('80%')
              .margin({ top: 5, left: -45 })
          }

          Row() {
            TextInput({ placeholder: $r('app.string.person_Full_Name'), text: this.inputTxt })
              .contentType(ContentType.PERSON_FULL_NAME)
              .height('7%')
              .width('90%')
              .fontWeight(FontWeight.Bold)
              .placeholderColor($r('app.color.placeholderColor'))
              .backgroundColor($r('app.color.backgroundColor'))
              .fontSize(16)
              .id('password3')
              .borderStyle(BorderStyle.Solid)
              .enableAutoFill(true)
              .borderRadius(25)
              .onChange(() => {
              })
              .margin({ top: 20 })
          }
        }
      }
      .margin({ top: '2.1%' })

      Button() {
        Text($r('app.string.saveData'))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.backgroundColor'))
      }
      .type(ButtonType.Normal)
      .borderRadius(25)
      .margin({ bottom: 20, top: '67.4%' })
      .backgroundColor($r('app.color.cancelBtnColor'))
      .fontSize(35)
      .width('90%')
      .height('6.4%')
      .id('save')
      .onClick(() => {
        let context = AppStorage.get<UIContext>('uiContext');
        if (context == null) {
          hilog.info(DOMAIN_NUMBER, TAG, 'UIContext is null. ');
        }
        hilog.info(DOMAIN_NUMBER, TAG, 'UIContext: ', JSON.stringify(context));
        try {
          autoFillManager.requestAutoSave(context, {
            onSuccess: () => {
              hilog.info(DOMAIN_NUMBER, TAG, 'save request on success');
            },
            onFailure: () => {
              hilog.info(DOMAIN_NUMBER, TAG, 'save request on failure');
            }
          });
        } catch (err) {
          hilog.error(DOMAIN_NUMBER, TAG, 'save err', JSON.stringify(err));
        }
      })

      Button() {
        Text($r('app.string.switchInterface'))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.cancelBtnColor'))
      }
      .type(ButtonType.Normal)
      .borderRadius(25)
      .margin({ bottom: 20, top: 5 })
      .backgroundColor($r('app.color.mainInterface'))
      .fontSize(35)
      .width('90%')
      .height('6.4%')
      .id('changInterface')
      .onClick(() => {
        router.pushUrl({
          url: 'autofillpages/ReturnMainPage',
        })
      })
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}