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

// [Start all_VoIPDemoForAudioCapturer]
import { audio } from '@kit.AudioKit'; // 导入audio模块。
import { BusinessError } from '@kit.BasicServicesKit'; // 导入BusinessError。
import { fileIo as fs } from '@kit.CoreFileKit'; // 导入文件操作模块。
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit'; // 导入UIAbilityContext。
// 与使用AudioCapturer开发音频录制功能过程相似,关键区别在于audioCapturerInfo参数和音频数据流向。
const TAG = 'VoIPDemoForAudioCapturer';

class Options {
  public offset?: number;
  public length?: number;
}

let bufferSize: number = 0;
let audioCapturer: audio.AudioCapturer | undefined = undefined;
let audioStreamInfo: audio.AudioStreamInfo = {
  samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率。
  channels: audio.AudioChannel.CHANNEL_2, // 通道。
  sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式。
  encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式。
};
let audioCapturerInfo: audio.AudioCapturerInfo = {
  // 需使用通话场景相应的参数。1
  source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION, // 音源类型:语音通话。
  capturerFlags: 0 // 音频采集器标志:默认为0即可。
};
let audioCapturerOptions: audio.AudioCapturerOptions = {
  streamInfo: audioStreamInfo,
  capturerInfo: audioCapturerInfo
};
let file: fs.File;
let readDataCallback: Callback<ArrayBuffer>;

// [StartExclude all_VoIPDemoForAudioCapturer]
// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager.requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  const hasPermission = result.authResults[0] === 0;

  if (hasPermission) {
    console.info('麦克风权限已授予');
    if (globalLogUpdate) {
      globalLogUpdate('麦克风权限已授予', false);
    }
  } else {
    console.error('麦克风权限未授权,无法录音');
    if (globalLogUpdate) {
      globalLogUpdate('麦克风权限未授权,无法录音', true);
    }
  }

  return hasPermission;
}
// [EndExclude all_VoIPDemoForAudioCapturer]

async function initArguments(context: common.UIAbilityContext) {
  let path = context.cacheDir;
  let filePath = path + '/StarWars10s-2C-48000-4SW.pcm';
  file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  console.info(`File opened: ${filePath}`);

  readDataCallback = (buffer: ArrayBuffer) => {
    let options: Options = {
      offset: bufferSize,
      length: buffer.byteLength
    }
    fs.writeSync(file.fd, buffer, options);
    bufferSize += buffer.byteLength;
  }
}

// 初始化,创建实例,设置监听事件。
async function init() {
  audio.createAudioCapturer(audioCapturerOptions, (err, capturer) => { // 创建AudioCapturer实例。
    if (err) {
      console.error(`Invoke createAudioCapturer failed, code is ${err.code}, message is ${err.message}`);
      // [StartExclude all_VoIPDemoForAudioCapturer]
      const errorMsg = `Invoke createAudioCapturer failed, code is ${err.code}, message is ${err.message}`;
      if (globalLogUpdate) {
        globalLogUpdate(errorMsg, true);
      }
      // [EndExclude all_VoIPDemoForAudioCapturer]
      return;
    }
    console.info(`${TAG}: create AudioCapturer success`);
    // [StartExclude all_VoIPDemoForAudioCapturer]
    const successMsg = `${TAG}: create AudioCapturer success`;
    if (globalLogUpdate) {
      globalLogUpdate(successMsg, false);
    }
    // [EndExclude all_VoIPDemoForAudioCapturer]
    audioCapturer = capturer;
    if (audioCapturer !== undefined) {
      audioCapturer.on('readData', readDataCallback);
    }
  });
}

