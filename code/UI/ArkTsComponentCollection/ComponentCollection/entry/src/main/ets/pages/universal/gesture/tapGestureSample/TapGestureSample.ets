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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .margin({ left: 12, right: 12 })
  .width('100%')
  .backgroundColor(Color.White)
}
@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .width('90%')
  .margin({ top: 20 })
  .padding({ left: 24, right: 24, top: 8, bottom: 8 })
}

@Entry
@Component
struct TapGestureExample {
  @State value: string = '';

  build() {
    Column() {
      TitleBar({ title: $r('app.string.tap_gesture') })
      Column() {
        IntroductionTitle({ introduction: $r('app.string.double_click') })
        Row() {
          Column() {
            Text(this.value)
              .fontSize(16)
          }
          .height(200)
          .width(300)
          .padding(20)
          .border({ width: 3 })
          .margin(30)
        }
        .justifyContent(FlexAlign.Center)
        .rowStyle()
        // 单指双击文本触发手势事件
        Button($r('app.string.double_click'))
          .commonButtonStyle()
          .id('tap_click')
          .gesture(
            TapGesture({ count: 2, fingers: 1 })
              .onAction((event: GestureEvent) => {
                this.value = getStringData($r('app.string.onAction')) + JSON.stringify(event.fingerList[0]);
              })
          )
      }
      .margin({ bottom: 80 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}