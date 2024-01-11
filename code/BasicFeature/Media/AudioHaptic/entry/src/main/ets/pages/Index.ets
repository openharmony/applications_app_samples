/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
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
  @State message: string = 'Hello World';

  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.pic01xhdpi'))
            .width(72)
            .height(72)
            .margin({ top: 36, left:45, right:45});
          Text($r('app.string.AudioHaptic'))
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .width(96)
            .height(22)
            .margin({ top:12, left:33, right:33 });
        }
        .id('audio_haptic_card')
        .backgroundColor(Color.White)
        .margin({ left: 12 })
        .width(162)
        .height(188)
        .borderRadius(30)
        .onClick(async () => {
          await router.pushUrl({ url: 'pages/AudioHaptic' });
        });
        Blank()
      }
      .margin({ top: 60 })
      .padding({ left: 12 }).width('100%')
    }
    .height('100%').width('100%').backgroundColor('#F1F3F5');
  }
}