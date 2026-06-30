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
// [Start all_audioLoopbackDebugInfo]
// [Start get_DebugManager]
import { audio } from '@kit.AudioKit'; // 导入audio模块。
// [Start print_LoopbackInfo]
import { BusinessError } from '@kit.BasicServicesKit'; // 导入BusinessError。
// [StartExclude get_DebugManager]
// [StartExclude print_LoopbackInfo]
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit'; // 导入UIAbilityContext。
import { fileIo as fs } from '@kit.CoreFileKit'; // 导入文件管理模块。

const TAG = 'AudioLoopbackDebugInfoDemo';
// [EndExclude print_LoopbackInfo]
let mode: audio.AudioLoopbackMode = audio.AudioLoopbackMode.HARDWARE;
let audioLoopback: audio.AudioLoopback | undefined = undefined;
// [StartExclude get_DebugManager]

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager
    .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  return result.authResults[0] === 0;
}
// [EndExclude all_audioLoopbackDebugInfo]

// 查询能力，创建返听器实例。
function init(updateCallback?: (msg: string, isError: boolean) => void): void {
// [EndExclude get_DebugManager]
  let isSupported = audio.getAudioManager().getStreamManager().isAudioLoopbackSupported(mode);
  if (isSupported) {
    audio.createAudioLoopback(mode).then((loopback) => {
      console.info('Succeeded in creating audio loopback.');
      // [StartExclude get_DebugManager]
      // [StartExclude all_audioLoopbackDebugInfo]
      const successMsg = 'Succeeded in creating audio loopback.';
      if (updateCallback) {
        updateCallback(successMsg, false);
      }
      // [EndExclude all_audioLoopbackDebugInfo]
      // [EndExclude get_DebugManager]
      audioLoopback = loopback;
    }).catch((err: BusinessError) => {
      console.error(`Failed to create audio loopback. Code: ${err.code}, message: ${err.message}`);
      // [StartExclude get_DebugManager]
      // [StartExclude all_audioLoopbackDebugInfo]
      const errorMsg = `Failed to create audio loopback. Code: ${err.code}, message: ${err.message}`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude all_audioLoopbackDebugInfo]
      // [EndExclude get_DebugManager]
    });
  } else {
    console.error('Audio loopback is unsupported.');
    // [StartExclude all_audioLoopbackDebugInfo]
    // [StartExclude get_DebugManager]
    const errorMsg = 'Audio loopback is unsupported.';
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude get_DebugManager]
    // [EndExclude all_audioLoopbackDebugInfo]
  }
}
// [End get_DebugManager]

// [StartExclude all_audioLoopbackDebugInfo]
// 启用返听。
async function enable(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  if (audioLoopback !== undefined) {
    try {
      let status = await audioLoopback.getStatus();
      if (status == audio.AudioLoopbackStatus.AVAILABLE_IDLE) {
        let isSuccess = await audioLoopback.enable(true);
        if (isSuccess) {
          console.info('Succeeded in using enable function.');
          const successMsg = 'Succeeded in using enable function.';
          if (updateCallback) {
            updateCallback(successMsg, false);
          }
        } else {
          status = await audioLoopback.getStatus();
        }
      }
    } catch (err) {
      console.error(`Failed to use enable function. code: ${err.code}, message: ${err.message}`);
      const errorMsg = `Failed to use enable function. code: ${err.code}, message: ${err.message}`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
    }
  } else {
    console.error('Audio loopback not created.');
    const errorMsg = `Audio loopback not created.`;
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
  }
}
// [EndExclude all_audioLoopbackDebugInfo]

// 查询返听器调试信息。
function printLoopbackInfo(updateCallback?: (msg: string, isError: boolean) => void): void {
// [EndExclude print_LoopbackInfo]
  if (audioLoopback === undefined) {
    console.error('Audio loopback not created.');
    // [StartExclude print_LoopbackInfo]
    const errorMsg = 'Audio loopback not created.';
    if (updateCallback) {
      updateCallback(errorMsg, true);
    }
    // [EndExclude print_LoopbackInfo]
    return;
  }
  // [StartExclude print_LoopbackInfo]
  let debugManager = audio.getAudioManager().getDebuggingManager();
  // [EndExclude print_LoopbackInfo]
  // 输出到hilog日志。
  debugManager.printLoopbackInfo(audioLoopback, -1);

  // 输出到文件。
  let filePath = getContext().filesDir + '/audio_loopback_debug.txt';
  let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  debugManager.printLoopbackInfo(audioLoopback, file.fd);
  fs.closeSync(file);
  // [StartExclude print_LoopbackInfo]
  const successMsg = `Loopback debug info written to: ${filePath}`;
  if (updateCallback) {
    updateCallback(successMsg, false);
  }
  // [EndExclude print_LoopbackInfo]
}
// [End print_LoopbackInfo]

// [StartExclude all_audioLoopbackDebugInfo]
@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build(): void {
    Scroll() {
      Column() {
        Column() {
          Text('返听器调试信息查询 Demo')
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text('当前状态')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
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

          Column() {
            Text('日志信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.logMessages)
              .fontSize(13)
              .fontColor('#52C41A')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
              .maxLines(5)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
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

        Row() {
          Column() {
            Text('创建音频低时延耳返实例')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ right: 12, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let hasPermission = await requestMicrophonePermission(context);
            if (!hasPermission) {
              this.updateLogInfo('麦克风权限未授权', true);
              this.currentState = '权限未授权';
              return;
            }
            init((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已创建实例';
          });

          Column() {
            Text('启用音频返听')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async (): Promise<void> => {
            await enable((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已启用返听';
          });
        }

        Row() {
          Column() {
            Text('查询返听器调试信息')
              .fontColor(Color.Black)
              .fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .margin({ bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick((): void => {
            printLoopbackInfo((msg, isError) => this.updateLogInfo(msg, isError));
          });
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}
// [EndExclude all_audioLoopbackDebugInfo]
// [End all_audioLoopbackDebugInfo]
