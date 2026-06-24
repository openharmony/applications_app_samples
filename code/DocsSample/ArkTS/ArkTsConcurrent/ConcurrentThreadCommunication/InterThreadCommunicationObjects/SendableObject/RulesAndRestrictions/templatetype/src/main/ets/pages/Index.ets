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

// 泛型类中的Sendable class，collections.Array，collections.Map，collections.Set的模板类型必须是Sendable类型
// [Start counter_example]
import { collections } from '@kit.ArkTS';

try {
  let arr: collections.Array<number> = new collections.Array<number>();
  let num: number = 1;
  arr.push(num);
} catch (e) {
  console.error(`create collections error: Code: ${e.code}, message: ${e.message}`);
}
// [End counter_example]

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          try {
            let arr1: collections.Array<number> = new collections.Array<number>();
            let num: number = 1;
            arr1.push(num);
            this.message = 'success';
          } catch (e) {
            this.message = 'failed';
            console.error(`create collections error: Code: ${e.code}, message: ${e.message}`);
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
