/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

@Component
  // [Start prop_four_start]
struct Child {
  @Prop value: number = 0;

  build() {
    Text(`${this.value}`)
      .fontSize(50)
      .onClick(() => {
        this.value++;
      })
  }
}

@Entry
@Component
struct Index {
  @State arr: number[] = [1, 2, 3];

  build() {
      Row() {
        Column() {
          Child({ value: this.arr[0] })
          Child({ value: this.arr[1] })
          Child({ value: this.arr[2] })

          Divider().height(5)

          ForEach(this.arr,
            (item: number) => {
              Child({ value: item })
            },
            (item: number) => item.toString()
          )
          Text('replace entire arr')
            .fontSize(50)
            .onClick(() => {
              // 两个数组都包含项“3”。
              this.arr = this.arr[0] == 1 ? [3, 4, 5] : [1, 2, 3];
            })
        }
      }
      // [EndExclude prop_four_start]
  }
}
// [End prop_four_start]
@Builder
export function MyIndexBuilder(){
  Index()
}