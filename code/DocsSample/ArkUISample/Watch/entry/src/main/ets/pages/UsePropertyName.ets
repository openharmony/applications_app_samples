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
// [Start use_property_name]
@Entry
@Component
struct UsePropertyName {
  @State @Watch('countUpdated') apple: number = 0;
  @State @Watch('countUpdated') cabbage: number = 0;
  @State fruit: number = 0;

  // @Watch 回调
  countUpdated(propName: string): void {
    if (propName === 'apple') {
      this.fruit = this.apple;
    }
  }

  build() {
    Column() {
      Text(`Number of apples: ${this.apple.toString()}`).fontSize(30)
      Text(`Number of cabbages: ${this.cabbage.toString()}`).fontSize(30)
      Text(`Total number of fruits: ${this.fruit.toString()}`).fontSize(30)
      Button('Add apples')
        .onClick(() => {
          this.apple++;
        })
      Button('Add cabbages')
        .onClick(() => {
          this.cabbage++;
        })
    }
  }
}

// [End use_property_name]