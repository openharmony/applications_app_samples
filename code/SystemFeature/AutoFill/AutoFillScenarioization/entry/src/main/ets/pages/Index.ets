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
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.scenarioization'))
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize($r('sys.float.ohos_id_text_size_headline6'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .padding({
              left: $r('sys.float.ohos_id_max_padding_start'),
              right: $r('sys.float.ohos_id_max_padding_end')
            })
        }.margin({ top: '14.2%' }).height('7.2%')


        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column() {
            Row() {
              Text($r('app.string.settingType'))
                .fontColor($r('app.color.TextColor'))
                .fontSize(14)
                .fontWeight(400)
                .textAlign(TextAlign.Start)
                .width('91%')
                .margin({ top: 5, left: -7.5 })
            }

            Row() {
              TextInput({ placeholder: $r('app.string.phone_Number'), text: this.inputTxt })
                .contentType(ContentType.FULL_PHONE_NUMBER)
                .height('9.4%')
                .width('91%')
                .fontWeight(FontWeight.Bolder)
                .placeholderColor($r('app.color.TextColor'))
                .backgroundColor($r('app.color.backgroundColor'))
                .id('password1')
                .fontSize(16)
                .fontWeight(400)
                .borderStyle(BorderStyle.Solid)
                .enableAutoFill(true)
                .borderRadius(25)
                .onChange(() => {
                })
                .margin({ top: '8vp' })
            }
          }.margin({ top: '7.1%' })
        }


        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column() {
            Row() {
              Text($r('app.string.setTypeName'))
                .fontColor($r('app.color.TextColor'))
                .fontSize(14)
                .fontWeight(400)
                .textAlign(TextAlign.Start)
                .width('91%')
                .margin({ top: 5, left: -7.5 })
            }

            Row() {
              TextInput({ placeholder: $r('app.string.person_Full_Name'), text: this.inputTxt })
                .contentType(ContentType.PERSON_FULL_NAME)
                .height('9.4%')
                .width('91%')
                .fontWeight(FontWeight.Bold)
                .placeholderColor($r('app.color.TextColor'))
                .backgroundColor($r('app.color.backgroundColor'))
                .fontSize(16)
                .fontWeight(400)
                .id('password3')
                .borderStyle(BorderStyle.Solid)
                .enableAutoFill(true)
                .borderRadius(25)
                .onChange(() => {
                })
                .margin({ top: '8vp' })
            }
          }
        }
        .margin({ top: '20vp' })
      }.height('70%')

      Column() {
        Button() {
          Text($r('app.string.saveData'))
            .fontSize(16)
            .fontWeight(400)
            .fontColor($r('app.color.backgroundColor'))
        }
        .type(ButtonType.Normal)
        .borderRadius(25)
        .margin({ bottom: '12vp' })
        .backgroundColor($r('app.color.cancelBtnColor'))
        .width('91%')
        .height('19.4%')
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
            .fontSize(16)
            .fontWeight(400)
            .fontColor($r('app.color.cancelBtnColor'))
        }
        .type(ButtonType.Normal)
        .borderRadius(25)
        .backgroundColor($r('app.color.mainInterface'))
        .width('91%')
        .height('19.4%')
        .margin({ bottom: '44px' })
        .id('changInterface')
        .onClick(() => {
          router.pushUrl({
            url: 'autofillpages/ReturnMainPage',
          })
        })
      }
      .height('30%')
      .justifyContent(FlexAlign.End)
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}