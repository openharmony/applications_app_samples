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

import router from '@ohos.router'
import VideoListLayout from '../component/VideoPreview'
import RacingLayout from '../component/Racing'
import BattleLayout from '../component/Battle'
import ShootLayout from '../component/Shooting'
import InstrumentLayout from '../component/Instrument'
import RealisticLayout from '../component/Realistic'
import FootstepLayout from '../component/Footstep'
import EnvironmentLayout from '../component/Environment'
import ExerciseLayout from '../component/Exercise'
import InteractionLayout from '../component/Interaction'
import Logger from './Logger'
import TabBar from './TabBar'

const TAG = '[DisplayModule]'

export enum TabIndex {
  RACING = 0,
  BATTLE,
  SHOOT,
  INSTRUMENT,
  REALISTIC,
  FOOTSTEP,
  ENVIRONMENT,
  EXERCISE,
  INTERACTION,
}

@Component
export default struct DisplayModule {
  @State titleArr: Resource[] = [
  $r("app.string.display_racing"), $r("app.string.display_battle"), $r("app.string.display_shoot"),
  $r("app.string.display_instrument"), $r("app.string.display_realistic"), $r("app.string.display_footstep"),
  $r("app.string.display_environment"), $r("app.string.display_exercise"), $r("app.string.display_interaction")
  ]
  @State currentIndex: number = 0
  private swiperController: SwiperController = new SwiperController()
  private tabHeight = 50
  @State playDis: boolean = false
  @Link vibrationIntensity: string
  @Link php: string
  private controller: TabsController = new TabsController();

  build() {
    Column({ space: 10 }) {
      Row() {
        Text($r("app.string.display_haptic_video"))
          .width('50%')
          .fontSize(24)
          .fontColor('#ffffffff')
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Start)
          .layoutWeight(7)
          .padding({ left: 10 })
        Button($r("app.string.display_show_more"))
          .id('showMore')
          .backgroundColor("#00d613ca")
          .layoutWeight(3)
          .height(35)
          .fontColor('#919191')
          .onClick(() => {
            Logger.info(TAG, 'Show more pressed')
            router.pushUrl({
              url: 'module/VideoListModule',
              params: {php: this.php}
            })
          })
      }
      .padding({ top: 5 })

      VideoListLayout({php: $php})

      Text($r("app.string.display_haptic_library"))
        .width('100%')
        .fontSize(24)
        .fontColor('#ffffffff')
        .fontWeight(FontWeight.Normal)
        .textAlign(TextAlign.Start)
        .padding({ left: 10 })

      Row() {
        TabBar({
          titleArr: $titleArr,
          currentIndex: $currentIndex,
          tabSelected: (position: number, title: string) => {
            this.currentIndex = position
            Logger.info(TAG, 'onTabSelected position = ' + position + ', title = ' + title)
            this.swiperController.showNext()
          },
        })
      }
      .width('100%')
      .height(this.tabHeight)
      .zIndex(10)

      Scroll() {
        Column() {
          Swiper(this.swiperController) {
            ForEach(this.titleArr, (item: string) => {
              Column() {
                if (this.currentIndex === TabIndex.RACING) {
                  RacingLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.BATTLE) {
                  BattleLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.SHOOT) {
                  ShootLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.INSTRUMENT) {
                  InstrumentLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.REALISTIC) {
                  RealisticLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.FOOTSTEP) {
                  FootstepLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.ENVIRONMENT) {
                  EnvironmentLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.EXERCISE) {
                  ExerciseLayout({
                    vibrationIntensity: $vibrationIntensity,
                    php: $php
                  })
                } else if (this.currentIndex === TabIndex.INTERACTION) {
                  InteractionLayout({
                    php: $php
                  })
                } else {
                  Text('Please Waiting！')
                    .fontSize(48)
                    .fontColor(Color.Black)
                    .width("100%")
                    .height("100%")
                }
              }
            }, (item: string) => item)
          }
          .index(0)
          .autoPlay(false)
          .indicator(false)
          .loop(false)
          .vertical(false)
          .itemSpace(0)
          .index(this.currentIndex)
          .flexGrow(1)
          .width('100%')
          .onChange((index: number) => {
            Logger.info(TAG, index.toString())
            this.currentIndex = index
          })
        }
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2191a32')
  }
}
