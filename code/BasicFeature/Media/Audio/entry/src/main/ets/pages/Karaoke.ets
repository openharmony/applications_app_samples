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

  private reverbPresetNameMap = new Map<audio.AudioLoopbackReverbPreset, Resource>([
    [audio.AudioLoopbackReverbPreset.ORIGINAL, $r('app.string.ORIGINAL')],
    [audio.AudioLoopbackReverbPreset.KTV, $r('app.string.KTV')],
    [audio.AudioLoopbackReverbPreset.THEATER, $r('app.string.THEATER')],
    [audio.AudioLoopbackReverbPreset.CONCERT, $r('app.string.CONCERT')],
  ]);
  
  private equalizerPresetNameMap = new Map<audio.AudioLoopbackEqualizerPreset, string>([
    [audio.AudioLoopbackEqualizerPreset.FLAT, '平坦'],
    [audio.AudioLoopbackEqualizerPreset.FULL, '饱满'],
    [audio.AudioLoopbackEqualizerPreset.BRIGHT, '明亮'],
  ]);

  // Initial loopback mode: hardware
  @State mode: audio.AudioLoopbackMode = audio.AudioLoopbackMode.HARDWARE;
  @State currentReverbPreset: audio.AudioLoopbackReverbPreset = audio.AudioLoopbackReverbPreset.THEATER;
  @State currentEqualizerPreset: audio.AudioLoopbackEqualizerPreset = audio.AudioLoopbackEqualizerPreset.FULL;
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
        Logger.info('createAudioLoopback succeeded.');
        this.audioLoopback = loopback;
        this.statusText = $r('app.string.KARAOKE_INITIALIZED');
        this.showStatusText();
      }).catch((err: BusinessError) => {
        Logger.error(`createAudioLoopback failed, code is ${err.code}, message is ${err.message}.`);
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
            Logger.info('enable succeeded');
          } else {
            status = await this.audioLoopback.getStatus();
            this.statusChangeCallback(status);
          }
        } else {
          this.statusChangeCallback(status);
        }
      } catch (err) {
        Logger.error(`enable failed, code is ${err.code}, message is ${err.message}.`);
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
            Logger.info('disable succeeded');
            this.audioLoopback.off('statusChange', this.statusChangeCallback);
          } else {
            status = await this.audioLoopback.getStatus();
            this.statusChangeCallback(status);
          }
        } else {
          this.statusChangeCallback(status);
        }
      } catch (err) {
        Logger.error(`disable failed, code is ${err.code}, message is ${err.message}.`);
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
        Logger.info(`setVolume ${this.volume} succeeded.`);
      } catch (err) {
        Logger.error(`setVolume failed, code is ${err.code}, message is ${err.message}.`);
      }
    } else {
      Logger.error('Audio loopback not created.');
    }
  }

  // Set audio loopback ReverbPreset
  setReverbPreset(preset: audio.AudioLoopbackReverbPreset): void {
    if (this.audioLoopback !== undefined) {
      try {
        this.audioLoopback.setReverbPreset(preset);
        Logger.info(`setReverbPreset( ${preset} succeeded.`);
        this.currentReverbPreset = this.audioLoopback.getReverbPreset();
      } catch (err) {
        Logger.error(`setReverbPreset( failed, code is ${err.code}, message is ${err.message}.`);
      }
    } else {
      Logger.error('Audio loopback not created.');
    }
  }

  // Set audio loopback EqualizerPreset
  setEqualizerPreset(preset: audio.AudioLoopbackEqualizerPreset): void {
    if (this.audioLoopback !== undefined) {
      try {
        this.audioLoopback.setEqualizerPreset(preset);
        Logger.info(`setEqualizerPreset ${preset} succeeded.`);
        this.currentEqualizerPreset = this.audioLoopback.getEqualizerPreset();
      } catch (err) {
        Logger.error(`setEqualizerPreset failed, code is ${err.code}, message is ${err.message}.`);
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
        max: 1,
        step: 0.01,
        style: SliderStyle.OutSet
      })
      .width('80%')
      .onChange((val: number) => this.setVolume(val))
      .id('karaoke_volume_slider')
      Text($r('app.string.Reverb')).fontSize(16).margin({ top: 24 }).id('karaoke_reverb_label').margin(5)
      Row() {
        ForEach(Array.from(this.reverbPresetNameMap.entries()), (item: [number, string]) => {
          Button(item[1])
          .width('22%')
          .height(40)
          .fontSize(12)
          .fontColor('#FFF')
          .backgroundColor(item[0] === this.currentReverbPreset ? '#0A59F7' : '#888')
          .onClick(()=>this.setReverbPreset(item[0]))
          .margin(5)
          .borderRadius(8)
        })
      }
      Text($r('app.string.Equalizer')).fontSize(16).margin({ top: 24 }).id('karaoke_equalizer_label')
      Row() {
        ForEach(Array.from(this.equalizerPresetNameMap.entries()), (item: [number, string]) => {
          Button(item[1])
          .width('22%')
          .height(40)
          .fontSize(12)
          .fontColor('#FFF')
          .backgroundColor(item[0] === this.currentEqualizerPreset ? '#0A59F7' : '#888')
          .onClick(()=>this.setEqualizerPreset(item[0]))
          .margin(5)
          .borderRadius(8)
        })

      }
    }
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor('#F9F9F9')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}

