/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
@Preview
@CustomDialog
export struct RenameFileDialog {
  @Link inputValue: string
  @Link isFile: boolean
  controller: CustomDialogController
  cancel?: () => void;
  confirm?: () => void;

  build() {
    Column() {

      TextInput({ placeholder: 'input file name', text: this.inputValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.inputValue = value;
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('confirm')
          .onClick(() => {
            if (this.inputValue.length > 0) {
              this.controller.close();
              ;
              this.confirm!()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Blue)
        Button('cancel')
          .onClick(() => {
            this.controller.close();
            this.cancel!()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }.padding(10)
  }
}