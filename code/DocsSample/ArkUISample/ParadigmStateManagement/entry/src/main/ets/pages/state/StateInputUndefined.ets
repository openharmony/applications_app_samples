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
// [Start state_input_undefined]
@Entry
@Component
struct Parent {
  @State count: number | undefined = undefined;

  build() {
    Column() {
      Text(`Parent count value: ${this.count}`)
        .fontSize(20)
        .margin(10)
      Child({ count: this.count })
    }
  }
}

@Component
struct Child {
  @State count: number | undefined = 0;

  build() {
    Column() {
      Text(`Child count value: ${this.count}`)
        .fontSize(20)
        .margin(10)
    }
  }
}
// [End state_input_undefined]

@Component
export struct StateInputUndefined {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_input_undefined'))
  }
}