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
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Image($r('app.media.png01_Soundeffectsxhdpi')).width(160).height(160).margin({ top: 48 });
        Text($r('app.string.AudioEffectManager')).fontColor(Color.Black).fontSize(18).margin({ top: 24 });
      }
      .id('audio_effect_manager_card')
      .backgroundColor(Color.White)
      .borderRadius(30)
      .margin({ right: 12 })
      .width(174)
      .height(188)
      .position({ x: 150, y: 100 })
      .onClick(async () => {
        await router.pushUrl({ url: 'pages/PresetEffect' });
      })
    }
    .height('100%')
  }
}