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
import {
  FoodInfo,
  Category,
  CategoryId,
  MealTimeId,
  OneMealStatisticsInfo,
  MealFoodInfo,
  DietRecord
} from './DataModels'
import { mockFoods, mockFoodInfo, mockDietRecords } from '../mock/MockData'

const DEBUG_PREVIEW = false
const MOCK_API = true

export function getFoods(): Array<FoodInfo> {
  return mockFoods
}

export function getFoodInfo(): FoodInfo {
  return DEBUG_PREVIEW ? mockFoodInfo : router.getParams()['foodId']
}

// make records ordered by meal time
export let initDietRecords: Array<DietRecord> = [
  {
    id: -1,
    foodId: 0,
    mealTime: { name: $r('app.string.meal_time_breakfast'), id: MealTimeId.Breakfast },
    weight: 0,
    key: '1'
  },
  {
    id: -1,
    foodId: 0,
    mealTime: { name: $r('app.string.meal_time_lunch'), id: MealTimeId.Lunch },
    weight: 0,
    key: '2'
  },
  {
    id: -1,
    foodId: 0,
    mealTime: { name: $r('app.string.meal_time_dinner'), id: MealTimeId.Dinner },
    weight: 0,
    key: '3'
  },
  {
    id: -1,
    foodId: 0,
    mealTime: { name: $r('app.string.meal_time_supper'), id: MealTimeId.Supper },
    weight: 0,
    key: '4'
  }]

export function getDietRecords(): Array<DietRecord> {
  return DEBUG_PREVIEW ? initDietRecords.concat(mockDietRecords) :
  AppStorage.Get<Array<DietRecord>>('dietRecords')
}

export function getFoodCategories(): Category[] {
  return [{ id: CategoryId.Vegetable, name: $r('app.string.category_vegetable') },
    { id: CategoryId.Fruit, name: $r('app.string.category_fruit') },
    { id: CategoryId.Nut, name: $r('app.string.category_nut') },
    { id: CategoryId.Seafood, name: $r('app.string.category_seafood') },
    { id: CategoryId.Dessert, name: $r('app.string.category_dessert') }]
}

export function getMileTimes(): string[] {
  if (MOCK_API) {
    return ['早餐', '午餐', '晚餐', '夜宵']
  } else {
    let mealTimeResources: Resource[] = [$r("app.string.meal_time_breakfast"), $r('app.string.meal_time_lunch'), $r('app.string.meal_time_dinner'), $r('app.string.meal_time_supper'), $r('app.string.category_dessert')]
    let mealTimes = []
    mealTimeResources.forEach(item => {
      let mealTime = this.context.resourceManager.getStringSync(item.id)
      if (mealTime !== '') {
        mealTimes.push(mealTime)
      }
    })
    return mealTimes
  }
}

export function getSortedFoodData(): Array<FoodInfo> {
  var letterReg = /^[A-Z]$/
  var list = new Array()
  var foods = getFoods()
  for (var i = 0;i < foods.length; i++) {
    list['#'] = new Array()
    // convert the first letter to uppercase
    var letter = foods[i].letter.substr(0, 1).toUpperCase()
    if (!letterReg.test(letter)) {
      letter = '#'
    }
    // create group by letter
    if (!(letter in list)) {
      list[letter] = new Array()
    }
    list[letter].push(foods[i])
  }

  // sort by alphabetical order
  var letterGroup = new Array()
  for (var key in list) {
    letterGroup.push({
      letter: key,
      list: list[key]
    })
  }
  letterGroup.sort(function (x, y) {
    return x.letter.charCodeAt(0) - y.letter.charCodeAt(0)
  })

  // put '#' to last for others
  var lastArr = letterGroup[0]
  letterGroup.splice(0, 1)
  letterGroup.push(lastArr)

  // create result list
  var resultList = []
  for (var i = 0; i < letterGroup.length; i++) {
    resultList.push(letterGroup[i].letter)
    resultList = resultList.concat(letterGroup[i].list)
  }
  return resultList
}

export function statistics(): Array<OneMealStatisticsInfo> {
  console.info('meal statistics')
  let dietRecords = getDietRecords()
  const mealMap = new Map()
  dietRecords.forEach((item) => {
    let oneMealStatisticsInfo: OneMealStatisticsInfo = mealMap.get(item.mealTime.id)
    if (oneMealStatisticsInfo === undefined) {
      oneMealStatisticsInfo = new OneMealStatisticsInfo(item.mealTime)
    }
    var foodInfo = getFoods().find((food) => {
      return food.id === item.foodId
    })
    var calories = foodInfo.calories * item.weight
    var protein = foodInfo.protein * item.weight
    var fat = foodInfo.fat * item.weight
    var carbohydrates = foodInfo.carbohydrates * item.weight
    oneMealStatisticsInfo.mealFoods.push(new MealFoodInfo(item.id, foodInfo.name, foodInfo.image, calories,
      protein, fat, carbohydrates, item.weight, item.key))
    oneMealStatisticsInfo.totalFat += fat
    oneMealStatisticsInfo.totalCalories += calories
    oneMealStatisticsInfo.totalCarbohydrates += carbohydrates
    oneMealStatisticsInfo.totalProtein += protein
    oneMealStatisticsInfo.key = item.key
    mealMap.set(item.mealTime.id, oneMealStatisticsInfo)
  })

  return Array.from(mealMap.values())
}

export function updateDietWeight(recordId: number, weight: number) {
  let dietRecords = getDietRecords()
  let index = dietRecords.findIndex((record) => {
    return record.id === recordId
  })
  dietRecords[index].weight = weight
  AppStorage.SetOrCreate<Array<DietRecord>>('dietRecords', dietRecords)
}