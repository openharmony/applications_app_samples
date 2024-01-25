/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import { getStringData } from '../../../../data/ResourceDataHandle';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import ShowToast from '../../../../util/ShowToast';
import Logger from '../../../../util/Logger';

const TAG: string = 'CustomClickEvent';

@Entry
@Component
struct CustomClickEvent {
  private btnFontColor: Resource = $r('app.color.white');

  isTouchPointInCircle(info: TouchTestInfo): boolean {
    let circleCenterX = info.rect.x + info.rect.width / 2;
    let circleCenterY = info.rect.y + info.rect.height / 2;
    let circleRadius = info.rect.width / 2;
    let distance = Math.sqrt((circleCenterX - info.parentX)**2 + (circleCenterY - info.parentY)**2);
    Logger.info(TAG, `isTouchPoinInCircle circleCenterX: ${circleCenterX}, circleCenterY: ${circleCenterY},\
     circleRadius: ${circleRadius}, distance: ${distance}`);
    if (distance <= circleRadius) {
      return true;
    }
    return false;
  }

  build() {
    Column() {
      // 标题
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .margin({ left: 24 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })
            .id('backBtn')
          Text($r('app.string.custom_click_event'))
            .fontSize(20)
            .layoutWeight(1)
            .fontWeight(700)
            .margin({ left: 16 })
            .align(Alignment.Start)
          Blank()
        }
        .height(56)
        .width('100%')
      }
      .height(56)
      .width('100%')

      Column() {
        // 大小圆圈
        Column({ space: 12 }) {
          Stack({ alignContent: Alignment.Bottom }) {
            Button({ type: ButtonType.Circle }) {
              Row() {
                Text($r('app.string.custom_click_big_btn'))
                  .fontSize(21)
                  .fontWeight(500)
                  .fontFamily('HarmonyHeiTi-Medium')
                  .textAlign(TextAlign.Center)
                  .padding({ top: 56, bottom: 300 })
              }
              .alignItems(VerticalAlign.Top)
            }
            .backgroundColor('#007DFF')
            .width('100%')
            .height('100%')
            .fontSize(21)
            .fontWeight(500)
            .id('BigCircle')
            .fontColor(this.btnFontColor)
            .onClick(() => {
              ShowToast.longToast($r('app.string.custom_bigcircle_prompt'));
            })

            Button($r('app.string.custom_click_small_btn'), { type: ButtonType.Circle })
              .backgroundColor('#F7CE00')
              .width(240)
              .fontSize(21)
              .fontWeight(500)
              .borderRadius(20)
              .fontColor(this.btnFontColor)
              .id('SmallCircle')
              .onClick(() => {
                ShowToast.longToast($r('app.string.custom_smallcircle_prompt'));
              })
          }
          .width('100%')
          .hitTestBehavior(HitTestMode.Block)
          .onChildTouchTest((touchinfo) => {
            Logger.info(TAG, `touchinfo array len: ${touchinfo.length}`);
            for(let i = 0; i < touchinfo.length; i++) {
              let info: TouchTestInfo = touchinfo[i];
              Logger.info(TAG, `touchinfo info.id: ${info.id}`);
              Logger.info(TAG, `touchinfo windowX: ${info.windowX}, windowY: ${info.windowY}`);
              Logger.info(TAG, `touchinfo parentX: ${info.parentX}, parentY: ${info.parentY}`);
              Logger.info(TAG, `touchinfo x: ${info.x}, y: ${info.y}`);
              Logger.info(TAG, `touchinfo rect.x: ${info.rect.x}, rect.y: ${info.rect.y}, rect.width: ${info.rect.width}, rect.height: ${info.rect.height}`);

              if (info.id == 'SmallCircle' && info.x > 0 && info.y > 0 && this.isTouchPointInCircle(info) == true) {
                Logger.info(TAG, `touchinfo touch point at scope of component: ${info.id}`);
                return { id: 'SmallCircle', strategy: TouchTestStrategy.FORWARD };
              }
              if (info.id == 'BigCircle' && info.x > 0 && info.y > 0 && this.isTouchPointInCircle(info) == true) {
                Logger.info(TAG, `touchinfo touch point at scope of component: ${info.id}`);
                return { id: 'BigCircle', strategy: TouchTestStrategy.FORWARD };
              }
            }
            return { strategy: TouchTestStrategy.DEFAULT };
          })
        }
        .padding({ left: 24, right: 24, bottom: 32 })

        // 文字提示
        Column() {
          Row() {
            Button({ type: ButtonType.Circle })
              .backgroundColor('#007DFF')
              .width(8)
              .height(8)
            Text($r('app.string.big_circle_prompt'))
              .fontSize(14)
              .fontWeight(400)
              .fontFamily('HarmonyHeiTi')
              .textAlign(TextAlign.Start)
              .margin({ left: 8 })
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Row() {
            Button({ type: ButtonType.Circle })
              .backgroundColor('#F7CE00')
              .width(8)
              .height(8)
            Text($r('app.string.small_circle_prompt'))
              .fontSize(14)
              .fontWeight(400)
              .fontFamily('HarmonyHeiTi')
              .textAlign(TextAlign.Start)
              .margin({ left: 8 })
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
      }
      .height('90%')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .flexShrink(1)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
