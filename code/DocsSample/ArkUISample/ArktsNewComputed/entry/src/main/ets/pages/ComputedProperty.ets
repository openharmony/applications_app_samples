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

@Entry
@ComponentV2
export struct ComputedProperty {
  @Local count1: number = 1;
  @Local count2: number = 2;
  @Local count3: number = 3;

  // [Start computed_property]
  @Computed
  get sum() {
    return this.count1 + this.count2 + this.count3;
  }
  // [End computed_property]

  build() {
    NavDestination() {
      Column() {
        // [Start computed_property_text]
        Text(`${this.count1 + this.count2 + this.count3}`) // 计算this.count1 + this.count2 + this.count3
        Text(`${this.count1 + this.count2 + this.count3}`) // 重复计算this.count1 + this.count2 + this.count3
        Text(`${this.sum}`) // 读取@Computed sum的缓存值，节省上述重复计算
        Text(`${this.sum}`) // 读取@Computed sum的缓存值，节省上述重复计算
        // [End computed_property_text]
      }
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.computed_property_title')替换为实际资源文件，在本示例中该资源文件的value值为"使用@Computed计算属性"
    .title($r('app.string.computed_property_title'))
  }
}
