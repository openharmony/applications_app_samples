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

// [Start isEnhancedRoutingSupported]
// [Start select_OutputDevice]
// [Start select_InputDevice]
// [Start select_OutputDeviceForAudioRenderer]
// [Start select_InputDeviceForAudioCapturer]
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';

let audioManager = audio.getAudioManager();
let audioDeviceEnhanceManager: audio.AudioDeviceEnhanceManager = audioManager.getDeviceEnhanceManager();
let audioSessionManager = audioManager.getSessionManager();

let audioRenderer: audio.AudioRenderer | undefined = undefined;
let audioCapturer: audio.AudioCapturer | undefined = undefined;
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
let audioCapturerInfo: audio.AudioCapturerInfo = {
  source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION,
  capturerFlags: 0
};
let audioCapturerOptions: audio.AudioCapturerOptions = {
  streamInfo: audioStreamInfo,
  capturerInfo: audioCapturerInfo
};

// [StartExclude isEnhancedRoutingSupported]
// [StartExclude select_OutputDevice]
// [StartExclude select_InputDevice]
// [StartExclude select_OutputDeviceForAudioRenderer]
// [StartExclude select_InputDeviceForAudioCapturer]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager
    .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  return result.authResults[0] === 0;
}

function checkEnhancedRoutingSupported() {
  // [EndExclude isEnhancedRoutingSupported]
  let isSupported: boolean = audioDeviceEnhanceManager.isEnhancedRoutingSupported();
  console.info(`Succeeded in querying whether enhanced routing is supported. Result: ${isSupported}.`);
  // [StartExclude isEnhancedRoutingSupported]
  if (globalLogUpdate) {
    globalLogUpdate(`isEnhancedRoutingSupported: ${isSupported}`, false);
  }
  // [End isEnhancedRoutingSupported]
  return isSupported;
}

function logDevice(device: audio.AudioDeviceDescriptor): string {
  let deviceInfo = `Device - id: ${device.id}\n`;
  deviceInfo += `Device - name: ${device.name}\n`;
  deviceInfo += `Device - type: ${device.deviceType}\n`;
  deviceInfo += `Device - role: ${device.deviceRole}\n`;
  deviceInfo += `Device - address: ${device.address}\n`;
  return deviceInfo;
}

