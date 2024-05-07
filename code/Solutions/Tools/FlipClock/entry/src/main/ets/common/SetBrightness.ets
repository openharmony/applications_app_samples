/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import Logger from '../model/Logger';

@Component
export struct SetBrightness {

  build() {
    Column() {
      Button( $r('app.string.setting') , {type: ButtonType.Capsule})
        .id("Setting")
        .width('40%')
        .fontColor($r('app.color.text_normal'))
        .backgroundColor($r('app.color.btn_bg'))
        .onClick(() => {
          let want: Want = {
            bundleName: 'com.samples.brightness',
            abilityName: 'EntryAbility'
          };
          let context: common.UIAbilityContext | undefined = AppStorage.Get('context');
          context && context.startAbility(want,  (err) => {
            if (err.code) {
              Logger.error('StartAbility', `Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
            }
          });
        })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}