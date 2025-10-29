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
class Fruit1 {
  public apple: number = 5;
  public orange: number = 10;
}

@Component
struct Child11 {
  // @Prop传递Fruit类，当子类修改属性，父类不受影响
  @Prop fruit: Fruit1;

  build() {
    Column() {
      Text('child apple: ' + this.fruit.apple.toString())
      Text('child orange: ' + this.fruit.orange.toString())
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
@Component
struct Parent11 {
  @State parentFruit: Fruit1 = new Fruit1();

  build() {
    Column() {
      Text('parent apple: ' + this.parentFruit.apple.toString())
      Text('parent orange: ' + this.parentFruit.orange.toString())
      Child11({ fruit: this.parentFruit })
    }
  }
}
// [End Parent11_start]