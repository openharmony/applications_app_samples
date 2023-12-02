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

import contextConstant from '@ohos.app.ability.contextConstant';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction'
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';

const TAG: string = '[Page_Context]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_Context {

  private context = getContext(this) as common.UIAbilityContext;


  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.Context01'))
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
              Text($r('app.string.MethodOneForObtainingApplicationFilePath'))
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
            let applicationContext = this.context.getApplicationContext();
            let cacheDir = applicationContext.cacheDir;
            let tempDir = applicationContext.tempDir;
            let filesDir = applicationContext.filesDir;
            let databaseDir = applicationContext.databaseDir;
            let bundleCodeDir = applicationContext.bundleCodeDir;
            let distributedFilesDir = applicationContext.distributedFilesDir;
            let preferencesDir = applicationContext.preferencesDir;
            // 获取应用文件路径
            let filePath = tempDir + 'test.txt';
            hilog.info(DOMAIN_NUMBER, TAG, `filePath: ${filePath}`);
            if (filePath !== null) {
              promptAction.showToast({
                message: filePath
              });
            }
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.MethodOneTwoObtainingApplicationFilePath'))
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
            let cacheDir = this.context.cacheDir;
            let tempDir = this.context.tempDir;
            let filesDir = this.context.filesDir;
            let databaseDir = this.context.databaseDir;
            let bundleCodeDir = this.context.bundleCodeDir;
            let distributedFilesDir = this.context.distributedFilesDir;
            let preferencesDir = this.context.preferencesDir;
            // 获取应用文件路径
            let filePath = tempDir + 'test.txt';
            hilog.info(DOMAIN_NUMBER, TAG, `filePath: ${filePath}`);
            if (filePath !== null) {
              promptAction.showToast({
                message: filePath
              });
            }
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.SwitchToEL1'))
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
            // 存储普通信息前，切换到EL1设备级加密
            if (this.context.area === contextConstant.AreaMode.EL2) { // 获取area
              this.context.area = contextConstant.AreaMode.EL1; // 修改area
              promptAction.showToast({
                message: $r('app.string.SwitchToEL1')
              });
            }
            // 存储普通信息
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.SwitchToEL2'))
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
            // 存储敏感信息前，切换到EL2用户级加密
            if (this.context.area === contextConstant.AreaMode.EL1) { // 获取area
              this.context.area = contextConstant.AreaMode.EL2; // 修改area
              promptAction.showToast({
                message: $r('app.string.SwitchToEL2')
              });
            }
            // 存储敏感信息
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.Context04'))
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
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'ContextAbility',
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ContextAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ContextAbility. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.Context05'))
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
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'LifecycleAbility',
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting LifecycleAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start LifecycleAbility. Code is ${err.code}, message is ${err.message}`);
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