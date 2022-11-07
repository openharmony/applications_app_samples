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
struct ClickEventSample {
  @State showClickEventInfo: string = ''
  @State crosshairPositionX: number = 200
  @State crosshairPositionY: number = 100

  build() {
    Column() {
      TitleBar({ title: $r('app.string.click_event') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.click_action_tips') })
          // Click event effect display
          Column() {
            Row() {
              Text('+')
                .fontSize(18)
                .position({ x: this.crosshairPositionX, y: this.crosshairPositionY })
            }
            .height(200)
            .width('100%')
            .backgroundColor($r('app.color.background_shallow_grey'))
            .onClick((event: ClickEvent) => {
              this.crosshairPositionX = event.x
              this.crosshairPositionY = event.y
              // Get click location information
              this.showClickEventInfo = 'Click Point: ' + '\n  screenX: ' + event.screenX + '\n  screenY: ' + event.screenY
              + '\n  x: ' + event.x + '\n  y: ' + event.y + '\ntarget: ' + '\n  component globalPos: ('
              + event.target.area.globalPosition.x + ',' + event.target.area.globalPosition.y + ')\n  width: '
              + event.target.area.width + 'vp' + '\n  height: ' + event.target.area.height + 'vp' + '\ntimestamp: ' + event.timestamp
            })
          }
          .padding(12)
          .borderRadius(24)
          .backgroundColor(Color.White)

          Text($r('app.string.get_click_event_detail'))
            .fontSize(18)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 18, top: 12 })

          // Click location information
          Text(this.showClickEventInfo)
            .fontSize(18)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 18, top: 12 })
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}