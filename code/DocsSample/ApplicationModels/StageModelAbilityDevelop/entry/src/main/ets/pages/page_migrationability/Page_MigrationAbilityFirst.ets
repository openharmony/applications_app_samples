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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction'
import router from '@ohos.router';

const TAG: string = '[MigrationAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_MigrationAbilityFirst {
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.DeviceCrossMigration'))
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
          Row() {
            Row() {
              Text($r('app.string.Page_MigrationAbilitySecond'))
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
            router.pushUrl({
              url: 'pages/page_migrationability/Page_MigrationAbilitySecond'
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.Page_MigrationAbilityThird'))
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
            router.pushUrl({
              url: 'pages/page_migrationability/Page_MigrationAbilityThird'
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
              Text($r('app.string.Page_MigrationAbilityFourth'))
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
            // 点击该按钮时，将应用设置为可迁移状态
            this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
              hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', `setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
              promptAction.showToast({
                message: $r('app.string.Success')
              });
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

  onPageShow(){
    // 进入该页面时，将应用设置为可迁移状态
    this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', `setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
    });
  }
}