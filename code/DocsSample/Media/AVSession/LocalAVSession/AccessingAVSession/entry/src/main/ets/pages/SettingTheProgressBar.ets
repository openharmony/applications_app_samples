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

// [Start settingTheProgressBar]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude settingTheProgressBar]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude settingTheProgressBar]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude settingTheProgressBar]
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
  // [EndExclude settingTheProgressBar]

  build() {
    Column() {
      // [StartExclude settingTheProgressBar]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude settingTheProgressBar]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);

          // 设置媒体资源时长。
          let metadata: AVSessionManager.AVMetadata = {
            assetId: '0',
            title: 'TITLE',
            mediaImage: 'IMAGE',
            duration: 23000, // 资源的时长，以ms为单位。
          };
          session.setAVMetadata(metadata).then(() => {
            console.info(`SetAVMetadata successfully`);
            // [StartExclude settingTheProgressBar]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVMetadata successfully', false);
            }
            // [EndExclude settingTheProgressBar]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
            // [StartExclude settingTheProgressBar]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
            }
            // [EndExclude settingTheProgressBar]
          });

          // 设置状态： 播放状态，进度位置，播放倍速，缓存的时间。
          let playbackState: AVSessionManager.AVPlaybackState = {
            state: AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY, // 播放状态。
            position: {
              elapsedTime: 1000, // 已经播放的位置，以ms为单位。
              updateTime: new Date().getTime(), // 应用更新当前位置时的时间戳，以ms为单位。
            },
            speed: 1.0, // 可选，默认是1.0，播放的倍速，按照应用内支持的speed进行设置，系统不做校验。
            bufferedTime: 14000, // 可选，资源缓存的时间，以ms为单位。
          };
          session.setAVPlaybackState(playbackState, (err) => {
            if (err) {
              console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
              // [StartExclude settingTheProgressBar]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude settingTheProgressBar]
            } else {
              console.info(`SetAVPlaybackState successfully`);
              // [StartExclude settingTheProgressBar]
              if (globalLogUpdate) {
                globalLogUpdate('SetAVPlaybackState successfully', false);
              }
              // [EndExclude settingTheProgressBar]
            }
          });
          // [StartExclude settingTheProgressBar]
          // 主动销毁已创建的session。
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude settingTheProgressBar]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End settingTheProgressBar]