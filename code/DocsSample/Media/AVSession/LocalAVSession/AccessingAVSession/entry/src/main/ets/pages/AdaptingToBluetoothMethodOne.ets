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

// [Start adaptingToBluetoothMethodOne]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude adaptingToBluetoothMethodOne]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude adaptingToBluetoothMethodOne]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude adaptingToBluetoothMethodOne]
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
  // [EndExclude adaptingToBluetoothMethodOne]

  build() {
    Column() {
      // [StartExclude adaptingToBluetoothMethodOne]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude adaptingToBluetoothMethodOne]
      Text(this.message)
        .onClick(async () => {
          try {
            let context = this.getUIContext().getHostContext() as Context;
            let type: AVSessionManager.AVSessionType = 'audio';
            let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
            // [StartExclude adaptingToBluetoothMethodOne]
            await session.activate();
            if (globalLogUpdate) {
              globalLogUpdate('AVSession created and activated', false);
            }
            // [EndExclude adaptingToBluetoothMethodOne]
            // 设置必要的媒体信息，务必设置，否则接收不到控制事件。
            let metadata: AVSessionManager.AVMetadata = {
              assetId: '0', // 由应用指定，用于标识应用媒体库里的媒体。
              title: 'TITLE',
              mediaImage: 'IMAGE',
              artist: 'ARTIST'
            };
            session.setAVMetadata(metadata).then(() => {
              console.info(`SetAVMetadata successfully`);
              // [StartExclude adaptingToBluetoothMethodOne]
              if (globalLogUpdate) {
                globalLogUpdate('SetAVMetadata successfully', false);
              }
              // [EndExclude adaptingToBluetoothMethodOne]
            }).catch((err: BusinessError) => {
              console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
              // [StartExclude adaptingToBluetoothMethodOne]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude adaptingToBluetoothMethodOne]
            });
            // 一般在监听器中会对播放器做相应逻辑处理。
            // 处理完后需要通过set接口同步播放相关信息，参考上面的用例。
            session.on('play', () => {
              console.info(`on play , do play task`);
              // [StartExclude adaptingToBluetoothMethodOne]
              if (globalLogUpdate) {
                globalLogUpdate('on play , do play task', false);
              }
              // [EndExclude adaptingToBluetoothMethodOne]
              // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('play')取消监听。
              // 处理完毕后，请使用setAVPlayState上报播放状态。
            });
            session.on('pause', () => {
              console.info(`on pause , do pause task`);
              // [StartExclude adaptingToBluetoothMethodOne]
              if (globalLogUpdate) {
                globalLogUpdate('on pause , do pause task', false);
              }
              // [EndExclude adaptingToBluetoothMethodOne]
              // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('pause')取消监听。
              // 处理完毕后，请使用setAVPlayState上报播放状态。
            });
            // [StartExclude adaptingToBluetoothMethodOne]
            try {
              let controller = await session.getController();
              await controller.sendControlCommand({ command: 'play' });
              await controller.sendControlCommand({ command: 'pause' });
              await new Promise<void>(resolve => setTimeout(resolve, 2000));
            } catch (err) {
              if (globalLogUpdate) {
                globalLogUpdate(`Controller error: ${err.message}`, true);
              }
            }
            // 主动销毁已创建的session。
            session.destroy((err) => {
              if (err) {
                console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
              } else {
                console.info(`Destroy : SUCCESS `);
              }
            });
            // [EndExclude adaptingToBluetoothMethodOne]
          } catch (err) {
            if (err) {
              console.error(`AVSession create Error: Code: ${err.code}, message: ${err.message}`);
              // [StartExclude adaptingToBluetoothMethodOne]
              if (globalLogUpdate) {
                globalLogUpdate(`AVSession create Error: Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude adaptingToBluetoothMethodOne]
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End adaptingToBluetoothMethodOne]