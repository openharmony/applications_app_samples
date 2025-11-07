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

// [Start deep_copy_reverse]
@Observed
class DeepReMyClass {
  public num: number = 0;

  constructor(num: number) {
    this.num = num;
  }
}

@Component
struct DeepRePropChild {
  @Prop testClass: DeepReMyClass; // @Prop装饰状态变量会深拷贝。

  build() {
    Text(`PropChild testNum ${this.testClass.num}`)
  }
}

@Entry
@Component
struct DeepReParent {
  @State testClass: DeepReMyClass[] = [new DeepReMyClass(1)];

  build() {
    Column() {
      Text(`DeepReParent testNum ${this.testClass[0].num}`)
        .onClick(() => {
          this.testClass[0].num += 1;
        })

      // DeepRePropChild没有改变@Prop testClass: DeepReMyClass的值，所以这时最优的选择是使用@ObjectLink。
      DeepRePropChild({ testClass: this.testClass[0] })
    }
  }
}
// [End deep_copy_reverse]