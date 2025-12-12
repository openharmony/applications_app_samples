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
// [Start all_audioCapturer]
// [Start create_AudioCapturer]
import { audio } from '@kit.AudioKit';
// [StartExclude create_AudioCapturer]
// [Start listen_AudioCapturer]
// [Start start_AudioCapturer]
// [Start stop_AudioCapturer]
// [Start release_AudioCapturer]
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude start_AudioCapturer]
// [StartExclude stop_AudioCapturer]
// [StartExclude release_AudioCapturer]
import { fileIo as fs } from '@kit.CoreFileKit';
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';
// [StartExclude listen_AudioCapturer]
const TAG = 'AudioCapturerDemo';
// [EndExclude listen_AudioCapturer]
class Options {
  public offset?: number;
  public length?: number;
}
// [StartExclude listen_AudioCapturer]

let audioCapturer: audio.AudioCapturer | undefined = undefined;
// [EndExclude create_AudioCapturer]
let audioStreamInfo: audio.AudioStreamInfo = {
  samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率。
  channels: audio.AudioChannel.CHANNEL_2, // 通道。
  sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式。
  encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式。
};
let audioCapturerInfo: audio.AudioCapturerInfo = {
  source: audio.SourceType.SOURCE_TYPE_MIC, // 音源类型:Mic音频源。根据业务场景配置,参考SourceType。
  capturerFlags: 0 // 音频采集器标志。
};
let audioCapturerOptions: audio.AudioCapturerOptions = {
  streamInfo: audioStreamInfo,
  capturerInfo: audioCapturerInfo
};
// [StartExclude create_AudioCapturer]
let file: fs.File;
let readDataCallback: Callback<ArrayBuffer>;

// [StartExclude all_audioCapturer]
async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager
    .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  return result.authResults[0] === 0;
}
// [EndExclude all_audioCapturer]

async function initArguments(context: common.UIAbilityContext): Promise<void> {
  // [EndExclude listen_AudioCapturer]
  let bufferSize: number = 0;
  let path = context.cacheDir;
  let filePath = path + '/StarWars10s-2C-48000-4SW.pcm';
  file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  readDataCallback = (buffer: ArrayBuffer) => {
    let options: Options = {
      offset: bufferSize,
      length: buffer.byteLength
    }
    fs.writeSync(file.fd, buffer, options);
    bufferSize += buffer.byteLength;
  };
  // [StartExclude listen_AudioCapturer]
}

// 初始化,创建实例,设置监听事件。
async function init(updateCallback?: (msg: string, isError: boolean) => void, stateCallback?:
  (msg: string) => void): Promise<void> {
  // [EndExclude create_AudioCapturer]
  audio.createAudioCapturer(audioCapturerOptions, (err, capturer) => { // 创建AudioCapturer实例。
    if (err) {
      console.error(`Invoke createAudioCapturer failed, code is ${err.code}, message is ${err.message}`);
      // [StartExclude all_audioCapturer]
      // [StartExclude create_AudioCapturer]
      const errorMsg = `Invoke createAudioCapturer failed, code is ${err.code}, message is ${err.message}`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude create_AudioCapturer]
      // [EndExclude all_audioCapturer]
      return;
    }
    console.info(`${TAG}: create AudioCapturer success`);
    // [StartExclude all_audioCapturer]
    // [StartExclude create_AudioCapturer]
    const successMsg = `${TAG}: create AudioCapturer success`;
    if (updateCallback) {
      updateCallback(successMsg, false);
    }
    // [EndExclude create_AudioCapturer]
    // [EndExclude all_audioCapturer]
    audioCapturer = capturer;
    if (audioCapturer !== undefined) {
      // [EndExclude listen_AudioCapturer]
      audioCapturer.on('readData', readDataCallback);
      // [End listen_AudioCapturer]
      // [StartExclude all_audioCapturer]
      // [StartExclude create_AudioCapturer]
      // 自动启动状态监听
      listenAudioCapturerState(stateCallback);
      // [EndExclude create_AudioCapturer]
      // [EndExclude all_audioCapturer]
    }
  });
  // [End create_AudioCapturer]
}

