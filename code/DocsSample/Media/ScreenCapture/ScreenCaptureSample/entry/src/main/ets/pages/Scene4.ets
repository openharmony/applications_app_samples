/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { BusinessError } from '@ohos.base';
import { media } from '@kit.MediaKit';
import fs from '@ohos.file.fs';
import { deviceInfo } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';

@Component
export struct Scene4 {
  @Consume('pageInfos') pageInfos: NavPathStack;
  private lastSaveTime: string = '';
  private saveIndex: number = 0;
  private outputFd: number | null = null;
  private avScreenCaptureRecorder?: media.AVScreenCaptureRecorder;
  private displayId:number = 0;
  private isStarted: boolean = false;
  private filepathSC: string = '';
  @State text: string = 'PRESERVE_ASPECT_RATIO'
  private displayWidth: number = 0;
  private displayHeight: number = 0;

  private initDeviceResolution(): void {
    try {
      let currentDisplay: display.Display =
        this.displayId? display.getDisplayByIdSync(this.displayId as number): display.getDefaultDisplaySync();
      this.displayWidth = currentDisplay.width;
      this.displayHeight = currentDisplay.height;
      console.info('ScreenCaptureSample displayWidth: ' + this.displayWidth + ', displayHeight: ' + this.displayHeight);
    } catch (err) {
      console.error('ScreenCaptureSample initDeviceResolution failed, code is ${err.code}, message is ${err.message}');
    }
  }
  checkName(name: string): string {
    if (this.lastSaveTime == name) {
      this.saveIndex += 1;
      return `${name}_${this.saveIndex}`
    }
    this.lastSaveTime = name;
    this.saveIndex = 0;
    return name;
  }

  StopRecording() {
    if (!this.avScreenCaptureRecorder) {
      return;
    }
    this.avScreenCaptureRecorder?.stopRecording();
    if (this.outputFd != undefined && this.outputFd?.valueOf() > 0) {
      fs.close(this.outputFd);
    }
    this.avScreenCaptureRecorder?.release();
    this.isStarted = false;
    this.outputFd = -1;
  }

