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

import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction'
import Want from '@ohos.app.ability.Want';

import { BusinessError } from '@ohos.base';

const TAG: string = '[Page_StartFAModel]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_StartFAModel {
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.StageModelinteractiveWithFAModel'))
            .fontSize(24)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({ top: 12 , bottom: 11 , right: 24 , left: 24})
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.StartFAModel'))
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
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let want: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.MainAbility'
            };
            this.context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Start Ability successfully.');
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Ability failed: ` + JSON.stringify(error));
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.StartFAModelWithResult'))
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
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let want: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.MainAbility',
            };
            this.context.startAbilityForResult(want).then((result) => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Ability verify result: ' + JSON.stringify(result));
              if (result !== null) {
                promptAction.showToast({
                  message : JSON.stringify(result)
                });
              }
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Ability failed: ` + JSON.stringify(error));
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.ServiceAbility'))
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
            let want: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.ServiceAbility',
            }
            let options: common.ConnectOptions = {
              onConnect: (elementName, proxy) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'onConnect called.');
                promptAction.showToast({
                  message: $r('app.string.ConnectFAServiceAbility')
                });
              },
              onDisconnect: (elementName) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'onDisconnect called.');
              },
              onFailed: (code) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'onFailed code is: ' + code);
              }
            };
            let connectionId = this.context.connectServiceExtensionAbility(want, options);
            hilog.info(DOMAIN_NUMBER, TAG, 'connectionId is ' + JSON.stringify(connectionId));
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.PageAbility'))
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
            let want: Want = {
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'ServiceExtAbility',
              parameters:{
                key: 'ConnectFaPageAbility'
              }
            }
            this.context.startServiceExtensionAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'startServiceExtensionAbility successfully');
            }).catch((err: BusinessError) =>{
              hilog.info(DOMAIN_NUMBER, TAG, 'startServiceExtensionAbility fail, err is: ' + JSON.stringify(err));
            })
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