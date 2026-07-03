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
// [Start Parent11_start]
const APPLE_INITIAL_COUNT = 5;
const ORANGE_INITIAL_COUNT = 10;

class Fruit {
  public apple: number = APPLE_INITIAL_COUNT;
  public orange: number = ORANGE_INITIAL_COUNT;
}

@Component
struct Child {
  // @Prop传递Fruit类，当子类修改属性，父类不受影响
  @Prop fruit: Fruit;

  build() {
    Column() {
      Text('child apple: ' + this.fruit.apple.toString())
        .fontSize(20)
        .margin(10)
      Text('child orange: ' + this.fruit.orange.toString())
        .fontSize(20)
        .margin(10)
      Button('apple+1')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.fruit.apple++; // 修改子组件@Prop对象，父组件不受影响
        })
      Button('orange+1')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.fruit.orange++;
        })
    }
    .width('100%')
  }
}

@Entry
@Component
struct Parent {
  @State parentFruit: Fruit = new Fruit();

  build() {
    Column() {
      Text('parent apple: ' + this.parentFruit.apple.toString())
        .fontSize(20)
        .margin(10)
      Text('parent orange: ' + this.parentFruit.orange.toString())
        .fontSize(20)
        .margin(10)
      Child({ fruit: this.parentFruit })
    }
    .width('100%')
  }
}
// [End Parent11_start]
const parent11 = Parent;
export default parent11;