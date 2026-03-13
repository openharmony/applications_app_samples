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

// [Start set_DefaultOutputDevice]
// [Start setting_DefaultOutputDevice]
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude set_DefaultOutputDevice]
// [Start get_SessionManager]
// [Start listen_CurrentOutputDeviceChangedEvent]
import { audio } from '@kit.AudioKit';  // 导入audio模块。
// [StartExclude listen_CurrentOutputDeviceChangedEvent]
let audioManager = audio.getAudioManager();  // 需要先创建AudioManager实例。

let audioSessionManager = audioManager.getSessionManager();  // 再调用AudioManager的方法创建AudioSessionManager实例。
// [End get_SessionManager]
// [StartExclude setting_DefaultOutputDevice]

// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;

// [EndExclude listen_CurrentOutputDeviceChangedEvent]
// 同一监听事件中,on方法和off方法传入callback参数一致,off方法取消对应on方法订阅的监听。
let currentOutputDeviceChangedCallback = (currentOutputDeviceChangedEvent: audio.CurrentOutputDeviceChangedEvent) => {
  console.info(`reason of audioSessionStateChanged: ${currentOutputDeviceChangedEvent.changeReason} `);

  // [Start listen_CurrentOutputDeviceChangedEvent]
  // 为UI收集信息
  let callbackMsg = `reason of audioSessionStateChanged: ${currentOutputDeviceChangedEvent.changeReason} `;
  if (globalCallbackUpdate) {
    globalCallbackUpdate(callbackMsg);
  }
  // [EndExclude listen_CurrentOutputDeviceChangedEvent]

  switch (currentOutputDeviceChangedEvent.changeReason) {
    case audio.AudioStreamDeviceChangeReason.REASON_OLD_DEVICE_UNAVAILABLE:
      // 响应设备不可用事件,如果应用处于播放状态,应暂停播放,更新UX界面。
      break;
    case audio.AudioStreamDeviceChangeReason.REASON_NEW_DEVICE_AVAILABLE:
      // 应用根据业务情况响应设备可用事件。
      break;
    case audio.AudioStreamDeviceChangeReason.REASON_OVERRODE:
      // 应用根据业务情况响应设备强选事件。
      break;
    case audio.AudioStreamDeviceChangeReason.REASON_SESSION_ACTIVATED:
      // 应用根据业务情况响应audio session激活时的输出设备信息。
      break;
    case audio.AudioStreamDeviceChangeReason.REASON_STREAM_PRIORITY_CHANGED:
      // 应用根据业务情况响应其它更高优先级的音频流触发的设备变更事件。
      break;
    case audio.AudioStreamDeviceChangeReason.REASON_UNKNOWN:
      // 应用根据业务情况响应未知原因事件。
      break;
  }
};
// [StartExclude listen_CurrentOutputDeviceChangedEvent]

function listenCurrentOutputDeviceChanged() {
  // [EndExclude listen_CurrentOutputDeviceChangedEvent]
  audioSessionManager.on('currentOutputDeviceChanged', currentOutputDeviceChangedCallback);
  // [StartExclude listen_CurrentOutputDeviceChangedEvent]
}

function cancelListenCurrentOutputDeviceChanged() {
  // [EndExclude listen_CurrentOutputDeviceChangedEvent]
  audioSessionManager.off('currentOutputDeviceChanged', currentOutputDeviceChangedCallback);
  // [StartExclude listen_CurrentOutputDeviceChangedEvent]
}

async function cancelAllListenCurrentOutputDeviceChanged() {
  // [EndExclude listen_CurrentOutputDeviceChangedEvent]
  // 取消该事件的所有监听。
  audioSessionManager.off('currentOutputDeviceChanged');
  // [End listen_CurrentOutputDeviceChangedEvent]
}

