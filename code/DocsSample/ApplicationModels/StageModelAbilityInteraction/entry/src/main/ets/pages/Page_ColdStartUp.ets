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

const TAG: string = '[Page_ColdStartUp]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_ColdStartUp {

  build() {
    Column() {
      Row() {
        Text($r('app.string.FunctionA'))
          .fontSize(24)
          .fontWeight(700)
          .textAlign(TextAlign.Start)
          .margin({ top: 12, bottom: 11, right: 24, left: 24 })
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)

      Button($r('app.string.FuncAbilityD'))
        .fontFamily('HarmonyHeiTi')
        .height(48)
        .width('624px')
        .margin({ top: 550 })
        .type(ButtonType.Capsule)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('app.color.button_color'))
        .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
          // 绑定点击事件
        .onClick(() => {
          let context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
          // context为需要停止的UIAbility实例的AbilityContext
          context.terminateSelf((err) => {
            if (err.code) {
              hilog.error(0x0000, TAG, `Failed to terminate self. Code is ${err.code}, message is ${err.message}`);
              return;
            }
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}