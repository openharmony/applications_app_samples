/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { TitleBar } from '../../../../common/TitleBar';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';

@Entry
@Component
struct ScrollEventSample {
  scroller: Scroller = new Scroller();
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.scroll_event') })
      Column({ space: 30 }) {
        IntroductionTitle({ introduction: $r('app.string.scroll_event_description') })
        Scroll() {
          Column() {
            Row() {
              Image($r('app.media.img_love'))
                .height(100)
                .width(100)
            }
            .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
              if (isVisible && currentRatio >= 1.0) {
                ShowToast.shortToast($r('app.string.scroll_event_toast_visible'));
              }

              if (!isVisible && currentRatio <= 0.0) {
                ShowToast.shortToast($r('app.string.scroll_event_toast_invisible'));
              }
            })

            ForEach(this.arr, (item: number) => {
              Text(item.toString())
                .width('100%')
                .height(80)
                .backgroundColor(0xFFFFFF)
                .borderRadius(24)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .margin({ left: 12, right: 12, top: 16 })
            }, (item: number) => JSON.stringify(item))
          }.width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor(Color.Gray)
        .scrollBarWidth(10)
        .margin({ bottom: 200 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}

