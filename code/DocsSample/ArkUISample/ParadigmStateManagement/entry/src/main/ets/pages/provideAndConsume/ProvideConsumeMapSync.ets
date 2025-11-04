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
// [Start provide_consume_map_sync]
@Component
struct Child {
  @Consume message: Map<number, string>

  build() {
    Column() {
      ForEach(Array.from(this.message.entries()), (item: [number, string]) => {
        Text(`${item[0]}`)
          .fontSize(30)
        Text(`${item[1]}`)
          .fontSize(30)
        Divider()
      })
      Button('Consume init Map')
        .onClick(() => {
          this.message = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);
        })
      Button('Consume set new one')
        .onClick(() => {
          this.message.set(4, 'd');
        })
      Button('Consume clear')
        .onClick(() => {
          this.message.clear();
        })
      Button('Consume replace the first item')
        .onClick(() => {
          this.message.set(0, 'aa');
        })
      Button('Consume delete the first item')
        .onClick(() => {
          this.message.delete(0);
        })
    }
  }
}


@Entry
@Component
struct MapSample {
  @Provide message: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']])

  build() {
    Row() {
      Column() {
        Button('Provide init Map')
          .onClick(() => {
            this.message = new Map([[0, 'a'], [1, 'b'], [3, 'c'], [4, 'd']]);
          })
        Child()
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End provide_consume_map_sync]

@Component
export struct ProvideConsumeMapSyncDecorator {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      MapSample()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.provide_consume_map_sync'))
  }
}