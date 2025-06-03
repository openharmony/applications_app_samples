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

import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import { logger } from '@ohos/common/src/main/ets/util/Logger';

@Component
export struct ProcessMessage {

  build() {
    Column() {
      Button() {
        Text($r('app.string.process'))
          .fontSize(16)
          .fontColor(Color.White)
      }
      .width('100%')
      .height(50)
      .type(ButtonType.Capsule)
      .onClick(() => {
        let context: common.UIAbilityContext | undefined = AppStorage.get('context');
        let want: Want = {
          bundleName: "com.samples.process_message",
          abilityName: "EntryAbility",
        };
        context && context.startAbility(want,  (err: BusinessError) => {
          if (err.code) {
            logger.error('StartAbility', `Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
          }
        });
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}