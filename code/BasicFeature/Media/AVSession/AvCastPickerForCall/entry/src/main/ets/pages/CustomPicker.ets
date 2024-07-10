
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
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { common } from '@kit.AbilityKit';
import { avSession, AVCastPicker, AVCastPickerState } from '@kit.AVSessionKit';

class Options {
  public offset: number = 0;
  public length: number = 0;
}

@Entry
@Component
struct customPicker {
  @State session: avSession.AVSession | undefined = undefined;
  @State avCastPickerColor:Color = Color.White;
  @State pickerImage: ResourceStr = $r('app.media.ic_earpiece');
  private appContext?: common.Context | undefined = undefined;
  private audioManager: audio.AudioManager | undefined = undefined;
  private audioRoutingManager: audio.AudioRoutingManager | undefined = undefined;
  private audioRenderer: audio.AudioRenderer | undefined = undefined;
  private audioSource = 'test1.wav';
  private fileDescriptor?: resourceManager.RawFileDescriptor | undefined = undefined;
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
    rendererFlags: 0,
  };
  private audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率
    channels: audio.AudioChannel.CHANNEL_2, // 通道
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  private  audioRendererOption: audio.AudioRendererOptions = {
    streamInfo: this.audioStreamInfo,
    rendererInfo: this.audioRendererInfo
  };

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
    this.audioManager = audio.getAudioManager();
    if (!this.audioManager) {
      console.error('get audioManager failed');
      return;
    }
    this.audioRoutingManager = this.audioManager.getRoutingManager();
    if(!this.audioRoutingManager) {
      return;
    }
    let desc: audio.AudioDeviceDescriptors =
      this.audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync(this.audioRendererInfo);
    this.changePickerShow(desc); //第一次拉起picker时获取当前输出设备
    this.audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo', this.audioRendererInfo, (desc: audio.AudioDeviceDescriptors) => {
      if(!this.audioRoutingManager) {
        return;
      }
      console.log(`device change to: ${desc[0].deviceType}`);
      let devices: audio.AudioDeviceDescriptors =
        this.audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync(this.audioRendererInfo);
      this.changePickerShow(devices);
    });
  }

  private changePickerShow(desc: audio.AudioDeviceDescriptors): void {
    if (desc[0].deviceType === 2) {
      this.pickerImage = $r('app.media.ic_public_sound');
    } else if (desc[0].deviceType === 7) {
      this.pickerImage = $r('app.media.ic_bluetooth');
    } else {
      this.pickerImage = $r('app.media.ic_earpiece');
    }
  }

  async getStageFileDescriptor(fileName: string): Promise<resourceManager.RawFileDescriptor | undefined> {
    let fileDescriptor: resourceManager.RawFileDescriptor | undefined = undefined;
    if (this.appContext) {
      let mgr = this.appContext.resourceManager;
      this.fileDescriptor = mgr.getRawFdSync(fileName);
      await mgr.getRawFd(fileName).then(value => {
        fileDescriptor = value;
        console.log(`case getRawFileDescriptor success fileName: ${fileName}`);
      }).catch((err: BusinessError) => {
        console.error(`case getRawFileDescriptor err: code: ${err.code}, message: ${err.message}`);
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
    if (!this.fileDescriptor) {
      return;
    }
    let file: resourceManager.RawFileDescriptor = this.fileDescriptor;
    try {
      this.audioRenderer = await audio.createAudioRenderer(this.audioRendererOption);
    } catch (error) {
      console.error(`audioRenderer create : Error: ${JSON.stringify(error)}`);
      return;
    }
    let bufferSize: number = this.fileDescriptor.offset;
    let writeDataCallback = (buffer: ArrayBuffer) => {
      let options: Options = {
        offset: bufferSize,
        length: buffer.byteLength
      }
      fileIo.readSync(file.fd, buffer, options);
      bufferSize += buffer.byteLength;
    };
    this.audioRenderer.on('writeData', writeDataCallback);
    await this.audioRenderer.start();
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
        console.log(`case closeRawFd success fileName: ${fileName}`);
      }).catch((err: BusinessError) => {
        console.error(`case closeRawFd err: code: ${err.code}, message: ${err.message}`);
      });
    }
  }

  onBackPress(): void {
    this.stopRenderer();
    this.destroy();
  }

  async onPageHide(): Promise<void> {
    this.stopRenderer();
    this.destroy();
  }

  onPageShow(): void {
    this.init();
  }

  destroy(): void {
    this.appContext = undefined;
    if (this.audioRoutingManager !== undefined) {
      this.audioRoutingManager.off('preferOutputDeviceChangeForRendererInfo');
    }
    try {
      if (this.session) {
        this.session?.destroy();
      }
    } catch (err) {
      console.error('session destroy failed');
    }
  }
  
  aboutToDisappear() {
    console.log('about to disappear');
    this.destroy();
  }

  @Builder
  ImageBuilder(): void {
    Image(this.pickerImage)
      .size({ width: '100%', height: '100%' })
      .backgroundColor('#00000000')
      .fillColor(Color.Black)
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
            customPicker: (): void => this.ImageBuilder(),
            onStateChange: (state: AVCastPickerState) => {
              console.info(`change avcastpicker: ${state}`);
            }
          })
            .size({ width: 45, height: 45 })
        }
        .size({ width: 64, height: 64 })
        .type(ButtonType.Circle)
        .backgroundColor(Color.Orange)
      }
      .size({ width: '33%', height: 64 })
    }
    .margin({ top: 300})
    .justifyContent(FlexAlign.SpaceBetween)
  }
}