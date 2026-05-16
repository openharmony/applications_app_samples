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
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import testNapi from 'libentry.so';

let mode: audio.AudioLoopbackMode = audio.AudioLoopbackMode.HARDWARE;
let audioLoopback: audio.AudioLoopback | undefined = undefined;

async function requestMicrophonePermission(context: common.UIAbilityContext): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  let result: PermissionRequestResult = await atManager
    .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE']);
  return result.authResults[0] === 0;
}

@Entry
@Component
struct AudioLoopbackDebugInfoDemo {
  @State message: string = 'Ready';
  @State napiReturnLog: string = '暂无返回信息';

  updateNapiLog(msg: string) {
    const timestamp = new Date().toLocaleTimeString();
    this.napiReturnLog = `[${timestamp}]\n${msg}`;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          // 信息显示区域
          Column() {
            Text('实时状态信息')
              .fontSize(18)
              .fontWeight(600)
              .margin({ bottom: 12 })

            Column() {
              Text('当前状态')
                .fontSize(14)
                .fontWeight(600)
                .margin({ bottom: 8 })
              Text(this.message)
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
              Text('NAPI返回信息')
                .fontSize(14)
                .fontWeight(600)
                .margin({ bottom: 8 })
              Scroll() {
                Text(this.napiReturnLog)
                  .fontSize(12)
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
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 准备工作：创建返听器并启用
          Text('准备工作')
            .fontSize(16)
            .fontWeight(600)
            .width('90%')
            .margin({ top: 8, bottom: 8 })

          Button('创建音频低时延耳返实例')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(async () => {
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              let hasPermission = await requestMicrophonePermission(context);
              if (!hasPermission) {
                this.message = '麦克风权限未授权';
                this.updateNapiLog('错误: 麦克风权限未授权');
                return;
              }
              let isSupported = audio.getAudioManager().getStreamManager().isAudioLoopbackSupported(mode);
              if (isSupported) {
                audio.createAudioLoopback(mode).then((loopback) => {
                  audioLoopback = loopback;
                  this.message = '已创建实例';
                  this.updateNapiLog('Succeeded in creating audio loopback.');
                }).catch((err: BusinessError) => {
                  this.message = '创建实例失败';
                  this.updateNapiLog(`Failed: ${err.code}, ${err.message}`);
                });
              } else {
                this.message = '不支持返听';
                this.updateNapiLog('Audio loopback is unsupported.');
              }
            })

          Button('启用音频返听')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(async () => {
              if (audioLoopback === undefined) {
                this.message = '请先创建实例';
                this.updateNapiLog('Audio loopback not created.');
                return;
              }
              try {
                let status = await audioLoopback.getStatus();
                if (status == audio.AudioLoopbackStatus.AVAILABLE_IDLE) {
                  let success = await audioLoopback.enable(true);
                  if (success) {
                    this.message = '已启用返听';
                    this.updateNapiLog('Succeeded in enabling loopback.');
                  }
                } else {
                  this.message = `状态: ${status}`;
                  this.updateNapiLog(`Loopback status: ${status}`);
                }
              } catch (err) {
                this.message = '启用失败';
                this.updateNapiLog(`Failed: ${err.code}, ${err.message}`);
              }
            })

          // C API 验证
          Text('C API 验证')
            .fontSize(16)
            .fontWeight(600)
            .width('90%')
            .margin({ top: 8, bottom: 8 })

          Button('C API PrintLoopbackInfo (hilog)')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              if (audioLoopback === undefined) {
                this.message = '请先创建并启用返听';
                this.updateNapiLog('Audio loopback not created.');
                return;
              }
              try {
                let result = testNapi.VerifyLoopbackCApi(audioLoopback, -1);
                this.message = 'C API 验证完成';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = 'C API 验证失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('C API PrintLoopbackInfo (文件)')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              if (audioLoopback === undefined) {
                this.message = '请先创建并启用返听';
                this.updateNapiLog('Audio loopback not created.');
                return;
              }
              try {
                let filePath = getContext().filesDir + '/loopback_capi_debug.txt';
                let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                let result = testNapi.VerifyLoopbackCApi(audioLoopback, file.fd);
                fs.closeSync(file);
                this.message = 'C API 验证完成';
                this.updateNapiLog(result + '\n文件: ' + filePath);
              } catch (err) {
                this.message = 'C API 验证失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('C API PrintAppInfo')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.TestPrintAppInfo(-1);
                this.message = 'PrintAppInfo 完成';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = 'PrintAppInfo 失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
  }
}
