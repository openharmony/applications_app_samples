/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import curves from '@ohos.curves';
import router from '@ohos.router';

@Entry
@Component
struct AnimationToAnimationDemo {
  @State isAnimation: boolean = false;
  @State translateX1: number = -100;
  @State translateX2: number = -100;
  @State translateX3: number = -100;

  build() {
    Column() {
      Row() {
        Text('30')
          .fontWeight(FontWeight.Bold)
          .fontSize(16)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .borderRadius(10)
          .backgroundColor(0xF56C6C)
          .width(80)
          .height(80)
          .translate({ x: this.translateX1 })
      }
      .height('20%')

      Row() {
        Text('40')
          .fontWeight(FontWeight.Bold)
          .fontSize(16)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .borderRadius(10)
          .backgroundColor(0x2E8B57)
          .width(80)
          .height(80)
          .translate({ x: this.translateX2 })
      }
      .height('20%')

      Row() {
        Text('60')
          .fontWeight(FontWeight.Bold)
          .fontSize(16)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .borderRadius(10)
          .backgroundColor(0x008B8B)
          .width(80)
          .height(80)
          .translate({ x: this.translateX3 })
          .animation({
            duration: 1200,
            iterations: 10,
            curve: curves.springMotion(),
            playMode: PlayMode.AlternateReverse,
            expectedFrameRateRange: {
              expected: 60,
              min: 0,
              max: 120
            },
          })
      }
      .height('20%')

      Row() {
        Button('Start')
          .id('PropertyAnimationStart')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick(() => {
            this.isAnimation = !this.isAnimation;
            this.translateX3 = this.isAnimation ? 100 : -100;

            animateTo({
              duration: 1200,
              iterations: 10,
              curve: curves.springMotion(),
              playMode: PlayMode.AlternateReverse,
              expectedFrameRateRange: {
                expected: 30,
                min: 0,
                max: 120,
              },
            }, () => {
              this.translateX1 = this.isAnimation ? 100 : -100;
            })

            animateTo({
              duration: 1200,
              iterations: 10,
              curve: curves.springMotion(),
              playMode: PlayMode.AlternateReverse,
              expectedFrameRateRange: {
                expected: 40,
                min: 0,
                max: 120,
              },
            }, () => {
              this.translateX2 = this.isAnimation ? 100 : -100;
            })
          })
          .width('40%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button('Back')
          .id('PropertyAnimationBack')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick((): void => {
            router.back();
          })
          .width('40%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .layoutWeight(1)
  }
}