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
// 正例：
import { collections } from '@kit.ArkTS';


// 反例：
// import { collections } from '@kit.ArkTS';
//
// try {
//   let arr1: collections.Array<Array<number>> = new collections.Array<Array<number>>();
//   let arr2: Array<number> = new Array<number>();
//   arr2.push(1);
//   arr1.push(arr2);
// } catch (e) {
//   console.error(`taskpool execute: Code: ${e.code}, message: ${e.message}`);
// }

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
          } catch (e) {
            console.error(`taskpool execute: Code: ${e.code}, message: ${e.message}`);
          }
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}