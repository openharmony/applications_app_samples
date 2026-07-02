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
// [Start Parent23_start]
@Observed
class Person {
  public name: string;
  public age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Component
struct Child {
  // @ObjectLink接收@Observed装饰的类对象，属性变化双向同步
  @ObjectLink person: Person;

  build() {
    Column() {
      Text(`Child name: ${this.person.name}`)
        .fontSize(20)
        .margin(10)
      Text(`Child age: ${this.person.age}`)
        .fontSize(20)
        .margin(10)
      Button('age+1')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.person.age++; // 子组件修改对象属性，父子组件同步刷新
        })
    }
    .width('100%')
  }
}

@Entry
@Component
struct Parent {
  @State person: Person = new Person('Alice', 20);

  build() {
    Column() {
      Text(`Parent name: ${this.person.name}`)
        .fontSize(20)
        .margin(10)
      Text(`Parent age: ${this.person.age}`)
        .fontSize(20)
        .margin(10)
      Child({ person: this.person }) // 传递对象给子组件
    }
    .width('100%')
  }
}
// [End Parent23_start]
const parent23 = Parent;
export default parent23;
