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

import { pasteboard, BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Row() {
      Column({ space: 10 }) {
        TextInput({ placeholder: $r('app.string.input_verify_code'), text: this.message })
        PasteButton()
          .padding({
            top: 12,
            bottom: 12,
            left: 24,
            right: 24
          })
          .onClick((event: ClickEvent, result: PasteButtonOnClickResult) => {
            if (PasteButtonOnClickResult.SUCCESS === result) {
              pasteboard.getSystemPasteboard().getData((err: BusinessError, pasteData: pasteboard.PasteData) => {
                if (err) {
                  console.error(`Failed to get paste data. Code is ${err.code}, message is ${err.message}`);
                  return;
                }
                // 剪贴板内容为 '123456'
                this.message = pasteData.getPrimaryText();
              });
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}