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

const TAG = 'TestTag_Setting: ';

@Entry
@Component
struct Settings {
  @StorageLink('ability_isON') stoLink_ability_isON: boolean = false;
  @StorageLink('pageStack_isON') stoLink_pageStack_isON: boolean = true;
  @StorageLink('sourceEnd_isON') stoLink_sourceEnd_isON: boolean = true;
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row }) {

          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .height(24)
              .margin({ right: 16 })
              .id('back_arrow_setting')

          }
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })

          Text(CommonConstants.MIGRATION_SETTINGS)
            .fontSize(20)
            .fontWeight(500)
            .margin({ top: 5 })

        }
        .margin({ top: 36, left: 24, bottom: 24 })
        .width(360)

        List() {

          ListItem() {
            Row() {
              Text(CommonConstants.MIGRATION_ABILITY)
                .fontSize(16)
              // 迁移能力
              Toggle({ type: ToggleType.Switch, isOn: this.stoLink_ability_isON })
                .onChange((isOn: boolean) => {
                  if (isOn) {
                    Logger.info('testTag: ' + 'isOn :' + isOn);
                    this.stoLink_ability_isON = isOn;
                    AppStorage.set('ability_isON', isOn);
                    this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
                      Logger.info(TAG, `setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
                    })
                  } else {
                    Logger.info('testTag: ' + 'isOn :' + isOn)
                    this.stoLink_ability_isON = isOn;
                    AppStorage.set('ability_isON', isOn);
                    this.context.setMissionContinueState(AbilityConstant.ContinueState.INACTIVE, (result) => {
                      Logger.info(TAG, `setMissionContinueState INACTIVE result: ${JSON.stringify(result)}`);
                    })
                  }
                })
                .restoreId(4)
                .id('toggle_ability_isOn')
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({ left: 12, right: 8 })
          }
          .height(48)


          ListItem() {
            Row() {
              Text(CommonConstants.MIGRATION_PAGE_STACK)
                .fontSize(16)

              // 迁移页面栈
              Toggle({ type: ToggleType.Switch, isOn: this.stoLink_pageStack_isON })
                .onChange((isOn: boolean) => {
                  this.stoLink_pageStack_isON = isOn;
                  AppStorage.setAndLink('pageStack_isON', isOn)
                  Logger.info(TAG, 'AppStorage.get<boolean>(pageStack_isON) :' +
                  AppStorage.get<boolean>('pageStack_isON'));
                })
                .restoreId(5)
                .id('toggle_pageStack_isOn')

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({ left: 12, right: 8 })
          }
          .height(48)

          ListItem() {
            Row() {
              Text(CommonConstants.MIGRATION_SOURCE_END)
                .fontSize(16)
              // 迁移后源端退出
              Toggle({ type: ToggleType.Switch, isOn: this.stoLink_sourceEnd_isON })
                .onChange((isOn: boolean) => {
                  this.stoLink_sourceEnd_isON = isOn;
                  AppStorage.set('sourceEnd_isON', isOn);
                  Logger.info(TAG, 'AppStorage.get(sourceEnd_isON) ' + JSON.stringify(AppStorage.get<string>('sourceEnd_isON')));
                })
                .restoreId(6)
                .id('toggle_sourceEnd_isOn')

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({ left: 12, right: 8 })
          }
          .height(48)
        }
        .restoreId(9)
        .backgroundColor(Color.White)
        .divider({
          strokeWidth: 0.5,
          color: 'rgba(0.0706,0.0941,0.1216,0.05)',
          startMargin: 12,
          endMargin: 8,
        })
        .borderRadius(24)
        .padding({ top: 4, bottom: 4 })
        .margin({ left: 12, right: 12 })
        .backgroundColor(Color.White)
        .width(336)
      }
      .width('100%')
    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundColor('#f1f3f5')
  }
}