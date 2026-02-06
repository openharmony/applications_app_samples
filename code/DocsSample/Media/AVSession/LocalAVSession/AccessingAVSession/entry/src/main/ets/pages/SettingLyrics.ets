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

// [Start settingLyrics]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude settingLyrics]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude settingLyrics]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude settingLyrics]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }
  // [EndExclude settingLyrics]

  build() {
    Column() {
      // [StartExclude settingLyrics]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude settingLyrics]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);

          // 把歌词信息设置给AVSession。
          let metadata: AVSessionManager.AVMetadata = {
            assetId: '0',
            title: 'TITLE',
            mediaImage: 'IMAGE',
            // LRC中有两类元素：一种是时间标签+歌词，一种是ID标签。
            // 例如：[00:25.44]xxx\r\n[00:26.44]xxx\r\n。
            lyric: 'lrc格式歌词内容',
            // singleLyricText字段存储单条歌词文本，不包含时间戳。
            // 例如："单条歌词内容"。
            singleLyricText: '单条歌词内容',
          };
          session.setAVMetadata(metadata).then(() => {
            console.info(`SetAVMetadata successfully`);
            // [StartExclude settingLyrics]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVMetadata successfully', false);
            }
            // [EndExclude settingLyrics]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
            // [StartExclude settingLyrics]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
            }
            // [EndExclude settingLyrics]
          });
          // [StartExclude settingLyrics]
          // 主动销毁已创建的session。
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude settingLyrics]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End settingLyrics]