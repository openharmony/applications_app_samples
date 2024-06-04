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

import { audio } from '@kit.AudioKit';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import resourceManager from '@ohos.resourceManager';
import common from '@ohos.app.ability.common';
import { avSession, AVCastPicker } from '@kit.AVSessionKit';

class Options {
  public offset: number = 0;
  public length: number = 0;
}

@Entry
@Component
struct DefaultPicker {
  @State session: avSession.AVSession | undefined = undefined;
  @State avCastPickerColor:Color = Color.White;
  private appContext?: common.Context | undefined = undefined;
  private audioRenderer: audio.AudioRenderer | undefined = undefined;
  private audioSource = 'test1.wav';
  private fileDescriptor?: resourceManager.RawFileDescriptor | undefined = undefined;
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
    rendererFlags: 0
  }
  private audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率
    channels: audio.AudioChannel.CHANNEL_2, // 通道
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  }
  private  audioRendererOption: audio.AudioRendererOptions = {
    streamInfo: this.audioStreamInfo,
    rendererInfo: this.audioRendererInfo
  }

  async aboutToAppear() {
    console.log('about to appear');
    await this.init();
  }

  async init() {
    if (!this.appContext) {
      this.appContext = getContext();
    }
    this.session = await avSession.createAVSession(this.appContext, 'voiptest', 'voice_call');
    this.observerDevices();
  }

  async observerDevices() {
    let audioManager = audio.getAudioManager();
    let audioRoutingManager = audioManager.getRoutingManager();
    audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo', this.audioRendererInfo, (desc: audio.AudioDeviceDescriptors) => {
      console.log(`device change to: ${desc[0].deviceType}`);
    });
  }

  async getStageFileDescriptor(fileName: string): Promise<resourceManager.RawFileDescriptor | undefined> {
    let fileDescriptor: resourceManager.RawFileDescriptor | undefined = undefined;
    if (this.appContext) {
      let mgr = this.appContext.resourceManager;
      await mgr.getRawFd(fileName).then(value => {
        fileDescriptor = value;
        console.log('case getRawFileDescriptor success fileName: ' + fileName);
      }).catch((error: BusinessError) => {
        console.log('case getRawFileDescriptor err: ' + error);
      });
    }
    return fileDescriptor;
  }

  async startRenderer(): Promise<void> {
    if (this.audioRenderer !== undefined) {
      return;
    }
    this.getStageFileDescriptor(this.audioSource).then((res) => {
      this.fileDescriptor = res;
    });
    try {
      this.audioRenderer = await audio.createAudioRenderer(this.audioRendererOption);
    } catch (error) {
      console.error(`audioRenderer create : Error: ${JSON.stringify(error)}`);
      return;
    }
    let bufferSize : number;
    try {
      bufferSize = await this.audioRenderer.getBufferSize();
      await this.audioRenderer.start();
    } catch (err) {
      let error = err as BusinessError;
      console.error(`audioRenderer start : Error: ${JSON.stringify(error)}`);
      return;
    }

    try {
      if (!this.fileDescriptor) {
        return;
      }
      let startOffset = this.fileDescriptor.offset;
      let cur = startOffset;
      let buf = new ArrayBuffer(bufferSize);
      while (true) {
        // when render released,state is changed to STATE_RELEASED
        if (this.audioRenderer.state === audio.AudioState.STATE_RELEASED) {
          break;
        }
        while (cur <= startOffset + this.fileDescriptor.length) {
          // when render released,state is changed to STATE_RELEASED
          if (this.audioRenderer.state.valueOf() === audio.AudioState.STATE_RELEASED.valueOf()) {
            break;
          }
          let options: Options = {
            offset: cur,
            length: bufferSize
          }
          await fs.read(this.fileDescriptor.fd, buf, options);
          await this.audioRenderer.write(buf);
          cur += bufferSize;
        }
        cur = startOffset;
      }
    } catch (err) {
      let error = err as BusinessError;
      console.error(`audioRenderer write : Error: ${JSON.stringify(error)}`);
    }
  }

  async stopRenderer(): Promise<void> {
    if (this.audioRenderer) {
      await this.audioRenderer.release();
      this.audioRenderer = undefined;
    }
    if (this.fileDescriptor) {
      this.closeResource(this.audioSource);
      this.fileDescriptor = undefined;
    }
  }

  async closeResource(fileName: string): Promise<void> {
    if (this.appContext) {
      let mgr = this.appContext.resourceManager;
      await mgr.closeRawFd(fileName).then(() => {
        console.log('case closeRawFd success fileName: ' + fileName);
      }).catch((error: BusinessError) => {
        console.log('case closeRawFd err: ' + error);
      });
    }
  }

  onBackPress(): void {
    this.stopRenderer();
    this.appContext ==undefined;
  }

  async onPageHide(): Promise<void> {
    this.stopRenderer();
    this.appContext ==undefined;
  }

  onPageShow(): void {
    this.init();
  }
  
  aboutToDisappear() {
    console.log('about to disappear');
    this.appContext = undefined;
    try {
      if (this.session) {
        this.session?.destroy();
      }
    } catch (error) {
      console.log('case closeRawFd err: ' + error);
    }
  }

  build() {
    Row() {
      Column() {
        Button() {
          Text('start').fontSize(22).fontColor(Color.White)
        }
        .size({ width: 64, height: 64 })
        .onClick(() => {
          this.startRenderer();
        })
        .type(ButtonType.Circle)
      }
      .size({ width: '33%', height: 64 })

      Column() {
        Button() {
          Text('stop').fontSize(22).fontColor(Color.White)
        }
        .size({ width: 64, height: 64 })
        .onClick(() => {
          this.stopRenderer();
        })
        .type(ButtonType.Circle)
      }
      .size({ width: '33%', height: 64 })

      Column() {
        Button() {
          AVCastPicker({
            normalColor: this.avCastPickerColor,
            activeColor: this.avCastPickerColor,
          })
            .size({ width: 45, height: 45 })
        }
        .size({ width: 64, height: 64 })
        .type(ButtonType.Circle)
      }
      .size({ width: '33%', height: 64 })
    }
    .margin({ top: 300})
    .justifyContent(FlexAlign.SpaceBetween)
  }
}