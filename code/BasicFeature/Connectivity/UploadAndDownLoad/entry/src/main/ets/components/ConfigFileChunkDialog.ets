/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import fs from '@ohos.file.fs';
import promptAction from '@ohos.promptAction';
import { logger, TOAST_BOTTOM, NO_IMAGE_SELECTED } from '@ohos/uploaddownload';

const TAG: string = 'ConfigFileChunkDialog';

@CustomDialog
export struct ConfigFileChunkDialog {
  private controller: CustomDialogController = new CustomDialogController({ builder: null });
  @Consume imageList: Array<string>;
  @Consume chunkImgIndex: number;
  @Consume chunkInputEnable: boolean;
  @Consume chunkParaBegins: number;
  @Consume chunkParaEnds: number;
  upload: () => void = () => {
  };

  build() {
    Column() {
      TextInput({ placeholder: $r('app.string.chunk_begins') })
        .type(InputType.Number)
        .onChange((value: string) => {
          this.chunkParaBegins = Number(value) || 0;
          let uri = this.imageList[this.chunkImgIndex];
          let file = fs.openSync(uri);
          let stat = fs.statSync(file.fd);
          let size = stat.size;
          fs.closeSync(file.fd);

          if (this.chunkParaBegins >= (size - 1)) {
            promptAction.showToast({ message: $r('app.string.chunk_para_invalid'), bottom: TOAST_BOTTOM });
          }
        })
        .enabled(this.chunkInputEnable)

      TextInput({ placeholder: $r('app.string.chunk_ends') })
        .type(InputType.Number)
        .onChange((value: string) => {
          this.chunkParaEnds = -1;
          if (value != "") {
            this.chunkParaEnds = Number(value).valueOf();
          }
          let uri = this.imageList[this.chunkImgIndex];
          let file = fs.openSync(uri);
          let stat = fs.statSync(file.fd);
          let size = stat.size;
          fs.closeSync(file.fd);

          logger.debug(TAG, `this.chunkParaEnds:${this.chunkParaEnds}`);
          if (this.chunkParaEnds != -1
            && (this.chunkParaEnds >= size || this.chunkParaEnds <= this.chunkParaBegins)) {
            promptAction.showToast({ message: $r('app.string.chunk_para_invalid'), bottom: TOAST_BOTTOM });
          }
        })
        .margin({ top: 16 })
        .enabled(this.chunkInputEnable)

      Row() {
        Checkbox()
          .onChange((checked: boolean) => {
            this.chunkInputEnable = checked;
          })
          .id('chunkcheckbox')

        Text($r('app.string.chunk_checkbox_tips'))
          .fontSize(16)
          .fontWeight(500)
      }
      .margin({ top: 16 })
      .alignSelf(ItemAlign.Start)

      Button() {
        Text($r('app.string.upload'))
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.white'))
      }
      .width('100%')
      .height(40)
      .backgroundColor($r('app.color.button_blue'))
      .margin({ top: 16 })
      .onClick(() => {
        this.controller.close();
        this.upload();
        this.chunkImgIndex = NO_IMAGE_SELECTED;
      })
    }
    .width('100%')
    .padding(24)
  }
}