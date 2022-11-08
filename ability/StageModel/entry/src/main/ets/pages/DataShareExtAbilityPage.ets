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

import DateShareHelper from '../feature/DataShareHelper'
import { BookModel, getBooksFromResultSet } from '../feature/BookModel'
import { BookView } from './component/BookView'
import { TitleBar } from './component/TitleBar'
import { UpdateDataDialog } from '../pages/component/UpdateDataDialog'

@Entry
@Component
struct DataShareExtAbilityPage {
  @State message: string = ''
  @State books: Array<BookModel> = []
  private fileFd: number
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
              if (this.dialogController !== null) {
                this.dialogController = null
              }
              this.dialogController = new CustomDialogController({
                builder: UpdateDataDialog({
                  book: item,
                  books: $books
                }),
                autoCancel: true
              })
              this.dialogController.open()
            })
          }, item => JSON.stringify(item))
        }
        .width('100%')
        .height('100%')
        .margin({ bottom: 100 })
        .constraintSize({ minHeight: '100%' })
        .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })
    }
    .width('100%')
    .height('100%')
  }

  async aboutToAppear() {
    let context = getContext(this)
    await DateShareHelper.getDataShareHelper(context)
    let data = await DateShareHelper.queryAll()
    this.books = getBooksFromResultSet(data)
  }
}