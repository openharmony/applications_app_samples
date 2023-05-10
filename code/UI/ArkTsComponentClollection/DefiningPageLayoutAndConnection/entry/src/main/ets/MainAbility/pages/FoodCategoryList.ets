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

import router from '@ohos.router'
import { Category, FoodData } from '../model/FoodData'
import { initializeOnStartup } from '../model/FoodDataModels'

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

@Component
struct FoodListItem {
  private foodItem: FoodData

  build() {
    Navigator({ target: 'pages/FoodDetail' }) {
      Row() {
        Row() {
          Image(this.foodItem.image)
            .objectFit(ImageFit.Contain)
            .autoResize(false)
            .height(40)
            .width(40)
        }
        .backgroundColor('#FFf1f3f5')
        .margin({ right: 16 })

        Text(this.foodItem.name)
          .fontSize(14)
          .flexGrow(1)
        Blank()
        Text(this.foodItem.calories + ' kcal')
          .fontSize(14)
      }
      .alignItems(VerticalAlign.Center)
      .height(64)
      .width('100%')
    }
    .width('100%')
    .params({ foodId: this.foodItem })
    .padding({ right: 24, left: 24 })
  }
}


@Component
struct FoodList {
  private foodItems: FoodData[]

  build() {
    Column() {
      Row() {
        Text('Food List')
          .fontSize(20)
          .margin({ left: 20 })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .height('7%')
      .width('100%')
      .backgroundColor('#FFf1f3f5')

      List() {
        LazyForEach(new MyDataSource(this.foodItems), (item, index) => {
          ListItem() {
            FoodListItem({ foodItem: item })
          }
          .key('foodListItem' + (index + 1))
        }, item => item.id.toString())
      }
      .width('100%')
      .height('93%')
    }
    .width('100%')
  }
}

@Component
struct FoodGridItem {
  private foodItem: FoodData

  build() {
    Column() {
      Row() {
        Image(this.foodItem.image)
          .objectFit(ImageFit.Contain)
          .height(152)
          .width('100%')
      }.backgroundColor('#FFf1f3f5')

      Row() {
        Text(this.foodItem.name)
          .fontSize(14)
          .flexGrow(1)
          .padding({ left: 8 })
        Text(this.foodItem.calories + 'kcal')
          .fontSize(14)
          .margin({ right: 6 })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .height(32)
      .width('100%')
      .backgroundColor('#FFe5e5e5')
    }
    .height(184)
    .width('100%')
    .onClick(() => {
      router.push({ url: 'pages/FoodDetail', params: { foodId: this.foodItem } })
    })
  }
}

@Component
struct FoodGrid {
  private foodItems: FoodData[]
  private gridRowTemplate: string = ''
  private heightValue: number

  aboutToAppear() {
    var rows = Math.round(this.foodItems.length / 2);
    this.gridRowTemplate = '1fr '.repeat(rows);
    this.heightValue = rows * 192 - 8;
  }

  build() {
    Scroll() {
      Grid() {
        LazyForEach(new MyDataSource(this.foodItems), (item: FoodData, index) => {
          GridItem() {
            FoodGridItem({ foodItem: item })
          }
          .key('foodGridItem' + (index + 1))
        }, (item: FoodData) => item.id.toString())
      }
      .rowsTemplate(this.gridRowTemplate)
      .columnsTemplate('1fr 1fr')
      .columnsGap(8)
      .rowsGap(8)
      .height(this.heightValue)
    }
    .scrollBar(BarState.Off)
    .padding({ left: 16, right: 16 })
  }
}

@Component
struct FoodCategory {
  private foodItems: FoodData[]

  build() {
    Tabs() {
      TabContent() {
        FoodGrid({ foodItems: this.foodItems })
      }.tabBar('All')

      TabContent() {
        FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Vegetable)) })
      }.tabBar('Vegetable')

      TabContent() {
        FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Fruit)) })
      }.tabBar('Fruit')

      TabContent() {
        FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Nut)) })
      }.tabBar('Nut')

      TabContent() {
        FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Seafood)) })
      }.tabBar('Seafood')

      TabContent() {
        FoodGrid({ foodItems: this.foodItems.filter(item => (item.category === Category.Dessert)) })
      }.tabBar('Dessert')
    }
    .width('100%')
    .barWidth('80%')
    .barHeight(70)
    .barMode(BarMode.Scrollable)
  }
}

@Entry
@Component
struct FoodCategoryList {
  private foodItems: FoodData[] = initializeOnStartup()
  @State private showList: boolean = false

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        if (this.showList) {
          FoodList({ foodItems: this.foodItems })
        } else {
          FoodCategory({ foodItems: this.foodItems })
        }
        Image($r('app.media.Switch'))
          .height(40)
          .width(24)
          .objectFit(ImageFit.Contain)
          .key('switch')
          .margin({ top: 15, right: 10 })
          .onClick(() => {
            this.showList = !this.showList
          })
      }
    }
    .width('100%')
    .height('100%')
  }
}
