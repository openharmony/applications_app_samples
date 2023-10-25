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

const LEFT_UP_X = -80; // 限定距离
const RIGHT_UP_X = 80;
const LEFT_UP_Y = -130;
const RIGHT_UP_Y = 130;

@Entry
@Component
struct CombinedExample {
  @State count: number = 0;
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State positionX: number = 0;
  @State positionY: number = 0;
  @State borderStyles: BorderStyle = BorderStyle.Solid;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.combined_gestures') })
      IntroductionTitle({ introduction: $r('app.string.combinded_description') })
      Row() {
        Column() {
          Text(getStringData($r('app.string.combinded_sequence')) + getStringData($r('app.string.combinded_longPress_onAction')) + this.count
          + getStringData($r('app.string.combinded_x'))
          + this.offsetX + getStringData($r('app.string.pan_offset_y')) + this.offsetY)
        }
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .height(150)
        .width(250)
        .padding(20)
        .margin(20)
        .border({ width: 3, style: this.borderStyles })
        .gesture(
          // 以下组合手势为顺序识别，当长按手势事件未正常触发时则不会触发拖动手势事件
          GestureGroup(GestureMode.Sequence,
            LongPressGesture({ repeat: true })
              .onAction((event: GestureEvent) => {
                if (event.repeat) {
                  this.count++;
                }
                ShowToast.shortToast($r('app.string.combinded_longPress_onAction'));
              })
              .onActionEnd(() => {
                ShowToast.shortToast($r('app.string.combinded_longPress_end'));
              }),
            PanGesture()
              .onActionStart(() => {
                this.borderStyles = BorderStyle.Dashed;
                ShowToast.shortToast($r('app.string.combinded_pan_start'));
              })
              .onActionUpdate((event: GestureEvent) => {
                this.offsetX = this.positionX + event.offsetX;
                this.offsetY = this.positionY + event.offsetY;
                if (this.offsetX >= RIGHT_UP_X) {
                  this.offsetX = RIGHT_UP_X
                }
                if (this.offsetX <= LEFT_UP_X) {
                  this.offsetX = LEFT_UP_X
                }
                if (this.offsetY >= RIGHT_UP_Y) {
                  this.offsetY = RIGHT_UP_Y
                }
                if (this.offsetY <= LEFT_UP_Y) {
                  this.offsetY = LEFT_UP_Y
                }
                ShowToast.shortToast($r('app.string.combinded_pan_update'));
              })
              .onActionEnd(() => {
                this.positionX = this.offsetX;
                this.positionY = this.offsetY;
                this.borderStyles = BorderStyle.Solid;
                ShowToast.shortToast($r('app.string.combinded_pan_end'));
              })
          )
            .onCancel(() => {
              ShowToast.shortToast($r('app.string.time_picker_dialog_cancel'));
            })
        )
      }
      .justifyContent(FlexAlign.Center)
      .borderRadius(24)
      .backgroundColor(Color.White)
      .height('60%')
      .width('100%')
      .margin({ left: 12, right: 12 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}