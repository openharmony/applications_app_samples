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

// 在启动指定实例模式的UIAbility时，给每一个UIAbility实例配置一个独立的Key标识
// 例如在文档使用场景中，可以用文档路径作为Key标识
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';

const TAG: string = '[Page_StartModel]';
const DOMAIN_NUMBER: number = 0xFF00;

function getInstance() : string {
  return 'KEY';
}

@Entry
@Component
struct Page_StartModel {
  private KEY_NEW = 'KEY';

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.UIAbilityComponentsStartModel'))
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
              Text($r('app.string.singleton'))
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
              let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
              let want: Want = {
                deviceId: '', // deviceId为空表示本设备
                bundleName: 'com.samples.stagemodelabilitydevelop',
                abilityName: 'SingletonAbility',
                moduleName: 'entry', // moduleName非必选
              };
              context.startAbility(want).then(() => {
              }).catch((err: BusinessError) => {
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
              Text($r('app.string.multiton'))
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
              let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
              let want: Want = {
                deviceId: '', // deviceId为空表示本设备
                bundleName: 'com.samples.stagemodelabilitydevelop',
                abilityName: 'MultitonAbility',
                moduleName: 'entry', // moduleName非必选
              };
              context.startAbility(want).then(() => {
              }).catch((err: BusinessError) => {
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
              Text($r('app.string.SpecifiedA'))
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
              let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
              // context为调用方UIAbility的UIAbilityContext;
              let want: Want = {
                deviceId: '', // deviceId为空表示本设备
                bundleName: 'com.samples.stagemodelabilitydevelop',
                abilityName: 'SpecifiedFirstAbility',
                moduleName: 'entry', // moduleName非必选
                parameters: { // 自定义信息
                  instanceKey: this.KEY_NEW
                }
              };
              context.startAbility(want).then(() => {
                hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting SpecifiedAbility.');
              }).catch((err: BusinessError) => {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
              });
              this.KEY_NEW = this.KEY_NEW + 'a';
            })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.SpecifiedB'))
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
            let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            // context为调用方UIAbility的UIAbilityContext;
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'SpecifiedSecondAbility',
              moduleName: 'entry', // moduleName非必选
              parameters: { // 自定义信息
                instanceKey: getInstance()
              }
            };
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting SpecifiedAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
            });
            this.KEY_NEW = this.KEY_NEW + 'a';
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