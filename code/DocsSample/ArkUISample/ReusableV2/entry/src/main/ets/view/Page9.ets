/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
// [Start Use_in_the_'each'_attribute_of_the_Repeat_component_in_non_lazy_loading_scenarios]
import { ReusableV2Component6 } from '../common/ReusableV2Component6';
@Entry
@ComponentV2
struct Page9 {
  @Local condition: boolean = true;
  @Local simpleList: number[] = [];

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.simpleList.push(i)
    }
  }

  build() {
    Column() {
      Button('改变condition').onClick(() => {
        this.condition = !this.condition;
      })
      if (this.condition) {
        // 此处仅做演示使用，让复用池中填充3个组件
        ReusableV2Component6({ num: 0 })
        ReusableV2Component6({ num: 0 })
        ReusableV2Component6({ num: 0 })
      }
      List({ space: 10 }) {
        Repeat(this.simpleList)
          .virtualScroll()
          .each((obj: RepeatItem<number>) => {
            ListItem() {
              Column() {
                ReusableV2Component6({ num: obj.item })
              }
            }
          })
      }.height('50%')
      .cachedCount(2)
    }
  }
}
// [End Use_in_the_'each'_attribute_of_the_Repeat_component_in_non_lazy_loading_scenarios]