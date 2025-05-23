/*
 * Copyright (c) 2021-2025 Huawei Device Co., Ltd.
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
import { FoodData } from '../model/FoodData';

@Component
struct PageTitle {
  build() {
    Row() {
      Image($r('app.media.Back'))
        .width(21.8)
        .height(19.6)
        .id('back')
      Text('Food Detail')
        .fontSize(21.8)
        .margin({ left: 17.4 })
    }
    .alignItems(VerticalAlign.Top)
    .height(61)
    .backgroundColor('#FFedf2f5')
    .padding({ top: 13, bottom: 15, left: 28.3 })
    .onClick(() => {
      router.back()
    })
  }
}

@Component
struct FoodImageDisplay {
  @Prop foodItem: FoodData;

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(this.foodItem.image)
        .objectFit(ImageFit.Contain)
      Text(this.foodItem.name)
        .fontSize(26)
        .fontWeight(500)
        .margin({ left: 26, bottom: 17.4 })
    }
    .backgroundColor('#FFedf2f5')
    .height(357)
  }
}

@Component
struct ContentTable {
  @Prop foodItem: FoodData;

  @Builder IngredientItem(title: string, name: string, value: string) {
    Row() {
      Text(title)
        .fontSize(17.4)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
      Row() {
        Text(name)
          .fontSize(17.4)
          .flexGrow(1)
        Text(value)
          .fontSize(17.4)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .layoutWeight(2)
    }
  }

  build() {
    Column() {
      this.IngredientItem('Calories', 'Calories', this.foodItem.calories + 'kcal')
      this.IngredientItem('Nutrition', 'Protein', this.foodItem.protein + 'g')
      this.IngredientItem(' ', 'Fat', this.foodItem.fat + 'g')
      this.IngredientItem(' ', 'Carbohydrates', this.foodItem.carbohydrates + 'g')
      this.IngredientItem(' ', 'VitaminC', this.foodItem.vitaminC + 'mg')
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 20, right: 20, left: 20 })
    .height(250)
  }
}

interface RouteParamsType {
  foodId: FoodData
}

@Entry
@Component
struct FoodDetail {
  @State foodItem: FoodData | undefined = undefined;

  aboutToAppear() {
    this.foodItem = (this.getUIContext().getRouter().getParams() as RouteParamsType).foodId;
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        FoodImageDisplay({ foodItem: this.foodItem })
        PageTitle()
      }

      ContentTable({ foodItem: this.foodItem })
    }
    .alignItems(HorizontalAlign.Center)
  }
}