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
      Row(){
        Row() {
          Column() {
            Image($r("app.media.ic_index_spatial")).width(72).height(72).margin({ top: 36 })
            Text($r('app.string.SPATIAL_AUDIO')).fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .id('spatial_audio_card')
          .backgroundColor(Color.White)
          .borderRadius(24)
          .width(174)
          .height(188)
          .margin({right: 6})
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/SpatialAudio'});
          })
        }
        .width('50%')
        .justifyContent(FlexAlign.End)
      }
      .margin({ top: 32 })
      .width('100%')

    }
    .height('100%').width('100%').backgroundColor('#F1F3F5')
  }
}