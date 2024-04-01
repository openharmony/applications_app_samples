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
import common from '@ohos.app.ability.common';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import CommonConstants from '../common/constants/CommonConstants';
import Logger from '../utils/Logger';

const TAG = '[testTag_Page_AsyncAbility]: ';

@Entry
@Component
struct Page_AsyncAbility {
  @StorageLink('testDate') testDate: string = '';
  @StorageLink('ability_isON') stoLink_ability_isON: boolean = true;
  private context = getContext(this) as common.UIAbilityContext;

  onPageShow() {
    // 进入该页面时，将应用设置为可迁移状态
    this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
      this.stoLink_ability_isON = true;
      Logger.info(TAG, `setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
    });
  }

  build() {
    Row() {
      Column() {
        Column() {
          TextInput({ text: this.testDate,
            placeholder: CommonConstants.PLEASE_INPUT_ASYNC_TEXT
          })
            .fontWeight(500)
            .fontSize(16)
            .textAlign(TextAlign.JUSTIFY)
            .align(Alignment.Center)
            .onChange((value: string) => {
              this.testDate = value;
              AppStorage.set('testDate', value);
              Logger.info(TAG, 'this.testDate: ' + this.testDate);
            })
            .type(InputType.Normal)
            .backgroundColor(Color.Transparent)
            .width(336)
            .height(64)
            .id('asyncTextInput')
        }
        .width(336)
        .height(64)
        .backgroundColor('#ffffff')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 16 })
      }
      .width('100%')
    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundColor('#f1f3f5')
  }
}