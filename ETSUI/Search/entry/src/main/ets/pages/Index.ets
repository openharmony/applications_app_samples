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

import DataModel from '../model/DataModel'
import TitleBar from '../common/TitleBar'
import { MainPage } from '@ohos/search'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount() {
    return 0
  }

  public getData(index: number) {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload() {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number) {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: Array<{
    title: string,
    introduction: string,
    image: Resource
  }> = DataModel.getAllData()

  public totalCount() {
    return this.dataArray.length
  }

  public getData(index: number) {
    return this.dataArray[index]
  }

  public addData(index: number) {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }

  public pushData(title: string, introduction: string, image: Resource) {
    this.dataArray.push({ title, introduction, image })
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  public replaceData(result: any[]) {
    this.dataArray = result
  }
}

@Entry
@Component
struct Index {
  @State changeValue: string = ''
  @State books: MyDataSource = new MyDataSource()
  private controller: SearchController = new SearchController()

  @Builder
  BookItem(image: Resource, title: string, introduction: string) {
    Row() {
      Image(image)
        .width(80)
        .height(120)
      Column() {
        Text(title)
          .fontColor(Color.Black)
          .fontSize(25)
        Text(introduction)
          .fontColor(Color.Gray)
          .fontSize(25)
      }
      .layoutWeight(1)
      .margin({ left: 10 })
      .alignItems(HorizontalAlign.Start)
    }
    .padding(10)
    .margin({ left: 10, right: 10 })
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  build() {
    Column() {
      TitleBar()
      MainPage({ textInfo: $changeValue, customizeFunction: () => {
        this.books.replaceData(DataModel.query(this.changeValue))
      } })
      List({ space: 10 }) {
        LazyForEach(this.books, item => {
          ListItem() {
            this.BookItem(item.image, item.title, item.introduction)
          }
        }, item => item.title)
      }
      .width('100%')
      .layoutWeight(1)
      .margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}