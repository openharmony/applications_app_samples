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

@Entry
@Component
struct audiosession {
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

          // 创建播放流按钮
          Button('创建播放流')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.CreateAudioRender();
                this.message = '创建播放流成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建播放流失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // 销毁播放流按钮
          Button('销毁播放流')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.DestroyAudioRender();
                this.message = '销毁播放流成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '销毁播放流失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // 设置音量按钮
          Button('设置音量')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.SetVolume();
                this.message = '设置音量成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '设置音量失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // 设置时延模式按钮
          Button('设置时延模式')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.setLatencyMode();
                this.message = '设置时延模式成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '设置时延模式失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // 获取时延模式按钮
          Button('获取时延模式')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.getLatencyMode();
                this.message = '获取时延模式成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '获取时延模式失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // 创建工作组按钮
          Button('创建工作组')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.workgroupcreate();
                this.message = '创建工作组成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '创建工作组失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          // 处理工作组按钮
          Button('处理工作组')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.workgroupprocess();
                this.message = '处理工作组成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '处理工作组失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('自定义的回调方法')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.registcallback1();
                this.message = '自定义的回调方法成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '自定义的回调方法失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('空指针初始化回调方法')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.registcallback2();
                this.message = '空指针初始化方法成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '空指针初始化方法失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('设置同时写入回调')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await testNapi.CreateAudioRender02();
                this.message = '设置同时写入回调成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '设置同时写入回调失败';
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