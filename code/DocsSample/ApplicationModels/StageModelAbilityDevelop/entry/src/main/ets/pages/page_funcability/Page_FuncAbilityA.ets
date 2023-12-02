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

const TAG: string = '[Page_FuncAbilityA]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_FuncAbilityA {

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.SpecifiedPageA'))
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
              Text($r('app.string.CloseSpecifiedPage'))
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
            const RESULT_CODE: number = 1001;
            let abilityResult: common.AbilityResult = {
              resultCode: RESULT_CODE,
              want: {
                bundleName: 'com.samples.stagemodelabilitydevelop',
                moduleName: 'entry', // moduleName非必选
                abilityName: 'FuncAbilityB',
                parameters: {
                  info: '来自FuncAbility Index页面'
                },
              },
            };
            context.terminateSelfWithResult(abilityResult, (err) => {
              if (err.code) {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self with result. Code is ${err.code}, message is ${err.message}`);
                return;
              }
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
              Text($r('app.string.CloseSpecifiedPageA'))
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
            const RESULT_CODE: number = 1001;
            let abilityResult: common.AbilityResult = {
              resultCode: RESULT_CODE,
              want: {
                bundleName: 'com.samples.stagemodelabilitydevelop',
                moduleName: 'entry', // moduleName非必选
                abilityName: 'FuncAbilityB',
                parameters: {
                  info: '来自FuncAbility Index页面'
                },
              },
            };
            context.terminateSelfWithResult(abilityResult, (err) => {
              if (err.code) {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self with result. Code is ${err.code}, message is ${err.message}`);
                return;
              }
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