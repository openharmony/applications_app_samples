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

// [Start set_BluetoothAndNearlinkPreferredRecordCategory]
// [Start select_MediaInputDevice]
import { audio } from '@kit.AudioKit';  // 导入audio模块。
import { BusinessError } from '@kit.BasicServicesKit';

let audioManager = audio.getAudioManager();  // 需要先创建AudioManager实例。

let audioSessionManager = audioManager.getSessionManager();  // 再调用AudioManager的方法创建AudioSessionManager实例.

// [StartExclude set_BluetoothAndNearlinkPreferredRecordCategory]
// [StartExclude select_MediaInputDevice]
// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalAvailableDeviceUpdate: ((msg: string) => void) | undefined;
let globalCurrentDeviceUpdate: ((msg: string) => void) | undefined;
// [EndExclude select_MediaInputDevice]
// 监听音频可选输入设备连接状态变化事件,当有输入设备上下线时会收到回调通知。
let availableDeviceChangeCallback = (deviceChanged: audio.DeviceChangeAction) => {
  let data: audio.AudioDeviceDescriptors = deviceChanged.deviceDescriptors;
  console.info(`Succeeded in using on or off function, AudioDeviceDescriptors: ${data}.`);
  // [StartExclude select_MediaInputDevice]
  const logMessage = `Succeeded in using on or off function, AudioDeviceDescriptors: ${data}.`;
  if (globalAvailableDeviceUpdate) {
    globalAvailableDeviceUpdate(logMessage);
  }
  // [EndExclude select_MediaInputDevice]
};

// 监听当前输入设备变化事件,当选择输入设备成功后会触发该回调。
let currentInputDeviceChangedCallback = (currentInputDeviceChangedEvent: audio.CurrentInputDeviceChangedEvent) => {
  console.info(`Succeeded in using on or off function, CurrentInputDeviceChangedEvent:
   ${currentInputDeviceChangedEvent}.`);
  // [StartExclude select_MediaInputDevice]
  const logMessage = `Succeeded in using on or off function, CurrentInputDeviceChangedEvent:
   ${currentInputDeviceChangedEvent}.`;
  if (globalCurrentDeviceUpdate) {
    globalCurrentDeviceUpdate(logMessage);
  }
  // [EndExclude select_MediaInputDevice]
};

// [StartExclude select_MediaInputDevice]
async function setBluetoothAndNearlinkPreferredRecordCategory() {
  // [EndExclude set_BluetoothAndNearlinkPreferredRecordCategory]
  audioSessionManager.setBluetoothAndNearlinkPreferredRecordCategory(audio.BluetoothAndNearlinkPreferredRecordCategory
    .PREFERRED_LOW_LATENCY).then(() => {
    console.info('Succeeded in setting bluetooth and nearlink preferred record category.');
    // [StartExclude set_BluetoothAndNearlinkPreferredRecordCategory]
    const successMsg = 'Succeeded in setting bluetooth and nearlink preferred record category.';
    if (globalLogUpdate) {
      globalLogUpdate(successMsg, false);
    }
    // [EndExclude set_BluetoothAndNearlinkPreferredRecordCategory]
  }).catch((err: BusinessError) => {
    console.error(`Failed to set bluetooth and nearlink preferred record category. Code: ${err.code},
     message: ${err.message}`);
    // [StartExclude set_BluetoothAndNearlinkPreferredRecordCategory]
    const errorMsg = `Failed to set bluetooth and nearlink preferred record category. Code: ${err.code},
     message: ${err.message}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude set_BluetoothAndNearlinkPreferredRecordCategory]
  });
  // [End set_BluetoothAndNearlinkPreferredRecordCategory]
}

function listenAvailableInputDeviceChange() {
  // 监听音频可选输入设备连接状态变化事件
  // [EndExclude select_MediaInputDevice]
  audioSessionManager.on('availableDeviceChange', audio.DeviceUsage.MEDIA_INPUT_DEVICES, availableDeviceChangeCallback);
  // [StartExclude select_MediaInputDevice]
}

function listenCurrentInputDeviceChanged() {
  // 监听当前输入设备变化事件
  // [EndExclude select_MediaInputDevice]
  audioSessionManager.on('currentInputDeviceChanged', currentInputDeviceChangedCallback);
  // [StartExclude select_MediaInputDevice]
  console.info('Started listening to current input device changes.');
}

function cancelListenAvailableInputDeviceChange() {
  // [EndExclude select_MediaInputDevice]
  // 取消监听音频可选输入设备连接状态变化事件
  audioSessionManager.off('availableDeviceChange', availableDeviceChangeCallback);
  // [StartExclude select_MediaInputDevice]
  console.info('Cancelled listening to available input device changes.');
}

function cancelListenCurrentInputDeviceChanged() {
  // [EndExclude select_MediaInputDevice]
  // 取消监听当前输入设备变化事件
  audioSessionManager.off('currentInputDeviceChanged', currentInputDeviceChangedCallback);
  // [StartExclude select_MediaInputDevice]
  console.info('Cancelled listening to current input device changes.');
}

async function getAndSelectInputDevice() {
  // 获取前先监听
  listenAvailableInputDeviceChange();
  listenCurrentInputDeviceChanged();

  // [EndExclude select_MediaInputDevice]
  try {
    // 获取当前可选的音频输入设备列表。
    let data: audio.AudioDeviceDescriptors =
      audioSessionManager.getAvailableDevices(audio.DeviceUsage.MEDIA_INPUT_DEVICES);
    console.info(`Succeeded in getting available devices, AudioDeviceDescriptors: ${data}.`);

    // [StartExclude select_MediaInputDevice]
    let deviceInfo = `Succeeded in getting available devices, AudioDeviceDescriptors: ${data}.\n`;
    // [EndExclude select_MediaInputDevice]

    // 当前可选音频输入设备列表不为空时,可进行选择。
    if (data[0]) {
      // 选择输入设备。
      await audioSessionManager.selectMediaInputDevice(data[0]).then(() => {
        console.info('Succeeded in selecting media input device.');
        // [StartExclude select_MediaInputDevice]
        const successMsg = 'Succeeded in selecting media input device.';
        deviceInfo += successMsg;
        if (globalLogUpdate) {
          globalLogUpdate(deviceInfo, false);
        }
        // [EndExclude select_MediaInputDevice]
      }).catch((err: BusinessError) => {
        console.error(`Failed to select media input device. Code: ${err.code}, message: ${err.message}`);
        // [StartExclude select_MediaInputDevice]
        const errorMsg = `Failed to select media input device. Code: ${err.code}, message: ${err.message}`;
        if (globalLogUpdate) {
          globalLogUpdate(errorMsg, true);
        }
        // [EndExclude select_MediaInputDevice]
      });
    }
  } catch (err) {
    let error = err as BusinessError;
    console.error(`Failed to select media input device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude select_MediaInputDevice]
    const errorMsg = `Failed to select media input device. Code: ${err.code}, message: ${err.message}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude select_MediaInputDevice]
  }
  // [StartExclude select_MediaInputDevice]
  // 获取后取消监听
  cancelListenAvailableInputDeviceChange();
  cancelListenCurrentInputDeviceChanged();
}

async function getSelectedInputDevice() {
  // [EndExclude select_MediaInputDevice]
  // 可通过该接口查询选择输入设备是否成功。
  try {
    let device: audio.AudioDeviceDescriptor = audioSessionManager.getSelectedMediaInputDevice();
    console.info(`Succeeded in getting selected media input device: ${JSON.stringify(device)}`);

    // [StartExclude select_MediaInputDevice]
    let deviceInfo = 'Succeeded in getting selected media input device\n';
    if (globalLogUpdate) {
      globalLogUpdate(deviceInfo, false);
    }
    // [EndExclude select_MediaInputDevice]
  } catch (err) {
    let error = err as BusinessError;
    console.error(`Failed to get selected media input device. Code: ${error.code}, message: ${error.message}`);
    // [StartExclude select_MediaInputDevice]
    const errorMsg = `Failed to get selected media input device. Code: ${error.code}, message: ${error.message}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude select_MediaInputDevice]
  }
  // [StartExclude select_MediaInputDevice]
}

