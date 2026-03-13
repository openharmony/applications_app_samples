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

// [Start createAVSession]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
// [StartExclude createAVSession]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude createAVSession]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude createAVSession]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }
  // [EndExclude createAVSession]

  build() {
    Column() {
      // [StartExclude createAVSession]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude createAVSession]
      Text(this.message)
        .onClick(async () => {
          // 开始创建并激活媒体会话。
          // 创建session。
          let context = this.getUIContext().getHostContext() as Context;
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          // 激活接口要在元数据、控制命令注册完成之后再执行。
          await session.activate();
          console.info(`session create done : sessionId : ${session.sessionId}`);
          // [StartExclude createAVSession]
          if (globalLogUpdate) {
            globalLogUpdate(`session create done : sessionId : ${session.sessionId}`, true);
          }
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude createAVSession]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End createAVSession]