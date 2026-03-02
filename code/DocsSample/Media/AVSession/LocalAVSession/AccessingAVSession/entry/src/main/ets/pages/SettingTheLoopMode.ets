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

// [Start settingTheLoopMode]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude settingTheLoopMode]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude settingTheLoopMode]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude settingTheLoopMode]
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
  // [EndExclude settingTheLoopMode]

  build() {
    Column() {
      // [StartExclude settingTheLoopMode]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude settingTheLoopMode]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          // [StartExclude settingTheLoopMode]
          await session.activate();
          // [EndExclude settingTheLoopMode]

          // 应用启动时/内部切换循环模式，需要把应用内的当前的循环模式设置给AVSession。
          let playBackState: AVSessionManager.AVPlaybackState = {
            loopMode: AVSessionManager.LoopMode.LOOP_MODE_SINGLE,
          };
          session.setAVPlaybackState(playBackState).then(() => {
            console.info(`set AVPlaybackState successfully`);
            // [StartExclude settingTheLoopMode]
            if (globalLogUpdate) {
              globalLogUpdate('set AVPlaybackState successfully', false);
            }
            // [EndExclude settingTheLoopMode]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
            // [StartExclude settingTheLoopMode]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`, true);
            }
            // [EndExclude settingTheLoopMode]
          });

          // 应用注册循环模式的控制监听。
          session.on('setLoopMode', (mode) => {
            console.info(`on setLoopMode ${mode}`);
            // [StartExclude settingTheLoopMode]
            if (globalLogUpdate) {
              globalLogUpdate(`on setLoopMode ${mode}`, false);
            }
            // [EndExclude settingTheLoopMode]
            // 应用收到设置循环模式的指令后，应用自定下一个模式，切换完毕后通过AVPlaybackState上报切换后的LoopMode。
            let playBackState: AVSessionManager.AVPlaybackState = {
              loopMode: AVSessionManager.LoopMode.LOOP_MODE_SINGLE,
            };
            session.setAVPlaybackState(playBackState).then(() => {
              console.info(`set AVPlaybackState successfully`);
              // [StartExclude settingTheLoopMode]
              if (globalLogUpdate) {
                globalLogUpdate('set AVPlaybackState successfully in setLoopMode', false);
              }
              // [EndExclude settingTheLoopMode]
            }).catch((err: BusinessError) => {
              console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
              // [StartExclude settingTheLoopMode]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set AVPlaybackState in setLoopMode. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude settingTheLoopMode]
            });
          });
          // [StartExclude settingTheLoopMode]
          try {
            let controller = await session.getController();
            await controller.sendControlCommand({ command: 'setLoopMode', parameter: AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE });
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
          // [EndExclude settingTheLoopMode]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End settingTheLoopMode]