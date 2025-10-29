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
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Name {
  @Trace public count1: number = 1;
  @Trace public count2: number = 2;
  @Trace public count3: number = 3;

  // [Start ComputedProperty]
  @Computed
  get sum() {
    return this.count1 + this.count2 + this.count3;
  }
  // [End ComputedProperty]
}

const name: Name = new Name();

@Entry
@ComponentV2
export struct ComputedProperty {
  name: Name = name;

  build() {
    NavDestination() {
      Column() {
        // [Start ComputedProperty_Text]
        Text(`${this.name.count1 + this.name.count2 + this.name.count3}`) // 计算this.count1 + this.count2 + this.count3
        Text(`${this.name.count1 + this.name.count2 + this.name.count3}`) // 重复计算this.count1 + this.count2 + this.count3
        Text(`${this.name.sum}`) // 读取@Computed sum的缓存值，节省上述重复计算
        Text(`${this.name.sum}`) // 读取@Computed sum的缓存值，节省上述重复计算
        // [End ComputedProperty_Text]
      }
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.computed_property_title'))
  }
}
