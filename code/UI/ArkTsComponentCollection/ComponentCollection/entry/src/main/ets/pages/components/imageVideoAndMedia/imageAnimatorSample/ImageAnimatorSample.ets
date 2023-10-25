/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Extend(Button) function normalButton() {
  .width(100)
  .margin(5)
  .type(ButtonType.Normal)
  .borderRadius(20)
}

@Entry
@Component
struct ImageAnimatorSample {
  @State message: string = 'Hello World';
  @State animatorState: AnimationStatus = AnimationStatus.Initial;
  @State animatorReserve: boolean = false;
  @State animatorInterations: number = 1;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.image_animator_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.image_animator_show') })
          Column() {
            ImageAnimator()
              .images([
                {
                  src: $r('app.media.image_animator_1')
                },
                {
                  src: $r('app.media.image_animator_2')
                },
                {
                  src: $r('app.media.image_animator_3')
                },
                {
                  src: $r('app.media.image_animator_4')
                },
                {
                  src: $r('app.media.image_animator_5')
                },
                {
                  src: $r('app.media.image_animator_6')
                },
                {
                  src: $r('app.media.image_animator_7')
                },
                {
                  src: $r('app.media.image_animator_8')
                },
                {
                  src: $r('app.media.image_animator_9')
                },
                {
                  src: $r('app.media.image_animator_10')
                }
              ])
              .duration(2000)
              .fillMode(FillMode.None)
              .width(340)
              .height(240)
              .iterations(this.animatorInterations)
              .state(this.animatorState)
              .reverse(this.animatorReserve)
              .onStart(() => {
                ShowToast.shortToast('start')
                console.info('Start')
              })
              .onPause(() => {
                ShowToast.shortToast('Pause')
                console.info('Pause')
              })
              .onRepeat(() => {
                ShowToast.shortToast('Repeat')
                console.info('Repeat')
              })
              .onCancel(() => {
                ShowToast.shortToast('Cancel')
                console.info('Cancel')
              })
              .onFinish(() => {
                ShowToast.shortToast('Finish')
                console.info('Finish')
                this.animatorState = AnimationStatus.Stopped
              })
          }
          .cardStyle()

          IntroductionTitle({ introduction: $r('app.string.image_animator_control') })
          Column() {
            Row() {
              Button('start')
                .onClick(() => {
                  this.animatorState = AnimationStatus.Running
                }).normalButton().id('start')
              Button('pause')
                .padding(5)
                .onClick(() => {
                  this.animatorState = AnimationStatus.Paused
                }).normalButton().id('pause')
              Button('end')
                .padding(5)
                .onClick(() => {
                  this.animatorState = AnimationStatus.Stopped
                }).normalButton().id('end')
            }

            Row() {
              Button('reserve')
                .onClick(() => {
                  this.animatorReserve = !this.animatorReserve
                }).normalButton().id('reserve')
              Button('single')
                .padding(5)
                .onClick(() => {
                  this.animatorInterations = 1
                }).normalButton().id('single')
              Button('circulate')
                .padding(5)
                .onClick(() => {
                  this.animatorInterations = -1
                }).normalButton().id('circulate')
            }
          }.cardStyle()
        }
      }.padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 100 })
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}