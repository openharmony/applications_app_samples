/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// 不能使用对象字面量/数组字面量初始化Sendable类型
// 正例：
import { collections } from '@kit.ArkTS';

let arr1: collections.Array<number> = new collections.Array<number>(1, 2, 3); // 是Sendable类型

// 反例：
// import { collections } from '@kit.ArkTS';
//
// let arr2: collections.Array<number> = [1, 2, 3]; // 不是Sendable类型，编译报错
// let arr3: number[] = [1, 2, 3]; // 不是Sendable类型，正例，不报错
// let arr4: number[] = new collections.Array<number>(1, 2, 3); // 编译报错

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
          console.log('result:', arr1);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}