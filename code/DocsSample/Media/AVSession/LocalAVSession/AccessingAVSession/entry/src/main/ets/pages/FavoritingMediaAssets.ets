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

// [Start toggleFavorite_mediaAssets]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude toggleFavorite_mediaAssets]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude toggleFavorite_mediaAssets]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude toggleFavorite_mediaAssets]
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
  // [EndExclude toggleFavorite_mediaAssets]

  build() {
    Column() {
      // [StartExclude toggleFavorite_mediaAssets]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude toggleFavorite_mediaAssets]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          // [StartExclude toggleFavorite_mediaAssets]
          await session.activate();
          // [EndExclude toggleFavorite_mediaAssets]
          session.on('toggleFavorite', (assetId) => {
            console.info(`on toggleFavorite `);
            // [StartExclude toggleFavorite_mediaAssets]
            if (globalLogUpdate) {
              globalLogUpdate('on toggleFavorite', false);
            }
            // [EndExclude toggleFavorite_mediaAssets]
            // 应用收到收藏命令，进行收藏处理。

            // 应用内完成或者取消收藏，把新的收藏状态设置给AVSession。
            let playbackState: AVSessionManager.AVPlaybackState = {
              isFavorite: true,
            };
            session.setAVPlaybackState(playbackState).then(() => {
              console.info(`SetAVPlaybackState successfully`);
              // [StartExclude toggleFavorite_mediaAssets]
              if (globalLogUpdate) {
                globalLogUpdate('SetAVPlaybackState successfully', false);
              }
              // [EndExclude toggleFavorite_mediaAssets]
            }).catch((err: BusinessError) => {
              console.error(`SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
              // [StartExclude toggleFavorite_mediaAssets]
              if (globalLogUpdate) {
                globalLogUpdate(`SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude toggleFavorite_mediaAssets]
            });
          });
          // [StartExclude toggleFavorite_mediaAssets]
          try {
            let controller = await session.getController();
            await controller.sendControlCommand({ command: 'toggleFavorite', parameter: '12345' });
            await new Promise<void>(resolve => setTimeout(resolve, 2000));
          } catch (err) {
            if (globalLogUpdate) {
              globalLogUpdate(`Controller error: ${err.message}`, true);
            }
          }
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude toggleFavorite_mediaAssets]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End toggleFavorite_mediaAssets]