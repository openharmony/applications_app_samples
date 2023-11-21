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

import featureAbility from '@ohos.ability.featureAbility';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.main_title'))
            .fontSize(24)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({ top: 12, bottom: 11, right: 24, left: 24 })
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.PageAbility_Component_Develop'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))

            Row() {
              Text($r('app.string.SingleDevice'))
                .textAlign(TextAlign.End)
                .fontWeight(500)
                .margin({ top: 19, bottom: 18 })
                .fontSize(14)
                .width(64)
                .height(19)
                .fontColor($r('app.color.text_color'))
                .opacity(0.6)

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, bottom: 16, right: 6 })
            }
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/pagePageAbilityFirst'
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.PageAbility_Component_Develop'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))

            Row() {
              Text($r('app.string.multi_device'))
                .textAlign(TextAlign.End)
                .fontWeight(500)
                .margin({ top: 19, bottom: 18 })
                .fontSize(14)
                .width(64)
                .height(19)
                .fontColor($r('app.color.text_color'))
                .opacity(0.6)

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, bottom: 16, right: 6 })
            }
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/pagePageAbilitySecond'
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.serviceAbility_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/pageServiceAbility'
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.dataAbility_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/pageDataAbility'
            });
            let array: Array<string> = ['ohos.permission.READ_CONTACTS', 'ohos.permission.WRITE_CONTACTS'];
            featureAbility.getContext().requestPermissionsFromUser(array, 1);
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.interflow_fa_and_stage_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(304)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/pageInterflowFaAndStage'
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })
      }
      .height('100%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor($r('app.color.backGrounding'))
  }
}