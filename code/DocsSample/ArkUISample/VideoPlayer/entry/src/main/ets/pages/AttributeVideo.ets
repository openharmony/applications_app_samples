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

// [Start attribute_video]
// xxx.ets
// [StartExclude attribute_video]
@Entry
// [EndExclude attribute_video]
@Component
export struct AttributeVideo {
  private controller: VideoController = new VideoController();

  build() {
    Column() {
      Video({
        controller: this.controller
      })
        .muted(false) // 设置是否静音
        .controls(false) // 设置是否显示默认控制条
        .autoPlay(false) // 设置是否自动播放
        .loop(false) // 设置是否循环播放
        .objectFit(ImageFit.Contain) // 设置视频填充模式
    }
  }
}
// [End attribute_video]