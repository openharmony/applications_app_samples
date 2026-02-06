/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start v2_to_v1_common_buildIn_class]
@Component
struct ChildEight {
  // V1从V2接收的状态变量，仅可使用@State、@Prop、@Provide接收
  @Provide set: Set<number> = new Set();

  build() {
    Column() {
      ForEach(Array.from(this.set.values()), (item: number) => { // 显示Set
        Text(`${item}`)
          .fontSize(30)
      })
    }
  }
}

@Entry
@ComponentV2
struct IndexEight {
  // @Local set: Set<number> = new Set([10, 20]); // 错误写法。内置类型状态变量，不支持传递；消除编译错误请去掉@Local
  set: Set<number> = new Set([10, 20]); // 正确写法。

  build() {
    Column() {
      ChildEight({
        set: this.set
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End v2_to_v1_common_buildIn_class]