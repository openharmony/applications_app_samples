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

// [Start performingProgressControl]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
// [StartExclude performingProgressControl]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude performingProgressControl]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude performingProgressControl]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    const newLog = `[${timestamp}] ${prefix} ${msg}`;
    const lines = this.logMessages ? this.logMessages.split('\n') : [];
    lines.push(newLog);
    if (lines.length > 6) {
      lines.shift();
    }
    this.logMessages = lines.join('\n');
  }
  // [EndExclude performingProgressControl]

  build() {
    Column() {
      // [StartExclude performingProgressControl]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude performingProgressControl]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          // [StartExclude performingProgressControl]
          // 先激活session
          await session.activate();
          // [EndExclude performingProgressControl]

          session.on('seek', (position: number) => {
            console.info(`on seek , the time is ${JSON.stringify(position)}`);
            // [StartExclude performingProgressControl]
            if (globalLogUpdate) {
              globalLogUpdate(`on seek , the time is ${JSON.stringify(position)}`, false);
            }
            // [EndExclude performingProgressControl]

            // 由于应用内seek可能会触发较长的缓冲等待，可以先把状态设置为 Buffering。
            let playbackState: AVSessionManager.AVPlaybackState = {
              state: AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING, // Buffering state.
            };
            session.setAVPlaybackState(playbackState, (err) => {
              if (err) {
                console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
                // [StartExclude performingProgressControl]
                if (globalLogUpdate) {
                  globalLogUpdate(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`, true);
                }
                // [EndExclude performingProgressControl]
              } else {
                console.info(`SetAVPlaybackState successfully`);
                // [StartExclude performingProgressControl]
                if (globalLogUpdate) {
                  globalLogUpdate('SetAVPlaybackState successfully', false);
                }
                // [EndExclude performingProgressControl]
              }
            });

            // 应用响应seek命令，使用应用内播放器完成seek实现。

            // 应用内更新新的位置后，也需要同步更新状态给系统。
            playbackState.state = AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY; // 播放状态。
            playbackState.position = {
              elapsedTime: position, // 已经播放的位置，以ms为单位。
              updateTime: new Date().getTime(), // 应用更新当前位置的时间戳，以ms为单位。
            }
            session.setAVPlaybackState(playbackState, (err) => {
              if (err) {
                console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
                // [StartExclude performingProgressControl]
                if (globalLogUpdate) {
                  globalLogUpdate(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`, true);
                }
                // [EndExclude performingProgressControl]
              } else {
                console.info(`SetAVPlaybackState successfully`);
                // [StartExclude performingProgressControl]
                if (globalLogUpdate) {
                  globalLogUpdate('SetAVPlaybackState successfully', false);
                }
                // [EndExclude performingProgressControl]
              }
            });
          });

          // [StartExclude performingProgressControl]
          try {
            let controller = await session.getController();
            await new Promise<void>(resolve => setTimeout(resolve, 2000));
            let seekCommand: AVSessionManager.AVControlCommand = {
              command: 'seek',
              parameter: 5000 // 跳转到5秒位置
            };
            await controller.sendControlCommand(seekCommand);
            await new Promise<void>(resolve => setTimeout(resolve, 2000));
            session.destroy((err) => {
              if (err) {
                console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
              } else {
                console.info(`Destroy : SUCCESS `);
              }
            });
          } catch (err) {
            console.error(`Failed to get controller or send command. Code: ${err.code}, message: ${err.message}`);
          }
          // [EndExclude performingProgressControl]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End performingProgressControl]