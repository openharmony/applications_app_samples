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

// [Start setAVSessionInformation]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude setAVSessionInformation]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude setAVSessionInformation]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude setAVSessionInformation]
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
  // [EndExclude setAVSessionInformation]

  build() {
    Column() {
      // [StartExclude setAVSessionInformation]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude setAVSessionInformation]
      Text(this.message)
        .onClick(async () => {
          console.info(`DesktopLyric set start`);
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', 'audio');

          // 系统是否支持歌词组件
          let isDesktopLyricSupported: boolean = false;
          try {
            isDesktopLyricSupported = await AVSessionManager.isDesktopLyricSupported();
          } catch (err) {
            console.error(`Failed to get isDesktopLyricSupported. Code: ${err.code}, message: ${err.message}`);
          }
          if (!isDesktopLyricSupported) {
            return;
          }

          try {
            // 使能歌词组件
            await session.enableDesktopLyric(true);
          } catch (err) {
            console.error(`enableDesktopLyric err. Code: ${err.code}, message: ${err.message}`);
          }

          try {
            // 监听歌词组件是否显示
            session.onDesktopLyricVisibilityChanged((isVisible: boolean) => {
              console.info(`onDesktopLyricVisibilityChanged changed: ${isVisible}`)
            });
          } catch (err) {
            console.error(`onDesktopLyricVisibilityChanged err. Code: ${err.code}, message: ${err.message}`);
          }

          try {
            // 监听歌词组件锁定状态
            session.onDesktopLyricStateChanged((state) => {
              console.info(`onDesktopLyricStateChanged changed: ${state.isLocked}`)
            });
          } catch (err) {
            console.error(`onDesktopLyricStateChanged err. Code: ${err.code}, message: ${err.message}`);
          }

          try {
            // 显示或隐藏歌词组件，歌词组件使能后默认隐藏
            await session.setDesktopLyricVisible(true);
          } catch (err) {
            console.error(`setDesktopLyricVisible err. Code: ${err.code}, message: ${err.message}`);
          }

          try {
            // 锁定或解锁歌词组件，歌词组件使能后默认是解锁状态
            await session.setDesktopLyricState({isLocked: true});
          } catch (err) {
            console.error(`setDesktopLyricState err. Code: ${err.code}, message: ${err.message}`);
          }

          console.info(`DesktopLyric set done`);
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End setAVSessionInformation]