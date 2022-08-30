/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import DataAbilityHelper from '../../feature/DataAbilityHelper'
import { BookModel, getBooksFromResultSet } from '../../model/BookModel'
import Logger from '../../util/Logger'

const TAG: string = 'UpdateData'

@CustomDialog
export struct UpdateDataDialog {
  @Link books: Array<BookModel>
  private book: BookModel = undefined
  private clearDialog: () => void
  controller: CustomDialogController

  build() {
    Column() {
      Text($r('app.string.book_name'))
        .fontWeight(FontWeight.Bold)
        .fontSize(22)
        .margin({ top: 20 })
        .fontColor(Color.Black)
      TextInput({ placeholder: 'input name', text: this.book.name })
        .type(InputType.Normal)
        .placeholderColor(Color.Gray)
        .fontSize(19)
        .margin({ top: 10, left: 12, right: 12 })
        .onChange((value: string) => {
          this.book.name = value
        })

      Text($r('app.string.book_intro'))
        .fontWeight(FontWeight.Bold)
        .fontSize(22)
        .fontColor(Color.Black)
        .margin({ top: 20 })
      TextInput({ placeholder: 'input introduction', text: this.book.introduction })
        .type(InputType.Normal)
        .placeholderColor(Color.Gray)
        .fontSize(19)
        .margin({ left: 12, right: 12, top: 10 })
        .onChange((value: string) => {
          this.book.introduction = value
        })

      Blank()

      Row() {
        Text($r('app.string.no'))
          .fontSize(21)
          .layoutWeight(1)
          .align(Alignment.Center)
          .onClick(() => {
            this.controller.close()
            this.clearDialog()
          })
        Text($r('app.string.yes'))
          .fontSize(21)
          .layoutWeight(1)
          .align(Alignment.Center)
          .onClick(async () => {
            Logger.info(TAG, 'updateBook start')
            let data = await DataAbilityHelper.updateBook(this.book)
            if (data) {
              this.books = getBooksFromResultSet(data)
            }
            this.controller.close()
            this.clearDialog()
          })
      }
      .width('100%')
    }
    .width('100%')
    .height(300)
  }
}