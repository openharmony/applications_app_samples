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
@Component
export struct LocalUseCaseArray {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.local_use_case_array'))
  }
}

// [Start Local_Use_Case_Array]
@Entry
@ComponentV2
struct Index {
  @Local count: number[] = [1, 2, 3];

  build() {
    Row() {
      Column() {
        ForEach(this.count, (item: number) => {
          Text(`${item}`).fontSize(30)
          Divider()
        })
        Button('init array').onClick(() => {
          this.count = [9, 8, 7];
        })
        Button('push').onClick(() => {
          this.count.push(0);
        })
        Button('reverse').onClick(() => {
          this.count.reverse();
        })
        Button('fill').onClick(() => {
          this.count.fill(6);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Local_Use_Case_Array]