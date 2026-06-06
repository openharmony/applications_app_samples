/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

import testNapi from 'libentry.so';
import fs from '@ohos.file.fs';
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  try {
    let result: PermissionRequestResult = await atManager
      .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
    return result.authResults[0] === 0;
  } catch (err) {
    console.error(`request microphone permission failed: ${JSON.stringify(err)}`);
    return false;
  }
}

// 激活音频会话Native实现
async function active() {
  console.info('active audio session success.');
  console.error('testNapi value: ' + testNapi);
  let result = testNapi.AudioSessionActive();
  console.info('active audio session result: ' + result);
  return result || '激活音频会话完成';
}

async function deactive() {
  let result = testNapi.AudioSessionDeactive();
  console.info('deactive audio session result: ' + result);
  return result || '停用音频会话完成';
}

async function setAudioSessionBehavior() {
  let result = testNapi.SetAudioSessionBehavior();
  console.info('set audio session behavior result: ' + result);
  return '设置音频会话行为和激活音频会话完成';
}

async function setAudioSessionCapturerMuteHint(): Promise<string> {
  let result: string = testNapi.SetAudioSessionCapturerMuteHint();
  console.info('set audio session capturer mute hint result: ' + result);
  return result || '上报会话级录音流静音提示完成，接口不实际触发静音';
}

async function printAudioSessionInfo() {
  let filePath = getContext().filesDir + '/audio_session_info.txt';
  let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.APPEND);
  let fd = file.fd;
  let result = testNapi.printAudioSessionInfo(fd);
  fs.closeSync(file);
  console.info('print audio session info filePath: ' + filePath);
  return 'Print audioSession info success.';
}

@Entry
@Component
struct Index {
  @State private runningResult: string = '暂无操作日志';
  @State private logMessages: string = '暂无log';

  build() {
    Scroll() {
      Column() {
        // 信息显示区域
        Column() {
          Text('操作日志')
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          // 当前状态
          Column() {
            Text('当前状态')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.runningResult)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // 日志信息
          Column() {
            Text('返回信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(14)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 20 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 功能按钮
        Row() {
          Button() {
            Text('设置场景+启用静音建议+激活焦点+注册监听').fontSize(10).fontColor(Color.White).fontSize(18)
          }
          .width('80%')
          .height(40)
          .onClick(async () => {
            try {
              let result = await active();
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '激活成功';
              this.logMessages = `[${timestamp}] ${result}`;
            } catch (err) {
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '激活失败';
              this.logMessages = `[${timestamp}] 错误: ${err}`;
            };
          })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })

        Row() {
          Button() {
            Text('设置场景+设置音频会话行为+激活焦点').fontSize(10).fontColor(Color.White).fontSize(18)
          }
          .width('80%')
          .height(40)
          .onClick(async () => {
            try {
              let result = await setAudioSessionBehavior();
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '激活成功';
              this.logMessages = `[${timestamp}] ${result}`;
            } catch (err) {
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '激活失败';
              this.logMessages = `[${timestamp}] 错误: ${err}`;
            };
          })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })

        Row() {
          Button() {
            Text('设置会话级录音流静音提示').fontSize(10).fontColor(Color.White).fontSize(18)
          }
          .width('80%')
          .height(40)
          .onClick(async () => {
            try {
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              let hasPermission = await requestMicrophonePermission(context);
              const timestamp = new Date().toLocaleTimeString();
              if (!hasPermission) {
                this.runningResult = '设置失败';
                this.logMessages = `[${timestamp}] 错误: 麦克风权限未授权，无法启动录音流`;
                return;
              }
              let result: string = await setAudioSessionCapturerMuteHint();
              this.runningResult = '设置完成';
              this.logMessages = `[${timestamp}] ${result}`;
            } catch (err) {
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '设置失败';
              this.logMessages = `[${timestamp}] 错误: ${err}`;
            };
          })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })

        Row() {
          Button() {
            Text('注销焦点+注销监听').fontSize(10).fontColor(Color.White).fontSize(18)
          }
          .width('80%')
          .height(40)
          .onClick(async () => {
            try {
              let result = await deactive();
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '停用成功';
              this.logMessages = `[${timestamp}] ${result}`;
            } catch (err) {
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '停用失败';
              this.logMessages = `[${timestamp}] 错误: ${err}`;
            };
          })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })

        Row() {
          Button() {
            Text('打印音频会话调试信息').fontSize(10).fontColor(Color.White).fontSize(18)
          }
          .width('80%')
          .height(40)
          .onClick(async (): Promise<void> => {
            try {
              let result = await printAudioSessionInfo();
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '打印成功';
              this.logMessages = `[${timestamp}] ${result}`;
            } catch (err) {
              const timestamp = new Date().toLocaleTimeString();
              this.runningResult = '打印失败';
              this.logMessages = `[${timestamp}] 错误: ${err}`;
            };
          })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}
