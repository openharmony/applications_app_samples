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
import testNapi from 'libentry.so';

const STATE_PAUSED = 2;

@Entry
@Component
struct AudioVividPlayback {
  @State musicState1: boolean = false;
  @State musicState2: boolean = false;

  @Builder DIYTitle() {
    Row() {
      Text($r("app.string.AUDIOVIVID_PLAYBACK"))
        .fontWeight(700)
        .fontSize(20)
    }
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }


  @Builder Press2PlayDemo1() {
    Image($r("app.media.ic_record_paused"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("normal_play_btn")
      .onClick(async () => {
        testNapi.avpAudioRendererStart();
        this.musicState1 = !this.musicState1;
      })
  }

  @Builder Press2PauseDemo1() {
    Image($r("app.media.ic_record_playing"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("normal_pause_btn")
      .onClick(async () => {
        testNapi.avpAudioRendererPause();
        this.musicState1 = !this.musicState1;
      })
  }

  @Builder Press2PlayDemo2() {
    Image($r("app.media.ic_record_paused"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("vivid_play_btn")
      .onClick(async () => {
        testNapi.avpVividAudioRendererStart();
        this.musicState2 = !this.musicState2;
      })
  }

  @Builder Press2PauseDemo2() {
    Image($r("app.media.ic_record_playing"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("vivid_pause_btn")
      .onClick(async () => {
        testNapi.avpVividAudioRendererPause();
        this.musicState2 = !this.musicState2;
      })

  }

  aboutToAppear(): void {
    testNapi.avpAudioRendererInit();
    testNapi.avpVividAudioRendererInit();
  }


  aboutToDisappear(): void {
    testNapi.avpAudioRendererStop();
    testNapi.avpAudioRendererRelease();
    testNapi.avpVividAudioRendererStop();
    testNapi.avpVividAudioRendererRelease();
  }

  onPageHide(): void {
    if (testNapi.avpGetRendererState() === STATE_PAUSED) {
      testNapi.avpAudioRendererPause();
      this.musicState1 = false;
    }
    if (testNapi.avpVividGetRendererState() === STATE_PAUSED) {
      testNapi.avpVividAudioRendererPause();
      this.musicState2 = false;
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Navigation() {
          }
          .hideBackButton(false)
          .titleMode(NavigationTitleMode.Mini)
          .title(this.DIYTitle())
          .mode(NavigationMode.Stack)
        }
        .height(56)
        .width(360)
        .id('spatial_audio_back_btn')
        .onClick(async () => {
          testNapi.avpAudioRendererStop();
          testNapi.avpAudioRendererRelease();
          testNapi.avpVividAudioRendererStop();
          testNapi.avpVividAudioRendererRelease();
          await router.replaceUrl({ url: 'pages/Index' });
        })

        Row() {
          Row() {
            Text($r("app.string.NORMAL_PLAY"))
              .fontSize(20)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .margin({ top: 21, bottom: 21, left: 16.5 })
            if (!this.musicState1) {
              this.Press2PlayDemo1();
            } else {
              this.Press2PauseDemo1();
            }
          }
          .height("100%")
          .width(336)
          .backgroundColor('#FFFFFF')
          .justifyContent(FlexAlign.SpaceBetween)
          .borderRadius(24)
        }
        .justifyContent(FlexAlign.SpaceAround)
        .height(68)
        .width('100%')
        .margin({ top: 8 })

        Row() {
          Row() {
            Text($r("app.string.VIVID_PLAY"))
              .fontSize(20)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .margin({ top: 21, bottom: 21, left: 16.5 })

            if (!this.musicState2) {
              this.Press2PlayDemo2();
            } else {
              this.Press2PauseDemo2();
            }
          }
          .height("100%")
          .width(336)
          .backgroundColor('#FFFFFF')
          .justifyContent(FlexAlign.SpaceBetween)
          .borderRadius(24)
        }
        .justifyContent(FlexAlign.SpaceAround)
        .height(68)
        .width('100%')
        .margin({ top: 12 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f1f3f5')
      .justifyContent(FlexAlign.Start)

    }
  }
}