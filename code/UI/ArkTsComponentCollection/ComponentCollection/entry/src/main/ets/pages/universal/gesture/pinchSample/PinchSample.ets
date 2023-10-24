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

const BIG_SCALE = 1.34;
const SMALL_SCALE = 0.75;

@Entry
@Component
struct PanExample {
  @State scaleValue: number = 1;
  @State pinchValue: number = 1;
  @State pinchX: number = 0;
  @State pinchY: number = 0;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.pinch_gesture') })
      IntroductionTitle({ introduction: $r('app.string.pinch_description') })
      Row() {
        Column() {
          Text(getStringData($r('app.string.pinch_scale')) + this.scaleValue);
          Text(getStringData($r('app.string.pinch_center')) + this.pinchX
          + getStringData($r('app.string.pan_offset_y')) + this.pinchY);
        }
        .height(200)
        .width(300)
        .padding(20)
        .border({ width: 3 })
        .scale({ x: this.scaleValue, y: this.scaleValue, z: 1 })
        // 三指捏合触发该手势事件
        .gesture(
          PinchGesture({ fingers: 3, distance: 5 })
            .onActionStart((event: GestureEvent) => {
              ShowToast.shortToast($r('app.string.pan_start'));
            })
            .onActionUpdate((event: GestureEvent) => {
              this.scaleValue = this.pinchValue * event.scale;
              if (this.scaleValue >= BIG_SCALE) {
                this.scaleValue = BIG_SCALE;
              }
              if (this.scaleValue <= SMALL_SCALE) {
                this.scaleValue = SMALL_SCALE;
              }
              this.pinchX = event.pinchCenterX;
              this.pinchY = event.pinchCenterY;
            })
            .onActionEnd(() => {
              this.pinchValue = this.scaleValue;
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
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}