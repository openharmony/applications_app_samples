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

// [Start provide_consume_This_Object]
class Animal {
  public name: string;
  public type: string;
  public age: number;

  constructor(name: string, type: string, age: number) {
    this.name = name;
    this.type = type;
    this.age = age;
  }

  static changeName(animal: Animal) {
    animal.name = 'Jack';
  }

  static changeAge(animal: Animal) {
    animal.age += 1;
  }
}

@Entry
@Component
struct Zoo {
  @Provide dog: Animal = new Animal('WangCai', 'dog', 2);

  changeZooDogAge(animal: Animal) {
    animal.age += 2;
  }

  build() {
    Column({ space: 10 }) {
      Text(`Zoo: This is a ${this.dog.age}-year-old ${this.dog.type} named ${this.dog.name}.`)
        .fontColor(Color.Red)
        .fontSize(30)
      Button('changeAge')
        .onClick(() => {
          // 通过赋值给临时变量保留Proxy代理
          let newDog = this.dog;
          Animal.changeAge(newDog);
        })
      Button('changeZooDogAge')
        .onClick(() => {
          // 通过赋值给临时变量保留Proxy代理
          let newDog = this.dog;
          this.changeZooDogAge(newDog);
        })
      ZooChild()
    }
  }
}

@Component
struct ZooChild {
  build() {
    Column({ space: 10 }) {
      Text(`ZooChild.`)
        .fontColor(Color.Blue)
        .fontSize(30)
      ZooGrandChild()
    }
  }
}

@Component
struct ZooGrandChild {
  @Consume dog: Animal;

  changeZooGrandChildName(animal: Animal) {
    animal.name = 'Marry';
  }

  build() {
    Column({ space: 10 }) {
      Text(`ZooGrandChild: This is a ${this.dog.age}-year-old ${this.dog.type} named ${this.dog.name}.`)
        .fontColor(Color.Yellow)
        .fontSize(30)
      Button('changeName')
        .onClick(() => {
          // 通过赋值给临时变量保留Proxy代理
          let newDog = this.dog;
          Animal.changeName(newDog);
        })
      Button('changeZooGrandChildName')
        .onClick(() => {
          // 通过赋值给临时变量保留Proxy代理
          let newDog = this.dog;
          this.changeZooGrandChildName(newDog);
        })
    }
  }
}
// [End provide_consume_This_Object]

@Component
export struct ProvideConsumeThisObject {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Zoo()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.provide_consume_this_object'))
  }
}