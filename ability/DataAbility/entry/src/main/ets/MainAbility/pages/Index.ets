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
import featureAbility from '@ohos.ability.featureAbility'
import dataAbility from '@ohos.data.dataAbility'
import router from '@ohos.router'
import { BASE_URI, COLUMNS, DA_HELPER } from '../model/DaHelperConst'
import { BookView } from '../component/BookView'
import { BookModel, initValuesBuckets, getListFromResultSet } from '../model/BookDataModel'
import { TitleBar } from '../component/TitleBar'
import { SearchBar } from '../component/SearchBar'
const TAG = '[DataAbility].Index'
let self = null

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdded(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChanged(index)
    })
  }
}

class MyDataSource extends BasicDataSource {
  public dataArray: string[] = []

  constructor(ele) {
    super()
    for (var index = 0;index < ele.length; index++) {
      this.dataArray.push(ele[index])
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): any {
    return this.dataArray[index]
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

@Entry
@Component
struct Index {
  private daHelper: any = undefined
  @State bookList: Array<BookModel> = []

  onPageShow(){
    this.queryAll()
  }

  queryAll = () => {
    console.info(TAG + ' queryAll')
    let predicates = new dataAbility.DataAbilityPredicates()
    DA_HELPER.query(BASE_URI, COLUMNS, predicates, (err, resultSet) => {
      this.bookList = getListFromResultSet(resultSet)
    })
  }

  deleteCallback = (book) =>  {
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
          LazyForEach(new MyDataSource(this.bookList), item => {
            ListItem() {
              BookView({ book: item, deleteCallback: this.deleteCallback })
            }
            .onClick(() => {
              router.push({ url: 'pages/Update', params: { book: item } })
            })
          }, item => item)
        }
        .height('100%')
        .translate({y:-50})
        .padding({bottom:'8%'})
        .margin({top:50})
        .width('100%')
        .constraintSize({ minHeight: '100%' })
        .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })

        Button() {
          Image($r('app.media.add'))
        }
        .type(ButtonType.Circle)
        .width(60).height(60)
        .backgroundColor('#0D9FFB')
        .margin({ bottom: 150, right: 50 })
        .onClick(() => {
          console.info(TAG + ' insert onClick')
          let valuesBuckets = { name: 'Book name', introduction: 'Book introduction' }
          DA_HELPER.insert(BASE_URI, valuesBuckets, (err, num) => {
            console.info(TAG + ' insert num=' + num)
            this.bookList.push({ id: num, name: 'Book name', introduction: 'Book introduction' })
          })
          valuesBuckets = null
        })
      }
      .width('100%').height('100%')
    }
    .width('100%').height('100%')
  }
}