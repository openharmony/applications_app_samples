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

import emitter from '@ohos.events.emitter'
import { FoodInfo, CategoryId } from '../model/DataModels'
import Logger from '../common/Logger'
import { getContextData, startMode, totast } from '../common/Util'
import { getFoodsData } from '../model/DataUtil'

const TAG = '[Sample_StartMode]'
const eventId = 1 // 设置一个Id，用来emitter传输
let abilityWant = getContextData()['want']

interface EventHub {
  emit(event: string, ...args: Object[]): void
}

interface GetFoodItemId {
  eventHub: EventHub
}

@Styles function cardStyle () {
  .height('100%')
  .padding({ top: 20, right: 20, left: 20 }) // The specific numerical unit here defaults to vp
  .backgroundColor(Color.White)
  .borderRadius(12)
}

@Component
struct CardTitle {
  private title: Resource
  private subtitle: Resource

  build() {
    Row() {
      Text(this.title)
        .fontSize(26)
      Blank()
      Text(this.subtitle)
        .fontSize(13)
        .fontColor('rgba(0,0,0,0.6)')
    }
    .width('100%')
    .height(26)
  }
}

@Component
struct PageTitle {
  private foodName: Resource = $r('app.string.title_food_detail')

  build() {
    Row() {
      Image($r('app.media.back'))
        .width(20)
        .height(20)
      Text(this.foodName)
        .fontSize(22)
        .margin({ left: 20 })
    }
    .padding(12)
    .width('100%')
    .onClick(() => {
      startMode({}, 'MainAbility')
    })
  }
}

@Component
struct FoodImageDisplay {
  @State imageBgColorA: number = 0
  @Link foodInfo: FoodInfo

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(this.foodInfo.image)
        .sharedTransition(this.foodInfo.letter, {
          duration: 400,
          delay: 100
        })
        .backgroundColor(`rgba(255, 255, 255, ${this.imageBgColorA})`)
        .objectFit(ImageFit.Contain)
      Row() {
        Text(this.foodInfo.name)
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 26, right: 6 })
      }
    }
    .height(280)
  }
}

@Component
struct ContentTable {
  @Link foodInfo: FoodInfo

  @Builder IngredientItem(title: Resource, colorValue: string, name: Resource, value: Resource) {
    Row() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .align(Alignment.Start)
      Row() {
        Circle({ width: 6, height: 6 })
          .margin({ right: 12 })
          .fill(colorValue)
        Text(name)
          .fontSize(18)
        Blank()
        Text(value)
          .fontSize(18)
      }
      .width('100%')
      .layoutWeight(2)
    }
    .margin({ bottom: 20 })
  }

  build() {
    Column() {
      this.IngredientItem($r('app.string.diet_record_calorie'), '#F54040', $r('app.string.diet_record_calorie'), $r('app.string.calorie_with_kcal_unit', this.foodInfo.calories.toString()))
      Row().height(20)
      this.IngredientItem($r('app.string.nutrition_element'), '#CCC', $r('app.string.nutrition_element'), $r('app.string.weight_with_gram_unit', this.foodInfo.protein.toString()))
      this.IngredientItem(null, '#F5D640', $r('app.string.diet_record_fat'), $r('app.string.weight_with_gram_unit', this.foodInfo.fat.toString()))
      this.IngredientItem(null, '#9E9EFF', $r('app.string.diet_record_carbohydrates'), $r('app.string.weight_with_gram_unit', this.foodInfo.carbohydrates.toString()))
      this.IngredientItem(null, '#53F540', $r('app.string.diet_record_vitaminC'), $r('app.string.weight_with_milligram_unit', this.foodInfo.vitaminC.toString()))
    }.cardStyle()
  }
}

@Component
struct CaloriesProgress {
  @Link foodInfo: FoodInfo
  private averageCalories: number = 0
  private totalCalories: number = 0
  private highCalories: boolean = false

