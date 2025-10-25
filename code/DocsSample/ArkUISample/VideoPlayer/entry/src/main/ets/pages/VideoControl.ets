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

// [Start video_guide]
// xxx.ets
@Entry
@Component
struct VideoGuide {
  @State videoSrc: Resource = $rawfile('videoTest.mp4');
  @State previewUri: string = 'common/videoIcon.png';
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;

  build() {
    Row() {
      Column() {
        Video({
          src: this.videoSrc,
          previewUri: this.previewUri,
          currentProgressRate: this.curRate // 设置视频播放倍速
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End video_guide]