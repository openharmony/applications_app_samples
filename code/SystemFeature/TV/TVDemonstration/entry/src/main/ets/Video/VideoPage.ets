/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { globalIdle } from '../utils/GlobalScreenSaver';

@Entry
@Component
struct VideoGuide1 {
  @State videoSrc: Resource = $rawfile('videoTest.mp4')
  @State previewUri: Resource = $r('app.media.cat');
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @State showControls: boolean = true
  @State sliderStartTime: string = '';
  @State currentTime: number = 0;
  @State durationTime: number = 0;
  @State durationStringTime: string = '';
  controller: VideoController = new VideoController()
  @State scale1: number = 1;
  @State opacity1: number = 1;
  @State isOn: boolean = true

  onPageShow(): void {
    globalIdle.startDetect();
  }

  onPageHide(): void {
    globalIdle.stopDetect()
  }

  build() {

    Column() {
      /*if(this.isOn){
        Image($r('app.media.preview'))
      }else {*/
      Video({
        src: this.videoSrc,
        previewUri: this.previewUri,
        currentProgressRate: this.curRate,
        controller: this.controller
      })
        .controls(false)
        .autoPlay(true)
        .onStart(() => {
          globalIdle.stopDetect()
          console.log('hsq onStart')
        })
        .onPause(() => {
          globalIdle.startDetect()

        })
        .onFinish(() => {
          globalIdle.startDetect()
        })

    }
    .width('100%')
    .onHover(() => {
      globalIdle.resetTimer()
    })
    .onKeyEvent(() => {
      globalIdle.resetTimer()
    })

  }
}