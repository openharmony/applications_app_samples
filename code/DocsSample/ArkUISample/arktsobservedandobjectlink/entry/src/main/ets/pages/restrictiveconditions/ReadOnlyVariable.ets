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
// [Start variables_decorated_ObjectLink_read_only]

@Observed
class Info {
  public count: number;

  constructor(count: number) {
    this.count = count;
  }
}

@Component
struct Child {
  @ObjectLink num: Info;

  build() {
    Column() {
      Text(`num value: ${this.num.count}`)
        .fontSize(20)
        .margin(10)
        .onClick(() => {
          // 正确写法，可以更改@ObjectLink装饰变量的成员属性
          this.num.count = 20;
        })
    }
    .width('100%')
  }
}

@Entry
@Component
struct Parent {
  @State num: Info = new Info(10);

  build() {
    Column() {
      Text(`count value: ${this.num.count}`)
        .fontSize(20)
        .margin(10)
      Button('click')
        .width(300)
        .margin(10)
        .onClick(() => {
          // 可以在父组件做整体替换
          this.num = new Info(30);
        })
      Child({ num: this.num })
    }
    .width('100%')
  }
}
// [End variables_decorated_ObjectLink_read_only]
const readOnlyVariableParent = Parent;
export default readOnlyVariableParent;