async function setDefaultOutputDeviceSpeaker() {
  // [EndExclude set_DefaultOutputDevice]
  // [EndExclude setting_DefaultOutputDevice]
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT
  };
  await audioSessionManager.activateAudioSession(strategy);
  // 设置默认输出设备为本机扬声器。
  audioSessionManager.setDefaultOutputDevice(audio.DeviceType.SPEAKER).then(() => {
    // [StartExclude setting_DefaultOutputDevice]
    console.info('setDefaultOutputDevice Success!');
    // [EndExclude setting_DefaultOutputDevice]
    // [StartExclude set_DefaultOutputDevice]
    console.info('Succeeded in setting default output device.');
    // [StartExclude setting_DefaultOutputDevice]
    const successMsg = 'setDefaultOutputDevice Success!\nSucceeded in setting default output device to SPEAKER.';
    if (globalLogUpdate) {
      globalLogUpdate(successMsg, false);
    }
    // [EndExclude setting_DefaultOutputDevice]
    // [EndExclude set_DefaultOutputDevice]
  }).catch((err: BusinessError) => {
    // [StartExclude setting_DefaultOutputDevice]
    console.error(`setDefaultOutputDevice Fail: ${err}`);
    // [EndExclude setting_DefaultOutputDevice]
    // [StartExclude set_DefaultOutputDevice]
    console.error(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude setting_DefaultOutputDevice]
    const errorMsg = `setDefaultOutputDevice Fail: ${err}; Failed to set default output device.
     Code: ${err.code}, message: ${err.message}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude set_DefaultOutputDevice]
    // [EndExclude setting_DefaultOutputDevice]
  });
  // [StartExclude set_DefaultOutputDevice]
  // [StartExclude setting_DefaultOutputDevice]
}

async function setDefaultOutputDeviceDefault() {
  // [EndExclude set_DefaultOutputDevice]
  // [EndExclude setting_DefaultOutputDevice]
  let strategy: audio.AudioSessionStrategy = {
    concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT
  };
  await audioSessionManager.activateAudioSession(strategy);
  // 设置默认输出设备为默认设备,即取消应用设置的默认设备,交由系统选择设备。
  audioSessionManager.setDefaultOutputDevice(audio.DeviceType.DEFAULT).then(() => {
    // [StartExclude setting_DefaultOutputDevice]
    console.info('setDefaultOutputDevice Success!');
    // [EndExclude setting_DefaultOutputDevice]
    // [StartExclude set_DefaultOutputDevice]
    console.info('Succeeded in setting default output device.');
    // [StartExclude setting_DefaultOutputDevice]
    const successMsg = 'setDefaultOutputDevice Success!';
    if (globalLogUpdate) {
      globalLogUpdate(successMsg, false);
    }
    // [EndExclude setting_DefaultOutputDevice]
    // [EndExclude set_DefaultOutputDevice]
  }).catch((err: BusinessError) => {
    // [StartExclude setting_DefaultOutputDevice]
    console.error(`setDefaultOutputDevice Fail: ${err}`);
    // [Exclude setting_DefaultOutputDevice]

    console.error(`Failed to set default output device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude set_DefaultOutputDevice]
    // [EndExclude setting_DefaultOutputDevice]
    const errorMsg = `setDefaultOutputDevice Fail: ${err}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude setting_DefaultOutputDevice]
    // [EndExclude set_DefaultOutputDevice]
  });
  // [End set_DefaultOutputDevice]
  // [End setting_DefaultOutputDevice]
}

async function getDefaultOutputDevice() {
  // 获取前先监听
  listenCurrentOutputDeviceChanged();
  // [Start get_DefaultOutputDevice]
  let deviceType = audioSessionManager.getDefaultOutputDevice();
  console.info(`getDefaultOutputDevice Success, deviceType: ${deviceType}`);
  // [End get_DefaultOutputDevice]
  const successMsg = `getDefaultOutputDevice Success\nDevice type: ${deviceType}`;
  if (globalLogUpdate) {
    globalLogUpdate(successMsg, false);
  }
  // 获取后取消监听
  cancelListenCurrentOutputDeviceChanged();
  // 取消该事件的所有监听
  cancelAllListenCurrentOutputDeviceChanged();
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
        Row() {
          Column() {
            Text('设置为扬声器').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在设置为扬声器...';
            await setDefaultOutputDeviceSpeaker();
            this.currentState = '设置完成';
          });

          Column() {
            Text('设置为默认输出').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在设置为默认输出...';
            await setDefaultOutputDeviceDefault();
            this.currentState = '设置完成';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Text('获取当前默认输出').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在获取当前默认输出...';
            await getDefaultOutputDevice();
            this.currentState = '获取完成';
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