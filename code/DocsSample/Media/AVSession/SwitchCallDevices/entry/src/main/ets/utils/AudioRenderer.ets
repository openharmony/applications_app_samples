/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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

// [Start start_render]
// [Start device_monitor]
import { audio } from '@kit.AudioKit';
// [StartExclude device_monitor]
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { fileIo } from '@kit.CoreFileKit';

class Options {
  public offset: number = 0;
  public length: number = 0;
}
// [EndExclude device_monitor]
export default class AudioRenderer {
  // [StartExclude device_monitor]
  private audioRenderer: audio.AudioRenderer | undefined = undefined;
  private audioStreamInfo: audio.AudioStreamInfo = {
    // 请按照实际场景设置，当前参数仅参考。
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率。
    channels: audio.AudioChannel.CHANNEL_2, // 通道。
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式。
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式。
  }
  public appContext?: common.UIAbilityContext | undefined = undefined;
  private audioSource = 'test1.wav';
  private fileDescriptor?: resourceManager.RawFileDescriptor | undefined = undefined;
  // [StartExclude start_render]
  // [EndExclude device_monitor]
  private audioManager: audio.AudioManager | undefined = undefined;
  private audioRoutingManager: audio.AudioRoutingManager | undefined = undefined;
  private audioRendererInfo: audio.AudioRendererInfo = {
    // 需使用通话场景相应的参数。
    usage: audio.StreamUsage.STREAM_USAGE_VIDEO_COMMUNICATION, // 音频流使用类型：VOIP视频通话，默认为扬声器。
    rendererFlags: 0 // 音频渲染器标志：默认为0即可。
  }
  private  audioRendererOption: audio.AudioRendererOptions = {
    streamInfo: this.audioStreamInfo,
    rendererInfo: this.audioRendererInfo
  };

  async observerDevices() {
    this.audioManager = audio.getAudioManager(); // 先创建audiomanager。
    if (!this.audioManager) {
      console.error('get audioManager failed');
      return;
    }
    // 再调用AudioManager的方法创建AudioRoutingManager实例。
    this.audioRoutingManager = this.audioManager.getRoutingManager();
    if(!this.audioRoutingManager) {
      return;
    }
    // 可选监听当前发声设备切换回调。
    this.audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo', this.audioRendererInfo, (desc: audio.AudioDeviceDescriptors) => {
      console.info(`device change to: ${desc[0].deviceType}`); // 设备类型。
    });
  }
  // [StartExclude device_monitor]
  // [EndExclude start_render]
  async getStageFileDescriptor(fileName: string): Promise<resourceManager.RawFileDescriptor | undefined> {
    let fileDescriptor: resourceManager.RawFileDescriptor | undefined = undefined;
    if (this.appContext) {
      let mgr = this.appContext.resourceManager;
      this.fileDescriptor = mgr.getRawFdSync(fileName);
      await mgr.getRawFd(fileName).then(value => {
        fileDescriptor = value;
        console.info('case getRawFileDescriptor success fileName: ' + fileName);
      }).catch((error: BusinessError) => {
        console.error('case getRawFileDescriptor err: ' + error);
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
        console.info('case closeRawFd success fileName: ' + fileName);
      }).catch((error: BusinessError) => {
        console.error('case closeRawFd err: ' + error);
      });
    }
  }
  // [EndExclude device_monitor]
}
// [End device_monitor]
// [End start_render]