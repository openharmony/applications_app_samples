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
import TabLayout from '../moudle/TabBar'
import VideoListLayout from '../component/VideoList'
import RacingLayout from '../component/Racing'
import BattleLayout from '../component/Battle'
import ShootLayout from '../component/Shooting'
import InstrumentLayout from '../component/Instrument'
import RealisticLayout from '../component/Realistic'
import FootstepLayout from '../component/Footstep'
import EnvironmentLayout from '../component/Environment'
import ExerciseLayout from '../component/Exercise'
import InteractionLayout from '../component/Interaction'

export enum tabIndex {
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
export  default struct DisplayPage {
  @State titleArr: string[] = ['竞速','战斗','枪击','乐器','拟真','脚步','环境','运动', '互动']
  @State currentIndex: number  = 0
  private swiperController: SwiperController = new SwiperController()
  private tabHeight = 50
  @State playDis: boolean = false
  @Link vibrationIntensity: string
  private controller: TabsController = new TabsController();
  build(){
    Column({ space: 10 }) {
      Row() {
        Text('触感效果视频')
          .width('50%')
          .fontSize(24)
          .fontColor('#ffffffff')
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Start)
          .layoutWeight(7)
          .padding({ left: 10 })
        Button('显示更多')
          .backgroundColor("#00d613ca")
          .layoutWeight(3)
          .height(35)
          .fontColor('#919191')
          .onClick(() => {
            console.info('显示更多按下')
            router.pushUrl({
              url: 'pages/VideoListPage'
            })
          })
      }.padding({ top: 5 })

      VideoListLayout()

      Text("振效库")
        .width('100%')
        .fontSize(24)
        .fontColor('#ffffffff')
        .fontWeight(FontWeight.Normal)
        .textAlign(TextAlign.Start)
        .padding({ left: 10 })

      Row() {
        TabLayout({
          titleArr: $titleArr,
          currentIndex: $currentIndex,
          tabSelected: (position: number, title: string) => {
            this.currentIndex = position
            console.log('onTabSelected position = ' + position + ', title = ' + title)
            this.swiperController.showNext()
          },
        })
      }.width('100%')
      .height(this.tabHeight)
      .zIndex(10)

      Scroll() {
        Column() {
          Swiper(this.swiperController) {
            ForEach(this.titleArr, (item) => {
              Column() {
                if (this.currentIndex === tabIndex.RACING) {
                  RacingLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.BATTLE) {
                  BattleLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.SHOOT) {
                  ShootLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.INSTRUMENT) {
                  InstrumentLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.REALISTIC) {
                  RealisticLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.FOOTSTEP) {
                  FootstepLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.ENVIRONMENT) {
                  EnvironmentLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.EXERCISE) {
                  ExerciseLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.INTERACTION) {
                  InteractionLayout()
                } else {
                  Text('敬请期待').fontSize(48).fontColor(Color.Black).width("100%").height("100%")
                }
              }
            }, item => item)
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
            console.info(index.toString())
            this.currentIndex = index
          })
        }
      }.scrollBar(BarState.Off).scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor('#f2191a32')
  }
}
