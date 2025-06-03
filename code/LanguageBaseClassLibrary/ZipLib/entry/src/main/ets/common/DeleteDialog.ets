/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xF811;
const BUNDLE = 'ZipLib_';
const TAG: string = '[DeleteDialog]';

@CustomDialog
export struct DeleteDialog {
  private fileNames: string[] = [];
  private isInserted: boolean = false;
  private deleteFiles: (isInserted: boolean, fileNames: Array<string>) => void =
    (isInserted: boolean, fileNames: Array<string>) => {
    };
  private controller: CustomDialogController;
  @State buttonColor: Resource = $r('app.color.button_light_color');

  build() {
    Column() {
      Text($r('app.string.delete_file'))
        .fontSize(16)
        .width('100%')
        .height('40%')
        .margin({ top: '3%' })
        .textAlign(TextAlign.Center)

      Row() {
        Text($r('app.string.button_cancel'))
          .fontColor($r('app.color.button_color'))
          .fontSize(16)
          .height('18.5%')
          .width('44%')
          .margin({ left: '23%', top: '3%' })
          .onClick(() => {
            this.controller.close();
          })

        Text($r('app.string.button_confirm'))
          .fontColor($r('app.color.button_color'))
          .fontSize(16)
          .height('18.5%')
          .width('44%')
          .margin({ right: '23%', top: '3%' })
          .onClick(() => {
            this.isInserted = true;
            hilog.info(DOMAIN, TAG, BUNDLE + `fileName = ${this.fileNames}`);
            this.deleteFiles(this.isInserted, this.fileNames);
            hilog.info(DOMAIN, TAG, BUNDLE + `isInserted = ${this.isInserted}`);
            this.controller.close();
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('18%')
    .backgroundColor($r('app.color.start_window_background'))
  }
}