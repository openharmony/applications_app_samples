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

@Entry
@Component
struct CustomJudgeEvent {
  private btnFontColor: Resource = $r('app.color.white');
  @State message: string = '';

  build() {
    Column() {
      // 标题
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .margin({ left: 12 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })
            .id('backBtn')
          Text($r('app.string.custom_judge_title'))
            .fontSize(20)
            .layoutWeight(1)
            .fontWeight(700)
            .margin({ left: 16 })
            .align(Alignment.Start)
          Blank()
        }
        .height('100%')
        .width('100%')
      }
      .height(56)
      .width('100%')

      // 上半部分
      Stack() {
        Column() {
        }
        .height(340)
        .width('100%')
        .backgroundColor('#007DFF')
        .opacity(0.1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .id('longPressColumn')
        .border({
          width: 1,
          color: '#007DFF',
          radius: { topLeft: 24, topRight: 24, bottomLeft: 0, bottomRight: 0 },
          style: BorderStyle.Dotted
        })

        Text($r('app.string.custom_judge_long_press'))
          .fontSize(16)
          .fontWeight(400)
          .fontFamily(' HarmonyHeiTi')
          .textAlign(TextAlign.Center)
          .opacity(0.7)
          .fontColor('#007DFF')
          .id('longPressPrompt')
      }
      .id('longPressArea')
      .gesture(
        TapGesture()
          .tag("tap1") // 设置点击手势标志
      )
      .gesture(
        LongPressGesture()
          .tag("longPress1")// 设置长按手势标志
          .onAction(() => {
            this.message = 'longPress';
            ShowToast.longToast($r('app.string.custom_long_press_prompt'));
          })
      )
      .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        // 自定义判定标准
        if (gestureInfo.type == GestureControl.GestureType.LONG_PRESS_GESTURE &&
          gestureInfo.tag == 'longPress1' &&
          event.fingerList.length > 0 &&
          event.fingerList[0].localY < 340) {
          // 返回 CONTINUE 将保持系统判定。
          return GestureJudgeResult.CONTINUE;
        } else {
          return GestureJudgeResult.REJECT;
        }
      })

      // 下半部分
      Stack() {
        Column() {
        }
        .height(340)
        .width('100%')
        .backgroundColor('#F7CE00')
        .opacity(0.1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .id('clickColumn')
        .border({
          width: 1,
          color: '#F7BD00',
          radius: { topLeft: 0, topRight: 0, bottomLeft: 24, bottomRight: 24 },
          style: BorderStyle.Dotted
        })

        Text($r('app.string.custom_judge_click'))
          .fontSize(16)
          .fontWeight(400)
          .fontFamily(' HarmonyHeiTi')
          .textAlign(TextAlign.Center)
          .fontColor('#FF9900')
          .opacity(1)
          .id('clickTextPrompt')
      }
      .id('clickArea')
      .gesture(
        TapGesture()
          .tag("tap2")// 设置点击手势标志
          .onAction(() => {
            this.message = 'tap';
            ShowToast.longToast($r('app.string.custom_tap_prompt'));
          })
      )
      .gesture(
        LongPressGesture()
          .tag("longPress2")// 设置长按手势标志
          .onAction(() => {
            this.message = 'longPress'
          })
      )
      .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        // 自定义判定标准
        if (gestureInfo.type == GestureControl.GestureType.TAP_GESTURE &&
          gestureInfo.tag == 'tap2' &&
          event.fingerList.length > 0 &&
          event.fingerList[0].localY <= 340) {
          // 返回 CONTINUE 将保持系统判定。
          return GestureJudgeResult.CONTINUE;
        } else {
          return GestureJudgeResult.REJECT;
        }
      })
    }
    .height('100%')
    .width('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
