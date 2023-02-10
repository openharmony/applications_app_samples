// @ts-nocheck
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

import emitter from "@ohos.events.emitter"
import window from '@ohos.window';
import WindowManger from '../feature/WindowManger'
import { WindowEventId, WindowType } from "../util/WindowConst"

const windowAttribute: WindowType = {
  moveToWidth: 50, // 窗口移动X坐标
  moveToHeight: 250, // 窗口移动Y坐标
  setTouchable: true, // 窗口是否可触
  resetSizeWidth: 300, // 窗口宽
  resetSizeHeight: 300, // 窗口高
  setPrivacyMode: true, // 窗口是否为隐私模式
  setBrightness: 1 // 窗口亮度
}

@Component
export struct WindowComponent {
  @StorageLink("topHeight") topHeight: number = 0 // 窗口规避区域高
  @StorageLink("topWidth") topWidth: number = 0 // 窗口规避区域宽
  @Link videoSrc: Resource

  build() {
    Column() {
      // 窗口顶部规避区域
      Row()
        .width(px2vp(this.topWidth))
        .height(px2vp(this.topHeight))
      // video视频
      VideoWindow({ videoSrc: $videoSrc })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct VideoWindow {
  @State isPlaying: boolean = false
  @Link videoSrc: Resource
  videoController: VideoController = new VideoController()
  private context: AbilityContext
  private subWindow: window.WindowStage

  aboutToAppear() {
    this.context = getContext(this) as AbilityContext
    let data = {
      context: null,
      launchWant: null,
      subWindow: null
    }
    this.context.eventHub.emit("createWindow", data)
    this.subWindow = data.subWindow
  }

  build() {
    Column() {
      Video({
        src: this.videoSrc,
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
        controller: this.videoController
      })
        .width('100%')
        .height(px2vp(350))
        .margin(5)
        .loop(false)
        .muted(false)
        .autoPlay(false)
        .controls(true)
        .autoPlay(true)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.videoController.pause()
          WindowManger.initSubWindow(this.subWindow)
          WindowManger.setSubWindowAttribute(this.subWindow, windowAttribute)
        })
        .onStart(() => {
          this.isPlaying = true
        })
        .onPause(() => {
          this.isPlaying = false
        })
        .onTouch((event: TouchEvent) => {
          let eventData = {
            data: {
              "x": event.touches[0].x,
              "y": event.touches[0].y,
            } }
          let innerEvent = {
            eventId: WindowEventId.SUB_WINDOW_INNER_EVENT_ID,
            priority: emitter.EventPriority.HIGH
          }
          emitter.emit(innerEvent, eventData)
        })
      Button($r("app.string.pages_textTwo")).onClick(() => {
        this.videoController.requestFullscreen(true)
        WindowManger.changeWindowDirection(this.subWindow)
      })
    }
  }
}


