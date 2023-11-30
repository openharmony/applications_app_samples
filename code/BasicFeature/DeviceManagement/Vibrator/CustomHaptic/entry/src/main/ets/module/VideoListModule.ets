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

@Entry
@Component
struct VideoListModule {
  private php: string = (router.getParams() as Record<string, string>)['php']
  build() {
    Column({ space: 20 }) {
      Row() {
        Button({ type: ButtonType.Normal }) {
          Text("<")
            .fontColor(Color.White)
            .fontSize(28)
        }
        .backgroundColor('#00191a32')
        .padding({ left: 5 })
        .layoutWeight(1)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Index'
          })
        })

        Text($r("app.string.back"))
          .fontColor(Color.White)
          .fontSize(24)
          .layoutWeight(7)
          .padding({ right: 10 })
      }
      .padding({ top: 5 })

      Column({ space: 20 }) {
        List({ space: 10 }) {
          ListItem() {
            Row() {
              Image($r("app.media.HapticVideoPreview"))
                .width("50%")
                .height(100)
                .borderRadius(10)
              Column() {
                Text($r("app.string.video_list_haptic_video"))
                  .fontSize(18)
                  .fontColor(Color.White)
                Text($r("app.string.video_list_haptic_video_msg"))
                  .fontSize(16)
                  .fontColor("#ff837979")
              }
              .alignItems(HorizontalAlign.Start)
              .padding({ left: 5 })
              .height(100)
            }
            .width("95%")
            .padding({ left: 10 })
            .backgroundColor("#00002222")
            .onClick(() => {
              router.pushUrl({
                url: "module/VideoPlayModule",
                params: {
                  vibrateFileName: "HapticVideo.json",
                  videoName: 'HapticVideo',
                  videoSrc: $r("app.media.HapticVideo"),
                  previewUri: $r("app.media.HapticVideoPreview"),
                  pages: "VideoListPage",
                  php: this.php
                }
              })
            })
          }
        }
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 10, color: "#00f3f3f3", startMargin: 20, endMargin: 20 })
        .height("60%")
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2191a32')
  }
}
