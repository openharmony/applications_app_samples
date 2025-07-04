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
    Scroll() {
      Column() {
        Row() {
          Column() {
            Image($r('app.media.png01_findxhdpi')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.SelectOutputDevice')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('select_output_device_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/PreferOutputDevice' });
          });

          Column() {
            Image($r('app.media.png01_audioxhdpi')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.AudioFocus')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('audio_focus_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/Focus' });
          });
        }
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Image($r('app.media.png01_Soundeffectsxhdpi')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.AudioEffectManager')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('audio_effect_manager_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/PresetEffect' });
          });

          Column() {
            Image($r('app.media.png01_Recordingxxxhdpi')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.AUDIO_CAPTURER')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('audio_capturer_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/NormalCapturer' });
          });
        }
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Image($r('app.media.ic_Sound_select')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.AVVOLUME_PANEL')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/VolumePanel' });
          });

          Column() {
            Image($r('app.media.ic_index_spatial')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.SPATIAL_AUDIO')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('spatial_audio_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/SpatialAudio' });
          });
        }
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Image($r('app.media.png01_Karaoke')).width(72).height(72).margin({ top: 24 });
            Text($r('app.string.KARAOKE')).fontColor(Color.Black).fontSize(16).margin({ top: 12 });
          }
          .id('karaoke_card')
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            await router.pushUrl({ url: 'pages/Karaoke' });
          });

          Blank().width('45%').height('25%');
        }
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .padding(12)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5');
  }
}