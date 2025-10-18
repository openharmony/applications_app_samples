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

// [Start dynamic_focus_transfer]
@Entry
export struct FocusTransferExample {
  @State logText: string = '\n';

  addText(message: string) {
    this.logText += `${message}\n`;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Column() {
            Button("button 1")
              .margin(20)
              .onClick(() => {
                this.logText = '获焦信息：\n';
                this.getUIContext().getFocusController().requestFocus("Row 2")
              })
          }
        }

        Column() {
          Row() {
            Button("button 2")
              .margin(20)
              .onFocus(() => {
                this.addText("Button 2 获得焦点");
              })
            Button("button 3")
              .margin(20)
              .onFocus(() => {
                this.addText("Button 3 获得焦点");
              })
          }
          .id("Row 2")
          .onFocus(() => {
            this.addText("Row 2 获得焦点");
          })
        }
        .onFocus(() => {
          this.addText("Column 2 获得焦点");
        })

        Scroll() {
          Text(this.logText)
            .fontSize(14)
            .textAlign(TextAlign.Start)
            .padding(10)
        }
        .height('40%')
        .width('100%')
        .border({ width: 1, color: '#ccc' })
        .margin(10)
      }
      .height('100%')
      .padding(20)
    }
    // [StartExclude dynamic_focus_transfer]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_Index_FocusTransfer_title'))
    // [EndExclude dynamic_focus_transfer]
  }
}

// [End dynamic_focus_transfer]