  aboutToAppear() {
    switch (this.foodInfo.categoryId) {
      case CategoryId.Vegetable:
        this.averageCalories = 26
        break
      case CategoryId.Fruit:
        this.averageCalories = 60
        break
      case CategoryId.Nut:
        this.averageCalories = 606
        break
      case CategoryId.Seafood:
        this.averageCalories = 56
        break
      case CategoryId.Dessert:
        this.averageCalories = 365
        break
    }
    this.totalCalories = this.averageCalories * 2
    this.highCalories = this.foodInfo.calories < this.averageCalories
  }

  build() {
    Column() {
      CardTitle({ title: $r('app.string.diet_record_calorie'), subtitle: $r('app.string.unit_weight') })
      Row() {
        Text(this.foodInfo.calories.toString())
          .fontColor(this.getCalorieColor())
          .fontSize(65)
        Text($r('app.string.calorie_with_kcal_unit', ''))
          .fontSize(20)
          .margin({ bottom: 10 })
      }
      .margin({ top: 25, bottom: 25 })
      .alignItems(VerticalAlign.Bottom)

      Text(this.highCalories ? $r('app.string.high_calorie_food') : $r('app.string.low_calorie_food'))
        .fontSize(13)
        .fontColor('#313131')

      Progress({ value: this.foodInfo.calories, total: this.totalCalories, style: ProgressStyle.Linear })
        .style({ strokeWidth: 24 })
        .color(this.getCalorieColor())
        .margin({ top: 18 })
    }.cardStyle()
  }

  getCalorieColor() {
    return this.highCalories ? $r('app.color.high_calorie') : $r('app.color.low_calorie')
  }
}

@Component
struct StartModeCard {
  @Link foodData: FoodInfo[]
  @Link foodItemId: number
  @Link foodInfo: FoodInfo
  private modeName: string
  private foodListIndex: number

  async cateMode(foodItemId: number) {
    Logger.info(TAG, 'StartModeCard startMode start')
    if (this.modeName == 'standard') {
      startMode({ foodItemId, modeName: this.modeName, foodListIndex: this.foodListIndex }, 'StandardAbility')
    } else if (this.modeName == 'specified') {
      if (this.foodItemId == foodItemId) {
        totast()
        return
      }
      startMode({
        target: 'pages/FoodDetail',
        foodItemId,
        modeName: this.modeName,
        foodListIndex: this.foodListIndex
      }, 'SpecifiedAbility')
    } else {
      startMode({ foodItemId, modeName: this.modeName, foodListIndex: this.foodListIndex }, 'SingletonAbility')
      let innerEvent = {
        eventId
      }
      emitter.on(innerEvent, (eventData) => {
        this.foodItemId = eventData.data.foodItemId
        // 判断数据的id值是否为0
        if (this.foodItemId == 0) {
          this.foodInfo = getFoodsData()[this.foodListIndex][this.foodItemId+1] // 这里的1指的是下一条数据
          this.foodData = [getFoodsData()[this.foodListIndex][this.foodItemId]]
        } else {
          this.foodInfo = getFoodsData()[this.foodListIndex][this.foodItemId-1] // 这里的1指的是上一条数据
          this.foodData = [getFoodsData()[this.foodListIndex][this.foodItemId]]
        }
      })
    }
    Logger.info(TAG, 'StartModeCard startMode start')
  }

  build() {
    Column() {
      Text($r('app.string.otherFoods'))
        .width('100%')
        .height(50)
        .fontSize(16)
        .fontWeight(600)
        .fontColor('#ff858588')
      Grid() {
        ForEach(this.foodData, (item: FoodInfo) => {
          GridItem() {
            Row() {
              Image(item.image)
                .objectFit(ImageFit.Contain)
                .autoResize(false)
                .height(40)
                .width(40)
                .backgroundColor('#FFf1f3f5')
                .margin({ right: 16 })
                .borderRadius(6)
              Row() {
                Text(item.name)
                  .fontSize(18)
                  .fontWeight(600)
              }.width('80%')
            }
            .width('100%')
            .height(64)
            .padding({ left: 10, right: 20 })
            .onClick(() => {
              this.cateMode(item.id)
            })
          }
        })
      }
      .columnsTemplate('1fr')
      .columnsGap(10)
      .rowsGap(10)
    }
    .backgroundColor(Color.White)
    .borderRadius(12)
    .height(200)
    .padding({ left: 15, bottom: 15 })
    .margin({ top: 20, right: 10, left: 20 })
  }
}

