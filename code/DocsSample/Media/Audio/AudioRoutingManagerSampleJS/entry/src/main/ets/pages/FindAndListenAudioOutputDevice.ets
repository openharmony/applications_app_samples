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

// [Start getRoutingManager_output]
// [Start get_OutputDevices]
// [Start deviceChange_output]
// [Start get_PreferOutputDeviceForRendererInfo]
// [Start listen_OutputDeviceChangeForRendererInfo]
import { audio } from '@kit.AudioKit';  // 导入audio模块。
// [StartExclude get_OutputDevices]
// [StartExclude deviceChange_output]
// [StartExclude getRoutingManager_output]
// [StartExclude listen_OutputDeviceChangeForRendererInfo]
import { BusinessError } from '@kit.BasicServicesKit';
// [EndExclude getRoutingManager_output]
// [StartExclude get_PreferOutputDeviceForRendererInfo]
let audioManager = audio.getAudioManager();  // 需要先创建AudioManager实例。
let audioRoutingManager = audioManager.getRoutingManager();  // 再调用AudioManager的方法创建AudioRoutingManager实例。
// [End getRoutingManager_output]
// [EndExclude get_PreferOutputDeviceForRendererInfo]
// [EndExclude listen_OutputDeviceChangeForRendererInfo]
let rendererInfo: audio.AudioRendererInfo = {
  usage: audio.StreamUsage.STREAM_USAGE_MUSIC,// 音频流使用类型:音乐。根据业务场景配置,参考StreamUsage。
  rendererFlags: 0 // 音频渲染器标志。
};
// [StartExclude get_PreferOutputDeviceForRendererInfo]
// [StartExclude listen_OutputDeviceChangeForRendererInfo]

// 全局UI更新回调
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
let globalCallbackUpdate: ((msg: string) => void) | undefined;
let globalPreferDeviceUpdate: ((msg: string) => void) | undefined;

function listenOutputStatus() {
  // [EndExclude deviceChange_output]
  // 监听音频设备状态变化。
  audioRoutingManager.on('deviceChange', audio.DeviceFlag.OUTPUT_DEVICES_FLAG, (deviceChanged: audio.DeviceChangeAction) => {
    console.info(`device change type : ${deviceChanged.type}`);  // 设备连接状态变化,0为连接,1为断开连接。
    console.info(`device descriptor size : ${deviceChanged.deviceDescriptors.length}`);
    console.info(`device change descriptor : ${deviceChanged.deviceDescriptors[0].deviceRole}`);  // 设备角色。
    console.info(`device change descriptor : ${deviceChanged.deviceDescriptors[0].deviceType}`);  // 设备类型。

    // [StartExclude deviceChange_output]
    // 为UI收集信息
    let callbackMsg = '';
    callbackMsg += `device change type : ${deviceChanged.type}\n`;
    callbackMsg += `device descriptor size : ${deviceChanged.deviceDescriptors.length}\n`;
    callbackMsg += `device change descriptor : ${deviceChanged.deviceDescriptors[0].deviceRole}\n`;
    callbackMsg += `device change descriptor : ${deviceChanged.deviceDescriptors[0].deviceType}`;

    if (globalCallbackUpdate) {
      globalCallbackUpdate(callbackMsg);
    }
    // [EndExclude deviceChange_output]
  });
  // [StartExclude deviceChange_output]
}

function cancelListenOutputStatus() {
  // [EndExclude deviceChange_output]
  // 取消监听音频设备状态变化。
  audioRoutingManager.off('deviceChange');
  // [End deviceChange_output]
}

async function getOutputDevices() {
  // 获取前先监听
  listenOutputStatus();
  // [EndExclude get_OutputDevices]
  audioRoutingManager.getDevices(audio.DeviceFlag.OUTPUT_DEVICES_FLAG).then((data: audio.AudioDeviceDescriptors) => {
    console.info('Promise returned to indicate that the device list is obtained.');
    // [StartExclude get_OutputDevices]
    // 为UI收集设备信息
    let deviceInfo = 'Promise returned to indicate that the device list is obtained.\n';
    if (globalLogUpdate) {
      globalLogUpdate(deviceInfo, false);
    }
    // [EndExclude get_OutputDevices]
  });
  // [End get_OutputDevices]

  // 获取后取消监听
  cancelListenOutputStatus();
}

