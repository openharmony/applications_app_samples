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

// [Start all_outputDeviceChange]
// [Start set_DefaultOutputDevice]
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude set_DefaultOutputDevice]
let audioRenderer: audio.AudioRenderer | undefined = undefined;
let audioStreamInfo: audio.AudioStreamInfo = {
  samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率。
  channels: audio.AudioChannel.CHANNEL_2, // 通道。
  sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式。
  encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式。
};
let audioRendererInfo: audio.AudioRendererInfo = {
  usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型:音乐。根据业务场景配置,参考StreamUsage。
  rendererFlags: 0 // 音频渲染器标志。
};
let audioRendererOptions: audio.AudioRendererOptions = {
  streamInfo: audioStreamInfo,
  rendererInfo: audioRendererInfo
};
// [StartExclude all_outputDeviceChange]
// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;

async function createAudioRenderer() {
  // [EndExclude all_outputDeviceChange]
  // 创建AudioRenderer实例。
  audio.createAudioRenderer(audioRendererOptions).then((data) => {
    audioRenderer = data;
    console.info('AudioFrameworkRenderLog: AudioRenderer Created : Success : Stream Type: SUCCESS');
    // [StartExclude all_outputDeviceChange]
    const successMsg = 'AudioFrameworkRenderLog: AudioRenderer Created : Success : Stream Type: SUCCESS';
    if (globalLogUpdate) {
      globalLogUpdate(successMsg, false);
    }
    // [EndExclude all_outputDeviceChange]
  }).catch((err: BusinessError) => {
    console.error(`AudioFrameworkRenderLog: AudioRenderer Created : ERROR : ${err}`);
    // [StartExclude all_outputDeviceChange]
    const errorMsg = `AudioFrameworkRenderLog: AudioRenderer Created : ERROR : ${err}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude all_outputDeviceChange]
  });

  if (audioRenderer) {
    // 订阅监听音频流输出设备变化及原因。
    (audioRenderer as audio.AudioRenderer).on('outputDeviceChangeWithInfo', async (deviceChangeInfo: audio
    .AudioStreamDeviceChangeInfo) => {
      switch (deviceChangeInfo.changeReason) {
        case audio.AudioStreamDeviceChangeReason.REASON_OLD_DEVICE_UNAVAILABLE:
          // 响应设备不可用事件,如果应用处于播放状态,应暂停播放,更新UX界面。
          // await audioRenderer.pause();
          break;
        case audio.AudioStreamDeviceChangeReason.REASON_NEW_DEVICE_AVAILABLE:
          // 应用根据业务情况响应设备可用事件。
          break;
        case audio.AudioStreamDeviceChangeReason.REASON_OVERRODE:
          // 应用根据业务情况响应设备强选事件。
          break;
        case audio.AudioStreamDeviceChangeReason.REASON_UNKNOWN:
          // 应用根据业务情况响应未知原因事件。
          break;
      }
    });
  }
  // [End all_outputDeviceChange]
}

async function rendererSetDefaultOutputDeviceSpeaker() {
  if (audioRenderer !== undefined) {
    // [EndExclude set_DefaultOutputDevice]
    // 设置默认输出设备为本机扬声器。
    audioRenderer.setDefaultOutputDevice(audio.DeviceType.SPEAKER).then(() => {
      console.info('Succeeded in setting default output device.');
      // [StartExclude set_DefaultOutputDevice]
      const successMsg = 'Succeeded in setting default output device to SPEAKER.';
      if (globalLogUpdate) {
        globalLogUpdate(successMsg, false);
      }
      // [EndExclude set_DefaultOutputDevice]
    }).catch((err: BusinessError) => {
      console.error(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude set_DefaultOutputDevice]
      const errorMsg = `Failed to set default output device. Code: ${err.code}, message: ${err.message}`;
      if (globalLogUpdate) {
        globalLogUpdate(errorMsg, true);
      }
      // [EndExclude set_DefaultOutputDevice]
    });
    // [StartExclude set_DefaultOutputDevice]
  }
}

async function rendererDefaultOutputDeviceDefault() {
  if (audioRenderer !== undefined) {
    // [EndExclude set_DefaultOutputDevice]
    // 设置默认输出设备为系统默认输出设备,即取消应用设置的默认设备,交由系统选择设备。
    audioRenderer.setDefaultOutputDevice(audio.DeviceType.DEFAULT).then(() => {
      console.info('Succeeded in setting default output device.');
      // [StartExclude set_DefaultOutputDevice]
      const successMsg = 'Succeeded in setting default output device to DEFAULT (system choice).';
      if (globalLogUpdate) {
        globalLogUpdate(successMsg, false);
      }
      // [EndExclude set_DefaultOutputDevice]
    }).catch((err: BusinessError) => {
      console.error(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude set_DefaultOutputDevice]
      const errorMsg = `Failed to set default output device. Code: ${err.code}, message: ${err.message}`;
      if (globalLogUpdate) {
        globalLogUpdate(errorMsg, true);
      }
      // [EndExclude set_DefaultOutputDevice]
    });
    // [End set_DefaultOutputDevice]
  }
}

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

  aboutToAppear(): void {
    // 设置全局回调
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
    globalCallbackUpdate = (msg) => this.updateCallbackInfo(msg);
  }

  // 更新日志信息
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  // 更新回调信息
  updateCallbackInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.callbackMessages = `[${timestamp}] ${msg}`;
  }

  build(): void {
    Scroll() {
      Column() {
        // 信息显示区域
        Column() {
          Text('实时状态信息')
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          // 当前状态
          Column() {
            Text('当前状态')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // 日志信息
          Column() {
            Text('日志信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // 回调信息
          Column() {
            Text('输出设备变化回调')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.callbackMessages)
                .fontSize(12)
                .fontColor('#FA8C16')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 20 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 功能按钮
        Column() {
          Text('创建音频播放实例').fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('100%')
        .height(60)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(async (): Promise<void> => {
          this.currentState = '正在创建音频播放实例...';
          await createAudioRenderer();
          this.currentState = '创建完成';
        });

        Row() {
          Column() {
            Text('设置为本机扬声器').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在设置为本机扬声器...';
            await rendererSetDefaultOutputDeviceSpeaker();
            this.currentState = '设置完成';
          });

          Column() {
            Text('设置为系统默认设备').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在设置为系统默认设备...';
            await rendererDefaultOutputDeviceDefault();
            this.currentState = '设置完成';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}