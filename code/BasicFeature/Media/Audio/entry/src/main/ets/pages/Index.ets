/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
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
      Column() {
        Image($r('app.media.png01')).width(120).height(120).margin({ top: 24 })
        Button() {
          Text($r('app.string.SelectOutputDevice')).fontColor(Color.White).fontSize(18)
        }.width(312).height(40).margin({ top: 24 })
      }
      .id('select_output_device_card')
      .backgroundColor(Color.White)
      .margin({ top: 40 })
      .borderRadius(30)
      .width('100%')
      .height(232)
      .onClick(async () => {
        await router.pushUrl({ url: 'pages/PreferOutputDevice' })
      })

      Column() {
        Image($r('app.media.png02')).width(120).height(120).margin({ top: 24 })
        Button() {
          Text($r('app.string.AudioFocus')).fontColor(Color.White).fontSize(18)
        }.width(312).height(40).margin({ top: 24 })
      }
      .id('audio_focus_card')
      .backgroundColor(Color.White)
      .margin({ top: 40 })
      .borderRadius(30)
      .width('100%')
      .height(232)
      .onClick(async () => {
        await router.pushUrl({ url: 'pages/Focus' })
      })
    }
    .height('100%').width('100%').backgroundColor('#c4c4c4').padding({ left: 20, right: 20 })
  }
}