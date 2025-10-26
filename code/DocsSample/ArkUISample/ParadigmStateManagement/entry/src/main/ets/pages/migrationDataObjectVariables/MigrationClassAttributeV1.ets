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
@Component
export struct MigrationClassAttributeV1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };

  build() {
    NavDestination() {
      UserProfile()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.migration_class_attribute_v1'))
  }
}


// [Start Migration_Class_Attribute_V1]
@Observed
class User {
  @Track public name: string;
  @Track public age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Entry
@Component
struct UserProfile {
  @State user: User = new User('Alice', 30);

  build() {
    Column() {
      Text(`Name: ${this.user.name}`)
      Text(`Age: ${this.user.age}`)
      Button('increase age')
        .onClick(() => {
          this.user.age++;
        })
    }
  }
}
// [End Migration_Class_Attribute_V1]