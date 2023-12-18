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

import vibrator from '@ohos.vibrator';
import router from '@ohos.router'
import { changeOrientation, showTitleBar, playVibrateCustom, hideTitleBar } from './Util'

@Entry
@Component
struct VideoPlayModule {
  @State videoName: string = (router.getParams() as Record<string, string>)['videoName']
  private pages: string = (router.getParams() as Record<string, string>)['pages']
  @State videoSrc: Resource = (router.getParams() as Record<string, Resource>)['videoSrc']
  @State previewUri: Resource = (router.getParams() as Record<string, Resource>)['previewUri']
  private vibrateFileName: string = (router.getParams() as Record<string, string>)['vibrateFileName']
  @State portrait: boolean = true
  private php: string = (router.getParams() as Record<string, string>)['php']
  videoController: VideoController = new VideoController()

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Video({
        src: this.videoSrc,
        previewUri: this.previewUri,
        controller: this.videoController,
      })
        .height("100%")
        .width('100%')
        .objectFit(ImageFit.Auto)
        .controls(false)
        .onStart(() => {
          changeOrientation(false)
          hideTitleBar()
          playVibrateCustom(this.vibrateFileName, this.php)
        })
        .onClick(() => {
          this.portrait = !this.portrait
        })
        .autoPlay(true)
      Row() {
        Button('<')
          .fontSize(15)
          .backgroundColor("#00222222")
          .id('videoBack')
          .onClick(() => {
            changeOrientation(false)
            showTitleBar()
            vibrator.stopVibration()
            router.back()
          })
        Text(this.videoName).fontSize(15).fontColor(Color.White)
      }
      .width("100%")
      .height("10%")
      .backgroundColor('#80191a32')
      .visibility(this.portrait ? Visibility.Visible : Visibility.Hidden)
    }.width('100%')
    .height('100%')
    .backgroundColor('#f2191a32')
  }
}
