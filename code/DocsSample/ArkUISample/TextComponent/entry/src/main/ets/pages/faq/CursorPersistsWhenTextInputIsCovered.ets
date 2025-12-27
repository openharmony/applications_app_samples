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

// [Start Cursor_Persists_When_TextInput_Is_Covered]
@Entry
@Component
export struct CursorPersistsWhenTextInputIsCoveredExample {
  controller: TextInputController = new TextInputController();
  @State message1: string = 'TextInput被遮挡不显示';

  build() {
    NavDestination() {
      Column({ space: 50 }) {
        Stack() {
          TextInput({ text: this.message1, controller: this.controller })
            .copyOption(CopyOptions.LocalDevice)
            .backgroundColor(Color.Green)
            .width(200)
            .id('textInput_1')

          // $r('app.media.foreground')需要替换为开发者所需的图像资源文件。
          Image($r('app.media.foreground'))
            .width(200)
            .height(200)
            .backgroundColor('rgb(213,213,213)')
        }

        Button('点击出现手柄')
          .onClick(() => {
            this.getUIContext().getFocusController().requestFocus('textInput_1')
            this.controller.setTextSelection(0, 5, { menuPolicy: MenuPolicy.HIDE })
          })
      }
      .padding('10%')
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .width('90%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Cursor_Persists_When_TextInput_Is_Covered'))
  }
}

// [End Cursor_Persists_When_TextInput_Is_Covered]