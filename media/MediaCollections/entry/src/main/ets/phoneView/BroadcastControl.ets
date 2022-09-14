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

// @ts-nocheck
import { myMedia } from '../model/myMedia'
import { getTimeString } from '../model/TimeTools'

@Component
export struct BroadcastControl {
  @State isInformation: boolean = false
  @Link myMedia: myMedia
  @Link isXComponent: boolean
  @Link surfaceId: number
  @Link isPlaying: boolean
  @Link currentTime: number
  private timer: number = undefined
  private mXComponentController: XComponentController
  private dialogController: CustomDialogController = null

  build() {
    Column() {
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text(this.myMedia.fileName || $r('app.string.phoneMain_title'))
            .fontColor('rgba(255,255,255,0.90)')
            .fontSize(18)
            .width('60%')
            .margin({ left: 15 })
            .fontFamily('HarmonyHeiTi-Medium')
            .layoutWeight(1)
          Row() {
            Image($r('app.media.icon_freeplay'))
              .width(24)
              .height(24)
              .opacity(0.4)
              .enabled(false)
            Image($r('app.media.icon_favorite'))
              .width(24)
              .height(24)
              .opacity(0.4)
              .enabled(false)
          }
          .width('20%')
          .justifyContent(FlexAlign.SpaceEvenly)
        }.height('15%')

        if (this.isXComponent) {
          Row() {
            XComponent({
              id: '',
              type: 'surface',
              controller: this.mXComponentController
            })
              .onLoad(() => {
                this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
              })
              .height('70%')
              .width('100%')
          }
        }
        Blank()
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          Image(this.isPlaying ? $r('app.media.icon_play') : $r('app.media.icon_pause'))
            .width(24)
            .height(24)
            .onClick(() => {
              this.isPlaying = !this.isPlaying
              clearInterval(this.timer)
              this.timer = setInterval(() => {
                this.currentTime = this.myMedia.getCurrentTime()
              }, 1000)
            })
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text(getTimeString(this.currentTime) || '00:00')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .fontWeight(500)
              .opacity(0.6)
              .fontFamily('HarmonyHeiTi')
            Slider({
              value: this.myMedia ? Math.round(this.currentTime / this.myMedia.totalDuration * 100) : 0
            })
              .selectedColor(Color.White)
              .width('81%')
              .trackColor(Color.Gray)
              .onChange((value: number) => {
                this.currentTime = this.myMedia.totalDuration * value / 100
                this.myMedia.seek(this.currentTime)
              })
            Text(this.myMedia ? getTimeString(this.myMedia.totalDuration) : '00:00')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .fontWeight(500)
              .opacity(0.6)
              .fontFamily('HarmonyHeiTi')
          }.width('80%')

          Image($r('app.media.icon_large'))
            .width(24)
            .height(24)
            .opacity(0.4)
            .enabled(false)
        }.width('100%').height('15%')
      }.height('100%')
    }.height('45%').backgroundColor(Color.Black)
  }
}