/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
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

import Logger from '../../../ohosTest/ets/utils/Logger';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import audio from '@ohos.multimedia.audio';
import promptAction from '@ohos.promptAction'
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct SpatialAudio {
  private audioRenderers: audio.AudioRenderer[] = [];
  private audioRendererOptions: audio.AudioRendererOptions[] = [
    {
      streamInfo: {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
        channels: audio.AudioChannel.CHANNEL_2,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW,
        channelLayout: audio.AudioChannelLayout.CH_LAYOUT_STEREO
      },

      rendererInfo: {
        usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
        rendererFlags: 0
      }
    },
    {
      streamInfo: {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
        channels: audio.AudioChannel.CHANNEL_6,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW,
        channelLayout: audio.AudioChannelLayout.CH_LAYOUT_5POINT1
      },
      rendererInfo: {
        usage: audio.StreamUsage.STREAM_USAGE_MOVIE,
        rendererFlags: 0
      }
    }
  ];

  private appContext?: common.Context;
  private audioSources = ['/2p0.pcm', '/5p1.pcm'];
  private audioSpatializationManager?: audio.AudioSpatializationManager;
  private audioRoutingManager?: audio.AudioRoutingManager;
  private curPos: number[] = [0, 0]
  @State supportState: boolean = false;
  @State spatializationEnabled: boolean = false;
  @State musicState1: boolean = false;
  @State musicState2: boolean = false;

  @Builder press2PlayDemo1() {
    Image($r('app.media.ic_pause_spa'))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id'('2P0_play_btn')
      .fillColor('#182431')
      .onClick(async () => {
        this.musicState1 = !this.musicState1;
        await this.playAudio(0);
      })
  }

  @Builder press2PauseDemo1() {
    Image($r('app.media.ic_play_spa'))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id('2P0_pause_btn')
      .onClick(async () => {
        this.musicState1 = !this.musicState1;
        await this.pauseAudio(0);
      })
  }

  @Builder press2PlayDemo2() {
    Image($r('app.media.ic_pause_spa'))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id('5P1_play_btn')
      .fillColor('#182431')
      .onClick(async () => {
        if (this.spatializationEnabled === true) {
          this.musicState2 = !this.musicState2;
          await this.playAudio(1);
        } else {
          promptAction.showToast({
            duration: 3000,
            message: ('请开启空间音频')
          });
        }
      })
  }

  @Builder press2PauseDemo2() {
    Image($r('app.media.ic_play_spa'))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id('5P1_pause_btn')
      .onClick(async () => {
        this.musicState2 = !this.musicState2;
        await this.pauseAudio(1);
      })

  }

  @Builder audioVividIfNotSupport() {
    Text($r('app.string.5P1_MUSIC'))
      .fontSize(20)
      .fontWeight(500)
      .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
      .fontColor(Color.Grey)
      .margin({ top: 21, bottom: 21, left: 16.5 })

    Image($r('app.media.ic_pause_spa'))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id('5P1_play_btn')
  }

  @Builder audioVividIfSupport() {
    Text($r('app.string.5P1_MUSIC'))
      .fontSize(20)
      .fontWeight(500)
      .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
      .margin({ top: 21, bottom: 21, left: 16.5 })
  }

  @Builder dIYTitle() {
    Row() {
      Text($r('app.string.SPATIAL_AUDIO'))
        .fontWeight(700)
        .fontSize(20)
    }
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }

  showToastBySpatialEnabled(): void {
    if (this.spatializationEnabled === true) {
      promptAction.showToast({
        duration: 6000,
        message: ('空间音频已开启')
      });
    } else {
      promptAction.showToast({
        duration: 6000,
        message: ('空间音频已关闭')
      });
    }
  }

  updateSupportStateUI(): void {
    this.supportState = this.supportStateQuery();
    if (this.audioSpatializationManager) {
      try {
        this.spatializationEnabled = this.audioSpatializationManager.isSpatializationEnabledForCurrentDevice();
      } catch (err) {
        Logger.error(`update Support State UI failed ,Error: ${JSON.stringify(err)}`);
        return;
      }
    }
  }

  supportStateQuery(): boolean {
    if (this.audioRoutingManager) {
      let audioDeviceDescriptors: audio.AudioDeviceDescriptors =
        this.audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync(this.audioRendererOptions[0].rendererInfo);
      audioDeviceDescriptors.forEach(audioDeviceDescriptor => {
        console.info("Device Role:" + audioDeviceDescriptor.deviceRole + ", device Type:" +
        audioDeviceDescriptor.deviceType + ", Macaddress:" + audioDeviceDescriptor.address +
        ", Support:" + audioDeviceDescriptor.spatializationSupported);
      })

      let isSpaSupported: boolean = false;
      if (this.audioSpatializationManager) {
        try {
          isSpaSupported = audioDeviceDescriptors[0].spatializationSupported as boolean;
        } catch (err) {
          Logger.error(`supportStateQuery ,Error: ${JSON.stringify(err)}`);
        }
      } else {
        Logger.info("Get manager failed.");
      }
      return isSpaSupported;
    }
    return false;
  }

  async init(): Promise<void> {
    if (this.appContext) {
      return;
    }
    this.appContext = getContext(this);

    for (let index = 0; index < 2; index++) {
      try {
        let renderer = await audio.createAudioRenderer(this.audioRendererOptions[index]);
        Logger.info("Create renderer success");
        this.audioRenderers.push(renderer);
      } catch (err) {
        Logger.error(`audioRenderer_${index} create ,Error: ${JSON.stringify(err)}`);
        return;
      }
    }

    let audioManager = audio.getAudioManager();
    try {
      this.audioSpatializationManager = audioManager.getSpatializationManager();
    } catch (err) {
      Logger.error(`Get Spatialization Manager failed, Error: ${JSON.stringify(err)}`);
      return;
    }

    this.audioRoutingManager = audioManager.getRoutingManager();
    this.updateSupportStateUI();
    let t_audioRendererInfo: audio.AudioRendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
      rendererFlags: 0
    }
    if (this.audioRoutingManager) {
      this.audioRoutingManager.on("preferOutputDeviceChangeForRendererInfo", t_audioRendererInfo, () => {
        Logger.info("Output device changed");
        this.updateSupportStateUI();
        if (this.audioRenderers[1] && this.audioRenderers[1].state === audio.AudioState.STATE_RUNNING) {
          this.audioRenderers[1].pause();
          this.musicState2 = false;
        }
      })
    }
    if (this.audioSpatializationManager) {
      this.audioSpatializationManager.on("spatializationEnabledChangeForCurrentDevice", (res) => {
        this.spatializationEnabled = res;
        this.showToastBySpatialEnabled();
      })
    }
  }

  async over(): Promise<void> {
    this.appContext = undefined;
    try {
      this.audioRenderers[0].stop();
      this.audioRenderers[0].release();
      this.audioRenderers[1].stop();
      this.audioRenderers[1].release();
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(`AudioRenderer stop or release : Error: ${JSON.stringify(error)}`);
      return;
    }
    this.audioRenderers = [];

    if (this.audioRoutingManager) {
      this.audioRoutingManager.off("deviceChange");
    }

    if (this.audioSpatializationManager) {
      this.audioSpatializationManager.off("spatializationEnabledChangeForCurrentDevice");
    }
  }

  async playAudio(index: number): Promise<void> {
    if (this.audioRenderers[index] === null) {
      return;
    }

    let bufferSize: number = 0;
    try {
      bufferSize = await this.audioRenderers[index].getBufferSize();
      await this.audioRenderers[index].start();
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(`AudioRenderer start : Error: ${JSON.stringify(error)}`);
      return;
    }

    let buf = new ArrayBuffer(bufferSize);
    let filePath: string = "";
    if (this.appContext) {
      filePath = this.appContext.filesDir + this.audioSources[index];
    }
    let stat = await fs.stat(filePath);
    let len = stat.size % bufferSize == 0 ? Math.floor(stat.size / bufferSize) : Math.floor(stat.size / bufferSize + 1);
    let file = await fs.open(filePath, 0o0);
    let i: number = this.curPos[index]

    while (true) {
      if (!this.audioRenderers[index]) {
        break;
      }
      Logger.info("start write");
      while (i < len) {
        if (this.audioRenderers[index].state === audio.AudioState.STATE_RELEASED) {
          return;
        }
        if (this.audioRenderers[index].state === audio.AudioState.STATE_PAUSED) {
          this.curPos[index] = i;
          return;
        }

        class options {
          offset: number = 0
          length: number = 0
        }

        let readOptions: options = {
          offset: i * bufferSize,
          length: bufferSize
        }
        await fs.read(file.fd, buf, readOptions);
        await this.audioRenderers[index].write(buf);
        i += 1;
      }
      i = 0;
    }

  }

  async pauseAudio(index: number): Promise<void> {
    try {
      if (this.audioRenderers[index]) {
        await this.audioRenderers[index].pause();
      }
    } catch (err) {
      Logger.error(`Pause Error: ${JSON.stringify(err)}`);
      return;
    }
  }

  async aboutToAppear(): Promise<void> {
    await this.init();
  }

  aboutToDisappear(): void {
    this.over();
  }

  onPageShow(): void {
    if (this.audioSpatializationManager === undefined) {
      return;
    }
    this.updateSupportStateUI()
    Logger.info("Page show");
  }

  onPageHide(): void {
    Logger.info("Page Hide");
    if (this.audioRenderers[0] && this.audioRenderers[0].state === audio.AudioState.STATE_RUNNING) {
      this.audioRenderers[0].pause();
      this.musicState1 = false;
    }
    if (this.audioRenderers[1] && this.audioRenderers[1].state === audio.AudioState.STATE_RUNNING) {
      this.audioRenderers[1].pause();
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
          .title(this.dIYTitle())
          .mode(NavigationMode.Stack)
        }
        .height(56)
        .width(360)
        .id('spatial_audio_back_btn')
        .onClick(async () => {
          await router.replaceUrl({ url: 'pages/Index' });
        })

        Row() {
          Row() {
            Text($r('app.string.2P0_MUSIC'))
              .fontSize(20)
              .fontWeight(500)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .margin({ top: 21, bottom: 21, left: 16.5 })
            if (!this.musicState1) {
              this.press2PlayDemo1();
            } else {
              this.press2PauseDemo1();
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
            if (this.supportState === false) {
              this.audioVividIfNotSupport();
            } else {
              this.audioVividIfSupport();
              if (!this.musicState2) {
                this.press2PlayDemo2();
              } else {
                this.press2PauseDemo2();
              }
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
      .justifyContent(FlexAlign.Start)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f3f5')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}