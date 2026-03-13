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

// [Start setAVMetadata]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude setAVMetadata]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude setAVMetadata]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude setAVMetadata]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }
  // [EndExclude setAVMetadata]

  build() {
    Column() {
      // [StartExclude setAVMetadata]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude setAVMetadata]
      Text(this.message)
        .onClick(async () => {
          try {
            let context = this.getUIContext().getHostContext() as Context;
            // 假设已经创建了一个session，如何创建session可以参考之前的案例。
            let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', 'audio');
            // 设置必要的媒体信息。
            let metadata: AVSessionManager.AVMetadata = {
              assetId: '0', // 由应用指定，用于标识应用媒体库里的媒体。
              title: 'TITLE',
              mediaImage: 'IMAGE',
              artist: 'ARTIST',
            };
            session.setAVMetadata(metadata).then(() => {
              console.info(`SetAVMetadata successfully`);
              // [StartExclude setAVMetadata]
              if (globalLogUpdate) {
                globalLogUpdate('SetAVMetadata successfully', false);
              }
              // 主动销毁已创建的session。
              session.destroy((err) => {
                if (err) {
                  console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
                } else {
                  console.info(`Destroy : SUCCESS `);
                }
              });
              // [EndExclude setAVMetadata]
            }).catch((err: BusinessError) => {
              console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
              // [StartExclude setAVMetadata]
              if (globalLogUpdate) {
                globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude setAVMetadata]
            });
          } catch (err) {
            if (err) {
              console.error(`AVSession create Error: Code: ${err.code}, message: ${err.message}`);
              // [StartExclude setAVMetadata]
              if (globalLogUpdate) {
                globalLogUpdate(`AVSession create Error: Code: ${err.code}, message: ${err.message}`, true);
              }
              // [EndExclude setAVMetadata]
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End setAVMetadata]