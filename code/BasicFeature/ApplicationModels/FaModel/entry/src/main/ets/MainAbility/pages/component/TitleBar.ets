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

import router from '@ohos.router'
import DataAbilityHelper from '../../feature/DataAbilityHelper'
import { BookModel, getBooksFromResultSet } from '../../model/BookModel'
import Logger from '../../util/Logger'

const TAG: string = 'TitleBar'

@Component
export struct TitleBar {
  @Link books: Array<BookModel>

  build() {
    Row() {
      Image($r('app.media.back'))
        .width(32)
        .height(32)
        .margin({ left: 26 })
        .onClick(() => {
          router.back()
        })

      Text($r('app.string.title'))
        .fontColor(Color.Black)
        .fontSize(24)
        .fontWeight(500)
        .layoutWeight(1)

      Button() {
        Image($r('app.media.add'))
      }
      .type(ButtonType.Circle)
      .width(40)
      .height(40)
      .layoutWeight(1)
      .margin({ left: 70 })
      .backgroundColor('#f1f3f5')
      .onClick(() => {
        this.heard()
      })
    }
    .height('8%')
    .width('100%')
  }

  async heard() {
    Logger.info(TAG, 'onClick')
    let data = await DataAbilityHelper.insertBook()
    Logger.info(TAG, `data  typeof = ${typeof (data)}, data = ${JSON.stringify(data)} `)
    if (data !== undefined) {
      this.books = getBooksFromResultSet(data)
    }
  }
}