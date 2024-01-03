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

import router from '@ohos.router'

const ANIMATION_TIME: number = 1000
const ANIMATION_PROGRESS: number = -600

@Entry
@Component
struct PageTransitionSampleTo {
  @State topY: number = 0
  @State zoom: number = 0
  @State angle: number = 1
  @State leftX: number = 0
  @State rightX: number = 0
  @State bottomY: number = 0
  @State progress: number = 0
  @State animationType: number = 0
  @State transitionType: SlideEffect = SlideEffect.Left

  build() {
    Column() {
      Text('PAGE TRANSITIONS')
        .fontSize(50)
        .opacity(0.4)
      Text($r('app.string.page_transition_back'))
        .height(70)
        .fontSize(30)
        .borderRadius(24)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .padding({ left: 12, right: 12 })
        .fontColor($r('app.color.font_color_shallow'))
        .backgroundColor($r('app.color.pop_up_background'))
        .onClick(() => {
          router.back()
        })
        .margin({ top: 100 })
    }
    .width('100%')
    .height('100%')
    .opacity(this.progress)
    .backgroundColor($r('app.color.background_shallow_grey'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .rotate(this.animationType === 3 ? { z: 1, angle: this.progress * this.angle } : { z: 1, angle: 0 })
    .scale(this.animationType === 2 ? {
      x: this.progress * this.zoom / 2,
      y: this.progress * this.zoom / 2,
      centerY: '50%',
      centerX: '50%'
    } : { x: 1, y: 1 })
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string | number | SlideEffect>;
    this.transitionType = params.type as SlideEffect;
    this.angle = params.angle as number;
    this.zoom = params.zoom as number;
    this.animationType = params.animationType as number;
  }

  pageTransition() {
    // Entry animation
    PageTransitionEnter({ duration: ANIMATION_TIME, curve: Curve.Linear })
      .slide(this.transitionType)
      .onEnter((type: RouteType, progress: number) => {
        this.topY = (-progress + 1) * this.topY
        this.bottomY = (-progress + 1) * this.bottomY
        this.leftX = (-progress + 1) * this.leftX
        this.rightX = (-progress + 1) * this.rightX
        this.progress = progress
      })

    // Exit animation
    PageTransitionExit({ duration: ANIMATION_TIME, curve: Curve.Ease })
      .slide(this.transitionType)
      .onExit((type: RouteType, progress: number) => {
        this.topY = -ANIMATION_PROGRESS * progress
        this.bottomY = ANIMATION_PROGRESS * progress
        this.leftX = -ANIMATION_PROGRESS * progress
        this.rightX = ANIMATION_PROGRESS * progress
        this.progress = progress
      })
  }
}

