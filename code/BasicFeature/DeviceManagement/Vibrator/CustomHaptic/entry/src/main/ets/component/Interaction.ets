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

import { playVibrateCustom } from '../module/Util'

@Component
export default struct InteractionLayout {
  @State status: boolean[] = [false, false, false, false]
  @State stateSlideLeftRight: AnimationStatus = AnimationStatus.Initial
  @State stateSlideUp: AnimationStatus = AnimationStatus.Initial
  @State stateSwitchApp: AnimationStatus = AnimationStatus.Initial
  @State stateUpSlideStop: AnimationStatus = AnimationStatus.Initial
  @State iterations: number = 1
  @Link php: string

  build() {
    Column() {
      List({ space: 20 }) {
        ListItem() {
          Row({ space: 30 }) {
            Column({ space: 10 }) {
              Row() {
                ImageAnimator()
                  .images([
                    { src: $r("app.media.Slide_LeftRight1") },
                    { src: $r("app.media.Slide_LeftRight2") },
                    { src: $r("app.media.Slide_LeftRight3") },
                    { src: $r("app.media.Slide_LeftRight4") },
                    { src: $r("app.media.Slide_LeftRight5") },
                    { src: $r("app.media.Slide_LeftRight6") },
                    { src: $r("app.media.Slide_LeftRight7") },
                    { src: $r("app.media.Slide_LeftRight8") },
                    { src: $r("app.media.Slide_LeftRight9") },
                    { src: $r("app.media.Slide_LeftRight10") },
                    { src: $r("app.media.Slide_LeftRight11") },
                    { src: $r("app.media.Slide_LeftRight12") },
                  ])
                  .borderRadius(10)
                  .duration(3000)
                  .state(this.stateSlideLeftRight)
                  .fillMode(FillMode.None)
                  .iterations(this.iterations)
                  .width("100%")
                  .height("100%")
                  .onFinish(() => {
                    this.stateSlideLeftRight = AnimationStatus.Initial
                  })
              }
              .width('30%')
              .borderRadius(20)
              .backgroundColor("#66191a32")
              .height("60%")
              .onClick(() => {
                this.stateSlideLeftRight = AnimationStatus.Running
                playVibrateCustom("Slide_LeftRight.json", this.php)
              })

              Text($r("app.string.interaction_slide_left_right"))
                .fontColor(Color.White)
                .fontSize(18)
            }

            Column({ space: 10 }) {
              Row() {
                ImageAnimator()
                  .images([
                    { src: $r("app.media.slide_up1") },
                    { src: $r("app.media.slide_up2") },
                    { src: $r("app.media.slide_up3") },
                    { src: $r("app.media.slide_up4") },
                    { src: $r("app.media.slide_up5") },
                    { src: $r("app.media.slide_up6") },
                    { src: $r("app.media.slide_up7") },
                    { src: $r("app.media.slide_up8") },
                    { src: $r("app.media.slide_up9") },
                  ])
                  .borderRadius(10)
                  .duration(2250)
                  .state(this.stateSlideUp)
                  .fillMode(FillMode.None)
                  .iterations(this.iterations)
                  .width("100%")
                  .height("100%")
                  .onFinish(() => {
                    this.stateSlideUp = AnimationStatus.Initial
                  })
              }
              .width('30%')
              .borderRadius(20)
              .backgroundColor("#66191a32")
              .height("60%")
              .onClick(() => {
                this.stateSlideUp = AnimationStatus.Running
                playVibrateCustom("Slide_Up.json", this.php)
              })

              Text($r("app.string.interaction_slide_up"))
                .fontColor(Color.White)
                .fontSize(18)
            }
          }
          .justifyContent(FlexAlign.Center)
        }
        .margin({ left: "1%" })
        .width("100%")

        ListItem() {
          Row({ space: 30 }) {
            Column({ space: 10 }) {
              Row() {
                ImageAnimator()
                  .images([
                    { src: $r("app.media.Switch_App1") },
                    { src: $r("app.media.Switch_App2") },
                    { src: $r("app.media.Switch_App3") },
                    { src: $r("app.media.Switch_App4") },
                    { src: $r("app.media.Switch_App5") },
                    { src: $r("app.media.Switch_App6") },
                    { src: $r("app.media.Switch_App7") },
                    { src: $r("app.media.Switch_App8") },
                    { src: $r("app.media.Switch_App9") },
                    { src: $r("app.media.Switch_App10") },
                    { src: $r("app.media.Switch_App11") },
                    { src: $r("app.media.Switch_App12") },
                    { src: $r("app.media.Switch_App13") },
                    { src: $r("app.media.Switch_App14") },
                  ])
                  .borderRadius(10)
                  .duration(3500)
                  .state(this.stateSwitchApp)
                  .fillMode(FillMode.None)
                  .iterations(this.iterations)
                  .width("100%")
                  .height("100%")
                  .onFinish(() => {
                    this.stateSwitchApp = AnimationStatus.Initial
                  })
              }
              .width('30%')
              .borderRadius(20)
              .backgroundColor("#66191a32")
              .height("60%")
              .onClick(() => {
                this.stateSwitchApp = AnimationStatus.Running
                playVibrateCustom("Switch_App.json", this.php)
              })

              Text($r("app.string.interaction_switch_app"))
                .fontColor(Color.White)
                .fontSize(18)
            }

            Column({ space: 10 }) {
              Row() {
                ImageAnimator()
                  .images([
                    { src: $r("app.media.Upslide_Stop1") },
                    { src: $r("app.media.Upslide_Stop2") },
                    { src: $r("app.media.Upslide_Stop3") },
                    { src: $r("app.media.Upslide_Stop4") },
                    { src: $r("app.media.Upslide_Stop5") },
                    { src: $r("app.media.Upslide_Stop6") },
                    { src: $r("app.media.Upslide_Stop7") },
                    { src: $r("app.media.Upslide_Stop8") },
                    { src: $r("app.media.Upslide_Stop9") },
                    { src: $r("app.media.Upslide_Stop10") },
                    { src: $r("app.media.Upslide_Stop11") },
                    { src: $r("app.media.Upslide_Stop12") },
                  ])
                  .borderRadius(10)
                  .duration(3000)
                  .state(this.stateUpSlideStop)
                  .fillMode(FillMode.None)
                  .iterations(this.iterations)
                  .width("100%")
                  .height("100%")
                  .onFinish(() => {
                    this.stateUpSlideStop = AnimationStatus.Initial
                  })
              }
              .width('30%')
              .borderRadius(20)
              .backgroundColor("#66191a32")
              .height("60%")
              .onClick(() => {
                this.stateUpSlideStop = AnimationStatus.Running
                playVibrateCustom("UpSlide_Stop.json", this.php)
              })

              Text($r("app.string.interaction_slide_stop"))
                .fontColor(Color.White)
                .fontSize(18)
            }
          }
          .justifyContent(FlexAlign.Center)
        }
        .margin({ left: "1%" })
        .width("100%")
      }
      .height('50%')
      .width("100%")
    }
  }
}
