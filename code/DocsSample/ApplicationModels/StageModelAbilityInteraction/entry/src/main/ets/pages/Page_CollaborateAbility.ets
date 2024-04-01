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
import { BusinessError } from '@ohos.base';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[Page_CollaborateAbility]';

@Entry
@Component
struct Page_CollaborateAbility {

  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Text($r('app.string.Page_CollaborateAbility'))
          .fontSize(24)
          .fontWeight(700)
          .textAlign(TextAlign.Start)
          .margin({ top: 12, bottom: 11, right: 24, left: 24 })
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)

      Button($r('app.string.ClosePage_CollaborateAbility'))
        .fontFamily('HarmonyHeiTi')
        .height(48)
        .width('624px')
        .margin({ top: 550 })
        .type(ButtonType.Capsule)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('app.color.button_color'))
        .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .onClick(()=>{
          const RESULT_CODE: number = 1001;
          // context为目标端UIAbility的AbilityContext
          this.context.terminateSelfWithResult(
            {
              resultCode: RESULT_CODE,
              want: {
                bundleName: 'com.samples.stagemodelabilitydevelop',
                abilityName: 'CollaborateAbility',
                moduleName: 'entry',
                parameters: {
                  info: '来自Page_CollaborateAbility页面'
                }
              }
            },
            (err: BusinessError) => {
              hilog.info(DOMAIN_NUMBER, TAG, `terminateSelfWithResult err: ` + JSON.stringify(err));
            });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}