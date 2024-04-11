/*
* Copyright (C) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import router from '@ohos.router';
@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Row() {
          Column() {
            Image($r('app.media.pic01')).width(72).height(72).margin({ top: 36 })
            Text($r('app.string.AUDIO_CAPTURER')).fontColor(Color.Black).fontSize(16).margin({ top: 12 })
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          }
          .id('record_play_card')
          .backgroundColor(Color.White)
          .width(162)
          .height(188)
          .borderRadius(24)
          .margin({right: 6})
          .onClick(async() => {
            await router.pushUrl({ url:'pages/AudioRecording' })
          })
        }
        .width('50%')
        .justifyContent(FlexAlign.End)


        Row() {
          Column() {
            Image($r("app.media.pic_Audiovivid")).width(72).height(72).margin({ top: 36 })
            Text($r("app.string.AUDIOVIVID_PLAYBACK")).fontColor(Color.Black).fontSize(16).margin({ top: 12 })
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          }
          .backgroundColor(Color.White)
          .width(162)
          .height(188)
          .borderRadius(24)
          .margin({left: 6})
          .id('audiovivid_page_card')
          .onClick(async() => {
            await router.pushUrl({ url:'pages/AudioVividPlayback' })
          })
        }
        .width('50%')
        .justifyContent(FlexAlign.Start)
      }
      .margin({ top: 32 })
      .width('100%')
    }
    .height('100%').width('100%').backgroundColor('#F1F3F5')
  }
}

