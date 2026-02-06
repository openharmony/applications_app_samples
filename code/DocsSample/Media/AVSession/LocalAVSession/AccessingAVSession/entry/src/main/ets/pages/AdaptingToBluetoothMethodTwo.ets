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

// [Start adaptingToBluetoothMethodTwo]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude adaptingToBluetoothMethodTwo]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude adaptingToBluetoothMethodTwo]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude adaptingToBluetoothMethodTwo]
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
    if (logs.length > 6) {
      logs.shift();
    }
    this.logMessages = logs.join('\n');
  }
  // [EndExclude adaptingToBluetoothMethodTwo]

  build() {
    Column() {
      // [StartExclude adaptingToBluetoothMethodTwo]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude adaptingToBluetoothMethodTwo]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          // [StartExclude adaptingToBluetoothMethodTwo]
          await session.activate();
          // [EndExclude adaptingToBluetoothMethodTwo]
          // 设置必要的媒体信息，务必设置，否则接收不到按键事件。
          let metadata: AVSessionManager.AVMetadata = {
            assetId: '0', // 由应用指定，用于标识应用媒体库里的媒体。
            title: 'TITLE',
            mediaImage: 'IMAGE',
            artist: 'ARTIST'
          };
          session.setAVMetadata(metadata).then(() => {
            console.info(`SetAVMetadata successfully`);
            // [StartExclude adaptingToBluetoothMethodTwo]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVMetadata successfully', false);
            }
            // [EndExclude adaptingToBluetoothMethodTwo]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
            // [StartExclude adaptingToBluetoothMethodTwo]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
            }
            // [EndExclude adaptingToBluetoothMethodTwo]
          });
          session.on('handleKeyEvent', (event) => {
            // 解析keycode，应用需要根据keycode对播放器做相应逻辑处理。
            console.info(`on handleKeyEvent, keyCode=${event.key.code}`);
            // [StartExclude adaptingToBluetoothMethodTwo]
            if (globalLogUpdate) {
              globalLogUpdate(`on handleKeyEvent, keyCode=${event.key.code}`, false);
            }
            // [EndExclude adaptingToBluetoothMethodTwo]
          });
          // [StartExclude adaptingToBluetoothMethodTwo]
          await new Promise<void>(resolve => setTimeout(resolve, 10000));
          // 主动销毁已创建的session。
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude adaptingToBluetoothMethodTwo]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End adaptingToBluetoothMethodTwo]