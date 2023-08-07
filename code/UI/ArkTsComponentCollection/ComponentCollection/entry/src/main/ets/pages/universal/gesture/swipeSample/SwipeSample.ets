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

@Entry
@Component
struct SwipeExample {
  @State rotateAngle: number = 0;
  @State speed: number = 1;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.swipe_gesture') })
      IntroductionTitle({ introduction: $r('app.string.swipe_description') })
      Row(){
        Column() {
          Text(getStringData($r('app.string.swipe_text_speed')) + this.speed)
          Text(getStringData($r('app.string.swipe_text_angle')) + this.rotateAngle)
        }
        .padding(20)
        .id('swipe_column')
        .border({ width: 3 })
        .width(300)
        .height(150)
        .rotate({ angle: this.rotateAngle })
        // 单指竖直方向滑动时触发该事件
        .gesture(
          SwipeGesture({ direction: SwipeDirection.All, fingers: 1, speed: 100 })
            .onAction((event: GestureEvent) => {
              this.speed = event.speed;
              this.rotateAngle = event.angle;
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