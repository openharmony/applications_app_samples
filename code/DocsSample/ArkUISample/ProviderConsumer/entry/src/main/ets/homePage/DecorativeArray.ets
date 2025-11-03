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

// [Start Decorative_Array]
@Entry
@ComponentV2
export struct Parent  {
  @Provider() count: number[] = [1,2,3];

  build() {
    Row() {
      Column() {
        ForEach(this.count, (item: number) => {
          Text(`parent: ${item}`).fontSize(30)
          Divider()
        })
        Button('push').onClick(() => {
          this.count.push(111);
        })
        Button('reverse').onClick(() => {
          this.count.reverse();
        })
        Button('fill').onClick(() => {
          this.count.fill(6);
        })
        Child()
      }
      .width('100%')
    }
    .height('100%')
  }
}

@ComponentV2
struct Child {
  @Consumer() count: number[] = [9,8,7];

  build() {
    Column() {
      ForEach(this.count, (item: number) => {
        Text(`child: ${item}`).fontSize(30)
        Divider()
      })
      Button('push').onClick(() => {
        this.count.push(222);
      })
      Button('reverse').onClick(() => {
        this.count.reverse();
      })
      Button('fill').onClick(() => {
        this.count.fill(8);
      })
    }
    .width('100%')
  }
}
// [End Decorative_Array]