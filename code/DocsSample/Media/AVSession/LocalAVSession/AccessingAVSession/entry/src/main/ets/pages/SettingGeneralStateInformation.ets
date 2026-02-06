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

// [Start settingGeneralStateInformation]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude settingGeneralStateInformation]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude settingGeneralStateInformation]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude settingGeneralStateInformation]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }
  // [EndExclude settingGeneralStateInformation]

  build() {
    Column() {
      // [StartExclude settingGeneralStateInformation]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude settingGeneralStateInformation]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', 'audio');

          // 播放器逻辑··· 引发媒体信息与播放状态的变更。
          // 简单设置一个播放状态 - 暂停 未收藏。
          let playbackState: AVSessionManager.AVPlaybackState = {
            state: AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE,
            isFavorite: false
          };
          session.setAVPlaybackState(playbackState, (err: BusinessError) => {
            if (err) {
              console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
              // [StartExclude settingGeneralStateInformation]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude settingGeneralStateInformation]
            } else {
              console.info(`SetAVPlaybackState successfully`);
              // [StartExclude settingGeneralStateInformation]
              if (globalLogUpdate) {
                globalLogUpdate('SetAVPlaybackState successfully', false);
              }
              // [EndExclude settingGeneralStateInformation]
            }
          });
          // [StartExclude settingGeneralStateInformation]
          // 主动销毁已创建的session。
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude settingGeneralStateInformation]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End settingGeneralStateInformation]