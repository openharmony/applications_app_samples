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
import Want from '@ohos.app.ability.Want';
import StartOptions from '@ohos.app.ability.StartOptions';
import { BusinessError } from '@ohos.base';
import { Caller } from '@ohos.app.ability.UIAbility';

const TAG: string = '[Page_UIAbilityComponentsInteractive]';
const DOMAIN_NUMBER: number = 0xFF00;


@Entry
@Component
struct Page_UIAbilityComponentsInteractive {
  private context = getContext(this) as common.UIAbilityContext;
  private callbackId: number = 0; // 注册订阅系统环境变化的ID

  unsubscribeConfigurationUpdate() {
    let applicationContext = this.context.getApplicationContext();
    applicationContext.off('environment', this.callbackId);
  }

  caller: Caller | undefined = undefined;
  // 注册caller的release监听
  private regOnRelease(caller: Caller): void {
    hilog.info(DOMAIN_NUMBER, TAG, `caller is ${caller}`);
    try {
      caller.on('release', (msg: string) => {
        hilog.info(DOMAIN_NUMBER, TAG, `caller onRelease is called ${msg}`);
      })
      hilog.info(DOMAIN_NUMBER, TAG, 'succeeded in registering on release.');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to caller register on release. Code is ${code}, message is ${message}`);
    };
  };

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.UIAbilityComponentsInteractive'))
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
              Text($r('app.string.UIAbilityComponentsInteractionA'))
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
            // context为Ability对象的成员，在非Ability对象内部调用需要
            // 将Context对象传递过去
            let wantInfo: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilitydevelop',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityA',
              parameters: { // 自定义信息
                info: '来自EntryAbility Page_UIAbilityComponentsInteractive页面'
              },
            };
            // context为调用方UIAbility的UIAbilityContext
            this.context.startAbility(wantInfo).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success.');
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, 'startAbility failed.');
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
              Text($r('app.string.UIAbilityComponentsInteractionB'))
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
            const RESULT_CODE: number = 1001;

            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilitydevelop',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityA',
              parameters: { // 自定义信息
                info: '来自EntryAbility UIAbilityComponentsInteractive页面'
              }
            };
            context.startAbilityForResult(want).then((data) => {
              if (data?.resultCode === RESULT_CODE) {
                // 解析被调用方UIAbility返回的信息
                let info = data.want?.parameters?.info;
                hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(info) ?? '');
                if (info !== null) {
                  promptAction.showToast({
                    message : JSON.stringify(info)
                  });
                }
              }
              hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(data.resultCode) ?? '');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability for result. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.UIAbilityComponentsInteractionC'))
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
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              // uncomment line below if wish to implicitly query only in the specific bundle.
              // bundleName: 'com.samples.stagemodelabilityinteraction',
              action: 'ohos.want.action.viewData',
              // entities can be omitted.
              entities: ['entity.system.default']
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting FuncAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start FuncAbility. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.UIAbilityComponentsInteractionE'))
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
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilitydevelop',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityB',
              parameters: { // 自定义信息
                info: '来自EntryAbility Index页面'
              }
            };
            let options: StartOptions = {
              windowMode: AbilityConstant.WindowMode.WINDOW_MODE_FLOATING
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want, options).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.UIAbilityComponentsInteractionF'))
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
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbility',
              parameters: { // 自定义参数传递页面信息
                router: 'FuncA'
              }
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.UIAbilityComponentsInteractionG'))
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
            let context = getContext(this) as common.UIAbilityContext;
            let wantInfo: Want = {
              // uncomment line below if wish to implicitly query only in the specific bundle.
              // bundleName: 'com.samples.stagemodelabilityinteraction',
              action: 'ohos.want.action.viewData',
              // entities can be omitted.
              entities: ['entity.system.browsable'],
              uri: 'https://www.test.com:8080/query/student'
            };
            context.startAbility(wantInfo).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting TUri.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start Uri. Code is ${err.code}, message is ${err.message}`);
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.UIAbilityComponentsInteractionH'))
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
            let context = getContext(this) as common.UIAbilityContext;
            let wantInfo: Want = {
              // uncomment line below if wish to implicitly query only in the specific bundle.
              // bundleName: 'com.samples.stagemodelabilityinteraction',
              action: 'ohos.want.action.search',
              // entities can be omitted.
              entities: ['entity.system.browsable'],
              uri: 'https://www.test.com:8080/query/student',
              type: 'application/http'
            };
            context.startAbility(wantInfo).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting tjyUri.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start Uri. Code is ${err.code}, message is ${err.message}`);
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.UIAbilityComponentsInteractionOnCreate'))
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
            let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'EntryAbility',
              parameters: { // 自定义参数传递页面信息
                router: 'funcA'
              }
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.UIAbilityComponentsInteractionOnNewWant'))
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
            let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'EntryAbility',
              parameters: { // 自定义参数传递页面信息
                router: 'funcB'
              }
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in starting ability.`);
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
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
              Text($r('app.string.Caller'))
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
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'CalleeAbility',
              parameters: { // 自定义信息
                info: 'CallSendMsg'
              }
            };

            context.startAbilityByCall(want).then((caller: Caller) => {
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in starting ability.Code is ${caller}`);
              if (caller === undefined) {
                hilog.info(DOMAIN_NUMBER, TAG, 'get caller failed');
                return;
              }
              else {
                hilog.info(DOMAIN_NUMBER, TAG, 'get caller success');
                this.regOnRelease(caller);
                promptAction.showToast({
                  message: $r('app.string.CallerSuccess')
                });
                try {
                  caller.release();
                } catch (releaseErr) {
                  console.log('Caller.release catch error, error.code: ' + JSON.stringify(releaseErr.code) +
                  ' error.message: ' + JSON.stringify(releaseErr.message));
                }
              }
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
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