async function selectOutputDevice(device: audio.AudioDeviceDescriptor) {
  if (!checkEnhancedRoutingSupported()) {
    if (globalLogUpdate) {
      globalLogUpdate('Enhanced routing is not supported, selectOutputDevice will not take effect.', true);
    }
    return;
  }
  // [EndExclude select_OutputDevice]
  audioDeviceEnhanceManager.selectOutputDevice(device).then(() => {
    console.info('Succeeded in selecting output device.');
    // [StartExclude select_OutputDevice]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in selecting output device.\n' + logDevice(device), false);
    }
    // [EndExclude select_OutputDevice]
  }).catch((err: BusinessError) => {
    console.error(`Failed to select output device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude select_OutputDevice]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to select output device. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [End select_OutputDevice]
  });
}

async function selectInputDevice(device: audio.AudioDeviceDescriptor) {
  if (!checkEnhancedRoutingSupported()) {
    if (globalLogUpdate) {
      globalLogUpdate('Enhanced routing is not supported, selectInputDevice will not take effect.', true);
    }
    return;
  }
  // [EndExclude select_InputDevice]
  audioDeviceEnhanceManager.selectInputDevice(device).then(() => {
    console.info('Succeeded in selecting input device.');
    // [StartExclude select_InputDevice]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in selecting input device.\n' + logDevice(device), false);
    }
    // [EndExclude select_InputDevice]
  }).catch((err: BusinessError) => {
    console.error(`Failed to select input device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude select_InputDevice]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to select input device. Code: ${err.code}, message: ${err.message}`, true);
    }
  // [End select_InputDevice]
  });
}

async function selectOutputDeviceForAudioRenderer(renderer: audio.AudioRenderer,
  outputDevice: audio.AudioDeviceDescriptor) {
  if (!checkEnhancedRoutingSupported()) {
    if (globalLogUpdate) {
      globalLogUpdate('Enhanced routing is not supported, selectOutputDeviceForAudioRenderer will not take effect.', true);
    }
    return;
  }
  // [EndExclude select_OutputDeviceForAudioRenderer]
  audioDeviceEnhanceManager.selectOutputDeviceForAudioRenderer(renderer, outputDevice).then(() => {
    console.info('Succeeded in selecting output device for audio renderer.');
    // [StartExclude select_OutputDeviceForAudioRenderer]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in selecting output device for audio renderer.\n' + logDevice(outputDevice), false);
    }
    // [EndExclude select_OutputDeviceForAudioRenderer]
  }).catch((err: BusinessError) => {
    console.error(`Failed to select output device for audio renderer. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude select_OutputDeviceForAudioRenderer]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to select output device for audio renderer. Code: ${err.code}, message: ${err.message}`, true);
    }
  // [End select_OutputDeviceForAudioRenderer]
  });
}

async function selectInputDeviceForAudioCapturer(capturer: audio.AudioCapturer,
  inputDevice: audio.AudioDeviceDescriptor) {
  if (!checkEnhancedRoutingSupported()) {
    if (globalLogUpdate) {
      globalLogUpdate('Enhanced routing is not supported, selectInputDeviceForAudioCapturer will not take effect.', true);
    }
    return;
  }
  // [EndExclude select_InputDeviceForAudioCapturer]
  audioDeviceEnhanceManager.selectInputDeviceForAudioCapturer(capturer, inputDevice).then(() => {
    console.info('Succeeded in selecting input device for audio capturer.');
    // [StartExclude select_InputDeviceForAudioCapturer]
    if (globalLogUpdate) {
      globalLogUpdate('Succeeded in selecting input device for audio capturer.\n' + logDevice(inputDevice), false);
    }
    // [EndExclude select_InputDeviceForAudioCapturer]
  }).catch((err: BusinessError) => {
    console.error(`Failed to select input device for audio capturer. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude select_InputDeviceForAudioCapturer]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to select input device for audio capturer. Code: ${err.code}, message: ${err.message}`, true);
    }
  // [End select_InputDeviceForAudioCapturer]
  });
}

async function createAudioRenderer() {
  audio.createAudioRenderer(audioRendererOptions).then((data) => {
    audioRenderer = data;
    console.info('AudioRenderer Created : Success');
    // [StartExclude select_OutputDeviceForAudioRenderer]
    if (globalLogUpdate) {
      globalLogUpdate('AudioRenderer Created : Success', false);
    }
    // [EndExclude select_OutputDeviceForAudioRenderer]
  }).catch((err: BusinessError) => {
    console.error(`AudioRenderer Created : ERROR : ${err}`);
    // [StartExclude select_OutputDeviceForAudioRenderer]
    if (globalLogUpdate) {
      globalLogUpdate(`AudioRenderer Created : ERROR : ${err}`, true);
    }
    // [EndExclude select_OutputDeviceForAudioRenderer]
  });
}

async function createAudioCapturer(context: common.UIAbilityContext) {
  let hasPermission = await requestMicrophonePermission(context);
  if (!hasPermission) {
    if (globalLogUpdate) {
      globalLogUpdate('麦克风权限未授权,无法创建AudioCapturer', true);
    }
    return;
  }
  audio.createAudioCapturer(audioCapturerOptions).then((data) => {
    audioCapturer = data;
    console.info('AudioCapturer Created : Success');
    // [StartExclude select_InputDeviceForAudioCapturer]
    if (globalLogUpdate) {
      globalLogUpdate('AudioCapturer Created : Success', false);
    }
    // [EndExclude select_InputDeviceForAudioCapturer]
  }).catch((err: BusinessError) => {
    console.error(`AudioCapturer Created : ERROR : ${err}`);
    // [StartExclude select_InputDeviceForAudioCapturer]
    if (globalLogUpdate) {
      globalLogUpdate(`AudioCapturer Created : ERROR : ${err}`, true);
    }
    // [EndExclude select_InputDeviceForAudioCapturer]
  });
}

// [StartExclude isEnhancedRoutingSupported]
// [StartExclude select_OutputDevice]
// [StartExclude select_InputDevice]
// [StartExclude select_OutputDeviceForAudioRenderer]
// [StartExclude select_InputDeviceForAudioCapturer]
function getAvailableOutputDevices(): audio.AudioDeviceDescriptors {
  return audioSessionManager.getAvailableDevices(audio.DeviceUsage.MEDIA_OUTPUT_DEVICES);
}

function getAvailableInputDevices(): audio.AudioDeviceDescriptors {
  return audioSessionManager.getAvailableDevices(audio.DeviceUsage.MEDIA_INPUT_DEVICES);
}

function buildDeviceSheets(devices: audio.AudioDeviceDescriptors,
  onSelect: (device: audio.AudioDeviceDescriptor) => void): Array<SheetInfo> {
  return devices.map((item: audio.AudioDeviceDescriptor) => {
    const sheet: SheetInfo = {
      title: item.name || item.displayName,
      action: () => onSelect(item)
    };
    return sheet;
  });
}
// [EndExclude isEnhancedRoutingSupported]
// [EndExclude select_OutputDevice]
// [EndExclude select_InputDevice]
// [EndExclude select_OutputDeviceForAudioRenderer]
// [EndExclude select_InputDeviceForAudioCapturer]

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  showOutputDeviceForApp() {
    let devices = getAvailableOutputDevices();
    if (devices.length === 0) {
      this.updateLogInfo('No available output devices found.', true);
      return;
    }
    this.getUIContext().showActionSheet({
      title: '选择输出设备',
      autoCancel: true,
      alignment: DialogAlignment.Center,
      message: '为应用选择输出设备',
      sheets: buildDeviceSheets(devices, (device: audio.AudioDeviceDescriptor) => {
        selectOutputDevice(device);
        this.currentState = '为应用选择输出: ' + (device.name || device.displayName);
      }),
    });
  }

  showInputDeviceForApp() {
    let devices = getAvailableInputDevices();
    if (devices.length === 0) {
      this.updateLogInfo('No available input devices found.', true);
      return;
    }
    this.getUIContext().showActionSheet({
      title: '选择输入设备',
      autoCancel: true,
      alignment: DialogAlignment.Center,
      message: '为应用选择输入设备',
      sheets: buildDeviceSheets(devices, (device: audio.AudioDeviceDescriptor) => {
        selectInputDevice(device);
        this.currentState = '为应用选择输入: ' + (device.name || device.displayName);
      }),
    });
  }

  showOutputDeviceForRenderer() {
    if (!audioRenderer) {
      this.updateLogInfo('请先创建AudioRenderer', true);
      return;
    }
    let devices = getAvailableOutputDevices();
    if (devices.length === 0) {
      this.updateLogInfo('No available output devices found.', true);
      return;
    }
    this.getUIContext().showActionSheet({
      title: '选择输出设备',
      autoCancel: true,
      alignment: DialogAlignment.Center,
      message: '为Renderer选择输出设备',
      sheets: buildDeviceSheets(devices, (device: audio.AudioDeviceDescriptor) => {
        selectOutputDeviceForAudioRenderer(audioRenderer as audio.AudioRenderer, device);
        this.currentState = '为Renderer选择输出: ' + (device.name || device.displayName);
      }),
    });
  }

  showInputDeviceForCapturer() {
    if (!audioCapturer) {
      this.updateLogInfo('请先创建AudioCapturer', true);
      return;
    }
    let devices = getAvailableInputDevices();
    if (devices.length === 0) {
      this.updateLogInfo('No available input devices found.', true);
      return;
    }
    this.getUIContext().showActionSheet({
      title: '选择输入设备',
      autoCancel: true,
      alignment: DialogAlignment.Center,
      message: '为Capturer选择输入设备',
      sheets: buildDeviceSheets(devices, (device: audio.AudioDeviceDescriptor) => {
        selectInputDeviceForAudioCapturer(audioCapturer as audio.AudioCapturer, device);
        this.currentState = '为Capturer选择输入: ' + (device.name || device.displayName);
      }),
    });
  }

  build(): void {
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
          .margin({ bottom: 20 })
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

        Row() {
          Column() {
            Text('查询增强路由支持').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(() => {
            checkEnhancedRoutingSupported();
          });

          Column() {
            Text('创建AudioRenderer').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            await createAudioRenderer();
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Column() {
          Text('创建AudioCapturer').fontColor(Color.Black).fontSize(13);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('100%')
        .height(60)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(async (): Promise<void> => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          await createAudioCapturer(context);
        });

        Text('应用级选择')
          .fontSize(16)
          .fontWeight(600)
          .margin({ bottom: 8 })

        Row() {
          Column() {
            Text('为应用选择输出').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(() => {
            this.showOutputDeviceForApp();
          });

          Column() {
            Text('为应用选择输入').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(() => {
            this.showInputDeviceForApp();
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text('流级选择')
          .fontSize(16)
          .fontWeight(600)
          .margin({ bottom: 8 })

        Row() {
          Column() {
            Text('为Renderer选择输出').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(() => {
            this.showOutputDeviceForRenderer();
          });

          Column() {
            Text('为Capturer选择输入').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(() => {
            this.showInputDeviceForCapturer();
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
