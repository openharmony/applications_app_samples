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

// [Start local_video]
// xxx.ets
// [StartExclude local_video]
@Entry
// [EndExclude local_video]
@Component
export struct LocalVideo {
  private controller: VideoController = new VideoController();
  private previewUris: Resource = $r('app.media.preview');
  private innerResource: Resource = $rawfile('videoTest.mp4');

  build() {
    Column() {
      Video({
        src: this.innerResource,  // 设置视频源
        previewUri: this.previewUris, // 设置预览图
        controller: this.controller //设置视频控制器，可以控制视频的播放状态
      })
    }
  }
}
// [End local_video]