  async createVideoFd(): Promise<number> {
    console.info('==ScreenCaptureSample== the value of the deviceType in');
    let deviceTypeInfo: string = deviceInfo.deviceType;
    console.info('==ScreenCaptureSample== the value of the deviceType is :' + deviceTypeInfo);

    const displayName = 'js_saving_file.mp4';
    let videoFd: number = 0;
    console.info('==ScreenCaptureSample== the value of the deviceType in');
    this.filepathSC = '/data/storage/el2/base/files/' + displayName;
    await fs.open(this.filepathSC, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file) => {
      videoFd = file.fd;
      console.info('==ScreenCaptureSample== the value of the deviceType in');
    }).catch((err: BusinessError) => {
      fs.unlinkSync(this.filepathSC);
      console.error('open file failed, code is ${err.code}, message is ${err.message}');
    })
    console.info('==ScreenCaptureSample== the value of the deviceType in');
    console.info('==ScreenCaptureSample== createVideoFd videoFd: ' + videoFd);
    return videoFd;
  }

  async StartRecording(): Promise<void> {
    if (this.isStarted === true) {
      console.info('==ScreenCaptureSample== isStarted: ' + this.outputFd);
      return;
    }
    this.outputFd = await this.createVideoFd()
    console.info('==ScreenCaptureSample== outputFd: ' + this.outputFd);
    if (this.outputFd  != 0) {
      console.info('selectOutputFilePath outputFd: ' + this.outputFd );
      this.initDeviceResolution();
      let avCaptureConfig: media.AVScreenCaptureRecordConfig = {
        fd: this.outputFd,
        frameWidth: this.displayWidth,
        frameHeight: this.displayHeight,
        videoBitrate: 10000000,
        audioSampleRate: 48000,
        audioChannelCount: 2,
        audioBitrate: 96001,
        displayId: this.displayId,
        preset: media.AVScreenCaptureRecordPreset.SCREEN_RECORD_PRESET_H264_AAC_MP4,
      };
      this.avScreenCaptureRecorder = await media.createAVScreenCaptureRecorder();
      await this.avScreenCaptureRecorder.init(avCaptureConfig).then(() => {
        console.info('==ScreenCaptureSample== Succeeded in init avScreenCaptureRecorder');
      }).catch((err: BusinessError) => {
        fs.unlinkSync(this.filepathSC);
        console.error('==ScreenCaptureSample== Failed to init avScreenCaptureRecorder, code is ${err.code},' +
          'message is ${err.message}');
      })

      this.avScreenCaptureRecorder.setMicEnabled(true).then(() => {
        console.info('==ScreenCaptureSample== Succeeded in setMicEnabled avScreenCaptureRecorder');
      }).catch((err: BusinessError) => {
        console.error('==ScreenCaptureSample== Failed to setMicEnabled avScreenCaptureRecorder, code is ${err.code},' +
          'message is ${err.message}');
      })

      this.avScreenCaptureRecorder.on('error', (err: BusinessError) => {
        console.error('==ScreenCaptureSample== avScreenCaptureRecorder stateChange to:' + err.message);
        fs.unlinkSync(this.filepathSC);
      })

      this.avScreenCaptureRecorder!.on('stateChange', async (state: media.AVScreenCaptureStateCode) => {
        console.info('==ScreenCaptureSample== 2 avScreenCaptureRecorder stateChange to ' + state);
        switch (state) {
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STARTED:
            console.info('==ScreenCaptureSample== screen capture started');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_CANCELED:
            this.avScreenCaptureRecorder?.release();
            this.avScreenCaptureRecorder = undefined;
            console.info('==ScreenCaptureSample== delete filepathSC uri: ' + this.filepathSC);
            fs.unlinkSync(this.filepathSC);
            console.info('==ScreenCaptureSample== screen capture canceled');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STOPPED_BY_USER:
            this.avScreenCaptureRecorder?.stopRecording();
            this.avScreenCaptureRecorder?.release();
            this.avScreenCaptureRecorder = undefined;
            console.info('==ScreenCaptureSample== screen capture stopped by user');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_INTERRUPTED_BY_OTHER:
            console.info('==ScreenCaptureSample== screen capture stopped by other');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STOPPED_BY_CALL:
            console.info('==ScreenCaptureSample== screen capture stopped by call');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_MIC_UNAVAILABLE:
            console.info('==ScreenCaptureSample== screen capture mic unavailable');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_MIC_MUTED_BY_USER:
            console.info('==ScreenCaptureSample== screen capture mic muted by user');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_MIC_UNMUTED_BY_USER:
            console.info('==ScreenCaptureSample== screen capture mic unmuted by user');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_ENTER_PRIVATE_SCENE:
            console.info('==ScreenCaptureSample== screen capture enter private scene');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_EXIT_PRIVATE_SCENE:
            console.info('==ScreenCaptureSample== screen capture exit private scene');
            break;
          case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STOPPED_BY_USER_SWITCHES:
            console.info('==ScreenCaptureSample== screen capture stopped by user switches');
            break;
          default:
            break;
        }
      })
      await this.avScreenCaptureRecorder?.startRecording().then(() => {
        console.info('==ScreenCaptureSample== Succeeded in starting avScreenCaptureRecorder');
        this.isStarted = true;
      }).catch((err: BusinessError) => {
        console.error('==ScreenCaptureSample== Failed to start avScreenCaptureRecorder, code is ${err.code}, message is ${err.message}');
      })

    }
  }

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Column() {
          Text($r('app.string.js_saving_file_desc'))
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('20%')

        Column() {
          List({ space: 40 }) {
            ListItem() {
              Button($r('app.string.start_desc'), { type: ButtonType.Circle, stateEffect: true })
                .id(getContext().resourceManager.getStringSync($r('app.string.start_desc')))
                .backgroundColor(0xF55A42)
                .width(90)
                .height(90)
                .onClick(() => {
                  this.StopRecording();
                  this.StartRecording()
                })
            }
            ListItem() {
              Button($r('app.string.stop_desc'), { type: ButtonType.Normal, stateEffect: true })
                .id(getContext().resourceManager.getStringSync($r('app.string.stop_desc')))
                .backgroundColor(0x000000)
                .width(85)
                .height(85)
                .shadow({ radius: 10 })
                .onClick(() => {
                  this.StopRecording();
                })
            }
          }.listDirection(Axis.Horizontal).lanes({ minLength: 200, maxLength: 300 })
        }
        .width('100%')
        .height('20%')

        Text($r('app.string.display_id_desc'))
        TextInput({
          text:'0'
        }).onChange((value)=>{
          console.info('==ScreenCaptureSample== displayId:' + value);
          this.displayId = parseInt(value);
        })
      }
      .width('100%')
    }
    .title($r('app.string.js_saving_file_desc'))
  }
}