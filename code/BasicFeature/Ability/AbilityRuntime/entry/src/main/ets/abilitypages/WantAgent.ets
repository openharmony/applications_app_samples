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

import { wantAgent } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'WantAgent';
const DOMAIN: number = 0xFF00;

@Entry
@Component
struct WantAgentClass {
  private promptDuration: number = 2000;
  private wantAgentInfo: wantAgent.WantAgentInfo = {
    wants: [
      {
        bundleName: "com.samples.abilityruntime",
        abilityName: "EntryAbility",
      }
    ],
    operationType: wantAgent.OperationType.START_ABILITY,
    requestCode: 0,
    wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  }

  async getBundleNameCallback(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.getBundleName(dataBase, (err, data) => {
        hilog.info(DOMAIN, TAG,
          `The result of getBundleName(callback) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `getBundleName(callback) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async getBundleNamePromise(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.getBundleName(dataBase).then((data) => {
        hilog.info(DOMAIN, TAG,
          `The result of getBundleName(promise) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `getBundleName(promise) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async getUidCallback(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.getUid(dataBase, (err, data) => {
        hilog.info(DOMAIN, TAG,
          `The result of getUid(callback) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `getUid(callback) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async getUidPromise(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.getUid(dataBase).then((data) => {
        hilog.info(DOMAIN, TAG,
          `The result of getUid(promise) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `getUid(promise) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async cancelCallback(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.cancel(dataBase, (err, data) => {
        hilog.info(DOMAIN, TAG,
          `The result of cancel(callback) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `cancel(callback) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async cancelPromise(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.cancel(dataBase).then((data) => {
        hilog.info(DOMAIN, TAG,
          `The result of cancel(promise) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `cancel(promise) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async equalCallback(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.equal(dataBase, dataBase, (err, data) => {
        hilog.info(DOMAIN, TAG,
          `The result of equal(callback) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `equal(callback) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async equalPromise(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.equal(dataBase, dataBase).then((data) => {
        hilog.info(DOMAIN, TAG,
          `The result of equal(promise) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `equal(promise) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async getOperationTypeCallback(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.getOperationType(dataBase, (err, data) => {
        hilog.info(DOMAIN, TAG,
          `The result of getOperationType(callback) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `getOperationType(callback) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async getOperationTypePromise(): Promise<void> {
    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.getOperationType(dataBase).then((data) => {
        hilog.info(DOMAIN, TAG,
          `The result of getOperationType(promise) is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `getOperationType(promise) success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  async trigger(): Promise<void> {
    let triggerInfo: wantAgent.TriggerInfo = {
      code: 0,
      want: {
        bundleName: "com.samples.abilityruntime",
        abilityName: "EntryAbility",
      },
      permission: '',
      extraInfo: {
        test: 'this is a test value'
      }
    }

    wantAgent.getWantAgent(this.wantAgentInfo).then((dataBase) => {
      wantAgent.trigger(dataBase, triggerInfo, (err, data) => {
        hilog.info(DOMAIN, TAG,
          `The result of trigger is: ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: `trigger success, data: ${JSON.stringify(data)}`,
          duration: this.promptDuration
        })
      })
      console.info(`${TAG} getWantAgent  success: ${JSON.stringify(dataBase)}`)
    })
  }

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.WantAgent'))
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
            Text($r(`app.string.getBundleNameCallback`))
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
          .id('getBundleNameCallback')
          .onClick(() => {
            this.getBundleNameCallback();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.getBundleNamePromise`))
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
          .id('getBundleNamePromise')
          .onClick(() => {
            this.getBundleNamePromise();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.getUidCallback`))
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
          .id('getUidCallback')
          .onClick(() => {
            this.getUidCallback();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.getUidPromise`))
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
          .id('getUidPromise')
          .onClick(() => {
            this.getUidPromise();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.cancelCallback`))
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
          .id('cancelCallback')
          .onClick(() => {
            this.cancelCallback();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.cancelPromise`))
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
          .id('cancelPromise')
          .onClick(() => {
            this.cancelPromise();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.equalCallback`))
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
          .id('equalCallback')
          .onClick(() => {
            this.equalCallback();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.equalPromise`))
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
          .id('equalPromise')
          .onClick(() => {
            this.equalPromise();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.getOperationTypeCallback`))
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
          .id('getOperationTypeCallback')
          .onClick(() => {
            this.getOperationTypeCallback();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.getOperationTypePromise`))
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
          .id('getOperationTypePromise')
          .onClick(() => {
            this.getOperationTypePromise();
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r(`app.string.trigger`))
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
          .id('trigger')
          .onClick(() => {
            this.trigger();
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
  }
}