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

// [Start setAVSessionInformation]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude setAVSessionInformation]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude setAVSessionInformation]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude setAVSessionInformation]
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
  // [EndExclude setAVSessionInformation]

  build() {
    Column() {
      // [StartExclude setAVSessionInformation]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude setAVSessionInformation]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', 'audio');
          // 播放器逻辑··· 引发媒体信息与播放状态的变更。
          // 设置必要的媒体信息。
          let metadata: AVSessionManager.AVMetadata = {
            assetId: '0', // 由应用指定，用于标识应用媒体库里的媒体。
            title: 'TITLE',
            mediaImage: 'IMAGE',
            artist: 'ARTIST'
          };
          session.setAVMetadata(metadata).then(() => {
            console.info(`SetAVMetadata successfully`);
            // [StartExclude setAVSessionInformation]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVMetadata successfully', false);
            }
            // [EndExclude setAVSessionInformation]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
            // [StartExclude setAVSessionInformation]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
            }
            // [EndExclude setAVSessionInformation]
          });
          // 简单设置一个播放状态 - 暂停 未收藏。
          let playbackState: AVSessionManager.AVPlaybackState = {
            state: AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE,
            isFavorite: false
          };
          session.setAVPlaybackState(playbackState, (err) => {
            if (err) {
              console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
              // [StartExclude setAVSessionInformation]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude setAVSessionInformation]
            } else {
              console.info(`SetAVPlaybackState successfully`);
              // [StartExclude setAVSessionInformation]
              if (globalLogUpdate) {
                globalLogUpdate('SetAVPlaybackState successfully', false);
              }
              // [EndExclude setAVSessionInformation]
            }
          });
          // 设置一个播放列表。
          let queueItemDescription1: AVSessionManager.AVMediaDescription = {
            assetId: '001',
            title: 'music_name',
            subtitle: 'music_sub_name',
            description: 'music_description',
            mediaImage: 'PIXELMAP_OBJECT',
            extras: { 'extras': 'any' }
          };
          let queueItem1: AVSessionManager.AVQueueItem = {
            itemId: 1,
            description: queueItemDescription1
          };
          let queueItemDescription2: AVSessionManager.AVMediaDescription = {
            assetId: '002',
            title: 'music_name',
            subtitle: 'music_sub_name',
            description: 'music_description',
            mediaImage: 'PIXELMAP_OBJECT',
            extras: { 'extras': 'any' }
          };
          let queueItem2: AVSessionManager.AVQueueItem = {
            itemId: 2,
            description: queueItemDescription2
          };
          let queueItemsArray = [queueItem1, queueItem2];
          session.setAVQueueItems(queueItemsArray).then(() => {
            console.info(`SetAVQueueItems successfully`);
            // [StartExclude setAVSessionInformation]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVQueueItems successfully', false);
            }
            // [EndExclude setAVSessionInformation]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVQueueItem, error code: ${err.code}, error message: ${err.message}`);
            // [StartExclude setAVSessionInformation]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVQueueItem, error code: ${err.code}, error message: ${err.message}`, true);
            }
            // [EndExclude setAVSessionInformation]
          });
          // 设置媒体播放列表名称。
          let queueTitle = 'QUEUE_TITLE';
          session.setAVQueueTitle(queueTitle).then(() => {
            console.info(`SetAVQueueTitle successfully`);
            // [StartExclude setAVSessionInformation]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVQueueTitle successfully', false);
            }
            // [EndExclude setAVSessionInformation]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVQueueTitle, error code: ${err.code}, error message: ${err.message}`);
            // [StartExclude setAVSessionInformation]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVQueueTitle, error code: ${err.code}, error message: ${err.message}`, true);
            }
            // [EndExclude setAVSessionInformation]
          });
          // [StartExclude setAVSessionInformation]
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude setAVSessionInformation]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End setAVSessionInformation]