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
// [Start Parent12_start]
@ObservedV2
class Fruit2 {
  @Trace public  apple: number = 5;
  @Trace public orange: number = 10;

  // 实现深拷贝，子组件不会修改父组件的数据
  clone(): Fruit2 {
    let newFruit: Fruit2 = new Fruit2();
    newFruit.apple = this.apple;
    newFruit.orange = this.orange;
    return newFruit;
  }
}

@ComponentV2
struct Child12 {
  @Param fruit: Fruit2 = new Fruit2();

  build() {
    Column() {
      Text('child')
      Text(this.fruit.apple.toString())
      Text(this.fruit.orange.toString())
      Button('apple+1')
        .onClick(() => {
          this.fruit.apple++;
        })
      Button('orange+1')
        .onClick(() => {
          this.fruit.orange++;
        })
    }
  }
}

@Entry
@ComponentV2
struct Parent12 {
  @Local parentFruit: Fruit2 = new Fruit2();

  build() {
    Column() {
      Text('parent')
      Text(this.parentFruit.apple.toString())
      Text(this.parentFruit.orange.toString())
      Child12({ fruit: this.parentFruit.clone() })
    }
  }
}
// [End Parent12_start]