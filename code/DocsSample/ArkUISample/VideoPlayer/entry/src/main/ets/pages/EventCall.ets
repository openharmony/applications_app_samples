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

// [Start event_call]
// xxx.ets
@Entry
@Component
struct eventCall {
  private controller: VideoController = new VideoController();
  private previewUris: Resource = $r('app.media.preview');
  private innerResource: Resource = $rawfile('videoTest.mp4');

  build() {
    Column() {
      Video({
        src: this.innerResource,
        previewUri: this.previewUris,
        controller: this.controller
      })
        .onUpdate((event) => { // 更新事件回调
        })
        .onPrepared((event) => { // 准备事件回调
        })
        .onError(() => { // 失败事件回调
        })
        .onStop(() => { // 停止事件回调
        })
    }
  }
}
// [End event_call]