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

// [Start all_VoIPDemoForAudioRenderer]
import { audio } from '@kit.AudioKit'; // 导入audio模块。
import { BusinessError } from '@kit.BasicServicesKit'; // 导入BusinessError。
import { fileIo as fs } from '@kit.CoreFileKit'; // 导入文件操作模块。
import { common } from '@kit.AbilityKit'; // 导入UIAbilityContext。

// 与使用AudioRenderer开发音频播放功能过程相似,关键区别在于audioRendererInfo参数和音频数据来源。
const TAG = 'VoIPDemoForAudioRenderer';

class Options {
  public offset?: number;
  public length?: number;
}

let bufferSize: number = 0;
let audioRenderer: audio.AudioRenderer | undefined = undefined;
let audioStreamInfo: audio.AudioStreamInfo = {
  samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率。
  channels: audio.AudioChannel.CHANNEL_2, // 通道。
  sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式。
  encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式。
};
let audioRendererInfo: audio.AudioRendererInfo = {
  // 需使用通话场景相应的参数。
  usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION, // 音频流使用类型:VoIP通话。
  rendererFlags: 0 // 音频渲染器标志:默认为0即可。
};
let audioRendererOptions: audio.AudioRendererOptions = {
  streamInfo: audioStreamInfo,
  rendererInfo: audioRendererInfo
};
let file: fs.File;
let writeDataCallback: audio.AudioRendererWriteDataCallback;
// [StartExclude all_VoIPDemoForAudioRenderer]
// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;
// [EndExclude all_VoIPDemoForAudioRenderer]
async function initArguments(context: common.UIAbilityContext) {
  let path = context.cacheDir;
  // 此处仅作示例,实际使用时需要将文件替换为应用要播放的PCM文件。
  let filePath = path + '/StarWars10s-2C-48000-4SW.pcm';
  file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
  writeDataCallback = (buffer: ArrayBuffer) => {
    let options: Options = {
      offset: bufferSize,
      length: buffer.byteLength
    };

    try {
      let bufferLength = fs.readSync(file.fd, buffer, options);
      bufferSize += buffer.byteLength;
      // 如果当前回调传入的数据不足一帧,空白区域需要使用静音数据填充,否则会导致播放出现杂音。
      if (bufferLength < buffer.byteLength) {
        let view = new DataView(buffer);
        for (let i = bufferLength; i < buffer.byteLength; i++) {
          // 空白区域填充静音数据。当使用音频采样格式为SAMPLE_FORMAT_U8时0x7F为静音数据,使用其他采样格式时0为静音数据。
          view.setUint8(i, 0);
        }
      }
      // API version 11不支持返回回调结果,从API version 12开始支持返回回调结果。
      // 如果开发者不希望播放某段buffer,返回audio.AudioDataCallbackResult.INVALID即可。
      return audio.AudioDataCallbackResult.VALID;
    } catch (error) {
      console.error('Error reading file:', error);

      if (globalLogUpdate) {
        globalLogUpdate(`Error reading file: ${error}`, true);
      }
      // API version 11不支持返回回调结果,从API version 12开始支持返回回调结果。
      return audio.AudioDataCallbackResult.INVALID;
    }
  };
}

// 初始化,创建实例,设置监听事件。
async function init() {
  audio.createAudioRenderer(audioRendererOptions, (err, renderer) => { // 创建AudioRenderer实例。
    if (!err) {
      console.info(`${TAG}: creating AudioRenderer success`);
      // [StartExclude all_VoIPDemoForAudioRenderer]
      const successMsg = `${TAG}: creating AudioRenderer success`;
      if (globalLogUpdate) {
        globalLogUpdate(successMsg, false);
      }
      // [EndExclude all_VoIPDemoForAudioRenderer]
      audioRenderer = renderer;
      if (audioRenderer !== undefined) {
        audioRenderer.on('writeData', writeDataCallback);
      }
    } else {
      console.info(`${TAG}: creating AudioRenderer failed, error: ${err.message}`);
      // [StartExclude all_VoIPDemoForAudioRenderer]
      const errorMsg = `${TAG}: creating AudioRenderer failed, error: ${err.message}`;
      if (globalLogUpdate) {
        globalLogUpdate(errorMsg, true);
      }
      // [EndExclude all_VoIPDemoForAudioRenderer]
    }
  });
}

