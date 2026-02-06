/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start prop_nineteen_start]
@Entry
@Component
struct Index {
  @State message: number[] = [0, 1, 2, 3];

  build() {
    Column() {
      Child({ message: this.message })
    }
  }
}

@Component
struct Child {
  @Prop message: number[] = [0, 1, 2, 3];

  build() {
    Row() {
      Column() {
        ForEach(this.message, (item: number) => {
          Text(`${item}`)
            .fontSize(20)
            .margin(10)
        })
        // 新增数组元素，触发UI刷新
        Button('Push element')
          .onClick(() => {
            this.message.push(4);
          })
          .width(300)
          .margin(10)
        // 删除数组元素，触发UI刷新
        Button('Pop element')
          .onClick(() => {
            this.message.pop();
          })
          .width(300)
          .margin(10)
        // 对数组整体重新赋值，触发UI刷新
        Button('Reset array')
          .onClick(() => {
            this.message = [9, 8, 7, 6];
          })
          .width(300)
          .margin(10)
        // 更新数组元素，触发UI刷新
        Button('Modify element[0]')
          .onClick(() => {
            this.message[0] = 10;
          })
          .width(300)
          .margin(10)
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End prop_nineteen_start]
