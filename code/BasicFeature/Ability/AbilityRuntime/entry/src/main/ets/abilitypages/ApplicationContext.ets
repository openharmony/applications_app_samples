/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { font, promptAction } from '@kit.ArkUI';

const TAG: string = 'ApplicationContext';
const DOMAIN: number = 0xFF00;

@Entry
@Component
struct ApplicationContext {
  private promptDuration: number = 2000;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.ApplicationContext'))
            .fontSize(30)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({
              top: 8,
              bottom: 8,
              left: 12
            })
        }
      }
      .width('100%')
      .height('14.36%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.ApplicationContext_getCurrentAppCloneIndex'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('getCurrentAppCloneIndex')
          .onClick(() => {
            hilog.info(DOMAIN, TAG, 'ApplicationContext.getCurrentAppCloneIndex begin.');
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            let applicationContext = context.getApplicationContext();
            try {
              let index = applicationContext.getCurrentAppCloneIndex();
              let msg = `getCurrentAppCloneIndex  successfully, index: ${index}`;
              hilog.info(DOMAIN, TAG, msg);
              promptAction.showToast({
                message: msg,
                duration: this.promptDuration
              })
            } catch (error) {
              hilog.info(DOMAIN, TAG,
                `ApplicationContext.getCurrentAppCloneIndex fail, error: ${JSON.stringify(error)}`);
            }
            hilog.info(DOMAIN, TAG, 'ApplicationContext.getCurrentAppCloneIndex succeed.');
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.ApplicationContext_getRunningProcessInformation_callback'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('getRunningProcessInformationCallback')
          .onClick(() => {
            hilog.info(DOMAIN, TAG, 'ApplicationContext.getRunningProcessInformation callback  begin.');
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            let applicationContext = context.getApplicationContext();

            try {
              applicationContext.getRunningProcessInformation((err, data) => {
                let msg = `getRunningProcessInformation callback successfully, data: ${JSON.stringify(data)}`;
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({
                  message: msg,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG,
                `ApplicationContext.getRunningProcessInformation callback fail, error: ${JSON.stringify(err)}`);
            }
            hilog.info(DOMAIN, TAG, 'ApplicationContext.getRunningProcessInformation callback succeed.');
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.ApplicationContext_getRunningProcessInformation_promise'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('getRunningProcessInformationPromise')
          .onClick(() => {
            hilog.info(DOMAIN, TAG, 'ApplicationContext.getRunningProcessInformation promise begin.');
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            let applicationContext = context.getApplicationContext();

            try {
              applicationContext.getRunningProcessInformation().then((data) => {
                let msg = `getRunningProcessInformation promise successfully, data: ${JSON.stringify(data)}`;
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({
                  message: msg,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG,
                `ApplicationContext.getRunningProcessInformation promise fail, error: ${JSON.stringify(err)}`);
            }
            hilog.info(DOMAIN, TAG, 'ApplicationContext.getRunningProcessInformation promise succeed.');
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.ApplicationContext_setFont'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('setFont')
          .onClick(() => {
            font.registerFont({
              familyName: 'fontName',
              familySrc: $rawfile('font/Roboto-Regular.ttf')
            })

            hilog.info(DOMAIN, TAG, 'ApplicationContext.setFont begin.');
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            let applicationContext = context.getApplicationContext();

            try {
              applicationContext.setFont('fontName');
              let msg = `setFont successfully`;
              hilog.info(DOMAIN, TAG, msg);
              promptAction.showToast({
                message: msg,
                duration: this.promptDuration
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG,
                `ApplicationContext.setFont fail, error: ${JSON.stringify(err)}`);
            }
            hilog.info(DOMAIN, TAG, 'ApplicationContext.setFont succeed.');
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })
      }
      .height('86%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .height('100%')
    .width('100%')
  }
}