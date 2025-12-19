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
// [Start create_AudioVolumeGroupManager]
import { audio } from '@kit.AudioKit';

let audioVolumeGroupManager: audio.AudioVolumeGroupManager;
// 创建audioVolumeGroupManager对象。
async function loadVolumeGroupManager(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  const groupid = audio.DEFAULT_VOLUME_GROUP_ID;
  audioVolumeGroupManager = await audio.getAudioManager().getVolumeManager().getVolumeGroupManager(groupid);
  console.info('audioVolumeGroupManager create success.');
  // [StartExclude create_AudioVolumeGroupManager]
  on();
  const successMsg = 'audioVolumeGroupManager create success.';
  if (updateCallback) {
    updateCallback(successMsg, false);
  }
  // [EndExclude create_AudioVolumeGroupManager]
}
// [End create_AudioVolumeGroupManager]

// [Start mac_on]
// 监听麦克风状态变化。
async function on() {
  audioVolumeGroupManager.on('micStateChange', (micStateChange: audio.MicStateChangeEvent) => {
    console.info(`Current microphone status is: ${micStateChange.mute} `);
  });
}
// [End mac_on]

// [Start is_MicrophoneMute]
// 查询麦克风是否静音。
async function isMicrophoneMute(updateCallback?: (msg: string, isError: boolean) => void): Promise<void> {
  await audioVolumeGroupManager.isMicrophoneMute().then((value: boolean) => {
    console.info(`isMicrophoneMute is: ${value}.`);
    // [StartExclude is_MicrophoneMute]
    const infoMsg = `isMicrophoneMute is: ${value}.`;
    if (updateCallback) {
      updateCallback(infoMsg, false);
    }
    // [EndExclude is_MicrophoneMute]
  });
}
// [End is_MicrophoneMute]

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

  // 更新日志信息
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  // 更新回调信息
  updateCallbackInfo(msg: string): void {
    const timestamp = new Date().toLocaleTimeString();
    this.callbackMessages = `[${timestamp}] ${msg}`;
  }

  build(): void {
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

          // 日志信息
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
          .margin({ bottom: 12 })

          // 回调信息
          Column() {
            Text('回调信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.callbackMessages)
              .fontSize(13)
              .fontColor('#FA8C16')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
              .maxLines(3)
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

        // 功能按钮
        Row() {
          Column() {
            Text('创建音量组管理器').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12, bottom: 12 })
          .onClick(async (): Promise<void> => {
            await loadVolumeGroupManager((msg, isError) => this.updateLogInfo(msg, isError));
            this.currentState = '已创建音量组管理器';
          });

          Column() {
            Text('查询麦克风是否静音').fontColor(Color.Black).fontSize(14);
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('45%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(async (): Promise<void> => {
            await isMicrophoneMute((msg, isError) => this.updateLogInfo(msg, isError));
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