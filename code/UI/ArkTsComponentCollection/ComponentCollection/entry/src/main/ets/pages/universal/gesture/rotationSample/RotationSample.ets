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

@Entry
@Component
struct RotationExample {
  @State angle: number = 0;
  @State rotateValue: number = 0;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.rotation_gesture') })
      IntroductionTitle({ introduction: $r('app.string.rotation_description') })
      Row() {
        Column() {
          Text(getStringData($r('app.string.rotation_text')) + this.angle)
        }
        .height(150)
        .width(300)
        .padding(20)
        .border({ width: 3 })
        .rotate({ angle: this.angle })
        // 双指旋转触发该手势事件
        .gesture(
          RotationGesture({ fingers: 2 })
            .onActionStart((event: GestureEvent) => {
              ShowToast.shortToast($r('app.string.pan_start'));
            })
            .onActionUpdate((event: GestureEvent) => {
              this.angle = this.rotateValue + event.angle;
            })
            .onActionEnd(() => {
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
      .height(350)
      .margin({ left: 12, right: 12 })
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}