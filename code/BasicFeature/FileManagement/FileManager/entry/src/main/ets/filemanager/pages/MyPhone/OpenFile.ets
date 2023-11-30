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

interface paramsTape {
  fileName: string,
  fileSize: string,
  fileContent: string
}

@Entry
@Component
struct OpenFile {
  @State myFileName: string = (router.getParams() as paramsTape).fileName;
  @State myFileSize: string = (router.getParams() as paramsTape).fileSize;
  @State myFileContent: string = (router.getParams() as paramsTape).fileContent;
  @State showFileName: string = this.myFileName;
  @State showFileContent: string = this.myFileContent;
  scroller: Scroller = new Scroller();
  controllerArea: TextAreaController = new TextAreaController();
  controllerInput: TextInputController = new TextInputController();

  build() {
    Row() {
      Column() {
        Row() {
          Row() {
            Image($r('app.media.ic_back'))
              .height("18vp")
              .width("20vp")
              .align(Alignment.TopStart)
              .id('openFileBack')
              .margin({ left: "26vp" })
              .onClick(() => {
                router.back();
              })
            Text(this.showFileName)
              .fontSize("20vp")
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
              .id('openFileName')
              .borderRadius(0)
              .fontWeight(700)
              .margin({ left: "18vp", right: "26vp" })
              .backgroundColor('#f1f3f5')
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height(56)
        .align(Alignment.TopStart)

        Column() {
          Scroll(this.scroller) {
            Text(this.showFileContent)
              .fontSize("16vp")
              .fontColor('#182431')
              .id('openFileContent')
              .fontWeight(500)
              .backgroundColor('#f1f3f5')
              .opacity(0.6)
              .width('100%')
              .padding({ top: 10, bottom: 32,right: 2 })
          }
        }
        .width('100%')
        .padding({ top: "4vp", left: "28vp", right: "72vp" })
        .height(660)
        .align(Alignment.TopStart)
      }
      .width('100%')
      .height(720)
      .align(Alignment.TopStart)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f3f5')
  }
}
