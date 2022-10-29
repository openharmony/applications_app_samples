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
import { TitleBar } from '../../../../common/TitleBar'

const ZOOM_FACTOR: number = 2
const ANIMATION_URL: string = 'pages/animations/TransitionAnimations/pageTransitionSample/PageTransitionSampleTo'

@Extend(Text) function textStyle () {
  .height(60)
  .fontSize(20)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12 })
  .fontWeight(FontWeight.Bold)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.font_color_shallow'))
  .backgroundColor($r('app.color.pop_up_background'))
}

@Entry
@Component
struct PageTransitionSample {
  @State topY: number = 0
  @State leftX: number = 0
  @State rightX: number = 0
  @State bottomY: number = 0
  @State angle: number = 360

  build() {
    Column() {
      TitleBar({ title: $r('app.string.page_transition') })
      Text($r('app.string.page_transition_top'))
        .textStyle()
        .margin({ top: 50 })
        .translate({ x: 0, y: this.topY })
        .onClick(() => {
          router.push({
            url: ANIMATION_URL,
            params: { type: SlideEffect.Top }
          })
        })
      Text($r('app.string.page_transition_bottom'))
        .translate({ x: 0, y: this.bottomY })
        .textStyle()
        .onClick(() => {
          router.push({
            url: ANIMATION_URL,
            params: { type: SlideEffect.Bottom }
          })
        })
      Text($r('app.string.page_transition_left'))
        .translate({ x: this.leftX, y: 0 })
        .textStyle()
        .onClick(() => {
          router.push({
            url: ANIMATION_URL,
            params: { type: SlideEffect.Left }
          })
        })
      Text($r('app.string.page_transition_right'))
        .translate({ x: this.rightX, y: 0 })
        .textStyle()
        .onClick(() => {
          router.push({
            url: ANIMATION_URL,
            params: { type: SlideEffect.Right }
          })
        })
      Text($r('app.string.page_transition_scale'))
        .translate({ x: this.leftX, y: this.topY })
        .textStyle()
        .onClick(() => {
          router.push({
            url: ANIMATION_URL,
            params: { type: SlideEffect.Bottom, zoom: ZOOM_FACTOR }
          })
        })
      Text($r('app.string.page_transition_rotate'))
        .translate({ x: this.rightX, y: this.bottomY })
        .textStyle()
        .onClick(() => {
          router.push({
            url: ANIMATION_URL,
            params: { type: SlideEffect.Bottom, angle: this.angle }
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  pageTransition() {
    // Entry animation
    PageTransitionEnter({ duration: 500, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        this.topY = (-progress + 1) * this.topY
        this.bottomY = (-progress + 1) * this.bottomY
        this.leftX = (-progress + 1) * this.leftX
        this.rightX = (-progress + 1) * this.rightX
      })

    // Exit animation
    PageTransitionExit({ duration: 500, curve: Curve.Ease })
      .onExit((type: RouteType, progress: number) => {
        this.topY = -600 * progress
        this.bottomY = 600 * progress
        this.leftX = -600 * progress
        this.rightX = 600 * progress
      })
  }
}