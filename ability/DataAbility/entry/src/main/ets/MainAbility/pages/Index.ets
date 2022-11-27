/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import dataAbility from '@ohos.data.dataAbility'
import router from '@ohos.router'
import { BASE_URI, COLUMNS, DA_HELPER } from '../model/DaHelperConst'
import { BookView } from '../component/BookView'
import { initValuesBuckets, getListFromResultSet } from '../model/BookDataModel'
import { BookDataSource } from '../model/BookDataSource'
import { TitleBar } from '../component/TitleBar'
import { SearchBar } from '../component/SearchBar'

const TAG = '[DataAbility].Index'

@Entry
@Component
struct Index {
  @State bookList: BookDataSource = new BookDataSource()
  @State listHeight: number = 0

  onPageShow() {
    this.queryAll()
  }

  queryAll = () => {
    console.info(TAG + ' queryAll')
    this.bookList['dataArray'] = []
    this.bookList.notifyDataReload()
    let predicates = new dataAbility.DataAbilityPredicates()
    DA_HELPER.query(BASE_URI, COLUMNS, predicates, (err, resultSet) => {
      this.bookList['dataArray'] = getListFromResultSet(resultSet)
      this.bookList.notifyDataReload()
    })
  }
  deleteCallback = (book) => {
    let predicates = new dataAbility.DataAbilityPredicates()
    predicates.equalTo('id', book.id)
    DA_HELPER.delete(BASE_URI, predicates, (err, num) => {
      console.info(TAG + ' delete num=' + num)
      this.queryAll()
    })
  }
  batchInsertCallback = () => {
    let valuesBuckets = initValuesBuckets()
    DA_HELPER.batchInsert(BASE_URI, valuesBuckets, (err, num) => {
      console.info(TAG + ' batch insert num=' + num)
      this.queryAll()
    })
  }

  build() {
    Column() {
      TitleBar({ batchInsertCallback: this.batchInsertCallback })
      SearchBar()
      Stack({ alignContent: Alignment.BottomEnd }) {
        List() {
          LazyForEach(this.bookList, item => {
            ListItem() {
              BookView({ book: item, deleteCallback: this.deleteCallback })
            }
            .onClick(() => {
              router.push({ url: 'pages/Update', params: { book: item } })
            })
          }, item => item.id.toString())
        }
        .height('100%')
        .translate({ y: -50 })
        .padding({ bottom: '8%' })
        .margin({ top: 50 })
        .width('100%')
        .constraintSize({ minHeight: '100%' })
        .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })

        Button() {
          Image($r('app.media.add'))
        }
        .type(ButtonType.Circle)
        .width(60)
        .height(60)
        .backgroundColor('#0D9FFB')
        .margin({ bottom: 150, right: 50 })
        .onClick(() => {
          console.info(TAG + ' insert onClick')
          let valuesBuckets = { name: 'Book name', introduction: 'Book introduction' }
          DA_HELPER.insert(BASE_URI, valuesBuckets, (err, num) => {
            console.info(TAG + ' insert num=' + num)
            this.queryAll()
          })
          valuesBuckets = null
        })
      }
      .margin({top: this.listHeight})
      .width('100%')
      .height('92%')
    }
    .width('100%').height('100%')
    .onAreaChange(( oldValue: Area, newValue: Area) => {
      this.listHeight = Number(newValue.height) * 0.08
    })
  }
}