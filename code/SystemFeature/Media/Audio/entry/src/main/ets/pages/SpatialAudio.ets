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

import Logger from '../../../ohosTest/ets/utils/Logger';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import audio from '@ohos.multimedia.audio';
import { BusinessError } from '@ohos.base';

const CLOSE_MODE = 0;
const OPEN_MODE = 1;
const TRACKING_MODE = 2;

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
  @State supportState: number = 1;
  @State spatializationEnabled: boolean = false;
  @State trackingEnabled: boolean = false;
  @State musicState1: boolean = false;
  @State musicState2: boolean = false;
  @State spatialSceneMode: audio.AudioSpatializationSceneType = audio.AudioSpatializationSceneType.DEFAULT;

  @Builder Press2PlayDemo1() {
    Image($r("app.media.ic_pause_spa"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("2P0_play_btn")
      .onClick(async () => {
        this.musicState1 = !this.musicState1;
        await this.playAudio(0);
      })
  }

  @Builder Press2PauseDemo1() {
    Image($r("app.media.ic_play_spa"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("2P0_pause_btn")
      .onClick(async () => {
        this.musicState1 = !this.musicState1;
        await this.pauseAudio(0);
      })
  }

  @Builder Press2PlayDemo2() {
    Image($r("app.media.ic_pause_spa"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("5P1_play_btn")
      .onClick(async () => {
        this.musicState2 = !this.musicState2;
        await this.playAudio(1);
      })
  }

  @Builder Press2PauseDemo2() {
    Image($r("app.media.ic_play_spa"))
      .height(36)
      .width(36)
      .margin({ right: 16 })
      .id("5P1_pause_btn")
      .onClick(async () => {
        this.musicState2 = !this.musicState2;
        await this.pauseAudio(1);
      })

  }

  @Builder CloseModeOn() {
    Image($r("app.media.ic_audio_close_on"))
      .height(48)
      .width(48)
      .margin({ left: 8 })
      .id("close_mode_on")
  }

  @Builder CloseModeOff() {
    Image($r("app.media.ic_audio_close_normal"))
      .height(48)
      .width(48)
      .margin({ left: 8 })
      .id("close_mode_off")
      .onClick(async () => {
        if (this.supportState !== CLOSE_MODE && this.audioSpatializationManager) {
          try {
            this.audioSpatializationManager.setSpatializationEnabled(false, () => {
            })
            this.audioSpatializationManager.setHeadTrackingEnabled(false, () => {
            })
          } catch (err) {
            Logger.error(`Set Spatialization or Head Tracking disabled failed, ${JSON.stringify(err)}`);
            return;
          }
        }
      })
  }

  @Builder OpenModeDisabled() {
    Image($r("app.media.ic_audio_open_disable"))
      .height(48)
      .width(48)
  }

  @Builder OpenModeOn() {
    Image($r("app.media.ic_audio_open_on"))
      .height(48)
      .width(48)
      .id("open_mode_on")
  }

  @Builder OpenModeOff() {
    Image($r("app.media.ic_audio_open_normal"))
      .height(48)
      .width(48)
      .id("open_mode_off")
      .onClick(async () => {
        if (this.audioSpatializationManager) {
          try {
            this.audioSpatializationManager.setSpatializationEnabled(true, () => {
            })
            this.audioSpatializationManager.setHeadTrackingEnabled(false, () => {
            })
          } catch (err) {
            Logger.error(`Set open mode failed, ${JSON.stringify(err)}`);
            return;
          }
        }

      })
  }

  @Builder TrackingModeOn() {
    Image($r("app.media.ic_audio_track_on"))
      .height(48)
      .width(48)
      .margin({ right: 8 })
      .id("tracking_mode_on")
  }

  @Builder TrackingModeOff() {
    Image($r("app.media.ic_audio_track_normal"))
      .height(48)
      .width(48)
      .margin({ right: 8 })
      .id("tracking_mode_off")
      .onClick(async () => {
        if (this.audioSpatializationManager) {
          try {
            this.audioSpatializationManager.setSpatializationEnabled(true, () => {
            })
            this.audioSpatializationManager.setHeadTrackingEnabled(true, () => {
            })
          } catch (err) {
            Logger.error(`Set HeadTracking enabled failed, ${JSON.stringify(err)}`);
            return;
          }
        }
      })
  }

  @Builder TrackingModeDisabled() {
    Image($r("app.media.ic_audio_track_disable"))
      .height(48)
      .width(48)
      .margin({ right: 8 })
      .fillColor("#182431")
  }

  @Builder UIForClose() {
    this.CloseModeOn();
    this.OpenModeDisabled();
    this.TrackingModeDisabled();
  }

  @Builder UIForOpen() {
    if (this.spatializationEnabled === true) {
      this.CloseModeOff();
      this.OpenModeOn();
    } else {
      this.CloseModeOn();
      this.OpenModeOff();
    }
    this.TrackingModeDisabled();
  }

  @Builder UIForTracking() {
    if (this.spatializationEnabled === true && this.trackingEnabled === true) {
      this.CloseModeOff();
      this.OpenModeOff();
      this.TrackingModeOn();
    } else if (this.spatializationEnabled === true && this.trackingEnabled === false) {
      this.CloseModeOff();
      this.OpenModeOn();
      this.TrackingModeOff();
    } else {
      this.CloseModeOn();
      this.OpenModeOff();
      this.TrackingModeOff();
    }
  }

  @Builder OpenTextEnable() {
    Text($r("app.string.OPEN_TEXT"))
      .height("100%")
      .width(64)
      .fontSize(12)
      .fontWeight(500)
      .margin({ right: 68 })
      .fontColor("#182431")
      .textAlign(TextAlign.Center)
  }

  @Builder OpenTextDisable() {
    Text($r("app.string.OPEN_TEXT"))
      .height("100%")
      .width(64)
      .fontSize(12)
      .fontWeight(500)
      .margin({ right: 68 })
      .fontColor(Color.Grey)
      .textAlign(TextAlign.Center)
      .id("open_mode_disabled")
  }

  @Builder TrackingTextEnable() {
    Text($r("app.string.TRACKING_TEXT"))
      .height(16)
      .width(48)
      .fontSize(12)
      .fontWeight(500)
      .fontColor("#182431")
      .textAlign(TextAlign.Center)
  }

  @Builder TrackingTextDisable() {
    Text($r("app.string.TRACKING_TEXT"))
      .height(16)
      .width(48)
      .fontSize(12)
      .fontWeight(500)
      .fontColor(Color.Grey)
      .textAlign(TextAlign.Center)
      .id("tracking_mode_disabled")
  }

  @Builder DIYTitle() {
    Row() {
      Text($r('app.string.SPATIAL_AUDIO'))
        .fontWeight(700)
        .fontSize(20)
    }
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }

  @Builder ChooseSpatialSceneMode() {
    Row() {
      Row() {
        Text($r('app.string.SPATIAL_SCENE_MODE'))
          .fontSize(14)
          .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          .fontColor('#000000')
          .opacity(0.6)
          .fontWeight(500)
      }
      .height(20)
      .width(176)
      .margin({ top: 28, left: 28 })
      .justifyContent(FlexAlign.Start)
    }
    .width(360)
    .height(56)
    .justifyContent(FlexAlign.Start)

    Column() {
      Row() {
        Image($r('app.media.ic_space_normal'))
          .height(24)
          .width(24)
        Row() {
          Text($r('app.string.SCENE_MODE_DEFAULT'))
            .fontSize(16)
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            .fontColor('#000000')
            .opacity(0.9)
            .fontWeight(500)
          Checkbox()
            .shape((CheckBoxShape.CIRCLE))
            .select(this.spatialSceneMode === audio.AudioSpatializationSceneType.DEFAULT)
            .margin({ right: 2 })
            .height(20)
            .width(20)
            .onChange((value: boolean) => {
              if (value === true) {
                this.spatialSceneMode = audio.AudioSpatializationSceneType.DEFAULT;
                if (this.audioSpatializationManager) {
                  try {
                    this.audioSpatializationManager.setSpatializationSceneType(this.spatialSceneMode);
                  } catch (err) {
                    Logger.error(`setSpatializationSceneType failed ,Error: ${JSON.stringify(err)}`);
                    return;
                  }
                }

              }
            })
        }
        .width(264)
        .height(22)
        .margin({ left: 16 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(304)
      .height(55.5)

      Row() {
        Column() {
        }
        .width(264)
        .height(0.5)
        .opacity(0.05)
        .backgroundColor('#000000')
      }
      .justifyContent(FlexAlign.End)
      .width(304)
      .height(0.5)

      Row() {
        Image($r('app.media.ic_space_theatre'))
          .height(24)
          .width(24)
        Row() {
          Text($r('app.string.SCENE_MODE_AUDIOBOOK'))
            .fontSize(16)
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            .fontColor('#000000')
            .opacity(0.9)
            .fontWeight(500)
          Checkbox()
            .shape((CheckBoxShape.CIRCLE))
            .margin({ right: 2 })
            .height(20)
            .width(20)
            .select(this.spatialSceneMode === audio.AudioSpatializationSceneType.AUDIOBOOK)
            .onChange((value: boolean) => {
              if (value === true) {
                this.spatialSceneMode = audio.AudioSpatializationSceneType.AUDIOBOOK;
                if (this.audioSpatializationManager) {
                  try {
                    this.audioSpatializationManager.setSpatializationSceneType(this.spatialSceneMode);
                  } catch (err) {
                    Logger.error(`setSpatializationSceneType failed ,Error: ${JSON.stringify(err)}`);
                    return;
                  }
                }
              }
            })
        }
        .width(264)
        .height(22)
        .margin({ left: 16 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(304)
      .height(55.5)

      Row() {
        Column() {
        }
        .width(264)
        .height(0.5)
        .opacity(0.05)
        .backgroundColor('#000000')
      }
      .justifyContent(FlexAlign.End)
      .width(304)
      .height(0.5)

      Row() {
        Image($r('app.media.ic_space_movie'))
          .height(24)
          .width(24)
        Row() {
          Text($r('app.string.SCENE_MODE_MOVIE'))
            .fontSize(16)
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            .fontColor('#000000')
            .opacity(0.9)
            .fontWeight(500)
          Checkbox()
            .shape((CheckBoxShape.CIRCLE))
            .margin({ right: 2 })
            .height(20)
            .width(20)
            .select(this.spatialSceneMode === audio.AudioSpatializationSceneType.MOVIE)
            .onChange((value: boolean) => {
              if (value === true) {
                this.spatialSceneMode = audio.AudioSpatializationSceneType.MOVIE;
                if (this.audioSpatializationManager) {
                  try {
                    this.audioSpatializationManager.setSpatializationSceneType(this.spatialSceneMode);
                  } catch (err) {
                    Logger.error(`setSpatializationSceneType failed ,Error: ${JSON.stringify(err)}`);
                    return;
                  }
                }
              }
            })
        }
        .width(264)
        .height(22)
        .margin({ left: 16 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(304)
      .height(55.5)

      Row() {
        Column() {
        }
        .width(264)
        .height(0.5)
        .opacity(0.05)
        .backgroundColor('#000000')
      }
      .justifyContent(FlexAlign.End)
      .width(304)
      .height(0.5)

      Row() {
        Image($r('app.media.ic_space_music'))
          .height(24)
          .width(24)
        Row() {
          Text($r('app.string.SCENE_MODE_MUSIC'))
            .fontSize(16)
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            .fontColor('#000000')
            .opacity(0.9)
            .fontWeight(500)
          Checkbox()
            .shape((CheckBoxShape.CIRCLE))
            .margin({ right: 2 })
            .height(20)
            .width(20)
            .select(this.spatialSceneMode === audio.AudioSpatializationSceneType.MUSIC)
            .onChange((value: boolean) => {
              if (value === true) {
                this.spatialSceneMode = audio.AudioSpatializationSceneType.MUSIC;
                if (this.audioSpatializationManager) {
                  try {
                    this.audioSpatializationManager.setSpatializationSceneType(this.spatialSceneMode);
                  } catch (err) {
                    Logger.error(`setSpatializationSceneType failed ,Error: ${JSON.stringify(err)}`);
                    return;
                  }
                }
              }
            })
        }
        .width(264)
        .height(22)
        .margin({ left: 16 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(304)
      .height(56)
    }
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .height(232)
    .width(328)
    .justifyContent(FlexAlign.Center)
  }

  updateSupportStateUI(): void {
    this.supportState = this.supportStateQuery();
    if (this.audioSpatializationManager) {
      try {
        this.spatializationEnabled = this.audioSpatializationManager.isSpatializationEnabled();
        this.trackingEnabled = this.audioSpatializationManager.isHeadTrackingEnabled();
        this.spatialSceneMode = this.audioSpatializationManager.getSpatializationSceneType();
      } catch (err) {
        Logger.error(`update Support State UI failed ,Error: ${JSON.stringify(err)}`);
        return;
      }
    }
  }

  supportStateQuery(): number {
    if (this.audioRoutingManager) {
      let audioDeviceDescriptors: audio.AudioDeviceDescriptors =
      this.audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync(this.audioRendererOptions[0].rendererInfo);
      audioDeviceDescriptors.forEach(audioDeviceDescriptor => {
        Logger.info("Device Role:" + audioDeviceDescriptor.deviceRole + ", device Type:" +
        audioDeviceDescriptor.deviceType + ", Macaddress:" + audioDeviceDescriptor.address);
      })

      let isSpaSupported: boolean = false;
      let isSpaSupportedForDevice: boolean = false;
      let isTraSupported: boolean = false;
      let isTraSupportedForDevice: boolean = false;
      if (this.audioSpatializationManager) {
        try {
          isSpaSupported = this.audioSpatializationManager.isSpatializationSupported();
          isSpaSupportedForDevice =
          this.audioSpatializationManager.isSpatializationSupportedForDevice(audioDeviceDescriptors[0]);
          isTraSupported = this.audioSpatializationManager.isHeadTrackingSupported();
          isTraSupportedForDevice =
          this.audioSpatializationManager.isHeadTrackingSupportedForDevice(audioDeviceDescriptors[0]);
        } catch (err) {
          Logger.error(`supportStateQuery ,Error: ${JSON.stringify(err)}`);
        }
      } else {
        Logger.info("Get manager failed.");
      }
      let isSpatializationSupportedBoth: boolean = isSpaSupported && isSpaSupportedForDevice;
      let isHeadTrackingSupportedBoth: boolean = isTraSupported && isTraSupportedForDevice;
      if (isSpatializationSupportedBoth && isHeadTrackingSupportedBoth) {
        return TRACKING_MODE;
      } else if (isSpatializationSupportedBoth) {
        return OPEN_MODE;
      } else {
        return CLOSE_MODE;
      }
    }
    return CLOSE_MODE;
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
      })
    }
    if (this.audioSpatializationManager) {
      this.audioSpatializationManager.on("spatializationEnabledChange", (res) => {
        this.spatializationEnabled = res;
      })
    }

    if (this.audioSpatializationManager) {
      this.audioSpatializationManager.on("headTrackingEnabledChange", (res) => {
        this.trackingEnabled = res;
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
      this.audioSpatializationManager.off("spatializationEnabledChange");
    }

    if (this.audioSpatializationManager) {
      this.audioSpatializationManager.off("headTrackingEnabledChange");
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
          .title(this.DIYTitle())
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
            Text($r("app.string.2P0_MUSIC"))
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
            Text($r("app.string.5P1_MUSIC"))
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

        if (this.supportState > CLOSE_MODE && this.spatializationEnabled === true) {
          this.ChooseSpatialSceneMode()
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)


      Column() {
        Row() {
          if (this.supportState === 2) {
            this.UIForTracking();
          } else if (this.supportState === 1) {
            this.UIForOpen();
          } else {
            this.UIForClose();
          }
        }
        .height(64)
        .width(312)
        .borderRadius(100)
        .backgroundColor('#FFFFFF')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text($r("app.string.CLOSE_TEXT"))
            .height("100%")
            .width(64)
            .fontSize(12)
            .fontWeight(500)
            .margin({ right: 60 })
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)

          if (this.supportState === 0) {
            this.OpenTextDisable();
            this.TrackingTextDisable();
          } else if (this.supportState === 1) {
            this.OpenTextEnable();
            this.TrackingTextDisable();
          } else {
            this.OpenTextEnable();
            this.TrackingTextEnable();
          }
        }
        .height(16)
        .width(312)
        .margin({ left: 24, right: 24, top: 8 })
      }
      .height(112)
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f3f5')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}