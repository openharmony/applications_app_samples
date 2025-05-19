/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import msliteNapi from 'libentry.so'
import AVPlayerDemo from './player';
import { transverter, TransverterType, TransverterLanguage } from "@nutpi/chinese_transverter"

const TAG = 'MindSporeLite';

@Entry
@Component
struct Index {
  @State message: string = 'MSLite Whisper Demo';
  @State wavName: string = 'zh.wav';
  @State content: string = '';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold);
        Button() {
          Text($r('app.string.play'))
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .onClick(async () =>{
          // 通过实例调用类中的函数
          console.info('MS_LITE_LOG: begin to play wav.');
          let myClass = new AVPlayerDemo();
          myClass.avPlayerFdSrcDemo();
        })
        Button() {
          Text($r('app.string.asr'))
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .onClick(() => {
          let resMgr = this.getUIContext()?.getHostContext()?.getApplicationContext().resourceManager;

          // 调用c++的runDemo
          console.info('MS_LITE_LOG: *** Start MSLite Demo ***');
          let output = msliteNapi.runDemo(resMgr);
          console.info('MS_LITE_LOG: output length = ', output.length, ';value = ', output.slice(0, 20));
          this.content = output;
          console.info('MS_LITE_LOG: *** Finished MSLite Demo ***');
        })

        // 显示识别内容
        if (this.content) {
          Text('识别内容: \n' + transverter({
            type: TransverterType.SIMPLIFIED,
            str: this.content,
            language: TransverterLanguage.ZH_CN
          }) + '\n').focusable(true).fontSize(20).height('20%')
        }
      }.width('100%')
    }
    .height('100%')
  }
}
