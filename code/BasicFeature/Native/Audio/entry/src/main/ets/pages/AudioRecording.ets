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

import audio from '@ohos.multimedia.audio';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import testNapi from 'libentry.so';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import deviceInfo from '@ohos.deviceInfo';

const MIN_RECORD_SECOND = 5;
const TOTAL_SECOND = 30;
const INTERVAL_TIME = 1000;

let context = getContext(this) as common.UIAbilityContext;
let atManager = abilityAccessCtrl.createAtManager();

@Entry
@Component
struct AudioRecording {
  private audioCapturerLowLatency: boolean = false;
  private audioRendererLowLatency: boolean = false;
  @State recordState: string = 'init'; // [init,started,continued,paused,stoped]
  @State title: string = 'oh_test_audio';
  @State date: string = '';
  @State playSec: number = 0;
  @State renderState: number = 0;
  @State recordSec: number = 0;
  @State showTime: string = '00:00:00';
  private interval: number = 0;
  @State isRecordOver: boolean = false;

  aboutToAppear() {
    console.log('AudioRecording aboutToAppear');
    this.initResource();
  }

  initResource() {
    try {
      this.recordState = 'init';
      this.date = this.getDate(1);
      testNapi.audioCapturerInit();
    } catch (err) {
      let error = err as BusinessError;
      console.error(`AudioRecording:createAudioCapturer err=${JSON.stringify(error)}`);
    }
  }

  releseResource() {
    if (this.interval) {
      clearInterval(this.interval)
    }
    if (this.recordState == 'started') {
      this.capturerPause();
    }
    this.recordState = 'init';
    testNapi.audioRendererRelease();
  }

  aboutToDisappear() {
    this.releseResource();
  }

