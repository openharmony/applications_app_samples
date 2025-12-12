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

// [Start getRoutingManager_input]
// [Start getDevices_input]
// [Start listen_InputStatus]
import { audio } from '@kit.AudioKit';  // 导入audio模块。
// [StartExclude getDevices_input]
// [StartExclude listen_InputStatus]
let audioManager = audio.getAudioManager();  // 需要先创建AudioManager实例。
let audioRoutingManager = audioManager.getRoutingManager();  // 再调用AudioManager的方法创建AudioRoutingManager实例。
// [End getRoutingManager_input]

// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;

function listenInputStatus() {
  // [EndExclude listen_InputStatus]
  // 监听音频设备状态变化。
  audioRoutingManager.on('deviceChange', audio.DeviceFlag.INPUT_DEVICES_FLAG,
    (deviceChanged: audio.DeviceChangeAction) => {
    console.info('device change type : ' + deviceChanged.type);  // 设备连接状态变化,0为连接,1为断开连接。
    console.info('device descriptor size : ' + deviceChanged.deviceDescriptors.length);
    console.info('device change descriptor : ' + deviceChanged.deviceDescriptors[0].deviceRole);  // 设备角色。
    console.info('device change descriptor : ' + deviceChanged.deviceDescriptors[0].deviceType);  // 设备类型。

    // [StartExclude listen_InputStatus]
    // 为UI收集信息
    let callbackMsg = '';
    callbackMsg += 'device change type : ' + deviceChanged.type + '\n';
    callbackMsg += 'device descriptor size : ' + deviceChanged.deviceDescriptors.length + '\n';
    callbackMsg += 'device change descriptor : ' + deviceChanged.deviceDescriptors[0].deviceRole + '\n';
    callbackMsg += 'device change descriptor : ' + deviceChanged.deviceDescriptors[0].deviceType;

    if (globalCallbackUpdate) {
      globalCallbackUpdate(callbackMsg);
    }
  });
}

function cancelListenInputStatus() {
  // [EndExclude listen_InputStatus]
  // 取消监听音频设备状态变化。
  audioRoutingManager.off('deviceChange', (deviceChanged: audio.DeviceChangeAction) => {
    console.info('Should be no callback.');
  });
  // [End listen_InputStatus]
}

async function getDevices() {
  // 获取前先监听
  listenInputStatus();

  // [EndExclude getDevices_input]
  audioRoutingManager.getDevices(audio.DeviceFlag.INPUT_DEVICES_FLAG).then((data: audio.AudioDeviceDescriptors) => {
    console.info('Promise returned to indicate that the device list is obtained.');

    // [StartExclude getDevices_input]
    // 为UI收集设备信息
    let deviceInfo = 'Promise returned to indicate that the device list is obtained.\n';
    deviceInfo += 'Device count: ' + data.length + '\n';
    for (let i = 0; i < data.length; i++) {
      console.info(`Device ${i} - id: ${data[i].id}`);
      console.info(`Device ${i} - name: ${data[i].name}`);
      console.info(`Device ${i} - type: ${data[i].deviceType}`);
      console.info(`Device ${i} - role: ${data[i].deviceRole}`);
      console.info(`Device ${i} - address: ${data[i].address}`);

      deviceInfo += `Device ${i} - id: ${data[i].id}\n`;
      deviceInfo += `Device ${i} - name: ${data[i].name}\n`;
      deviceInfo += `Device ${i} - type: ${data[i].deviceType}\n`;
      deviceInfo += `Device ${i} - role: ${data[i].deviceRole}\n`;
      deviceInfo += `Device ${i} - address: ${data[i].address}\n`;
    }
    if (globalLogUpdate) {
      globalLogUpdate(deviceInfo, false);
    }
    // [EndExclude getDevices_input]
  });
  // [End getDevices_input]

  // 获取后取消监听
  cancelListenInputStatus();
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
            Text('回调信息')
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
          Text('获取输入设备列表').fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(60)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(async (): Promise<void> => {
          this.currentState = '正在获取输入设备列表...';
          await getDevices();
          this.currentState = '获取完成';
        });
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}