// 开始一次音频采集。
async function start(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioCapturer !== undefined) {
    let stateGroup = [audio.AudioState.STATE_PREPARED
      , audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    // 当且仅当状态为STATE_PREPARED、STATE_PAUSED和STATE_STOPPED之一时才能启动采集。
    if (stateGroup.indexOf(audioCapturer.state.valueOf()) === -1) {
      console.error(`${TAG}: start failed`);
      // [StartExclude all_audioCapturer]
      const errorMsg = `${TAG}: start failed`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude all_audioCapturer]
      return;
    }

    // 启动采集。
    // [EndExclude start_AudioCapturer]
    audioCapturer.start((err: BusinessError) => {
      if (err) {
        // [StartExclude all_audioCapturer]
        // [StartExclude start_AudioCapturer]
        const errorMsg = 'Capturer start failed.';
        if (updateCallback) {
          updateCallback(errorMsg, true);
        }
        // [EndExclude start_AudioCapturer]
        // [EndExclude all_audioCapturer]
        console.error('Capturer start failed.');
      } else {
        // [StartExclude all_audioCapturer]
        // [StartExclude start_AudioCapturer]
        const successMsg = 'Capturer start success.';
        if (updateCallback) {
          updateCallback(successMsg, false);
        }
        // [EndExclude start_AudioCapturer]
        // [EndExclude all_audioCapturer]
        console.info('Capturer start success.');
      }
    });
    // [End start_AudioCapturer]
  }
}

// 停止采集。
async function stop(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioCapturer !== undefined) {
    // 只有采集器状态为STATE_RUNNING或STATE_PAUSED的时候才可以停止。
    if (audioCapturer.state.valueOf() !== audio.AudioState.STATE_RUNNING &&
      audioCapturer.state.valueOf() !== audio.AudioState.STATE_PAUSED) {
      console.info('Capturer is not running or paused');
      // [StartExclude all_audioCapturer]
      const infoMsg = 'Capturer is not running or paused';
      if (updateCallback) {
        updateCallback(infoMsg, false);
      }
      // [EndExclude all_audioCapturer]
      return;
    }

    // 停止采集。
    // [EndExclude stop_AudioCapturer]
    audioCapturer.stop((err: BusinessError) => {
      if (err) {
        // [StartExclude all_audioCapturer]
        // [StartExclude stop_AudioCapturer]
        const errorMsg = 'Capturer stop failed.';
        if (updateCallback) {
          updateCallback(errorMsg, true);
        }
        // [EndExclude stop_AudioCapturer]
        // [EndExclude all_audioCapturer]
        console.error('Capturer stop failed.');
      } else {
        // [StartExclude all_audioCapturer]
        // [StartExclude stop_AudioCapturer]
        const successMsg = 'Capturer stop success.';
        if (updateCallback) {
          updateCallback(successMsg, false);
        }
        // [EndExclude stop_AudioCapturer]
        // [EndExclude all_audioCapturer]
        console.info('Capturer stop success.');
      }
    });
    // [End stop_AudioCapturer]
  }
}

