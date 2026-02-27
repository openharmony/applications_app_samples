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

// [Start settingPlaylistInformation]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude settingPlaylistInformation]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude settingPlaylistInformation]

let context: Context = getContext(this);
// [StartExclude settingPlaylistInformation]
let componentInstance: Index | null = null;
// [EndExclude settingPlaylistInformation]
async function setListener() {
  // 假设已经创建了一个session，如何创建session可以参考之前的案例
  let type: AVSessionManager.AVSessionType = 'audio';
  let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
  // 将歌单信息设置给AVSession
  let metadata: AVSessionManager.AVMetadata = {
    // 下面内容均由应用设置
    assetId: 'musicid123',
    avQueueName: 'myQueue',
    avQueueId: 'myQueue123',
    avQueueImage: 'PIXELMAP_OBJECT',
  };
  session.setAVMetadata(metadata).then(() => {
    console.info(`SetAVMetadata successfully`);
    // [StartExclude settingPlaylistInformation]
    if (globalLogUpdate) {
      globalLogUpdate('SetAVMetadata successfully', false);
    }
    // [EndExclude settingPlaylistInformation]
  }).catch((err: BusinessError) => {
    console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
    // [StartExclude settingPlaylistInformation]
    if (globalLogUpdate) {
      globalLogUpdate(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`, true);
    }
    // [EndExclude settingPlaylistInformation]
  });
  // 上报播放状态，参考播放状态
  // [StartExclude settingPlaylistInformation]
  // 主动销毁已创建的session。
  session.destroy((err) => {
    if (err) {
      console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
    } else {
      console.info(`Destroy : SUCCESS `);
    }
  });
  // [EndExclude settingPlaylistInformation]
}
// [StartExclude settingPlaylistInformation]
@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  @State logMessages: string = '';
  aboutToAppear(): void {
    componentInstance = this;
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }
  build() {
    Column() {
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      Text(this.message)
        .onClick(() => {
          setListener();
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [EndExclude settingPlaylistInformation]
// [End settingPlaylistInformation]