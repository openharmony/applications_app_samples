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

// [Start v2_to_v1_simpleData]
// 模拟三方库导入的V1组件
@Component
struct ThirdPartyComp {
  // V1从V2接收的状态变量，仅可使用@State、@Prop、@Provide接收
  @State prop: boolean = true; // 可以观测到变化

  build() {
    Column() {
      Text(`ThirdPartyComp：${this.prop}`)
    }
  }
}

@Entry
@ComponentV2
struct V2Comp2 {
  @Local param: boolean = false;

  build() {
    Column() {
      Text(`V2Comp2：${this.param}`)

      // V2组件向V1的三方库传递简单状态变量
      ThirdPartyComp({ prop: this.param })
    }
  }
}
// [End v2_to_v1_simpleData]