// 开始一次音频采集。
async function start() {
  if (audioCapturer !== undefined) {
    let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    if (stateGroup.indexOf(audioCapturer.state.valueOf()) === -1) {
      // 当且仅当状态为STATE_PREPARED、STATE_PAUSED和STATE_STOPPED之一时才能启动采集。
      console.error(`${TAG}: start failed`);
      // [StartExclude all_VoIPDemoForAudioCapturer]
      const errorMsg = `${TAG}: start failed - Invalid state: ${audioCapturer.state}`;
      if (globalLogUpdate) {
        globalLogUpdate(errorMsg, true);
      }
      // [EndExclude all_VoIPDemoForAudioCapturer]
      return;
    }

    // 启动采集。
    audioCapturer.start((err: BusinessError) => {
      if (err) {
        console.error('Capturer start failed.');
        // [StartExclude all_VoIPDemoForAudioCapturer]
        const errorMsg = `Capturer start failed.`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioCapturer]
      } else {
        console.info('Capturer start success.');
        // [StartExclude all_VoIPDemoForAudioCapturer]
        if (globalLogUpdate) {
          globalLogUpdate('Capturer start success.', false);
        }
        // [EndExclude all_VoIPDemoForAudioCapturer]
      }
    });
  }
}

// 停止采集。
async function stop() {
  if (audioCapturer !== undefined) {
    // 只有采集器状态为STATE_RUNNING或STATE_PAUSED的时候才可以停止。
    if (audioCapturer.state.valueOf() !== audio.AudioState.STATE_RUNNING &&
      audioCapturer.state.valueOf() !== audio.AudioState.STATE_PAUSED) {
      console.info('Capturer is not running or paused');
      // [StartExclude all_VoIPDemoForAudioCapturer]
      const infoMsg = `Capturer is not running or paused - Current state: ${audioCapturer.state}`;
      if (globalLogUpdate) {
        globalLogUpdate(infoMsg, false);
      }
      // [EndExclude all_VoIPDemoForAudioCapturer]
      return;
    }

    // 停止采集。
    audioCapturer.stop((err: BusinessError) => {
      if (err) {
        console.error('Capturer stop failed.');
        // [StartExclude all_VoIPDemoForAudioCapturer]
        const errorMsg = `Capturer stop failed. Code: ${err.code}, message: ${err.message}`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioCapturer]
      } else {
        fs.close(file);
        console.info('Capturer stop success.');
        // [StartExclude all_VoIPDemoForAudioCapturer]
        const successMsg = `Capturer stop success.\nTotal recorded: ${bufferSize} bytes`;
        if (globalLogUpdate) {
          globalLogUpdate(successMsg, false);
        }
        // [EndExclude all_VoIPDemoForAudioCapturer]
      }
    });
  }
}

// 销毁实例,释放资源。
async function release() {
  if (audioCapturer !== undefined) {
    // 采集器状态不是STATE_RELEASED或STATE_NEW状态,才能release。
    if (audioCapturer.state.valueOf() === audio.AudioState.STATE_RELEASED ||
      audioCapturer.state.valueOf() === audio.AudioState.STATE_NEW) {
      console.info('Capturer already released');
      // [StartExclude all_VoIPDemoForAudioCapturer]
      if (globalLogUpdate) {
        globalLogUpdate('Capturer already released', false);
      }
      // [EndExclude all_VoIPDemoForAudioCapturer]
      return;
    }

    // 释放资源。
    audioCapturer.release((err: BusinessError) => {
      if (err) {
        console.error('Capturer release failed.');
        // [StartExclude all_VoIPDemoForAudioCapturer]
        const errorMsg = `Capturer release failed.`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude all_VoIPDemoForAudioCapturer]
      } else {
        console.info('Capturer release success.');
        // [StartExclude all_VoIPDemoForAudioCapturer]
        if (globalLogUpdate) {
          globalLogUpdate('Capturer release success.', false);
        }
        // [EndExclude all_VoIPDemoForAudioCapturer]
      }
    });
  }
}
// [End all_VoIPDemoForAudioCapturer]

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
            // [StartExclude all_VoIPDemoForAudioCapturer]
            let hasPermission = await requestMicrophonePermission(context);
            if (!hasPermission) {
              this.currentState = '初始化失败:权限未授予';
              return;
            }
            // [EndExclude all_VoIPDemoForAudioCapturer]
            await initArguments(context);
            await init();
            this.currentState = '初始化完成';
          });

          Column() {
            Text('开始录制').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在开始录制...';
            await start();
            this.currentState = '录制中';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Text('停止录制').fontColor(Color.Black).fontSize(14);
          }
          .id('audio_effect_manager_card')
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在停止录制...';
            await stop();
            this.currentState = '已停止';
          });

          Column() {
            Text('释放资源').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在释放资源...';
            await release();
            this.currentState = '已释放';
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