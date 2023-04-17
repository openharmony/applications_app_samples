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

import Logger from '../../common/Logger'
import { startMode } from '../../common/Util'
import { FoodInfo } from '../../model/DataModels'

const TAG = '[Sample_StartMode]'

@Component
export struct FoodListItem {
  private foodItem: FoodInfo
  private foodItemIndex: number
  private modeName: string
  private foodListIndex: number

  cateData() {
    Logger.info(TAG, 'cateData start')
    if (this.modeName === 'standard') {
      startMode({
        foodItemId: this.foodItem.id,
        modeName: this.modeName,
        foodListIndex: this.foodListIndex
      }, 'StandardAbility')
    } else if (this.modeName === 'specified') {
      startMode({
        target: 'pages/FoodDetail',
        foodItemId: this.foodItem.id,
        modeName: this.modeName,
        foodListIndex: this.foodListIndex
      }, 'SpecifiedAbility')
    } else {
      startMode({
        foodItemId: this.foodItem.id,
        foodListIndex: this.foodListIndex,
        modeName: this.modeName
      }, 'SingletonAbility')
    }
    Logger.info(TAG, 'cateData end')
  }

  build() {
    Column() {
      Row() {
        Image(this.foodItem.image)
          .objectFit(ImageFit.Contain)
          .autoResize(false)
          .height(40)
          .width(40)
          .backgroundColor('#FFf1f3f5')
          .margin({ right: 16 })
          .borderRadius(6)
        Text(this.foodItem.name)
          .fontSize(18)
          .fontWeight(600)
      }
      .width('100%')
      .height(64)
      .onClick(() => {
        this.cateData()
      })
    }.margin({ right: 24, left: 32 })
  }
}