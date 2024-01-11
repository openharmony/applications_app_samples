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
import ShowToast from '../../../../util/ShowToast';

const LEFT_UP_X = -110; // 限定距离
const RIGHT_UP_X = 110;
const LEFT_UP_Y = -118;
const RIGHT_UP_Y = 118;

@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .width('90%')
  .margin({ top: 20 })
  .padding({ left: 24, right: 24, top: 8, bottom: 8 })
}

@Entry
@Component
struct PanExample {
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State positionX: number = 0;
  @State positionY: number = 0;
  @State flag: boolean = false;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right });

  build() {
    Column() {
      TitleBar({ title: $r('app.string.pan_gesture') })
      if (!this.flag) {
        IntroductionTitle({ introduction: $r('app.string.pan_text_one') })
      } else {
        IntroductionTitle({ introduction: $r('app.string.pan_text') })
      }
      Column() {
        Text(getStringData($r('app.string.pan_offset'))
        + this.offsetX + getStringData($r('app.string.pan_offset_y')) + this.offsetY)
          .id('pan_column')
          .fontSize(16)
          .height(200)
          .width(200)
          .padding(20)
          .margin(50)
          .border({ width: 3 })
          .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
            // 左右拖动触发该手势事件
          .gesture(
            PanGesture(this.panOption)
              .onActionStart((event: GestureEvent) => {
                ShowToast.shortToast($r('app.string.pan_start'));
              })
              .onActionUpdate((event: GestureEvent) => {
                this.offsetX = this.positionX + event.offsetX;
                this.offsetY = this.positionY + event.offsetY;
                if (this.offsetX >= RIGHT_UP_X) {
                  this.offsetX = RIGHT_UP_X;
                }
                if (this.offsetX <= LEFT_UP_X) {
                  this.offsetX = LEFT_UP_X;
                }

                if (this.offsetY >= RIGHT_UP_Y) {
                  this.offsetY = RIGHT_UP_Y;
                }
                if (this.offsetY <= LEFT_UP_Y) {
                  this.offsetY = LEFT_UP_Y;
                }
              })
              .onActionEnd(() => {
                this.positionX = this.offsetX;
                this.positionY = this.offsetY;
                ShowToast.shortToast($r('app.string.pan_end'));
              })
              .onActionCancel(() => {
                ShowToast.shortToast($r('app.string.time_picker_dialog_cancel'));
              })
          )
      }
      .justifyContent(FlexAlign.Center)
      .borderRadius(24)
      .backgroundColor(Color.White)
      .height('60%')
      .margin({ left: 12, right: 12 })
      .width('100%')

      Button($r('app.string.pan_button'))
        .id('pan_change')
        .commonButtonStyle()
        .onClick(() => {
          this.flag = !this.flag;
          // 将PanGesture手势事件触发条件改为双指以任意方向拖动
          this.panOption.setDirection(PanDirection.All);
          this.panOption.setFingers(2);
          if (this.flag === false) {
            this.panOption.setDirection(PanDirection.Horizontal);
            this.panOption.setFingers(1);
          }
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}