@Entry
@Component
export struct FoodDetail {
  @State foodInfo: any = {}
  @State standardFoodData: FoodInfo[] = []
  @State specifiedFoodData: FoodInfo[] = []
  @State singletonFoodData: FoodInfo[] = []
  @State foodItemId: number = 0 // 接受want传过来的foodItemId,并根据此Id去筛选数据，初始值为0
  private foodData: Array<FoodInfo>[] = getFoodsData()
  private modeName: string
  private foodListIndex: number

  async aboutToAppear() {
    Logger.info(TAG, 'FoodDetail aboutToAppear start')
    this.foodItemId = await abilityWant.parameters.foodItemId
    this.modeName = await abilityWant.parameters.modeName
    this.foodListIndex = await abilityWant.parameters.foodListIndex
    this.foodInfo = this.foodData[this.foodListIndex].filter(item => {
      return this.foodItemId == item.id
    })[0]
    if (this.modeName === 'standard') {
      // 判断数据的id值是否为0
      if (this.foodItemId == 0) {
        this.foodItemId = 1 // 这里的1为了查找id为1的数据
        this.standardFoodData = [this.foodData[this.foodListIndex][this.foodItemId]]
      } else {
        this.foodItemId = 0 // 这里的0为了查找id为0的数据
        this.standardFoodData = [this.foodData[this.foodListIndex][this.foodItemId]]
      }
    } else if (this.modeName == 'specified') {
      this.specifiedFoodData = this.foodData[this.foodListIndex]
    } else {
      if (this.foodItemId == 0) {
        this.foodItemId = 1 // 这里的1为了查找id为1的数据
        this.singletonFoodData = [this.foodData[this.foodListIndex][this.foodItemId]]
      } else {
        this.foodItemId = 0 // 这里的0为了查找id为0的数据
        this.singletonFoodData = [this.foodData[this.foodListIndex][this.foodItemId]]
      }
    }
    Logger.info(TAG, 'FoodDetail aboutToAppear end')
  }

  build() {
    Scroll() {
      Column() {
        PageTitle()
        FoodImageDisplay({ foodInfo: $foodInfo })
        Swiper() {
          ContentTable({ foodInfo: $foodInfo })
          CaloriesProgress({ foodInfo: $foodInfo })
        }
        .clip(new Rect().width('100%').height('100%').radiusWidth(15).radiusHeight(15))
        .itemSpace(20)
        .height(330)
        .indicatorStyle({ selectedColor: $r('app.color.theme_color_green') })
        .margin({ top: 10, right: 10, left: 10 })

        if (this.modeName === 'standard') {
          StartModeCard({
            foodData: $standardFoodData,
            modeName: this.modeName,
            foodItemId: $foodItemId,
            foodInfo: $foodInfo,
            foodListIndex: this.foodListIndex
          })
        } else if (this.modeName === 'specified') {
          StartModeCard({
            foodData: $specifiedFoodData,
            modeName: this.modeName,
            foodItemId: $foodItemId,
            foodInfo: $foodInfo,
            foodListIndex: this.foodListIndex
          })
        } else {
          StartModeCard({
            foodData: $singletonFoodData,
            modeName: this.modeName,
            foodItemId: $foodItemId,
            foodInfo: $foodInfo,
            foodListIndex: this.foodListIndex
          })
        }
      }
      .alignItems(HorizontalAlign.Center)
    }
    .backgroundColor('#EDF2F5')
    .height('100%')
    .align(Alignment.Top)
  }
}