async function clearSelectedInputDevice() {
  // [EndExclude select_MediaInputDevice]
  // 清空通过selectMediaInputDevice选择的输入设备。
  audioSessionManager.clearSelectedMediaInputDevice().then(() => {
    console.info('Succeeded in clearing selected media input device.');
    // [StartExclude select_MediaInputDevice]
    const successMsg = 'Succeeded in clearing selected media input device.';
    if (globalLogUpdate) {
      globalLogUpdate(successMsg, false);
    }
    // [EndExclude select_MediaInputDevice]
  }).catch((err: BusinessError) => {
    console.error(`Failed to clear selected media input device. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude select_MediaInputDevice]
    const errorMsg = `Failed to clear selected media input device. Code: ${err.code}, message: ${err.message}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude select_MediaInputDevice]
  });
  // [End select_MediaInputDevice]
}

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State availableDeviceMessages: string = '暂无可选设备信息';
  @State currentDeviceMessages: string = '暂无当前设备信息';

  aboutToAppear(): void {
    // 设置全局回调
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
    globalAvailableDeviceUpdate = (msg) => this.updateAvailableDeviceInfo(msg);
    globalCurrentDeviceUpdate = (msg) => this.updateCurrentDeviceInfo(msg);
  }

  // 更新日志信息
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  // 更新可选设备信息
  updateAvailableDeviceInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.availableDeviceMessages = `[${timestamp}] ${msg}`;
  }

  // 更新当前设备信息
  updateCurrentDeviceInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.currentDeviceMessages = `[${timestamp}] ${msg}`;
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

          // 可选设备变化回调
          Column() {
            Text('可选设备变化回调')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.availableDeviceMessages)
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
          .margin({ bottom: 12 })

          // 当前设备变化回调
          Column() {
            Text('当前设备变化回调')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.currentDeviceMessages)
                .fontSize(12)
                .fontColor('#9254DE')
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
            Text('设置蓝牙/近场优选低延迟').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在设置蓝牙/近场优选...';
            await setBluetoothAndNearlinkPreferredRecordCategory();
            this.currentState = '设置完成';
          });

          Column() {
            Text('获取并选择输入设备').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在获取并选择输入设备...';
            await getAndSelectInputDevice();
            this.currentState = '操作完成';
          });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column() {
            Text('查询已选输入设备').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 8, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在查询已选输入设备...';
            await getSelectedInputDevice();
            this.currentState = '查询完成';
          });

          Column() {
            Text('清空已选输入设备').fontColor(Color.Black).fontSize(13);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('48%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在清空已选输入设备...';
            await clearSelectedInputDevice();
            this.currentState = '清空完成';
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