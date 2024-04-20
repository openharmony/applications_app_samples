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
import audio from '@ohos.multimedia.audio';
import display from '@ohos.display';
import { AVVolumePanel } from '@ohos.multimedia.avVolumePanel';

@Entry
@Component
struct VolumePanel {
  @State private curMediaVolume: number = 0;
  private audioManager: audio.AudioManager = audio.getAudioManager();
  private audioVolumeManager: audio.AudioVolumeManager | undefined = undefined;

  aboutToAppear(): void {
    this.audioVolumeManager = this.audioManager.getVolumeManager();
    this.audioVolumeManager?.on('volumeChange', async (data) => {
      let event: audio.VolumeEvent = data;
      this.curMediaVolume = event.volume;
    })
  }

  build() {
    Column() {
      Row() {
        Navigation() {
          NavRouter() {
            NavDestination() {
            }
          }
        }
        .height('100%')
        .width('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        .title($r('app.string.AVVOLUME_PANEL_TITLE'))
        .mode(NavigationMode.Stack);
      }.height(56).width('100%').id('back_btn_focus')
      .onClick(async () => {
        await router.pushUrl({ url: 'pages/Index' });
      });

      Column() {
        Row() {
          Button() {
            Text($r('app.string.VOLUME_UP')).fontSize(22).fontColor(Color.White)
          }.width('49%').height(60).onClick(() => {
            this.curMediaVolume++;
          })

          Button() {
            Text($r('app.string.VOLUME_DOWN')).fontSize(22).fontColor(Color.White)
          }.width('49%').height(60).onClick(() => {
            this.curMediaVolume--;
          })
        }.margin(({ top: 10 })).width('100%').justifyContent(FlexAlign.SpaceBetween)

        AVVolumePanel({
          volumeLevel: this.curMediaVolume,
          volumeParameter: {
            position: {
              x: display.getDefaultDisplaySync().width / 2 - vp2px(20),
              y: display.getDefaultDisplaySync().height / 2 - vp2px(83)
            }
          }
        })
      }
    }
  }
}