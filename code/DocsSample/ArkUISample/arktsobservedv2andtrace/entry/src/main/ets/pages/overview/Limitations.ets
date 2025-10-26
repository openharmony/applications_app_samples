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
// [Start Observed_Limitations]
@Observed
class FatherLim {
 public son: SonLim;

  constructor(name: string, age: number) {
    this.son = new SonLim(name, age);
  };
};
@Observed
class SonLim {
 public name: string;
 public age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  };
};
@Entry
@Component
struct Limitations {
  @State father: FatherLim = new FatherLim('John', 8);

  build() {
    Row() {
      Column() {
        Text(`name: ${this.father.son.name} age: ${this.father.son.age}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.father.son.age++;
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Observed_Limitations]