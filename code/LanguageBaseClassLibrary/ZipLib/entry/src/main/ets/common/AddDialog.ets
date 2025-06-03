/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { promptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xF811;
const BUNDLE = 'ZipLib_';
const TAG: string = '[AddDiaglog]';

@CustomDialog
export struct AddDialog {
  private fileName: string = '';
  private fileContent: string = '';
  private isInserted: boolean = false;
  private createFile: (isInserted: boolean, fileName: string, content: string) => void =
    (isInserted: boolean, fileName: string, content: string) => {
    };
  private controller: CustomDialogController;
  @State oneBorderColor: Resource = $r('app.color.border_blur_color');
  @State twoBorderColor: Resource = $r('app.color.border_blur_color');
  @State onePlaceholderColor: Resource = $r('app.color.focus_color');
  @State twoPlaceholderColor: Resource = $r('app.color.focus_color');
  @State buttonColor: Resource = $r('app.color.button_light_color');

  @Builder
  InputLine(inputName: Resource, key: string, inputPrompt: Resource, inputContent: string, onChange:
    (value: string) => void) {
  };

  aboutToAppear() {
    this.fileName = '';
    this.fileContent = '';
  }

  build() {
    Column() {
      Text($r('app.string.create_file'))
        .fontSize(20)
        .width('100%')
        .height('26%')
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      Row() {
        TextInput({ placeholder: $r('app.string.input_name'), text: this.fileName })
          .textAlign(TextAlign.Start)
          .placeholderColor(this.onePlaceholderColor)
          .fontSize(16)
          .maxLength(16)
          .focusOnTouch(true)
          .focusable(true)
          .backgroundColor($r('app.color.start_window_background'))
          .id('inputFileName')
          .onChange((value: string) => {
            this.fileName = value;
            if (value === '' && this.fileContent === '') {
              this.buttonColor = $r('app.color.button_light_color');
            } else {
              this.buttonColor = $r('app.color.button_color');
            }
          })
          .onFocus(() => {
            this.oneBorderColor = $r('app.color.focus_color');
            this.onePlaceholderColor = $r('app.color.focus_color');
          })
          .onBlur(() => {
            if (this.fileName === '') {
              this.oneBorderColor = $r('app.color.border_blur_color');
              this.onePlaceholderColor = $r('app.color.blur_color');
            }
          })
      }
      .backgroundColor($r('app.color.start_window_background'))
      .width('100%')
      .height('22%')

      Divider()
        .color(this.oneBorderColor)
        .strokeWidth(1)
        .width('92%')

      Row() {
        TextInput({ placeholder: $r('app.string.input_content'), text: this.fileContent })
          .textAlign(TextAlign.Start)
          .placeholderColor(this.twoPlaceholderColor)
          .fontSize(16)
          .maxLength(16)
          .focusOnTouch(true)
          .focusable(true)
          .backgroundColor($r('app.color.start_window_background'))
          .id('inputFileContent')
          .onChange((value: string) => {
            this.fileContent = value;
            if (value === '' && this.fileName === '') {
              this.buttonColor = $r('app.color.button_light_color');
            } else {
              this.buttonColor = $r('app.color.button_color');
            }
          })
          .onFocus(() => {
            this.twoBorderColor = $r('app.color.focus_color');
            this.twoPlaceholderColor = $r('app.color.focus_color');
          })
          .onBlur(() => {
            if (this.fileContent === '') {
              this.twoBorderColor = $r('app.color.border_blur_color');
              this.twoPlaceholderColor = $r('app.color.blur_color');
            }
          })
      }
      .backgroundColor($r('app.color.start_window_background'))
      .width('100%')
      .height('22%')

      Divider()
        .color(this.twoBorderColor)
        .strokeWidth(1)
        .width('92%')

      this.InputLine($r('app.string.file_name'), 'FileName', $r('app.string.input_name'), this.fileName, (value: string) => {
        this.fileName = value;
      })
      this.InputLine($r('app.string.file_content'), 'FileContent', $r('app.string.input_content'), this.fileContent, (value: string) => {
        this.fileContent = value;
      })

      Row() {
        Button() {
          Text($r('app.string.button_cancel'))
            .fontColor($r('app.color.button_color'))
            .fontSize(16)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
        }
        .height('18.5%')
        .width('44%')
        .margin({ top: 8 })
        .borderRadius(20)
        .backgroundColor($r('app.color.start_window_background'))
        .onClick(() => {
          this.controller.close();
        })

        Button() {
          Text($r('app.string.button_confirm'))
            .fontColor($r('app.color.start_window_background'))
            .fontSize(16)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
        }
        .id('confirmBtn')
        .backgroundColor(this.buttonColor)
        .borderRadius(20)
        .height('18.5%')
        .width('44%')
        .margin({ left: '2%', top: 8 })
        .onClick(() => {
          hilog.info(DOMAIN, TAG, BUNDLE + `this.fileName = ${this.fileName}`);
          if (this.fileName === '') {
            promptAction.showToast({ message: $r('app.string.warning_empty'), bottom: '11%', duration: 1000 });
            return;
          }
          this.isInserted = true;
          hilog.info(DOMAIN, TAG, BUNDLE + `fileName = ${this.fileName}`);
          this.createFile(this.isInserted, this.fileName, this.fileContent);
          hilog.info(DOMAIN, TAG, BUNDLE + `isInserted = ${this.isInserted}`);
          this.controller.close();
        })
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('30%')
    .backgroundColor($r('app.color.start_window_background'))
  }
}