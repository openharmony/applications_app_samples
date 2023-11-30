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

// 用户改变文件(夹)时间的弹窗
@CustomDialog
export struct ChangeTimeDialog {
  controller?: CustomDialogController
  textController: TextInputController = new TextInputController()
  confirm: () => void = () => {}
  time: string = ''

  aboutToAppear() {
    if (this.time) {
      AppStorage.SetOrCreate('time', this.time);
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.label_change_time'))
          .fontSize(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      TextInput({
        placeholder: $r('app.string.label_input'),
        text: this.time ? this.time : '',
        controller: this.textController
      })
        .id('changeTimeInput')
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .caretColor(Color.Blue)
        .width('100%')
        .height(40)
        .margin({ top: 20, bottom: 20 })
        .fontSize(14)
        .fontColor(Color.Black)
        .enableKeyboardOnFocus(false)
        .onChange((value: string) => {
          AppStorage.SetOrCreate('time', value)
        })

      Row() {
        Text($r('app.string.label_confirm'))
          .id('changeTimePromise')
          .fontColor($r('app.color.text_color'))
          .fontSize(20)
          .letterSpacing(2)
          .opacity(.8)
      }
      .padding({ top: 10, bottom: 10 })
      .margin({ bottom: 20 })
      // 界面需求，这里给出50%
      .width('50%')
      .justifyContent(FlexAlign.Center)
      .borderWidth(2)
      .borderColor($r('app.color.text_color'))
      .borderRadius(40)
      .onClick(() => {
        this.confirm()
      })

      Text($r('app.string.label_cancel'))
        .id('changeTimeCancel')
        .fontSize(20)
        .onClick(() => {
          this.controller?.close()
        })
    }
    .width('100%')
    .padding(40)
    .borderRadius(20)
    .backgroundColor(Color.White)
  }
}
