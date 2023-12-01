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

import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Logger from '../utils/Logger';
import CommonConstants from '../common/constants/CommonConstants';

const TAG = 'TestTag_Index: ';

@Entry
@Component
struct Index {
  @StorageLink('ability_isON') stoLink_ability_isON: boolean = true;
  private context = getContext(this) as common.UIAbilityContext;

  onPageShow() {
    // 进入该页面时，将应用设置为不可迁移状态
    this.context.setMissionContinueState(AbilityConstant.ContinueState.INACTIVE, (result) => {
      this.stoLink_ability_isON = false;
      Logger.info(TAG, `setMissionContinueState INACTIVE result: ${JSON.stringify(result)}`);
      Logger.info(TAG, ` AppStorage.get<boolean>('ability_isON') :  ${AppStorage.get<boolean>('ability_isON')}`);
    });
  }

  build() {
    Row() {
      Column() {

        Image(($r('app.media.png01xxxhdpi')))
          .width(80).height(80).margin({ top: 100 })

        Text(CommonConstants.HELLO)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0061C6')
          .margin({ top: 68, left: -146 })

        Text(CommonConstants.WELCOME_USE_JOT)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0061C6')
          .margin({ top: 10 })

        Button(CommonConstants.ENTER_IN, { type: ButtonType.Capsule, stateEffect: true })
          .backgroundColor(0x317aff)
          .width(312)
          .height(40)
          .fontSize(16)
          .margin({ top: 344 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Home' })
          })
          .id('enter_in_jot')

      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.welcome'))
      .backgroundImageSize(ImageSize.Cover)
    }
    .height('100%')
  }
}