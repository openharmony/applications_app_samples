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

import { DataStatus, dataStatus } from '../serviceextability/IPC_Service'

@Entry
@Component
struct Index {
  @State message: string = 'IPC-Server';
  @State statusObj: DataStatus = dataStatus

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .margin({
            top: $r('app.float.page_text_top_size'),
            bottom: $r('app.float.page_text_bottom_size')
          })
        Text($r('app.string.DisplayParcelable'))
          .width('100%')
          .fontSize(24)
          .textAlign(TextAlign.Start)
        TextArea({ placeholder: $r('app.string.Parcelable'), text: this.statusObj.getParcelable })
          .width('100%')
          .height('25%')
          .fontSize(20)
          .margin({
            top: $r('app.float.page_text_top_size'),
            bottom: $r('app.float.page_text_bottom_size')
          })
        Text($r('app.string.DisplayArrayBuffer'))
          .width('100%')
          .fontSize(24)
        TextArea({ placeholder: $r('app.string.ArrayBuffer'), text: this.statusObj.getArrayBuffer })
          .width('100%')
          .height('25%')
          .fontSize(20)
          .margin({
            top: $r('app.float.page_text_top_size'),
            bottom: $r('app.float.page_text_bottom_size')
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}