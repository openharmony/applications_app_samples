/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import prompt from '@ohos.prompt'

@Entry
@Component
struct OpenFile {
  @State myFileName: string = router.getParams()['fileName'];
  @State myFileContent: string = router.getParams()['fileContent'];
  @State text: string = router.getParams()['text'];
  @State showFileName: string = this.myFileName;
  @State showFileContent: string = this.myFileContent;
  scroller: Scroller = new Scroller();
  controllerArea: TextAreaController = new TextAreaController();
  controllerInput: TextInputController = new TextInputController();

  build() {
    Scroll(this.scroller) {
      Row() {
        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_back'))
                .width(24)
                .height(24)
                .align(Alignment.Start)
                .id('back')
                .onClick(() => {
                  router.back();
                })
            }
            .width('100%')
          }
          .height(26)
          .margin({ top: 19, left: 26, right: 24 })
          .align(Alignment.Center)

          Column() {
            Row() {
              TextInput({ text: this.showFileName, controller: this.controllerInput })
                .fontSize(30)
                .fontColor('#182431')
                .textAlign(TextAlign.Start)
                .id('fileName')
                .borderRadius(0)
                .fontWeight(500)
                .margin({ left: 8, right: 8 })
                .backgroundColor('#f1f3f5')
                .maxLength(30)
            }
            .width('100%')
            .align(Alignment.Start)
            .margin({ top: 8 })
          }
          .margin({ top: 11 })
          .height(81)

          Row() {
            TextArea({ text: this.showFileContent, controller: this.controllerArea })
              .fontSize(16)
              .fontColor('#182431')
              .height(560)
              .id('fileContent')
              .borderRadius(0)
              .fontWeight(400)
              .align(Alignment.TopStart)
              .backgroundColor('#f1f3f5')
              .opacity(0.6)
              .margin({ left: 8, right: 8 })
          }
          .margin({ top: 11 })
        }
        .width('100%')
        .height('100%')
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#f1f3f5')
    }
  }
}
