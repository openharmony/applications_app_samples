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

import router from '@ohos.router'

@Component
export default struct VideoListLayout {
  @State playDis: boolean = false
  @Link php: string

  build() {
    Scroll() {
      Row({ space: 10 }) {
        Stack() {
          Image($r("app.media.HapticVideoPreview"))
            .width("100%")
            .height("100%")
            .borderRadius(10)
          Image($r("app.media.player2"))
            .width("30%")
            .height("30%")
            .visibility(this.playDis ? Visibility.Hidden : Visibility.Visible)
        }
        .id("videoPreview")
        .width("95%")
        .height("30%")
        .onClick(() => {
          this.playDis = true
          router.pushUrl({
            url: "module/VideoPlayModule",
            params: {
              vibrateFileName: "HapticVideo.json",
              videoName: 'HapticVideo',
              videoSrc: $r("app.media.HapticVideo"),
              previewUri: $r("app.media.HapticVideoPreview"),
              pages: "Index",
              php: this.php
            }
          })
        })
        .padding({ left: 10 })
      }
    }
    .scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
  }
}
