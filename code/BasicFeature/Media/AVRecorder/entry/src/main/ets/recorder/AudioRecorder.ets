/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import media from '@ohos.multimedia.media';
import { dateTime } from '../utils/DateTimeUtils';
import Logger from '../utils/Logger';
import SaveCameraAsset from '../utils/SaveCameraAsset';

const TAG: string = 'Sample_AudioRecorder';

@Entry
@Component
struct AudioRecording {
  private audioRecorder: media.AVRecorder;
  private fdPath: string = undefined;
  @State frameRate: number = 15;
  @State audioRecorderTimeText: string = '00:00';
  private seconds: number = 0;
  private timer: number = 0;
  @State displayLog: string = undefined;
  private recorderState: string = 'free';
  @State isStartRecording: boolean = false;
  @State isPauseRecording: boolean = false;
  private mSaveCameraAsset: SaveCameraAsset = new SaveCameraAsset(TAG);
  private mFileAssetId: number = 0; // init fd 0
  @State audioChannels: number = 2; // set default audioChannels 2
  @State audioSampleRate: number = 48000; // set default audioSampleRate 48000

  private avProfile = {
    audioBitrate: 48000, // set audioBitrate according to device ability
    audioChannels: 2, // set audioChannels, valid value 1-8
    audioCodec: media.CodecMimeType.AUDIO_AAC, // set audioCodec, AUDIO_AAC is the only choice
    audioSampleRate: 48000, // set audioSampleRate according to device ability
    fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // set fileFormat, for video is m4a
  }
  private avConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
    profile: this.avProfile,
    url: 'fd://'
  }

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear called');
    Logger.info(TAG, 'aboutToAppear done');
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'aboutToDisappear called');
    Logger.info(TAG, 'aboutToDisappear done');
  }

  async failureCallback(error): Promise<void> {
    Logger.info(TAG, 'case failureCallback called,errMessage is ' + error.message);
  }

  async catchCallback(error): Promise<void> {
    Logger.info(TAG, 'case catchCallback called,errMessage is ' + error.message);
  }

  // show recording time
  getRecordTime(): void {
    this.timer = setInterval(() => {
      this.seconds += 1;
      this.audioRecorderTimeText = dateTime(this.seconds);
    }, 1000)
  }

  // create file fd
  async getFileFd(): Promise<void> {
    Logger.info(TAG, 'getFileFd called');
    this.mFileAssetId = await this.mSaveCameraAsset.createAudioFd();
    this.fdPath = 'fd://' + this.mFileAssetId.toString();
    this.avConfig.url = this.fdPath;
    Logger.info(TAG, 'fdPath is: ' + this.fdPath);
    Logger.info(TAG, 'getFileFd done');
  }

  async createAudioRecorder(): Promise<void> {
    await media.createAVRecorder().then((recorder) => {
      Logger.info(TAG, 'case createAVRecorder called');
      if (typeof (recorder) !== 'undefined') {
        this.audioRecorder = recorder;
      } else {
        Logger.info(TAG, 'case create avRecorder failed!!!');
        return
      }
    }, this.failureCallback).catch(this.catchCallback);
    this.setCallback();
  }

  // set callback on
  setCallback(): void {
    Logger.info(TAG, 'case callback');
    this.audioRecorder.on('stateChange', (state, reason) => {
      Logger.info(TAG, 'case state has changed, new state is' + state);
      switch (state) {
        case 'idle':
          this.recorderState = 'idle';
          break;
        case 'prepared':
          this.recorderState = 'prepared';
          break;
        case 'started':
          this.recorderState = 'started';
          this.getRecordTime();
          this.isStartRecording = true;
          this.isPauseRecording = false;
          break;
        case 'paused':
          this.recorderState = 'paused';
          clearInterval(this.timer);
          this.isPauseRecording = true;
          break;
        case 'stopped':
          this.recorderState = 'stopped';
          this.isStartRecording = false;
          break;
        case 'released':
          this.recorderState = 'released';
          break;
        case 'error':
          Logger.info(TAG, 'case error state!!!');
          this.recorderState = 'error';
          break;
        default:
          Logger.info(TAG, 'case start is unknown');
          break;
      }
    });
    this.audioRecorder.on('error', (err) => {
      Logger.info(TAG, 'case avRecorder.on(error) called, errMessage is ' + err.message);
    });
  }

  async prepareAudioRecorder(): Promise<void> {
    Logger.info(TAG, 'case prepareAudioRecorder in');
    this.avConfig.profile.audioChannels = this.audioChannels;
    this.avConfig.profile.audioSampleRate = this.audioSampleRate;
    await this.audioRecorder.prepare(this.avConfig).then(() => {
      Logger.info(TAG, 'case prepare AVRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
    Logger.info(TAG, 'case prepareAudioRecorder out');
  }

  async startAudioRecording(): Promise<void> {
    Logger.info(TAG, 'case startAudioRecording called');
    await this.audioRecorder.start().then(() => {
      Logger.info(TAG, 'case start AudioRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async pauseAudioRecording(): Promise<void> {
    Logger.info(TAG, 'case pauseAudioRecording called');
    await this.audioRecorder.pause().then(() => {
      Logger.info(TAG, 'case pause AudioRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async resumeAudioRecording(): Promise<void> {
    Logger.info(TAG, 'case resumeAudioRecording called');
    await this.audioRecorder.resume().then(() => {
      Logger.info(TAG, 'case resume AudioRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async stopAudioRecording(): Promise<void> {
    Logger.info(TAG, 'case stopAudioRecording called');
    await this.audioRecorder.stop().then(() => {
      Logger.info(TAG, 'case stop AudioRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async resetAudioRecording(): Promise<void> {
    await this.audioRecorder.reset().then(() => {
      Logger.info(TAG, 'case resetAudioRecording called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async releaseAudioRecorder(): Promise<void> {
    if (this.audioRecorder) {
      this.audioRecorder.off('stateChange');
      this.audioRecorder.off('error');
      await this.audioRecorder.release().then(() => {
        Logger.info(TAG, 'case releaseAudioRecorder called');
      }, this.failureCallback).catch(this.catchCallback);
      this.audioRecorder = undefined;
    }
  }

  // close file fd
  async closeFd(): Promise<void> {
    Logger.info(TAG, 'case closeFd called');
    if (this.fdPath) {
      await this.mSaveCameraAsset.AudioPrepareFile.close(this.mFileAssetId);
      this.mFileAssetId = undefined;
      this.fdPath = undefined;
      Logger.info(TAG, 'case closeFd done');
    }
  }

  // start button process
  async startRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'startRecording called');
    if (this.audioRecorder) {
      Logger.info(TAG, 'audioRecorder exist,release it');
      await this.audioRecorder.release();
    }
    await this.createAudioRecorder();
    await this.getFileFd();
    await this.prepareAudioRecorder();
    await this.startAudioRecording();
    Logger.info(TAG, 'startRecording done');
  }

  // pause button process
  async pauseRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'pauseRecording called');
    if (this.recorderState === 'started') {
      Logger.info(TAG, 'current state is started, to pause');
      await this.pauseAudioRecording();
    }
    Logger.info(TAG, 'pauseRecording done');
  }

  // resume button process
  async resumeRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'resumeRecording called');
    if (this.recorderState === 'paused') {
      Logger.info(TAG, 'current state is paused, to resume');
      await this.resumeAudioRecording();
    }
    Logger.info(TAG, 'resumeRecording done');
  }

  // stop button process
  async stopRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'stopRecording called');
    if (this.recorderState === 'started' || this.recorderState === 'paused') {
      await this.stopAudioRecording();
    }
    await this.resetAudioRecording();
    await this.releaseAudioRecorder();
    await this.closeFd();
    clearInterval(this.timer);
    this.isStartRecording = false;
    this.isPauseRecording = false;
    this.seconds = 0;
    this.audioRecorderTimeText = '00:00';
    Logger.info(TAG, 'stopRecording done');
  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          Text(this.audioRecorderTimeText)
            .fontFamily('HarmonyHeiTi-Light')
            .width(70)
            .height(40)
            .fontSize(27)
            .fontColor('white')
            .margin({ left: 99, top: 13, right: 79, bottom: 703 })
          if (!this.isStartRecording) {
            Image($r('app.media.ic_setting'))
              .width(40)
              .height(40)
              .margin({ left: 12, top: 12, right: 308, bottom: 704 })
              .onClick(() => {
                if (this.settingDialog !== undefined) {
                  Logger.info(TAG, 'to open setting dialog');
                  this.settingDialog.open()
                }
              })
              .id('audioSetting')
            Image($r('app.media.ic_red_circle'))
              .width(12)
              .height(12)
              .margin({ left: 136, top: 25, right: 212, bottom: 715 })
            Image($r('app.media.take_video_normal'))
              .width(86)
              .height(86)
              .margin({ left: 132, top: 612, right: 132, bottom: 72 })
              .onClick(() => this.startRecordingProcess())
              .id('audioStart')
          }
          else {
            Image($r('app.media.ic_circle_open'))
              .width(120)
              .height(56)
              .margin({ left: 120, top: 632, right: 120, bottom: 92 })
            Image($r('app.media.ic_stop'))
              .width(16)
              .height(16)
              .margin({ left: 146, top: 652, right: 198, bottom: 112 })
              .onClick(() => this.stopRecordingProcess())
              .id('audioStop')
            if (!this.isPauseRecording) {
              Image($r('app.media.ic_red_circle'))
                .width(12)
                .height(12)
                .margin({ left: 136, top: 25, right: 212, bottom: 715 })
              Image($r('app.media.ic_pause'))
                .width(14)
                .height(15)
                .margin({ left: 200, top: 652, right: 146, bottom: 113 })
                .onClick(() => this.pauseRecordingProcess())
                .id('audioPause')
            } else {
              Image($r('app.media.ic_small_pause'))
                .width(14)
                .height(14)
                .margin({ left: 136, top: 25, right: 212, bottom: 715 })
              Image($r('app.media.ic_continue'))
                .width(16)
                .height(16)
                .margin({ left: 198, top: 651, right: 144, bottom: 111 })
                .onClick(() => this.resumeRecordingProcess())
                .id('audioResume')
            }
          }
        }.width('100%').height('100%')
      }.backgroundColor(Color.Black)
    }
  }

  onCancel() {
    Logger.info(TAG, 'Callback when the cancel button is clicked')
  }

  onAccept() {
    Logger.info(TAG, 'Callback when the confirm button is clicked')
  }

  existApp() {
    Logger.info(TAG, 'Click the callback in the blank area')
  }

  settingDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogSetting({
      cancel: this.onCancel,
      confirm: this.onAccept,
      audioChannels: $audioChannels,
      audioSampleRate: $audioSampleRate,
    }),
    cancel: this.existApp,
    autoCancel: false,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })
}


@CustomDialog
struct CustomDialogSetting {
  @Link audioChannels: number
  @Link audioSampleRate: number
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  @State currentAudioChannels: number = 2
  @State currentAudioSampleRate: number = 48000
  private initAudioChannels: number = this.audioChannels
  private initAudioSampleRate: number = this.audioSampleRate
  @State audioChannelsList: Array<number> = [1, 2]
  @State audioSampleRateList: Array<number> = [8000, 22050, 32000, 44100, 48000, 96000]

  build() {
    Column() {
      Column() {
        Text($r('app.string.audio_parameter'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(20)
          .width(288)
          .height(26)
          .margin({ left: 24, right: 24, top: 16 })
        Column() {
          List({ space: 10 }) {
            ForEach(this.audioSampleRateList, (item, index) => {
              ListItem() {
                Row() {
                  Text($r('app.string.audio_samplerate'))
                    .fontSize(16)
                  Text(item.toString())
                    .fontSize(16)
                    .width(160)
                  if (item == this.initAudioSampleRate) {
                    Radio({ value: item.toString(), group: 'radioGroup2' }).checked(true)
                      .height(20)
                      .id(item.toString())
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          Logger.info(TAG, item.toString() + ' audioSample is chosen')
                          this.currentAudioSampleRate = item
                        }
                      })
                  } else {
                    Radio({ value: item.toString(), group: 'radioGroup2' }).checked(false)
                      .height(20)
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          Logger.info(TAG, item.toString() + ' audioSample is chosen')
                          this.currentAudioSampleRate = item
                        }
                      })
                  }
                }.margin({ left: 0, right: 39 })
              }
            })
          }.listDirection(Axis.Vertical)
          .divider({ strokeWidth: 0.5, color: '#EEEEEE', startMargin: 0, endMargin: 0 })
        }.margin({ left: 24, right: 24, top: 16 })
      }.alignItems(HorizontalAlign.Start)

      Row() {
        Button($r('app.string.button_cancel'))
          .onClick(() => {
            this.audioChannels = this.initAudioChannels
            this.audioSampleRate = this.initAudioSampleRate
            this.controller.close()
            this.cancel()
          })
          .backgroundColor($r('app.color.button_background'))
          .fontColor($r('app.color.button_color'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(16)
          .id('audioCancel')
          .layoutWeight(1)
        Divider()
          .vertical(true)
          .height(24)
          .color($r('app.color.divider_color'))
          .opacity(0.6)
          .margin({ left: 8, right: 8 })
        Button($r('app.string.button_confirm'))
          .onClick(() => {
            this.audioChannels = this.currentAudioChannels
            this.audioSampleRate = this.currentAudioSampleRate
            this.controller.close()
            this.confirm()
          })
          .backgroundColor($r('app.color.button_background'))
          .fontColor($r('app.color.button_color'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(16)
          .id('audioConfirm')
          .layoutWeight(1)
      }
      .width(300)
      .height(40)
      .margin({ top: 12, bottom: 16 })
    }
    .margin({ left: 12, right: 12, bottom: 12 })
    .backgroundColor($r('app.color.button_background'))
    .borderRadius(32)
    .alignItems(HorizontalAlign.Center)
  }
}