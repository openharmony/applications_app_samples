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

const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';
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
  name1: Name = name;

  build() {
    NavDestination() {
      Column() {
        // [Start ComputedProperty]
        Text(`${this.name1.count1 + this.name1.count2 + this.name1.count3}`) // 计算this.count1 + this.count2 + this.count3
        Text(`${this.name1.count1 + this.name1.count2 + this.name1.count3}`) // 重复计算this.count1 + this.count2 + this.count3
        Text(`${this.name1.sum}`) // 读取@Computed sum的缓存值，节省上述重复计算
        Text(`${this.name1.sum}`) // 读取@Computed sum的缓存值，节省上述重复计算
        // [End ComputedProperty]
      }
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.computed_property_title'))
  }
}
