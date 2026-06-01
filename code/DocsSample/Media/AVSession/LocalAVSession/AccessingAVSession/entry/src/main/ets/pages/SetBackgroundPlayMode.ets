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

// [Start setBackgroundPlayMode]
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude setBackgroundPlayMode]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude setBackgroundPlayMode]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude setBackgroundPlayMode]
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
  // [EndExclude setBackgroundPlayMode]

  build() {
    Column() {
      // [StartExclude setBackgroundPlayMode]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude setBackgroundPlayMode]
      Text(this.message)
        .onClick(async () => {
          let currentAVSession: avSession.AVSession | undefined = undefined;
          let tag = 'createNewSession';
          let context: Context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          avSession.createAVSession(context, tag, 'audio', (err: BusinessError, data: avSession.AVSession) => {
            if (err) {
              console.error(`CreateAVSession BusinessError: code: ${err.code}, message: ${err.message}`);
            } else {
              currentAVSession = data;
            }
          });

          //设置后台播放模式
          if (currentAVSession !== undefined) {
            try {
              (currentAVSession as avSession.AVSession)
                .setBackgroundPlayMode(avSession.BackgroundPlayMode.ENABLE_BACKGROUND_PLAY);
              // [StartExclude setBackgroundPlayMode]
              if (globalLogUpdate) {
                globalLogUpdate('set BackgroundPlayMode successfully', false);
              }
              // [EndExclude setBackgroundPlayMode]
            } catch (err) {
              console.error(`setBackgroundPlayMode BusinessError: code: ${err.code}, message: ${err.message}`);
              // [StartExclude setBackgroundPlayMode]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set BackgroundPlayMode. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude setBackgroundPlayMode]
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End setBackgroundPlayMode]