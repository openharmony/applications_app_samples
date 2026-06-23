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

import testNapi from 'libentry.so';
import { audio } from '@kit.AudioKit';
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';

let audioManager = audio.getAudioManager();
let audioSessionManager = audioManager.getSessionManager();

let audioRenderer: audio.AudioRenderer | undefined = undefined;
let audioCapturer: audio.AudioCapturer | undefined = undefined;

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager
    .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  return result.authResults[0] === 0;
}

async function createAudioRenderer(): Promise<void> {
  let audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  };
  let audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
    rendererFlags: 0
  };
  let audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: audioStreamInfo,
    rendererInfo: audioRendererInfo
  };
  audio.createAudioRenderer(audioRendererOptions).then((data) => {
    audioRenderer = data;
  }).catch(() => {});
}

async function createAudioCapturer(context: common.UIAbilityContext): Promise<void> {
  let hasPermission = await requestMicrophonePermission(context);
  if (!hasPermission) {
    return;
  }
  let audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  };
  let audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION,
    capturerFlags: 0
  };
  let audioCapturerOptions: audio.AudioCapturerOptions = {
    streamInfo: audioStreamInfo,
    capturerInfo: audioCapturerInfo
  };
  audio.createAudioCapturer(audioCapturerOptions).then((data) => {
    audioCapturer = data;
  }).catch(() => {});
}

function getAvailableOutputDevices(): audio.AudioDeviceDescriptors {
  return audioSessionManager.getAvailableDevices(audio.DeviceUsage.MEDIA_OUTPUT_DEVICES);
}

function getAvailableInputDevices(): audio.AudioDeviceDescriptors {
  return audioSessionManager.getAvailableDevices(audio.DeviceUsage.MEDIA_INPUT_DEVICES);
}

@Entry
@Component
struct EnhancedDeviceRoutingDemo {
  @State currentState: string = '未初始化';
  @State napiReturnLog: string = '暂无返回信息';

  updateNapiLog(msg: string) {
    const timestamp = new Date().toLocaleTimeString();
    this.napiReturnLog = `[${timestamp}]\n${msg}`;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text('实时状态信息')
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

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

          Column() {
            Text('NAPI返回信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.napiReturnLog)
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
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ bottom: 16 })

        Text('准备')
          .fontSize(16)
          .fontWeight(600)
          .margin({ bottom: 8 })

        Button('查询增强路由支持')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(() => {
            try {
              let result = testNapi.IsEnhancedRoutingSupported();
              this.currentState = '查询完成';
              this.updateNapiLog(result);
            } catch (err) {
              this.currentState = '查询失败';
              this.updateNapiLog('错误: ' + JSON.stringify(err));
            }
          })

        Button('创建AudioRenderer')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(async () => {
            await createAudioRenderer();
            this.currentState = audioRenderer !== undefined ? 'Renderer已创建' : 'Renderer创建失败';
            this.updateNapiLog(audioRenderer !== undefined ? 'AudioRenderer创建成功' : 'AudioRenderer创建失败');
          })

        Button('创建AudioCapturer')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            await createAudioCapturer(context);
            this.currentState = audioCapturer !== undefined ? 'Capturer已创建' : 'Capturer创建失败';
            this.updateNapiLog(audioCapturer !== undefined ? 'AudioCapturer创建成功' : 'AudioCapturer创建失败');
          })

        Text('应用级选择')
          .fontSize(16)
          .fontWeight(600)
          .margin({ bottom: 8 })

        Button('为应用选择输出')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(() => {
            let devices = getAvailableOutputDevices();
            if (devices.length === 0) {
              this.updateNapiLog('No available output devices found.');
              return;
            }
            let sheets: Array<SheetInfo> = devices.map((item: audio.AudioDeviceDescriptor) => {
              const sheet: SheetInfo = {
                title: item.name || item.displayName,
                action: () => {
                  try {
                    let result = testNapi.SelectOutputDevice(item.id);
                    this.currentState = '为应用选择输出: ' + (item.name || item.displayName);
                    this.updateNapiLog(result);
                  } catch (err) {
                    this.updateNapiLog('错误: ' + JSON.stringify(err));
                  }
                }
              };
              return sheet;
            });
            this.getUIContext().showActionSheet({
              title: '选择输出设备',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              message: '为应用选择输出设备',
              sheets: sheets,
            });
          })

        Button('为应用选择输入')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(() => {
            let devices = getAvailableInputDevices();
            if (devices.length === 0) {
              this.updateNapiLog('No available input devices found.');
              return;
            }
            let sheets: Array<SheetInfo> = devices.map((item: audio.AudioDeviceDescriptor) => {
              const sheet: SheetInfo = {
                title: item.name || item.displayName,
                action: () => {
                  try {
                    let result = testNapi.SelectInputDevice(item.id);
                    this.currentState = '为应用选择输入: ' + (item.name || item.displayName);
                    this.updateNapiLog(result);
                  } catch (err) {
                    this.updateNapiLog('错误: ' + JSON.stringify(err));
                  }
                }
              };
              return sheet;
            });
            this.getUIContext().showActionSheet({
              title: '选择输入设备',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              message: '为应用选择输入设备',
              sheets: sheets,
            });
          })

        Text('流级选择')
          .fontSize(16)
          .fontWeight(600)
          .margin({ bottom: 8 })

        Button('为Renderer选择输出')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(() => {
            if (!audioRenderer) {
              this.updateNapiLog('请先创建AudioRenderer');
              this.currentState = '请先创建AudioRenderer';
              return;
            }
            let devices = getAvailableOutputDevices();
            if (devices.length === 0) {
              this.updateNapiLog('No available output devices found.');
              return;
            }
            let sheets: Array<SheetInfo> = devices.map((item: audio.AudioDeviceDescriptor) => {
              const sheet: SheetInfo = {
                title: item.name || item.displayName,
                action: () => {
                  try {
                    let result = testNapi.SelectOutputDeviceForAudioRenderer(item.id);
                    this.currentState = '为Renderer选择输出: ' + (item.name || item.displayName);
                    this.updateNapiLog(result);
                  } catch (err) {
                    this.updateNapiLog('错误: ' + JSON.stringify(err));
                  }
                }
              };
              return sheet;
            });
            this.getUIContext().showActionSheet({
              title: '选择输出设备',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              message: '为Renderer选择输出设备',
              sheets: sheets,
            });
          })

        Button('为Capturer选择输入')
          .width('90%')
          .height(48)
          .margin({ bottom: 12 })
          .onClick(() => {
            if (!audioCapturer) {
              this.updateNapiLog('请先创建AudioCapturer');
              this.currentState = '请先创建AudioCapturer';
              return;
            }
            let devices = getAvailableInputDevices();
            if (devices.length === 0) {
              this.updateNapiLog('No available input devices found.');
              return;
            }
            let sheets: Array<SheetInfo> = devices.map((item: audio.AudioDeviceDescriptor) => {
              const sheet: SheetInfo = {
                title: item.name || item.displayName,
                action: () => {
                  try {
                    let result = testNapi.SelectInputDeviceForAudioCapturer(item.id);
                    this.currentState = '为Capturer选择输入: ' + (item.name || item.displayName);
                    this.updateNapiLog(result);
                  } catch (err) {
                    this.updateNapiLog('错误: ' + JSON.stringify(err));
                  }
                }
              };
              return sheet;
            });
            this.getUIContext().showActionSheet({
              title: '选择输入设备',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              message: '为Capturer选择输入设备',
              sheets: sheets,
            });
          })
      }
      .width('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
