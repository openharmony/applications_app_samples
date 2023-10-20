/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@CustomDialog
struct InputTextDialog {
  @Link inputValue: string;
  controller?: CustomDialogController;
  cancel: () => void = () => {};
  confirm: () => void = () => {};

  build() {
    Column() {
      Text($r('app.string.input_text_dialog_text'))
        .fontSize($r('app.float.size_20'))
        .margin({ top: $r('app.float.size_30'), bottom: $r('app.float.size_30') })
      TextInput({ placeholder: $r('app.string.input_text_dialog_inputText'), text: '' })
        .height($r('app.float.size_60'))
        .width('90%')
        .onChange((value: string) => {
          this.inputValue = value;
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.input_text_dialog_cancel'))
          .onClick(() => {
            if (this.controller !== undefined && this.controller !== null) {
              this.controller.close();
            }
            this.cancel();
          }).backgroundColor(Color.White).fontColor(Color.Black)
        Button($r('app.string.input_text_dialog_sure'))
          .onClick(() => {
            if (this.controller !== undefined && this.controller !== null) {
              this.controller.close();
            }
            this.confirm();
          }).backgroundColor(Color.White).fontColor(Color.Red)
          .id('Sure')
      }.margin({ top: $r('app.float.size_30'), bottom: $r('app.float.size_30') })
    }
    .id('TextInput')
  }
}

export default InputTextDialog;