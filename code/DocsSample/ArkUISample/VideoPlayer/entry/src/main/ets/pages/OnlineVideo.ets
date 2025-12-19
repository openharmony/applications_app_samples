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

// [Start online_video]
// xxx.ets
// [StartExclude online_video]
@Entry
// [EndExclude online_video]
@Component
export struct OnlineVideo {
  private controller: VideoController = new VideoController();
  // $r('app.media.preview')需要替换为开发者所需的图像资源文件
  private previewUris: Resource = $r('app.media.preview');
  private videoSrc: string = 'www.example.com/example.mp4'; // 使用时请替换为实际视频加载网址

  build() {
    Column() {
      Video({
        src: this.videoSrc,
        previewUri: this.previewUris,
        controller: this.controller
      })
    }
  }
}
// [End online_video]