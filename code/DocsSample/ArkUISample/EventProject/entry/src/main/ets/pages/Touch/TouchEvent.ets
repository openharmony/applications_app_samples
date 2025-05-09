/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start touch_event_handle]
@Entry
@Component
export struct Touch {
  @State text: string = '';
  @State eventType: string = '';

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('Touch').height(40).width(100)
            .onTouch((event?: TouchEvent) => {
              if (event) {
                if (event.type === TouchType.Down) {
                  this.eventType = 'Down';
                }
                if (event.type === TouchType.Up) {
                  this.eventType = 'Up';
                }
                if (event.type === TouchType.Move) {
                  this.eventType = 'Move';
                }
                this.text = 'TouchType:' + this.eventType + '\nDistance between touch point and touch element:\nx: ' +
                event.touches[0].x + '\n' + 'y: ' + event.touches[0].y + '\nComponent globalPos:(' +
                event.target.area.globalPosition.x + ',' + event.target.area.globalPosition.y + ')\nwidth:' +
                event.target.area.width + '\nheight:' + event.target.area.height
              }
            })
          Button('Touch').height(50).width(200).margin(20)
            .onTouch((event?: TouchEvent) => {
              if (event) {
                if (event.type === TouchType.Down) {
                  this.eventType = 'Down';
                }
                if (event.type === TouchType.Up) {
                  this.eventType = 'Up';
                }
                if (event.type === TouchType.Move) {
                  this.eventType = 'Move';
                }
                this.text = 'TouchType:' + this.eventType + '\nDistance between touch point and touch element:\nx: ' +
                event.touches[0].x + '\n' + 'y: ' + event.touches[0].y + '\nComponent globalPos:(' +
                event.target.area.globalPosition.x + ',' + event.target.area.globalPosition.y + ')\nwidth:' +
                event.target.area.width + '\nheight:' + event.target.area.height
              }
            })
          Text(this.text)
        }.width('100%').padding(30)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Touch_TouchEvent_title'))
  }
}
// [End touch_event_handle]