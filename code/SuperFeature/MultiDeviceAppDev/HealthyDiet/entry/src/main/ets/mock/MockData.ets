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

import { FoodInfo, CategoryId, MealTimeId, DietRecord } from '../model/DataModels'

export let mockFoods: Array<FoodInfo> = [
  {
    id: 0,
    letter: 'Tomato',
    name: $r('app.string.food_name_tomato'),
    image: $r('app.media.tomato'),
    categoryId: CategoryId.Vegetable,
    calories: 15,
    protein: 0.9,
    fat: 0.2,
    carbohydrates: 3.3,
    vitaminC: 14.0
  },
  {
    id: 1,
    letter: 'Walnut',
    name: $r('app.string.food_name_walnut'),
    image: $r('app.media.walnut'),
    categoryId: CategoryId.Nut,
    calories: 646,
    protein: 14.9,
    fat: 58.8,
    carbohydrates: 19.1,
    vitaminC: 1.0
  },
  {
    id: 2,
    letter: 'Cucumber',
    name: $r('app.string.food_name_cucumber'),
    image: $r('app.media.cucumber'),
    categoryId: CategoryId.Vegetable,
    calories: 16,
    protein: 0.8,
    fat: 0.2,
    carbohydrates: 2.9,
    vitaminC: 9.0
  },
  {
    id: 3,
    letter: 'Blueberry',
    name: $r('app.string.food_name_blueberry'),
    image: $r('app.media.blueberry'),
    categoryId: CategoryId.Fruit,
    calories: 57,
    protein: 0.7,
    fat: 0.3,
    carbohydrates: 14.5,
    vitaminC: 9.7
  },
  {
    id: 4,
    letter: 'Crab',
    name: $r('app.string.food_name_crab'),
    image: $r('app.media.crab'),
    categoryId: CategoryId.Seafood,
    calories: 97,
    protein: 19,
    fat: 1.5,
    carbohydrates: 0,
    vitaminC: 7.6
  },
  {
    id: 5,
    letter: 'IceCream',
    name: $r('app.string.food_name_ice_cream'),
    image: $r('app.media.icecream'),
    categoryId: CategoryId.Dessert,
    calories: 150,
    protein: 3.5,
    fat: 11,
    carbohydrates: 24,
    vitaminC: 0.6
  },
  {
    id: 6,
    letter: 'Onion',
    name: $r('app.string.food_name_onion'),
    image: $r('app.media.onion'),
    categoryId: CategoryId.Vegetable,
    calories: 40,
    protein: 1.1,
    fat: 0.2,
    carbohydrates: 9,
    vitaminC: 8.0
  },
  {
    id: 7,
    letter: 'Mushroom',
    name: $r('app.string.food_name_mushroom'),
    image: $r('app.media.mushroom'),
    categoryId: CategoryId.Vegetable,
    calories: 20,
    protein: 3.1,
    fat: 0.3,
    carbohydrates: 3.3,
    vitaminC: 206
  },
  {
    id: 8,
    letter: 'Kiwi',
    name: $r('app.string.food_name_kiwi'),
    image: $r('app.media.kiwi'),
    categoryId: CategoryId.Fruit,
    calories: 61,
    protein: 0.8,
    fat: 0.6,
    carbohydrates: 14.5,
    vitaminC: 62
  },
  {
    id: 9,
    letter: 'Pitaya',
    name: $r('app.string.food_name_pitaya'),
    image: $r('app.media.pitaya'),
    categoryId: CategoryId.Fruit,
    calories: 55,
    protein: 1.1,
    fat: 0.2,
    carbohydrates: 13.3,
    vitaminC: 3.0
  },
  {
    id: 10,
    letter: 'Avocado',
    name: $r('app.string.food_name_avocado'),
    image: $r('app.media.avocado'),
    categoryId: CategoryId.Fruit,
    calories: 171,
    protein: 2.0,
    fat: 15.3,
    carbohydrates: 7.4,
    vitaminC: 8.0
  },
  {
    id: 11,
    letter: 'Strawberry',
    name: $r('app.string.food_name_strawberry'),
    image: $r('app.media.strawberry'),
    categoryId: CategoryId.Fruit,
    calories: 32,
    protein: 1.0,
    fat: 0.2,
    carbohydrates: 7.1,
    vitaminC: 47.0
  }
]

export let mockFoodInfo: FoodInfo = {
  id: 0,
  letter: 'Tomato',
  name: $r('app.string.food_name_tomato'),
  image: $r('app.media.tomato'),
  categoryId: CategoryId.Vegetable,
  calories: 15,
  protein: 0.9,
  fat: 0.2,
  carbohydrates: 3.3,
  vitaminC: 14.0
}

export let mockDietRecords: Array<DietRecord> = [
  {
    id: 1,
    foodId: 2,
    mealTime: { name: $r('app.string.meal_time_dinner'), id: MealTimeId.Dinner },
    weight: 200
  },
  {
    id: 2,
    foodId: 8,
    mealTime: { name: $r('app.string.meal_time_dinner'), id: MealTimeId.Dinner },
    weight: 200
  },
  {
    id: 3,
    foodId: 6,
    mealTime: { name: $r('app.string.meal_time_lunch'), id: MealTimeId.Lunch },
    weight: 200
  },
  {
    id: 4,
    foodId: 3,
    mealTime: { name: $r('app.string.meal_time_dinner'), id: MealTimeId.Dinner },
    weight: 200
  }
]