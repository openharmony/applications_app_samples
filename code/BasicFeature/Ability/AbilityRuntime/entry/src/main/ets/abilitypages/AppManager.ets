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

import { appManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'AppManager';
const DOMAIN: number = 0xFF00;

@Entry
@Component
struct AppManager {
  private promptDuration: number = 2000;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.AppManager'))
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
      .height('7.18%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))
      .margin({
        top: '7.18%',
        bottom: '6.41%',
        left: '3.33%'
      })

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.isRunningInStabilityTestCallback'))
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
              .id('isRunningInStabilityTestCallback')
          }
          .onClick(() => {
            try {
              appManager.isRunningInStabilityTest((err, data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of isRunningInStabilityTest(callback) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `isRunningInStabilityTest(callback) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `isRunningInStabilityTest(callback) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.isRunningInStabilityTestPromise'))
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
              .id('isRunningInStabilityTestPromise')
          }
          .onClick(() => {
            try {
              appManager.isRunningInStabilityTest().then((data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of isRunningInStabilityTest(promise) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `isRunningInStabilityTest(promise) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `isRunningInStabilityTest(promise) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.isRamConstrainedDeviceCallback'))
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
              .id('isRamConstrainedDeviceCallback')
          }
          .onClick(() => {
            try {
              appManager.isRamConstrainedDevice((err, data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of isRamConstrainedDevice(callback) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `isRamConstrainedDevice(callback) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `isRamConstrainedDevice(callback) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.isRamConstrainedDevicePromise'))
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
              .id('isRamConstrainedDevicePromise')
          }
          .onClick(() => {
            try {
              appManager.isRamConstrainedDevice().then((data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of isRamConstrainedDevice(promise) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `isRamConstrainedDevice(promise) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `isRamConstrainedDevice(promise) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.getAppMemorySizeCallback'))
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
              .id('getAppMemorySizeCallback')
          }
          .onClick(() => {
            try {
              appManager.getAppMemorySize((err, data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of getAppMemorySize(callback) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `getAppMemorySize(callback) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `getAppMemorySize(callback) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.getAppMemorySizePromise'))
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
              .id('getAppMemorySizePromise')
          }
          .onClick(() => {
            try {
              appManager.getAppMemorySize().then((data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of getAppMemorySize(promise) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `getAppMemorySize(promise) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `getAppMemorySize(promise) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.getRunningProcessInformationCallback'))
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
              .id('getRunningProcessInformationCallback')
          }
          .onClick(() => {
            try {
              appManager.getRunningProcessInformation((err, data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of getRunningProcessInformation(callback) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `getRunningProcessInformation(callback) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `getRunningProcessInformation(callback) fail, err: ${JSON.stringify(err)}`);
            }
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.getRunningProcessInformationPromise'))
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
              .id('getRunningProcessInformationPromise')
          }
          .onClick(() => {
            try {
              appManager.getRunningProcessInformation().then((data) => {
                hilog.info(DOMAIN, TAG,
                  `The result of getRunningProcessInformation(promise) is: ${JSON.stringify(data)}`);
                promptAction.showToast({
                  message: `getRunningProcessInformation(promise) success, data: ${JSON.stringify(data)}`,
                  duration: this.promptDuration
                })
              })
            } catch (err) {
              hilog.info(DOMAIN, TAG, `getRunningProcessInformation(promise) fail, err: ${JSON.stringify(err)}`);
            }
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
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}