  capturerStart() {
    try {
      testNapi.audioCapturerStart();
      this.recordSec = 0;
      this.recordState = 'started';
      clearInterval(this.interval);
      this.interval = setInterval(async () => {
        if (this.recordSec >= TOTAL_SECOND) {
          clearInterval(this.interval);
          this.capturerStop();
          return;
        }
        this.recordSec++;
        this.showTime = this.getTimesBySecond(this.recordSec);
      }, INTERVAL_TIME);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`AudioRecording:audioCapturer start err=${JSON.stringify(error)}`);
    }
  }

  renderCreate() {
    try {
      testNapi.audioRendererInit();
      this.renderState = testNapi.getRendererState();
    } catch (err) {
      let error = err as BusinessError;
      console.error(`createAudioRenderer err=${JSON.stringify(error)}`);
    }
  }

  renderStart() {
    try {
      testNapi.audioRendererStart();
      this.renderState = testNapi.getRendererState();
      if (this.playSec === this.recordSec) {
        this.playSec = 0;
      }
      this.interval = setInterval(async () => {
        let playNumber = Math.round(testNapi.getFramesWritten() * 4 / testNapi.getFileSize() * this.recordSec);
        this.playSec = (playNumber < 0 || this.playSec === this.recordSec) ? this.recordSec : playNumber;
        if (testNapi.getFileState()) {
          testNapi.audioRendererStop();
          testNapi.audioRendererRelease();
          testNapi.closeFile();
          if (testNapi.getFastState()) {
            testNapi.audioRendererLowLatencyInit();
          } else {
            testNapi.audioRendererInit();
          }
          clearInterval(this.interval);
          this.renderState = testNapi.getRendererState();
          return;
        }
      }, 50);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`write err:${JSON.stringify(error)}`);
    }
  }

  renderPause() {
    try {
      testNapi.audioRendererPause();
      this.renderState = testNapi.getRendererState();
      clearInterval(this.interval);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`pause err:${JSON.stringify(error)}`);
    }
  }

  capturerContinue() {
    try {
      testNapi.audioCapturerStart();
      this.recordState = 'continued';
      console.log('audioCapturer start ok');
      this.interval = setInterval(async () => {
        if (this.recordSec >= TOTAL_SECOND) {
          clearInterval(this.interval);
          this.capturerStop();
          return;
        }
        this.recordSec++;
        this.showTime = this.getTimesBySecond(this.recordSec);
      }, INTERVAL_TIME);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`AudioRecording:audioCapturer start err=${JSON.stringify(error)}`);
    }
  }

  capturerStop() {
    if (this.recordSec < MIN_RECORD_SECOND) {
      return;
    }
    try {
      testNapi.audioCapturerStop();
      this.recordState = 'stopped';
      clearInterval(this.interval);
    } catch (err) {
      let error = err as BusinessError;
      this.recordState = 'stopped';
      console.error(`AudioRecording:audioCapturer stop err=${JSON.stringify(error)}`);
    }
    this.isRecordOver = true;
    this.renderCreate();
  }

  capturerPause() {
    try {
      testNapi.audioCapturerPause();
      this.recordState = 'paused';
      clearInterval(this.interval);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`AudioRecording:audioCapturer stop err=${JSON.stringify(error)}`);
      return;
    }
  }

  formatNumber(num: number) {
    if (num <= 9) {
      return '0' + num;
    } else {
      return '' + num;
    }
  }

  getDate(mode: number) {
    let date = new Date();
    if (mode === 1) {
      return `${date.getFullYear()}/${this.formatNumber(date.getMonth() + 1)}/${this.formatNumber(date.getDate())}`;
    } else {
      return `${date.getFullYear()}${this.formatNumber(date.getMonth() + 1)}${this.formatNumber(date.getDate())}`;
    }
  }

  getTimesBySecond(t: number) {
    let h = Math.floor(t / 60 / 60 % 24);
    let m = Math.floor(t / 60 % 60);
    let s = Math.floor(t % 60);
    let hs = h < 10 ? '0' + h : h;
    let ms = m < 10 ? '0' + m : m;
    let ss = s < 10 ? '0' + s : s;
    return `${hs}:${ms}:${ss}`;
  }

  @Builder
  InitRecord() {
    Column() {
      Image($r('app.media.ic_record')).width(56).height(56)
    }
    .width('100%')
    .height(56)
    .position({ y: 60 })
    .id('start_record_btn')
    .onClick(() => {
      atManager.requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']).then((data) => {
        console.info('data:' + JSON.stringify(data));
        if (data.authResults[0] !== 0) {
          return;
        }
        this.capturerStart();
      }).catch((err: BusinessError) => {
        console.error('data:' + JSON.stringify(err));
      });
    })
  }

  @Builder
  StartedRecord() {
    Column() {
      Text(this.showTime).fontSize(21).fontWeight(500).margin({ bottom: 8 })
    }.width('100%').height(66).position({ y: 30 }).id('show_time_txt')

    Column() {
      Image($r('app.media.ic_recording')).width(56).height(56)
    }
    .width('100%')
    .height(56)
    .position({ y: 60 })
    .id('stop_record_btn')
    .onClick(() => {
      this.capturerStop()
    })

    Column() {
      Image($r('app.media.ic_record_pause')).width(24).height(24)
      Text($r('app.string.PAUSE')).fontSize(12).fontWeight(400).id('pause_record_btn').margin({ top: 2 })
    }
    .height(56)
    .width(56)
    .position({ x: '80%', y: 60 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.capturerPause()
    })
  }

  @Builder
  PausedRecord() {
    Column() {
      Text(this.showTime).fontSize(21).fontWeight(500).margin({ bottom: 8 })
    }.width('100%').height(66).position({ y: 30 })

    Column() {
      Image($r('app.media.ic_recording')).width(56).height(56)
    }.width('100%').height(56).position({ y: 60 })
    .onClick(() => {
      this.capturerStop()
    })

    Column() {
      Image($r('app.media.ic_record_continue')).width(24).height(24)
      Text($r('app.string.CONTINUE')).fontSize(12).fontWeight(400).margin({ top: 2 })
    }
    .height(56)
    .width(56)
    .position({ x: '80%', y: 60 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .id('continue_record_btn')
    .onClick(() => {
      this.capturerContinue()
    })
  }

  @Builder
  FinishedRecord() {
    Column() {
      Image($r('app.media.ic_record')).width(56).height(56)
    }
    .width('100%')
    .height(56)
    .position({ y: 60 })
    .opacity(0.4)
    .id('disalbe_btn')
  }

  build() {
    Column() {
      Column() {
        Navigation() {
        }
        .width('100%')
        .height('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        .title($r('app.string.AUDIO_CAPTURER'))
        .mode(NavigationMode.Stack)
        .backgroundColor('#F1F3F5')
      }
      .id('capturer_back_btn')
      .width('100%')
      .height(56)
      .onClick(async () => {
        await router.replaceUrl({ url: 'pages/Index' });
      })

      Column() {
        Row() {
          if (this.isRecordOver === true) {
            Text($r('app.string.LOW_LATENCY_CAPTURER'))
              .fontSize(16)
              .fontWeight(500)
              .fontColor('#182431')
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .opacity(0.4)
          } else {
            Text($r('app.string.LOW_LATENCY_CAPTURER'))
              .fontSize(16)
              .fontWeight(500)
              .fontColor('#182431')
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          }
          Toggle({ type: ToggleType.Switch, isOn: (this.audioCapturerLowLatency) })
            .margin({ right: 0 })
            .width(36)
            .height(20)
            .id('capturer_low_latency_btn')
            .onChange((isOn: boolean) => {
              if (isOn) {
                testNapi.audioCapturerLowLatencyInit();
                this.audioCapturerLowLatency = true;
              } else {
                testNapi.audioCapturerInit();
                this.audioCapturerLowLatency = false;
              }
            })
            .enabled(this.recordState === 'init' && deviceInfo.deviceType === 'phone')
        }.width('100%').height(24).justifyContent(FlexAlign.SpaceBetween).margin({ top: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .borderRadius(24)
      .margin({ top: 12 })
      .padding({ left: 12, right: 12 })

      if (this.isRecordOver === true) {
        Column() {
          Row() {
            Text($r('app.string.LOW_LATENCY_RENDERER'))
              .fontSize(16)
              .fontWeight(500)
              .fontColor('#182431')
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            Toggle({ type: ToggleType.Switch, isOn: (this.audioRendererLowLatency) })
              .margin({ right: 0 })
              .width(36)
              .height(20)
              .id('renderer_low_latency_btn')
              .onChange((isOn: boolean) => {
                if (isOn) {
                  testNapi.audioRendererLowLatencyInit();
                  this.audioRendererLowLatency = true;
                } else {
                  testNapi.audioRendererInit();
                  this.audioRendererLowLatency = false;
                }
              })
              .enabled(this.renderState === 1 && deviceInfo.deviceType === 'phone')
          }
          .width('100%').height(24).justifyContent(FlexAlign.SpaceBetween).margin({ top: 16 })
        }
        .width('100%')
        .height(56)
        .backgroundColor(Color.White)
        .borderRadius(24)
        .margin({ top: 12 })
        .padding({ left: 12, right: 12 })

        Column() {
          Text($r('app.string.RECORD_RESULT')).fontSize(14).position({ x: 0 })
        }
        .height(19)
        .width('100%')
        .margin({ top: 19.5 })
        .padding({ left: 12, right: 24 })


        Column() {
          Row() {
            Text(this.title)
              .fontSize(16)
              .fontWeight(500)
              .fontColor('#182431')
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            if (this.renderState === audio.AudioState.STATE_RUNNING) {
              Image($r('app.media.ic_record_playing')).width(24).height(24).id('playing_state')
            } else {
              Image($r('app.media.ic_record_paused')).width(24).height(24).id('paused_state')
            }

          }.width('100%').height(24).justifyContent(FlexAlign.SpaceBetween).margin({ top: 16 })

          Row() {
            Text(this.date)
              .fontSize(16)
              .fontWeight(400)
              .fontColor('#182431')
              .opacity(0.6)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            Text(this.getTimesBySecond(this.recordSec) + '')
              .fontSize(16)
              .fontWeight(400)
              .fontColor('#182431')
              .opacity(0.6)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          }.width('100%').height(24).justifyContent(FlexAlign.SpaceBetween).margin({ top: 4 })

          Row() {
            Progress({ value: this.playSec, total: this.recordSec, type: ProgressType.Linear })
              .color('#007DFF')
              .value(this.playSec)
              .width('100%')
              .height(4)
          }.margin({ top: 23, bottom: 3 })

          Row() {
            Text(this.getTimesBySecond(this.playSec) + '')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .opacity(0.6)
              .fontWeight(400)
            Text(this.getTimesBySecond(this.recordSec) + '')
              .fontSize(12)
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontColor('#182431')
              .opacity(0.6)
              .fontWeight(400)
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }
        .width('100%')
        .height(126)
        .backgroundColor(Color.White)
        .borderRadius(24)
        .margin({ top: 9.5 })
        .padding({ left: 12, right: 12 })
        .id('player_btn')
        .onClick(() => {
          if (this.renderState === audio.AudioState.STATE_PREPARED) {
            this.renderStart();
          } else if (this.renderState === audio.AudioState.STATE_RUNNING) {
            this.renderPause();
          } else if (this.renderState === audio.AudioState.STATE_PAUSED) {
            this.renderStart();
          } else if (this.renderState === audio.AudioState.STATE_STOPPED) {
            this.renderStart();
          }
        })
      }
      Row() {
        if (this.recordState === 'init') {
          this.InitRecord();
        } else if (this.recordState === 'started') {
          this.StartedRecord();
        } else if (this.recordState === 'paused') {
          this.PausedRecord();
        } else if (this.recordState === 'continued') {
          this.StartedRecord();
        } else if (this.recordState === 'stopped') {
          this.FinishedRecord();
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .height(116)
      .position({ y: '82%' })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#F1F3F5')
    .padding({ left: 12, right: 12 })
  }
}