// 开始一次音频渲染。
async function start() {
  if (audioRenderer !== undefined) {
    let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    if (stateGroup.indexOf(audioRenderer.state.valueOf()) === -1) { // 当且仅当状态为prepared、paused和stopped之一时才能启动渲染。
      console.error(TAG + 'start failed');
      // [StartExclude all_VoIPDemoForAudioRenderer]
      const errorMsg = `${TAG} start failed`;
      if (globalLogUpdate) {
        globalLogUpdate(errorMsg, true);
      }
      // [EndExclude all_VoIPDemoForAudioRenderer]
      return;
    }
    // 启动渲染。
    audioRenderer.start((err: BusinessError) => {
      if (err) {
        console.error('Renderer start failed.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        const errorMsg = `Renderer start failed.`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      } else {
        console.info('Renderer start success.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        if (globalLogUpdate) {
          globalLogUpdate('Renderer start success.', false);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      }
    });
  }
}

// 暂停渲染。
async function pause() {
  if (audioRenderer !== undefined) {
    // 只有渲染器状态为running的时候才能暂停。
    if (audioRenderer.state.valueOf() !== audio.AudioState.STATE_RUNNING) {
      console.info('Renderer is not running');
      // [StartExclude all_VoIPDemoForAudioRenderer]
      const infoMsg = `Renderer is not running`;
      if (globalLogUpdate) {
        globalLogUpdate(infoMsg, false);
      }
      // [EndExclude all_VoIPDemoForAudioRenderer]
      return;
    }
    // 暂停渲染。
    audioRenderer.pause((err: BusinessError) => {
      if (err) {
        console.error('Renderer pause failed.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        const errorMsg = `Renderer pause failed.`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      } else {
        console.info('Renderer pause success.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        if (globalLogUpdate) {
          globalLogUpdate('Renderer pause success.', false);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      }
    });
  }
}

// 停止渲染。
async function stop() {
  if (audioRenderer !== undefined) {
    // 只有渲染器状态为running或paused的时候才可以停止。
    if (audioRenderer.state.valueOf() !== audio.AudioState.STATE_RUNNING &&
      audioRenderer.state.valueOf() !== audio.AudioState.STATE_PAUSED) {
      console.info('Renderer is not running or paused.');
      // [StartExclude all_VoIPDemoForAudioRenderer]
      const infoMsg = `Renderer is not running or paused.`;
      if (globalLogUpdate) {
        globalLogUpdate(infoMsg, false);
      }
      // [EndExclude all_VoIPDemoForAudioRenderer]
      return;
    }
    // 停止渲染。
    audioRenderer.stop((err: BusinessError) => {
      if (err) {
        console.error('Renderer stop failed.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        const errorMsg = `Renderer stop failed.`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      } else {
        fs.close(file);
        console.info('Renderer stop success.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        const successMsg = `Renderer stop success.`;
        if (globalLogUpdate) {
          globalLogUpdate(successMsg, false);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      }
    });
  }
}

// 销毁实例,释放资源。
async function release() {
  if (audioRenderer !== undefined) {
    // 渲染器状态不是released状态,才能release。
    if (audioRenderer.state.valueOf() === audio.AudioState.STATE_RELEASED) {
      console.info('Renderer already released');
      // [StartExclude all_VoIPDemoForAudioRenderer]
      if (globalLogUpdate) {
        globalLogUpdate('Renderer already released', false);
      }
      // [EndExclude all_VoIPDemoForAudioRenderer]
      return;
    }
    // 释放资源。
    audioRenderer.release((err: BusinessError) => {
      if (err) {
        console.error('Renderer release failed.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        const errorMsg = `Renderer release failed.`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      } else {
        console.info('Renderer release success.');
        // [StartExclude all_VoIPDemoForAudioRenderer]
        if (globalLogUpdate) {
          globalLogUpdate('Renderer release success.', false);
        }
        // [EndExclude all_VoIPDemoForAudioRenderer]
      }
    });
  }
}
// [End all_VoIPDemoForAudioRenderer]

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
            Text('数据回调信息')
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
        Row() {
          Column() {
            Text('初始化').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在初始化...';
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            await initArguments(context);
            await init();
            this.currentState = '初始化完成';
          });

          Column() {
            Text('开始播放').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在开始播放...';
            await start();
            this.currentState = '播放中';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Text('暂停播放').fontColor(Color.Black).fontSize(14);
          }
          .id('audio_effect_manager_card')
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在暂停播放...';
            await pause();
            this.currentState = '已暂停';
          });

          Column() {
            Text('停止播放').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在停止播放...';
            await stop();
            this.currentState = '已停止';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Text('释放资源').fontColor(Color.Black).fontSize(14);
          }
          .id('audio_volume_card')
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在释放资源...';
            await release();
            this.currentState = '已释放';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}