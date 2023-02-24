/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import DataAbilityHelperTest from '../../feature/DataAbilityHelper'
import Logger from '../../util/Logger'
import { BookModel, getBooksFromResultSet } from '../../model/BookModel'

const TAG: string = 'BookView'

@Component
export struct BookView {
  @Link books: Array<BookModel>
  @ObjectLink book: BookModel

  build() {
    Row() {
      Image($r('app.media.app'))
        .height(80)
        .width(80)
        .objectFit(ImageFit.Cover)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        if (this.book) {
          Text(this.book.name)
            .fontColor(Color.Black)
            .fontSize(18)
            .margin({ top: 14 })
            .fontWeight(FontWeight.Bold)
          Text(this.book.introduction)
            .fontColor(Color.Grey)
            .fontSize(18)
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
      .onClick(async () => {
        Logger.info(TAG, 'deleteBook start')
        let data = await DataAbilityHelperTest.deleteBook(this.book)
        if (data !== undefined) {
          this.books = getBooksFromResultSet(data)
        }
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
}