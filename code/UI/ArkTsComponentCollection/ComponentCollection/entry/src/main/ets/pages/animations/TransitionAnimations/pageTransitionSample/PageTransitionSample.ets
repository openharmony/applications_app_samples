/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { TitleBar } from '../../../../common/TitleBar';

const ANIMATION_TIME: number = 1000;
const ANIMATION_URL: string = 'pages/animations/TransitionAnimations/pageTransitionSample/PageTransitionSampleTo';

@Extend(Text)
function textStyle() {
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
  @State zoom: number = 2;
  @State angle: number = 360;
  @State progress: number = 0;
  @State transitionType: SlideEffect = SlideEffect.Left;

  pageTransition() {
    // Entry animation
    PageTransitionEnter({ duration: ANIMATION_TIME, curve: Curve.Linear })
      .slide(this.transitionType)
      .onEnter((type: RouteType, progress: number) => {
        this.progress = progress;
      })

    // Exit animation
    PageTransitionExit({ duration: ANIMATION_TIME, curve: Curve.Ease })
      .slide(this.transitionType)
      .onExit((type: RouteType, progress: number) => {
        this.progress = progress;
      })
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.page_transition') })
      Scroll() {
        Column() {
          Text($r('app.string.page_transition_top'))
            .textStyle()
            .margin({ top: 50 })
            .onClick(() => {
              this.transitionType = SlideEffect.Bottom;
              router.push({
                url: ANIMATION_URL,
                params: { type: SlideEffect.Top, animationType: 1 }
              });
            })
          Text($r('app.string.page_transition_bottom'))
            .textStyle()
            .onClick(() => {
              this.transitionType = SlideEffect.Top;
              router.push({
                url: ANIMATION_URL,
                params: { type: SlideEffect.Bottom, animationType: 1 }
              });
            })
          Text($r('app.string.page_transition_left'))
            .textStyle()
            .onClick(() => {
              this.transitionType = SlideEffect.Right;
              router.push({
                url: ANIMATION_URL,
                params: { type: SlideEffect.Left, animationType: 1 }
              });
            })
          Text($r('app.string.page_transition_right'))
            .textStyle()
            .onClick(() => {
              this.transitionType = SlideEffect.Left;
              router.push({
                url: ANIMATION_URL,
                params: { type: SlideEffect.Right, animationType: 1 }
              });
            })
          Text($r('app.string.page_transition_scale'))
            .textStyle()
            .onClick(() => {
              this.transitionType = SlideEffect.Top;
              router.push({
                url: ANIMATION_URL,
                params: { type: SlideEffect.Bottom, zoom: this.zoom, animationType: 2 }
              });
            })
          Text($r('app.string.page_transition_rotate'))
            .textStyle()
            .onClick(() => {
              this.transitionType = SlideEffect.Top;
              router.push({
                url: ANIMATION_URL,
                params: { type: SlideEffect.Bottom, angle: this.angle, animationType: 3 }
              });
            })
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}