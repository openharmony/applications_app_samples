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

import { BookView } from './component/BookView'
import { BookModel, getBooksFromResultSet } from '../model/BookModel'
import { TitleBar } from './component/TitleBar'
import { UpdateDataDialog } from './component/UpdateDataDialog'
import DataAbilityHelper from '../feature/DataAbilityHelper'

@Entry
@Component
struct DataPage {
  @State books: Array<BookModel> = []
  private dialogController: CustomDialogController = null

  build() {
    Column() {
      TitleBar({ books: $books })
      List() {
        ForEach(this.books, item => {
          ListItem() {
            BookView({ book: item, books: $books })
          }
          .height(90)
          .backgroundColor('#ffffff')
          .borderRadius(20)
          .onClick(() => {
            if (this.dialogController === null) {
              this.dialogController = new CustomDialogController({
                builder: UpdateDataDialog({
                  book: item,
                  clearDialog: this.clearDialog,
                  books: $books
                }),
                autoCancel: true
              })
            }
            this.dialogController.open()
          })
        }, item => item.name)
      }
      .width('94%')
      .height('100%')
      .margin({ bottom: 120 })
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 110, endMargin: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }

  onPageShow() {
    this.refreshData()
  }

  async refreshData() {
    let resultSet = await DataAbilityHelper.queryAll()
    this.books = getBooksFromResultSet(resultSet)
  }

  clearDialog = () => {
    this.dialogController = null
  }
}