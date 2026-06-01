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

@Entry
@Component
struct AudioCaptureDemo {
  @State message: string = 'Ready';
  @State napiReturnLog: string = '暂无返回信息'; // NAPI返回值日志

  // 更新NAPI返回信息
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

            // 当前状态
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

            // NAPI返回信息
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

          // AudioCapture.cpp 接口
          Text('音频录制（使用ReadDataCallback写入数据）')
            .fontSize(16)
            .fontWeight(600)
            .width('90%')
            .margin({ top: 8, bottom: 8 })

          Button('创建录制音频流')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.CreateAudioCapturer();
                this.message = '创建录制音频流成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建录制音频流失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('设置录音流静音提示')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                let hasPermission = await requestMicrophonePermission(context);
                if (!hasPermission) {
                  this.message = '麦克风权限未授权';
                  this.updateNapiLog('错误: 麦克风权限未授权，无法启动录制流');
                  return;
                }
                let result: string = testNapi.SetAudioCapturerMuteHint();
                this.message = '上报录音流静音提示完成';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '设置录音流静音提示失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // CaptureCallback.cpp 接口
          Text('音频录制（使用Callbacks写入数据）')
            .fontSize(16)
            .fontWeight(600)
            .width('90%')
            .margin({ top: 8, bottom: 8 })

          Button('创建录制流（使用空指针初始化）')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.CreateAudioCapturerLegacy1();
                this.message = '创建录制流成功（使用空指针初始化）';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建录制流失败（使用空指针初始化）';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('创建录制流（使用清零结构体初始化）')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.CreateAudioCapturerLegacy2();
                this.message = '创建录制流成功（使用清零结构体初始化）';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建录制流失败（使用清零结构体初始化）';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // CaptureLoopback.cpp 接口
          Text('音频录制（耳返）')
            .fontSize(16)
            .fontWeight(600)
            .width('90%')
            .margin({ top: 8, bottom: 8 })

          Button('创建耳返录制流')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.CreateAudioCapturerLoopback();
                this.message = '创建耳返录制流成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建耳返录制流失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('创建采集回环音效的录制流')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.CreateAudioCapturerLoopbackEffect();
                this.message = result.includes('成功') ? '创建采集回环音效的录制流成功' : '创建采集回环音效的录制流失败';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建采集回环音效的录制流失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // RendererLoopback.cpp 接口
          Text('音频播放（耳返）')
            .fontSize(16)
            .fontWeight(600)
            .width('90%')
            .margin({ top: 8, bottom: 8 })

          Button('创建耳返播放流')
            .width('90%')
            .height(48)
            .margin({ bottom: 12 })
            .onClick(() => {
              try {
                let result = testNapi.CreateAudioRendererLoopback();
                this.message = '创建耳返播放流成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建耳返播放流失败';
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