function listenOutputDeviceChangeForRendererInfo() {
  // [EndExclude listen_OutputDeviceChangeForRendererInfo]
  // 监听最高优先级输出设备变化。
  audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo', rendererInfo, (desc: audio.AudioDeviceDescriptors) => {
    console.info(`device change descriptor : ${desc[0].deviceRole}`);  // 设备角色。
    console.info(`device change descriptor : ${desc[0].deviceType}`);  // 设备类型。

    // [StartExclude listen_OutputDeviceChangeForRendererInfo]
    // 为UI收集信息
    let preferMsg = '';
    preferMsg += `device change descriptor : ${desc[0].deviceRole}\n`;
    preferMsg += `device change descriptor : ${desc[0].deviceType}`;

    if (globalPreferDeviceUpdate) {
      globalPreferDeviceUpdate(preferMsg);
    }
    // [EndExclude listen_OutputDeviceChangeForRendererInfo]
  });
  // [StartExclude listen_OutputDeviceChangeForRendererInfo]
}

function cancelListenOutputDeviceChangeForRendererInfo() {
  // [EndExclude listen_OutputDeviceChangeForRendererInfo]
  // 取消监听最高优先级输出设备变化。
  audioRoutingManager.off('preferOutputDeviceChangeForRendererInfo');
  // [End listen_OutputDeviceChangeForRendererInfo]
}

// [EndExclude get_PreferOutputDeviceForRendererInfo]
async function getPreferOutputDeviceForRendererInfo() {
  // [StartExclude get_PreferOutputDeviceForRendererInfo]
  // 获取前先监听
  listenOutputDeviceChangeForRendererInfo();
  // [EndExclude get_PreferOutputDeviceForRendererInfo]
  audioRoutingManager.getPreferOutputDeviceForRendererInfo(rendererInfo).then((desc: audio.AudioDeviceDescriptors) => {
    console.info(`device descriptor: ${desc}`);

    // [StartExclude get_PreferOutputDeviceForRendererInfo]
    // 为UI收集信息
    let preferInfo = `device descriptor: ${desc}\n`;
    if (globalLogUpdate) {
      globalLogUpdate(preferInfo, false);
    }
    // [EndExclude get_PreferOutputDeviceForRendererInfo]
  }).catch((err: BusinessError) => {
    console.error(`Result ERROR: ${err}`);
    // [StartExclude get_PreferOutputDeviceForRendererInfo]
    const errorMsg = `Result ERROR: ${err}`;
    if (globalLogUpdate) {
      globalLogUpdate(errorMsg, true);
    }
    // [EndExclude get_PreferOutputDeviceForRendererInfo]
  });
  // [StartExclude get_PreferOutputDeviceForRendererInfo]
  // 获取后取消监听
  cancelListenOutputDeviceChangeForRendererInfo();
  // [EndExclude get_PreferOutputDeviceForRendererInfo]
}
// [End get_PreferOutputDeviceForRendererInfo]

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';
  @State preferDeviceMessages: string = '暂无优先设备信息';

  aboutToAppear(): void {
    // 设置全局回调
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
    globalCallbackUpdate = (msg) => this.updateCallbackInfo(msg);
    globalPreferDeviceUpdate = (msg) => this.updatePreferDeviceInfo(msg);
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

  // 更新优先设备信息
  updatePreferDeviceInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.preferDeviceMessages = `[${timestamp}] ${msg}`;
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

          // 设备变化回调信息
          Column() {
            Text('设备变化回调')
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
          .margin({ bottom: 12 })

          // 优先设备变化回调信息
          Column() {
            Text('优先设备变化回调')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.preferDeviceMessages)
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
            Text('获取输出设备列表').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在获取输出设备列表...';
            await getOutputDevices();
            this.currentState = '获取完成';
          });

          Column() {
            Text('获取优先输出设备').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            this.currentState = '正在获取优先输出设备...';
            await getPreferOutputDeviceForRendererInfo();
            this.currentState = '获取完成';
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