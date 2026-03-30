/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { router,window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { audio } from '@kit.AudioKit';
import { AudioPlayer } from './AudioPlayer';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct CallOut {
  private context: Context = this.getUIContext().getHostContext() as Context;
  private audioPlayer: AudioPlayer = new AudioPlayer();

  onBackPress(): boolean | void {
    return true;
  }

  aboutToAppear(): void {
    let windowClass = window.getLastWindow(getContext(this))
    windowClass.then((win) => {
      win.setWindowLayoutFullScreen(true)
    })
    // 申请长时任务
    this.audioPlayer.startContinuousTask(this.context);

    // 播放提示音
    this.startRinging();
  }

  aboutToDisappear(): void {
    // 取消长时任务
    this.audioPlayer.stopContinuousTask(this.context);
  }

  async startRinging() {
    try {
      await this.audioPlayer.avSetAudio(audio.StreamUsage.STREAM_USAGE_RINGTONE, 'test_01.mp3', true);
    } catch (error) {
      console.error(`播放失败: ${error.code}, ${error.message}`);
    }
  }

  async stopRinging() {
    try {
      this.audioPlayer.stop();
      this.audioPlayer.release();
    } catch (error) {
      console.error(`播放失败: ${error.code}, ${error.message}`);
    }
  }

  build() {
    Stack() {
      Image($r('app.media.background_main'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        Text($r('app.string.INCOMING_CALL'))
          .fontSize($r('app.float.page_title_font_size'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.float.page_title_margin') })

        Row({ space: $r('app.float.main_button_space') }) {
          Column({ space: 10 }) {
            Button() {
              Image($r('app.media.phone'))
                .width($r('app.float.main_button_size'))
                .height($r('app.float.main_button_size'))
                .objectFit(ImageFit.Contain)
                .borderRadius(50)
            }
            .type(ButtonType.Circle)
            .width($r('app.float.main_button_size'))
            .height($r('app.float.main_button_size'))
            .onClick(async () => {
              this.stopRinging();
              await router.pushUrl({ url: 'pages/InCalling' })
            })

            Text($r('app.string.ANSWER_THE_CALL'))
              .fontSize($r('app.float.main_button_text_font_size'))
              .fontColor(Color.White)
          }

          Column({ space: 10 }) {
            Button() {
              Image($r('app.media.phone_down'))
                .width($r('app.float.main_button_size'))
                .height($r('app.float.main_button_size'))
                .objectFit(ImageFit.Contain)
                .borderRadius(50)
            }
            .type(ButtonType.Circle)
            .width($r('app.float.main_button_size'))
            .height($r('app.float.main_button_size'))
            .onClick(async () => {
              this.stopRinging();
              await router.back({ url: 'pages/Index' })
            })

            Text($r('app.string.REFUSE_THE_CALL'))
              .fontSize($r('app.float.main_button_text_font_size'))
              .fontColor(Color.White)
          }
        }
        .margin({ top: $r('app.float.button_margin') })
      }
      .height('100%')
      .width('100%')
    }
  }
}