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

// [Start displayTagsOfMediaAssets]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude displayTagsOfMediaAssets]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude displayTagsOfMediaAssets]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude displayTagsOfMediaAssets]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }
  // [EndExclude displayTagsOfMediaAssets]

  build() {
    Column() {
      // [StartExclude displayTagsOfMediaAssets]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude displayTagsOfMediaAssets]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);

          // 把媒体音源信息设置给AVSession。
          let metadata: AVSessionManager.AVMetadata = {
            assetId: '0',
            title: 'TITLE',
            mediaImage: 'IMAGE',
            // 标识该媒体音源是Audio Vivid。
            displayTags: AVSessionManager.DisplayTag.TAG_AUDIO_VIVID,
          };
          session.setAVMetadata(metadata).then(() => {
            console.info(`SetAVMetadata successfully`);
            // [StartExclude displayTagsOfMediaAssets]
            if (globalLogUpdate) {
              globalLogUpdate('SetAVMetadata successfully', false);
            }
            // [EndExclude displayTagsOfMediaAssets]
          }).catch((err: BusinessError) => {
            console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
            // [StartExclude displayTagsOfMediaAssets]
            if (globalLogUpdate) {
              globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
            }
            // [EndExclude displayTagsOfMediaAssets]
          });
          // [StartExclude displayTagsOfMediaAssets]
          // 主动销毁已创建的session。
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude displayTagsOfMediaAssets]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End displayTagsOfMediaAssets]