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

@Component
export struct StreamingMedia {
  @State httpUrl: string = ''
  @State isEnabled: boolean = false
  @Link streamOpacity: number
  @Link streamBackgroundColor: string
  @Link myMedia: myMedia
  @Link isXComponent: boolean
  @Link isPlaying: boolean
  @Link isShowMenu: boolean
  @Link streamBtnText: Resource
  @Link isStreamShow: boolean
  @Link currentTime: number
  private timer: number = undefined
  private timerOut: number = undefined
  private mXComponentController: XComponentController

  build() {
    Row() {
      TextInput({ placeholder: $r('app.string.streamMedia_inputText') })
        .placeholderColor("rgba(255,255,255,0.60)")
        .placeholderFont({ size: 16, family: "HarmonyHeiTi", style: FontStyle.Normal })
        .textAlign(TextAlign.Center)
        .caretColor(Color.White)
        .fontSize(16)
        .fontFamily("HarmonyHeiTi")
        .fontStyle(FontStyle.Normal)
        .fontColor("rgba(255,255,255,0.60)")
        .borderRadius("24px 0px 0px 24px")
        .backgroundColor('#343434')
        .width('100%')
        .onChange((value: string) => {
          this.isEnabled = true
          this.httpUrl = value
          this.streamOpacity = 1
          this.streamBackgroundColor = '#5291FF'
        })
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        Row() {
          if (this.isStreamShow) {
            Image($r('app.media.icon_note')).width(24).height(24).margin({ left: 12 })
          }
          Text(this.streamBtnText)
            .fontSize(16)
            .align(Alignment.Center)
            .fontColor('#FFFFFF')
            .margin({ left: 5, right: 12, top: 2 })
            .fontFamily('HarmonyHeiTi-Medium')
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width(120)
      .enabled(this.isEnabled)
      .height(40)
      .opacity(this.streamOpacity)
      .backgroundColor(this.streamBackgroundColor)
      .borderRadius('100px 24px 24px 100px')
      .position({ x: '88%', y: '0' })
      .onClick(() => {
        this.streamBtnText = $r('app.string.streamMedia_Playing')
        this.isStreamShow = true
        this.isShowMenu = true
        this.isPlaying = true
        this.isXComponent = true
        if (this.timerOut !== undefined) {
          clearTimeout(this.timerOut)
        }
        console.info('zyk' + 'http' + this.httpUrl)
        this.timerOut = setTimeout(() => {
          let surfaceId = this.mXComponentController.getXComponentSurfaceId()
          this.myMedia.httpInit(this.httpUrl, surfaceId)
        }, 100)
        if (this.timer !== undefined) {
          clearInterval(this.timer)
        }
        this.timer = setInterval(() => {
          this.currentTime = this.myMedia.getCurrentTime()
        }, 1000)
      })
    }.width('79%').margin({ right: 4 })
  }
}