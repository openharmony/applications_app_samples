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

// [Start prop_ten_start]
@Component
struct Child {
  @Prop value: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);

  build() {
    Column() {
      ForEach(Array.from(this.value.entries()), (item: [number, string]) => {
        Text(`${item[0]}`).fontSize(30)
        Text(`${item[1]}`).fontSize(30)
        Divider()
      })
      Button('child init map').onClick(() => {
        this.value = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);
      })
      Button('child set new one').onClick(() => {
        this.value.set(4, 'd');
      })
      Button('child clear').onClick(() => {
        this.value.clear();
      })
      Button('child replace the first one').onClick(() => {
        this.value.set(0, 'aa');
      })
      Button('child delete the first one').onClick(() => {
        this.value.delete(0);
      })
    }
  }
}


@Entry
@Component
struct MapSample {
  @State message: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);

  build() {
    Row() {
      Column() {
        Child({ value: this.message })
      }
      .width('100%')
    }
    .height('100%')
  }
}

// [End prop_ten_start]

@Builder
export function MyMapSampleBuilder() {
  MapSample()
}