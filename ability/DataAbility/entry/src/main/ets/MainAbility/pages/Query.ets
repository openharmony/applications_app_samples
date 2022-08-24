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
import router from '@ohos.router';
import dataAbility from '@ohos.data.dataAbility'
import { BASE_URI, COLUMNS, DA_HELPER } from '../model/DaHelperConst'
import { BookModel, getListFromResultSet } from '../model/BookDataModel'
import { BookView } from '../component/BookView'

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

const TAG = 'DataAbility.Query'

@Entry
@Component
struct Query {
  @State bookList: Array<BookModel> = []

  query(queryStr) {
    let predicates = new dataAbility.DataAbilityPredicates()
    predicates.contains('name', queryStr)
      .or()
      .contains('introduction', queryStr)
    DA_HELPER.query(BASE_URI, COLUMNS, predicates, (err, resultSet) => {
      this.bookList = getListFromResultSet(resultSet)
    })
  }
  aboutToAppear() {
    console.info(TAG + ' aboutToAppear')
  }
  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40).height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.title'))
          .fontColor(Color.White)
          .fontSize(20)
          .layoutWeight(1)
      }
      .height(50).width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 10, right: 10 })

      Stack({ alignContent: Alignment.End }) {
        TextInput({ placeholder: $r('app.string.search_placeholder') })
          .height('85%').width('94%')
          .padding({ left: 15 })
          .margin('3%')
          .backgroundColor('#F0F0F0')
          .border({ radius: 20 })
          .key('search')
          .onChange((value: string) => {
            console.info(TAG + ' query str=' + value)
            if (value !== '') {
              this.query(value)
            }else{
              this.bookList = []
            }
          })
        Image($r('app.media.search_gray'))
          .height(40).width(40)
          .margin({ right: '5%' })
          .objectFit(ImageFit.Contain)
      }
      .width('100%').height(50)
      .backgroundColor('#F5F5F5')

      List() {
        LazyForEach(new MyDataSource(this.bookList), item => {
          ListItem() {
            BookView({ book: item, deleteCallback: null })
          }
        }, item => JSON.stringify(item))
      }
      .height('100%')
      .padding({bottom:'8%'})
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })
    }
  }
}