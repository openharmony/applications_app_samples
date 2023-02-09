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

import { FoodInfo } from '../model/DataModels'
import { getFoodsData } from '../model/DataUtil'
import { FoodListItem } from './component/FoodListItem'

@Entry
@Component
struct Home {
  private foodList: Array<FoodInfo>[] = getFoodsData()

  build() {
    Column() {
      Text($r("app.string.startMode"))
        .width('100%')
        .height('10%')
        .fontWeight(600)
        .padding(10)
        .fontSize(22)
      Column() {
        List() {
          ForEach(this.foodList, (item, index) => {
            ListItem() {
              Column() {
                if (index == 0) {
                  FoodListComp({
                    modeIntro: $r("app.string.standard"),
                    modeName: 'standard',
                    foodsList: item,
                    foodListIndex: index
                  })
                } else if (index == 1) {
                  FoodListComp({
                    modeIntro: $r("app.string.specified"),
                    modeName: 'specified',
                    foodsList: item,
                    foodListIndex: index
                  })
                } else {
                  FoodListComp({
                    modeIntro: $r("app.string.singleton"),
                    modeName: 'sinleton',
                    foodsList: item,
                    foodListIndex: index
                  })
                }
              }.justifyContent(FlexAlign.Center)
            }
          })
        }
      }
    }.width('100%').height('100%').backgroundColor('#FF1f3f5')
  }
}

@Component
struct FoodListComp {
  private modeIntro: Resource
  private foodsList: Array<FoodInfo>
  private modeName: string
  private foodListIndex: number

  build() {
    Column() {
      Row() {
        Text(this.modeIntro)
          .fontSize(16)
          .fontWeight(600)
          .fontColor('#ff858588')

        Text(` ${this.modeName}`)
          .fontSize(16)
          .fontWeight(600)
          .fontColor('#ff858588')
        Blank()
      }.width('100%')
      .height(46)
      .padding({ left: 10, top: 10 })

      ForEach(this.foodsList, (item, index) => {
        FoodListItem({
          foodItem: item,
          foodItemIndex: index,
          modeName: this.modeName,
          foodListIndex: this.foodListIndex
        })
      })
    }
    .width('94%')
    .borderRadius(30)
    .margin(16)
    .padding({ bottom: 10 })
    .backgroundColor(Color.White)
  }
}