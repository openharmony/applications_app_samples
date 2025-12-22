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
// [Start get_StreamManager]
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';

let audioManager = audio.getAudioManager();
let audioStreamManager = audioManager.getStreamManager();
// [End get_StreamManager]

// 全局UI更新回调
let globalCallbackUpdate: ((msg: string) => void) | undefined;

function listenAudioStreamManager(): void {
  // [Start audioStreamManager_on]
  audioStreamManager.on('audioCapturerChange', (audioCapturerChangeInfoArray: audio.AudioCapturerChangeInfoArray) =>  {
    // [StartExclude audioStreamManager_on]
    let infoMsg = '';
    // [EndExclude audioStreamManager_on]
    for (let i = 0; i < audioCapturerChangeInfoArray.length; i++) {
      console.info(`## CapChange on is called for element ${i} ##`);
      console.info(`StreamId for ${i} is: ${audioCapturerChangeInfoArray[i].streamId}`);
      console.info(`Source for ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.source}`);
      console.info(`Flag  ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.capturerFlags}`);

      // [StartExclude audioStreamManager_on]
      // 为UI收集信息
      infoMsg += `CapChange on is called for element ${i}\n`;
      infoMsg += `StreamId for ${i} is: ${audioCapturerChangeInfoArray[i].streamId}\n`;
      infoMsg += `Source for ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.source}\n`;
      infoMsg += `Flag ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.capturerFlags}\n`;
      // [EndExclude audioStreamManager_on]

      let devDescriptor: audio.AudioDeviceDescriptors = audioCapturerChangeInfoArray[i].deviceDescriptors;
      for (let j = 0; j < audioCapturerChangeInfoArray[i].deviceDescriptors.length; j++) {
        console.info(`Id: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].id}`);
        console.info(`Type: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].deviceType}`);
        console.info(`Role: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].deviceRole}`);
        console.info(`Name: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].name}`);
        console.info(`Address: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].address}`);
        console.info(`SampleRates: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].sampleRates[0]}`);
        console.info(`ChannelCounts ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].channelCounts[0]}`);
        console.info(`ChannelMask: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].channelMasks}`);
      }
    }
    // [StartExclude audioStreamManager_on]
    // 更新UI
    if (globalCallbackUpdate) {
      globalCallbackUpdate(infoMsg);
    }
    // [EndExclude audioStreamManager_on]
  });
  // [End audioStreamManager_on]
}

function cancelListenAudioStreamManager(): void {
  // [Start cancel_ListenAudioStreamManager]
  audioStreamManager.off('audioCapturerChange');
  console.info('CapturerChange Off is called');
  // [End cancel_ListenAudioStreamManager]
}

// [Start get_CurrentAudioCapturerInfoArray]
async function getCurrentAudioCapturerInfoArray(updateCallback?:
  (msg: string, isError: boolean) => void): Promise<void>{
  // [StartExclude get_CurrentAudioCapturerInfoArray]
  // 获取前先监听
  listenAudioStreamManager();
  // [EndExclude get_CurrentAudioCapturerInfoArray]

  await audioStreamManager.getCurrentAudioCapturerInfoArray()
    .then((audioCapturerChangeInfoArray: audio.AudioCapturerChangeInfoArray) => {
      console.info('getCurrentAudioCapturerInfoArray Get Promise Called');
      // [Start get_CurrentAudioCapturerInfoArray]
      let detailInfo = 'getCurrentAudioCapturerInfoArray Get Promise Called\n';
      // [EndExclude get_CurrentAudioCapturerInfoArray]
      if (audioCapturerChangeInfoArray != null) {
        for (let i = 0; i < audioCapturerChangeInfoArray.length; i++) {
          console.info(`StreamId for ${i} is: ${audioCapturerChangeInfoArray[i].streamId}`);
          console.info(`Source for ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.source}`);
          console.info(`Flag  ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.capturerFlags}`);

          detailInfo += `StreamId for ${i} is: ${audioCapturerChangeInfoArray[i].streamId}\n`;
          detailInfo += `Source for ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.source}\n`;
          detailInfo += `Flag ${i} is: ${audioCapturerChangeInfoArray[i].capturerInfo.capturerFlags}\n`;

          for (let j = 0; j < audioCapturerChangeInfoArray[i].deviceDescriptors.length; j++) {
            console.info(`Id: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].id}`);
            console.info(`Type: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].deviceType}`);
            console.info(`Role: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].deviceRole}`);
            console.info(`Name: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].name}`);
            console.info(`Address: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].address}`);
            console.info(`SampleRates: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].sampleRates[0]}`);
            console.info(`ChannelCounts ${i} : ${audioCapturerChangeInfoArray[i]
              .deviceDescriptors[j].channelCounts[0]}`);
            console.info(`ChannelMask: ${i} : ${audioCapturerChangeInfoArray[i].deviceDescriptors[j].channelMasks}`);
          }
        }
      }
      // [Start get_CurrentAudioCapturerInfoArray]
      if (updateCallback) {
        updateCallback(detailInfo, false);
      }
      // [EndExclude get_CurrentAudioCapturerInfoArray]
    }).catch((err: BusinessError) => {
      console.error(`Invoke getCurrentAudioCapturerInfoArray failed, code is ${err.code}, message is ${err.message}`);
      // [Start get_CurrentAudioCapturerInfoArray]
      const errorMsg = `Invoke getCurrentAudioCapturerInfoArray failed, code is ${err.code}, message is ${err.message}`;
      if (updateCallback) {
        updateCallback(errorMsg, true);
      }
      // [EndExclude get_CurrentAudioCapturerInfoArray]
    });
  // [Start get_CurrentAudioCapturerInfoArray]
  // 获取后取消监听
  cancelListenAudioStreamManager();
  // [EndExclude get_CurrentAudioCapturerInfoArray]
}
// [End get_CurrentAudioCapturerInfoArray]

@Entry
@Component
struct Index {
  @State currentState: string = '未初始化';
  @State logMessages: string = '暂无日志信息';
  @State callbackMessages: string = '暂无回调信息';

  aboutToAppear(): void {
    // 设置全局回调
    globalCallbackUpdate = (msg) => this.updateCallbackInfo(msg);
  }

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
            Scroll() {
              Text(this.logMessages)
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
          .margin({ bottom: 12 })

          // 回调信息
          Column() {
            Text('回调信息')
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.callbackMessages)
                .fontSize(12)
                .fontColor('#FA8C16')
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
        Column() {
          Text('获取当前录制流信息').fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(60)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(async (): Promise<void> => {
          this.currentState = '正在获取录制流信息...';
          await getCurrentAudioCapturerInfoArray((msg, isError) => {
            this.updateLogInfo(msg, isError);
            if (!isError) {
              this.currentState = '获取成功';
            } else {
              this.currentState = '获取失败';
            }
          });
        });
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}