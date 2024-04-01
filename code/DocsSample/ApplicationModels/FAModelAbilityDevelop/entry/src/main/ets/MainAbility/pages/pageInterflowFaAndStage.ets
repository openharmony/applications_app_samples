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
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';

const TAG: string = 'PageInterflowFaAndStage';
const domain: number = 0xFF00;

@Entry
@Component
struct PageInterflowFaAndStage {
  async startServiceAbility(): Promise<void> {
    try {
      let want: Want = {
        bundleName: 'com.samples.famodelabilitydevelop',
        abilityName: 'com.samples.famodelabilitydevelop.ServiceAbilityStartUIAbility'
      };
      await featureAbility.startAbility({ want });
      hilog.info(domain, TAG, `Start ServiceAbility succeed`);
    } catch (error) {
      hilog.error(domain, TAG, 'Start ServiceAbility failed with ' + error);
    }
  }

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.interflow_fa_and_stage_button'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
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
          Row() {
            Row() {
              Text($r('app.string.start_stage_noResult_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            let want: Want = {
              bundleName: 'ohos.samples.etsclock',
              abilityName: 'MainAbility'
            };
            featureAbility.startAbility({ want }).then((code) => {
              hilog.info(domain, TAG, 'Ability verify code: ' + JSON.stringify(code));
            }).catch((error: BusinessError) => {
              hilog.error(domain, TAG, 'Ability failed: ' + JSON.stringify(error));
            });

            let serviceWant: Want = {
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'ServiceExtAbility'
            };

            let faConnect: common.ConnectOptions = {
              onConnect: (elementName, proxy) => {
                hilog.info(domain, TAG, "FaConnection onConnect called.");
              },
              onDisconnect: (elementName) => {
                hilog.info(domain, TAG, "FaConnection onDisconnect called.");
              },
              onFailed: (code) => {
                hilog.info(domain, TAG, "FaConnection onFailed code is: " + code);
              }
            };
            let connectionId = featureAbility.connectAbility(serviceWant, faConnect);
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.start_stage_withResult_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            let want: Want = {
              bundleName: 'ohos.samples.etsclock',
              abilityName: 'MainAbility'
            };
            featureAbility.startAbilityForResult({ want }).then((result) => {
              hilog.info(domain, TAG, 'Ability verify result: ' + JSON.stringify(result));
            }).catch((error: BusinessError) => {
              hilog.error(domain, TAG, 'Ability failed: ' + JSON.stringify(error));
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
              Text($r('app.string.start_stage_service_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            this.startServiceAbility();
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