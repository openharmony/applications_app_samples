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

import DateShareHelper from '../../feature/DataShareHelper'
import Logger from '../../util/Logger'
import { BookModel, getBooksFromResultSet } from '../../feature/BookModel'

const TAG = 'bookView'

@Component
export struct BookView {
  @Link books: Array<BookModel>
  private book: BookModel = null

  build() {
    Row() {
      Image($r('app.media.book'))
        .height(80)
        .width(80)
        .objectFit(ImageFit.Cover)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        if (this.book !== null) {
          Text(this.book.name)
            .fontColor(Color.Black)
            .fontSize(22)
            .margin({ top: 14 })
            .fontWeight(FontWeight.Bold)
          Text(this.book.introduction)
            .fontColor(Color.Grey)
            .fontSize(20)
            .margin({ top: 10 })
        }
      }
      .height('100%')
      .layoutWeight(1)
      .margin({ left: 12 })

      Button() {
        Image($r('app.media.delete'))
          .height(50)
          .width(50)
          .objectFit(ImageFit.Contain)
      }
      .type(ButtonType.Circle)
      .height(80)
      .width(80)
      .backgroundColor('#F5F5F5')
      .onClick(() => {
        Logger.info(TAG, 'deleteBook start')
        this.delete()
      })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 15, right: 15 })
  }

  async delete(){
    let data = await DateShareHelper.deleteBook(this.book)
    if (data !== undefined) {
      this.books = getBooksFromResultSet(data)
    }
  }
}