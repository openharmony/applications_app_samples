/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import promptAction from '@ohos.promptAction';
import Logger from '../../../ohosTest/ets/utils/Logger';
const TAG = 'KaraokePage';

@Entry
@Component
struct KaraokePage {
  @State audioLoopback: audio.AudioLoopback | undefined = undefined;
  @State statusText: Resource = $r('app.string.KARAOKE_NOT_INITIALIZED');
  @State volume: number = 50;

  // Initial loopback mode: hardware
  @State mode: audio.AudioLoopbackMode = audio.AudioLoopbackMode.HARDWARE;

  // Audio loopback status change callback
  private statusChangeCallback = (status: audio.AudioLoopbackStatus) => {
    if (status == audio.AudioLoopbackStatus.UNAVAILABLE_DEVICE) {
      this.statusText = $r('app.string.KARAOKE_DEVICE_UNSUPPORTED');
      Logger.info('Audio loopback status is: UNAVAILABLE_DEVICE');
    } else if (status == audio.AudioLoopbackStatus.UNAVAILABLE_SCENE) {
      this.statusText = $r('app.string.KARAOKE_SCENE_UNSUPPORTED');
      Logger.info('Audio loopback status is: UNAVAILABLE_SCENE');
    } else if (status == audio.AudioLoopbackStatus.AVAILABLE_IDLE) {
      this.statusText = $r('app.string.KARAOKE_IDLE');
      Logger.info('Audio loopback status is: AVAILABLE_IDLE');
    } else if (status == audio.AudioLoopbackStatus.AVAILABLE_RUNNING) {
      this.statusText = $r('app.string.KARAOKE_RUNNING');
      Logger.info('Audio loopback status is: AVAILABLE_RUNNING');
    }
    this.showStatusText();
  };

  private showStatusText() {
    if (this.statusText) {
      promptAction.showToast({
        message: this.statusText,
        duration: 2000
      });
    }
  }

  // Initialize the audio loopback
  async initLoopback() {
    let isSupported = audio.getAudioManager().getStreamManager().isAudioLoopbackSupported(this.mode);
    if (isSupported) {
      audio.createAudioLoopback(this.mode).then((loopback) => {
        Logger.info('Invoke createAudioLoopback succeeded.');
        this.audioLoopback = loopback;
        this.statusText = $r('app.string.KARAOKE_INITIALIZED');
        this.showStatusText();
      }).catch((err: BusinessError) => {
        Logger.error(`Invoke createAudioLoopback failed, code is ${err.code}, message is ${err.message}.`);
        this.statusText = $r('app.string.KARAOKE_INITIALIZATION_FAILED');
        this.showStatusText();
      });
    } else {
      this.statusText = $r('app.string.KARAOKE_UNSUPPORTED_HARDWARE');
      this.showStatusText();
      Logger.error('Audio loopback is unsupported.');
    }
  }

  // Enable audio loopback
  async enableLoopback() {
    if (this.audioLoopback !== undefined) {
      try {
        let status = await this.audioLoopback.getStatus();
        if (status == audio.AudioLoopbackStatus.AVAILABLE_IDLE) {
          this.audioLoopback.on('statusChange', this.statusChangeCallback);
          let success = await this.audioLoopback.enable(true);
          if (success) {
            Logger.info('Invoke enable succeeded');
          } else {
            status = await this.audioLoopback.getStatus();
            this.statusChangeCallback(status);
          }
        } else {
          this.statusChangeCallback(status);
        }
      } catch (err) {
        Logger.error(`Invoke enable failed, code is ${err.code}, message is ${err.message}.`);
      }
    } else {
      this.statusText = $r('app.string.KARAOKE_NO_INSTANCE');
      Logger.error('Audio loopback not created.');
    }
  }

  // Disable audio loopback
  async disableLoopback() {
    if (this.audioLoopback !== undefined) {
      try {
        let status = await this.audioLoopback.getStatus();
        if (status == audio.AudioLoopbackStatus.AVAILABLE_RUNNING) {
          let success = await this.audioLoopback.enable(false);
          this.statusText = $r('app.string.KARAOKE_IDLE');
          if (success) {
            Logger.info('Invoke disable succeeded');
            this.audioLoopback.off('statusChange', this.statusChangeCallback);
          } else {
            status = await this.audioLoopback.getStatus();
            this.statusChangeCallback(status);
          }
        } else {
          this.statusChangeCallback(status);
        }
      } catch (err) {
        Logger.error(`Invoke disable failed, code is ${err.code}, message is ${err.message}.`);
      }
    } else {
      this.statusText = $r('app.string.KARAOKE_NO_INSTANCE');
      Logger.error('Audio loopback not created.');
    }
  }

  // Set audio loopback volume
  async setVolume(newVolume: number) {
    this.volume = newVolume;
    if (this.audioLoopback !== undefined) {
      try {
        await this.audioLoopback.setVolume(this.volume);
        Logger.info(`Invoke setVolume ${this.volume} succeeded.`);
      } catch (err) {
        Logger.error(`Invoke setVolume failed, code is ${err.code}, message is ${err.message}.`);
      }
    } else {
      Logger.error('Audio loopback not created.');
    }
  }

  build() {
    Column({ space: 20 }) {
      Text($r('app.string.KARAOKE_DEMO_TITLE')).fontSize(24).fontWeight(FontWeight.Bold).padding(16).id('karaoke_title')

      Text(this.statusText).fontSize(16).padding(8).id('karaoke_status_text')

      Button($r('app.string.KARAOKE_INIT_BUTTON'))
        .onClick(() => this.initLoopback())
        .width('80%').margin(8)
        .id('karaoke_init_btn')

      Button($r('app.string.KARAOKE_ENABLE_BUTTON'))
        .onClick(() => this.enableLoopback())
        .width('80%').margin(8)
        .id('karaoke_enable_btn')

      Button($r('app.string.KARAOKE_DISABLE_BUTTON'))
        .onClick(() => this.disableLoopback())
        .width('80%').margin(8)
        .id('karaoke_disable_btn')

      Text($r('app.string.KARAOKE_VOLUME_LABEL')).fontSize(16).margin({ top: 24 }).id('karaoke_volume_label')

      Slider({
        value: this.volume,
        min: 0,
        max: 100,
        step: 1,
        style: SliderStyle.OutSet
      })
      .width('80%')
      .onChange((val: number) => this.setVolume(val))
      .id('karaoke_volume_slider')
    }
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor('#F9F9F9')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}

