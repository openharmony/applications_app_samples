/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { COLLECTION_CATEGORIES } from '../data/CollectionCategory'
import { FirstLevelCategory } from '../model/CategoricalDataType'
import { TabContentNavigation } from '../common/TabContentNavigation'

@Entry
@Component
struct Index {
  @State tabsIndex: number = 0

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      ForEach(COLLECTION_CATEGORIES, (item: FirstLevelCategory, index: number) => {
        TabContent() {
          TabContentNavigation({ categories: item.childNodes })
        }
        .tabBar(this.TabBarBuilder(index, item.selectedImage, item.unselectedImage, item.tabBarName))
      })
    }
    .barHeight(56)
    .barWidth('100%')
    .vertical(false)
    .backgroundColor($r('app.color.background_shallow_grey'))
    .onChange((index: number) => {
      this.tabsIndex = index
    })
  }

  @Builder TabBarBuilder(index: number, selectedImage: Resource, unselectedImage: Resource, tabBarName: Resource) {
    Column() {
      Image(this.tabsIndex === index ? selectedImage : unselectedImage)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })

      Text(tabBarName)
        .fontSize(10)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor(this.tabsIndex === index ? $r('app.color.tab_bar_select') : $r('app.color.tab_bar_unselect'))
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
    .alignItems(HorizontalAlign.Center)
  }
}