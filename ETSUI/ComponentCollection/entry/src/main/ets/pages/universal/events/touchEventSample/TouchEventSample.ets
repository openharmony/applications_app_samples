/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Entry
@Component
struct TouchEventSample {
  @State positionX: number = 200
  @State positionY: number = 100
  @State touchEventInfo: string = ''
  private touchAreaRight: number = 0
  private touchAreaBottom: number = 0

  build() {
    Column() {
      TitleBar({ title: $r('app.string.touch_event') })
      IntroductionTitle({ introduction: $r('app.string.touch_action_tips') })
      Column() {
        Row() {
          Text('+')
            .fontSize(28)
            .position({ x: this.positionX, y: this.positionY })
        }
        .height(200)
        .width('100%')
        .backgroundColor($r('app.color.background_shallow_grey'))
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.touchAreaRight = newValue.width as number
          this.touchAreaBottom = newValue.height as number
        })
        .onTouch((event: TouchEvent) => {
          let touchPointsCount = event.touches.length
          let touchPoint = event.touches[touchPointsCount - 1]
          if (touchPoint.x < 0 || touchPoint.y < 0 || touchPoint.x > this.touchAreaRight
          || touchPoint.y > this.touchAreaBottom) {
            return
          }
          this.positionX = touchPoint.x
          this.positionY = touchPoint.y
          let eventType = 'Down'
          if (event.type === TouchType.Down) {
            eventType = 'Down'
          } else if (event.type === TouchType.Up) {
            eventType = 'Up'
          } else if (event.type === TouchType.Move) {
            eventType = 'Move'
          }
          this.touchEventInfo
          = 'Touch Event:\n  Type:' + eventType + '\n  screenX: ' + touchPoint.screenX
          + '\n  screenY: ' + touchPoint.screenY + '\n  x: ' + touchPoint.x + '\n  y: ' + touchPoint.y
          + '\n  timestamp: ' + event.timestamp
          + '\nTarget:\n  globalPos: (' + event.target.area.globalPosition.x + ',' + event.target.area.globalPosition.y
          + ')\n  width:' + event.target.area.width + '\n  height:' + event.target.area.height
        })
      }
      .padding(12)
      .borderRadius(24)
      .backgroundColor(Color.White)
      // touch location information
      Text(this.touchEventInfo)
        .fontSize(18)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ left: 18, top: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