// 销毁实例,释放资源。
async function release(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioCapturer !== undefined) {
    // 采集器状态不是STATE_RELEASED或STATE_NEW状态,才能release。
    if (audioCapturer.state.valueOf() === audio.AudioState.STATE_RELEASED ||
      audioCapturer.state.valueOf() === audio.AudioState.STATE_NEW) {
      console.info('Capturer already released');
      // [StartExclude all_audioCapturer]
      const infoMsg = 'Capturer already released';
      if (updateCallback) {
        updateCallback(infoMsg, false);
      }
      // [EndExclude all_audioCapturer]
      return;
    }

    // 释放资源。
    // [EndExclude release_AudioCapturer]
    audioCapturer.release((err: BusinessError) => {
      if (err) {
        // [StartExclude all_audioCapturer]
        // [StartExclude release_AudioCapturer]
        const errorMsg = 'Capturer release failed.';
        if (updateCallback) {
          updateCallback(errorMsg, true);
        }
        // [EndExclude release_AudioCapturer]
        // [EndExclude all_audioCapturer]
        console.error('Capturer release failed.');
      } else {
        fs.closeSync(file);
        console.info('Capturer release success.');
        // [StartExclude all_audioCapturer]
        // [StartExclude release_AudioCapturer]
        const successMsg = 'Capturer release success.';
        if (updateCallback) {
          updateCallback(successMsg, false);
        }
        // [EndExclude release_AudioCapturer]
        // [EndExclude all_audioCapturer]
      }
    });
    // [End release_AudioCapturer]
  }
}

// [StartExclude all_audioCapturer]
async function viewAudioCapturerState(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioCapturer !== undefined) {
    // [Start view_AudioCapturerState]
    let audioCapturerState: audio.AudioState = audioCapturer.state;
    console.info(`Current state is: ${audioCapturerState }`)
    // [End view_AudioCapturerState]
    const stateMsg = `Current state is: ${audioCapturerState}`;
    if (updateCallback) {
      updateCallback(stateMsg, false);
    }
  }
}
// [EndExclude all_audioCapturer]

// [StartExclude all_audioCapturer]
async function listenAudioCapturerState(callbackUpdate?: (msg: string) => void): Promise<void> {
  if (audioCapturer !== undefined) {
    // [Start listen_AudioCapturerState]
    audioCapturer.on('stateChange', (capturerState: audio.AudioState) => {
      console.info(`State change to: ${capturerState}`)
      // [StartExclude listen_AudioCapturerState]
      const stateMsg = `State change to: ${capturerState}`;
      if (callbackUpdate) {
        callbackUpdate(stateMsg);
      }
      // [EndExclude listen_AudioCapturerState]
    });
    // [End listen_AudioCapturerState]
  }
}
// [EndExclude all_audioCapturer]
// [End all_audioCapturer]

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

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
            Text(this.logMessages)
              .fontSize(13)
              .fontColor('#52C41A')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
              .maxLines(5)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // 回调信息
          Column() {
            Text('回调信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.callbackMessages)
              .fontSize(13)
              .fontColor('#FA8C16')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
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
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let hasPermission = await requestMicrophonePermission(context);
            if (!hasPermission) {
              console.error('麦克风权限未授权,无法录音');
              this.updateLogInfo('麦克风权限未授权,无法录音', true);
              this.currentState = '权限未授权';
              return;
            }
            initArguments(context);
            init((msg, isError) => this.updateLogInfo(msg, isError), (msg) => this.updateCallbackInfo(msg));
            this.currentState = '已初始化';
          });

          Column() {
            Text('开始录制').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            start((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '录制中';
          });
        }

        Row() {
          Column() {
            Text('停止录制').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            stop((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已停止';
          });

          Column() {
            Text('释放资源').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            release((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已释放';
          });
        }

        Row() {
          Column() {
            Text('查看状态').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            viewAudioCapturerState((msg, isError) => this.updateLogInfo(msg, isError));
            if (audioCapturer !== undefined) {
              let state = audioCapturer.state;
              let stateText = '';
              switch (state) {
                case audio.AudioState.STATE_NEW:
                  stateText = '新建';
                  break;
                case audio.AudioState.STATE_PREPARED:
                  stateText = '准备就绪';
                  break;
                case audio.AudioState.STATE_RUNNING:
                  stateText = '运行中';
                  break;
                case audio.AudioState.STATE_STOPPED:
                  stateText = '已停止';
                  break;
                case audio.AudioState.STATE_RELEASED:
                  stateText = '已释放';
                  break;
                case audio.AudioState.STATE_PAUSED:
                  stateText = '已暂停';
                  break;
                default:
                  stateText = '未知';
              }
              this.currentState = stateText;
            }
          });
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}
