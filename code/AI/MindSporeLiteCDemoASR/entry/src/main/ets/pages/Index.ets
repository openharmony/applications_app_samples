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
  @State uris: Array<string> = [];
  @State content: string = '';
  @State max: number = 0;
  @State maxIndex: number = 0;
  @State maxArray: Array<number> = [];
  @State maxIndexArray: Array<number> = [];

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold);
        //图片显示
        // Image(this.uris[0]).width(320).height(40).margin(15)

        Button() {
          Text('播放示例音频')
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
          console.warn('MS_LITE_LOG: begin to play wav.');
          let myClass = new AVPlayerDemo();
          myClass.avPlayerFdSrcDemo();

          // 创建avPlayer实例对象。
          // let avPlayer: media.AVPlayer = await media.createAVPlayer();

        })

        Button() {
          Text('识别示例音频')
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
          // let output: Array<number> = msliteNapi.runDemo(Array.from(float32View), resMgr);
          let output = msliteNapi.runDemo(resMgr);
          // let output = '我认为跑步最重要的就是给我带来了身体健康。';
          // let output = '我認為跑步最重要的就是給我帶來了身體健康。';
          console.warn('MS_LITE_WARN: output length = ', output.length, ';value = ', output.slice(0, 20));
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
