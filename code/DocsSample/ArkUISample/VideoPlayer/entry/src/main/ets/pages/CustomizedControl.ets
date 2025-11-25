/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start customize_control]
// xxx.ets
@Entry
@Component
struct CustomizedControl {
  @State videoSrc: Resource = $rawfile('videoTest.mp4');
  @State previewUri: string = 'common/videoIcon.png';
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;
  // 初始化当前时间为0
  @State currentTime: number = 0;
  // 初始化持续时间为0
  @State durationTime: number = 0;
  controller: VideoController = new VideoController();

  build() {
    Row() {
      Column() {
        Video({
          src: this.videoSrc,
          previewUri: this.previewUri,
          currentProgressRate: this.curRate,
          controller: this.controller
        })
          .controls(false)
          .autoPlay(true)
          .onPrepared((event) => {
            if (event) {
              this.durationTime = event.duration
            }
          })
          .onUpdate((event) => {
            if (event) {
              this.currentTime = event.time
            }
          })
        Row() {
          Text(JSON.stringify(this.currentTime) + 's')
          Slider({
            value: this.currentTime,
            min: 0,
            max: this.durationTime
          })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.controller.setCurrentTime(value); // 设置视频播放的进度跳转到value处
            })
            .width('90%')
          Text(JSON.stringify(this.durationTime) + 's')
        }
        .opacity(0.8)
        .width('100%')
      }
      .width('100%')
    }
    .height('40%')
  }
}
// [End customize_control]