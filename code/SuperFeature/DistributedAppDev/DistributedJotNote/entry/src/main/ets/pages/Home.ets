/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import mainViewModel from '../viewmodel/MainViewModel';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Logger from '../utils/Logger';
import CommonConstants from '../common/constants/CommonConstants';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';

const TAG = 'testTag_Home: ';

@Entry
@Component
struct Home {
  @StorageLink('ability_isON') stoLink_ability_isON: boolean = true;
  @StorageLink('ContinueWork') inputTxt: string = '';
  @StorageLink('swiperIndex') swiperIndex: number = -1;
  @StorageLink('testDate') testDate: string = '';
  private swiperController: SwiperController = new SwiperController();
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
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Image($r('app.media.ic_set'))
              .width(20.81)
              .height(21.53)
              .id('settingsImg')
          }
          .width(50)
          .height(50)
          .margin({ left: 313.59, top: 17.22, right: 20 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Settings' })
          })
        }
        .width('100%')
        .height(56)
        .margin({ top: 36 })

        Column() {
          Text(CommonConstants.HOME_TITLE)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .width(312)
        .height(41)
        .margin({ left: '24px', top: '7px' })
        .alignItems(HorizontalAlign.Start)

        // 轮播图
        Column() {
          Swiper(this.swiperController) {
            ForEach(mainViewModel.getSwiperImages(), (img: Resource) => {
              Image(img).borderRadius(24)
            }, (img: Resource) => img.id.toString())
          }
          .id('swiper')
          .indicator( // 设置圆点导航点样式
            new DotIndicator()
              .color('rgba(235, 197, 210,50)')
              .selectedColor(Color.White))
          .margin({ top: 16 })
          .autoPlay(false)
          .index(1)
          .restoreId(1)
          .onChange((index: number) => {
            Logger.info(TAG, 'index: ' + index)
            this.swiperIndex = index;
            AppStorage.set('swiperIndex', index);
          })
        }
        .width(336)
        .height(188)

        // 笔记页
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.ic_note'))
              .margin({ left: 12 })
              .width(18)
              .height(22)
              .id('notePage')

            Text($r('app.string.NOTES_TITLE'))
              .width(244)
              .height(22)
              .fontSize(16)
              .lineHeight(22)
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .margin({ left: 19 })
              .fontFamily('HarmonyHeiTi')


            Row() {
              Image($r('app.media.ic_arrow'))
                .width(12)
                .height(12)
            }
            .width(24)
            .height(24)
            .margin({ left: 50 })

          }
          .width(336)
          .height(64)
        }
        .width(336)
        .height(64)
        .backgroundColor('#ffffff')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 16 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Notes' })
        })

        // 待办事项
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.ic_list'))
              .width(18)
              .height(22)
              .margin({ left: 12 })

            Text($r('app.string.TO_DO_LIST'))
              .width(244)
              .height(22)
              .fontSize(16)
              .lineHeight(22)
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .margin({ left: 19 })
              .id('todolist_btn')

            Row() {
              Image($r('app.media.ic_arrow'))
                .width(12)
                .height(12)
            }
            .width(24)
            .height(24)
            .margin({ left: 50 })

          }
          .width(336)
          .height(64)
        }
        .width(336)
        .height(64)
        .backgroundColor('#ffffff')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 16 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Todolist' })
        })

        // 图片墙
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.ic_image'))
              .width(24)
              .height(24)
              .margin({ left: 12 })

            Text($r('app.string.IMG_WALL_TITLE'))
              .width(244)
              .height(22)
              .fontSize(16)
              .lineHeight(22)
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .margin({ left: 19 })
              .id('imgWall_btn')

            Row() {
              Image($r('app.media.ic_arrow'))
                .width(12)
                .height(12)
            }
            .width(24)
            .height(24)
            .margin({ left: 50 })

          }
          .width(336)
          .height(64)
        }
        .width(336)
        .height(64)
        .backgroundColor('#ffffff')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 16 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/ImgWall' })
        })

        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Text($r('app.string.USE_ASYNC_SAVE_DATA'))
              .width(244)
              .height(22)
              .fontSize(16)
              .lineHeight(22)
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .margin({ left: 19 })
              .id('async_save_data')
          }
          .width(336)
          .height(64)
        }
        .width(336)
        .height(64)
        .backgroundColor('#ffffff')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 16 })
        .onClick(() => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          let want: Want = {
            bundleName: 'com.samples.distributedjotnote',
            abilityName: 'AsyncAbility'
          };
          context.startAbility(want).then(() => {
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to start MigrationAbility. Code is ${err.code}, message is ${err.message}`);
          });
        })

      }
      .width('100%')

    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundColor('#f1f3f5')
  }
}