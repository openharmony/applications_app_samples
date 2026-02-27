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

// [Start advancedPlayback]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
// [StartExclude advancedPlayback]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude advancedPlayback]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude advancedPlayback]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    const newLog = `[${timestamp}] ${prefix} ${msg}`;
    let logs = this.logMessages ? this.logMessages.split('\n') : [];
    logs.push(newLog);
    if (logs.length > 15) {
      logs.shift();
    }
    this.logMessages = logs.join('\n');
  }
  // [EndExclude advancedPlayback]

  build() {
    Column() {
      // [StartExclude advancedPlayback]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude advancedPlayback]
      Text(this.message)
        .onClick(async () => {
          try {
            let context = this.getUIContext().getHostContext() as Context;
            // 假设已经创建了一个session，如何创建session可以参考之前的案例。
            let type: AVSessionManager.AVSessionType = 'audio';
            let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
            // [StartExclude advancedPlayback]
            if (globalLogUpdate) {
              globalLogUpdate('AVSession created successfully', false);
            }
            // [EndExclude advancedPlayback]
            // 一般在监听器中会对播放器做相应逻辑处理。
            // 不要忘记处理完后需要通过set接口同步播放相关信息，参考上面的用例。
            session.on('skipToQueueItem', (itemId) => {
              console.info(`on skipToQueueItem , do skip task`);
              // [StartExclude advancedPlayback]
              if (globalLogUpdate) {
                globalLogUpdate(`on skipToQueueItem , itemId: ${itemId}`, false);
              }
              // [EndExclude advancedPlayback]
              // 实现具体功能。
            });
            session.on('handleKeyEvent', (event) => {
              console.info(`on handleKeyEvent , the event is ${JSON.stringify(event)}`);
              // [StartExclude advancedPlayback]
              if (globalLogUpdate) {
                globalLogUpdate(`on handleKeyEvent registered`, false);
              }
              // [EndExclude advancedPlayback]
              // 实现具体功能。
            });
            session.on('outputDeviceChange', (device) => {
              console.info(`on outputDeviceChange , the device info is ${JSON.stringify(device)}`);
              // [StartExclude advancedPlayback]
              if (globalLogUpdate) {
                globalLogUpdate(`on outputDeviceChange registered`, false);
              }
              // [EndExclude advancedPlayback]
              // 实现具体功能。
            });
            session.on('commonCommand', (commandString, args) => {
              console.info(`on commonCommand , command is ${commandString}, args are ${JSON.stringify(args)}`);
              // [StartExclude advancedPlayback]
              if (globalLogUpdate) {
                globalLogUpdate(`on commonCommand registered`, false);
              }
              // [EndExclude advancedPlayback]
              // 实现具体功能。
            });
            // [StartExclude advancedPlayback]
            session.destroy((err) => {
              if (err) {
                console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
              } else {
                console.info(`Destroy : SUCCESS `);
              }
            });
            // [EndExclude advancedPlayback]
          } catch (err) {
            if (err) {
              console.error(`AVSession create Error: Code: ${err.code}, message: ${err.message}`);
              // [StartExclude advancedPlayback]
              if (globalLogUpdate) {
                globalLogUpdate(`AVSession create Error: Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude advancedPlayback]
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End advancedPlayback]