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

import emitter from "@ohos.events.emitter"

@Entry
@Component
struct SubWindowPage {
  SUB_WINDOW_INNER_EVENT_ID: number = 1001
  videoController: VideoController = new VideoController()

  build() {
    Column() {
      Video({
        src: $rawfile('video.mp4'),
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
        controller: this.videoController
      })
        .width(400)
        .height(250)
        .margin(5)
        .loop(false)
        .muted(false)
        .controls(true)
        .autoPlay(true)
        .onTouch((event: TouchEvent) => {
          let eventData = {
            data: {
              "x": event.touches[0].x,
              "y": event.touches[0].y,
            } }
          let innerEvent = {
            eventId: this.SUB_WINDOW_INNER_EVENT_ID,
            priority: emitter.EventPriority.HIGH
          }
          emitter.emit(innerEvent, eventData)
        })
    }
    .width('100%').height('100%')
  }
}