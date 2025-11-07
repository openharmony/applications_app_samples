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
// [Start state_change_observation_object]
class Person {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

class Model {
  public value: string;
  public name: Person;

  constructor(value: string, person: Person) {
    this.value = value;
    this.name = person;
  }
}
// [End state_change_observation_object]

@Entry
@Component
struct Index {
  // [Start state_decorate_type_object]
  // class类型
  @State title: Model = new Model('Hello', new Person('World'));

  // [End state_decorate_type_object]

  aboutToAppear(): void {
    setTimeout(() => {

    }, 1000)
  }

  build() {
    Column({ space: 10 }) {
      Text(this.title.value)
      Text(this.title.name.value)
      Button($r('app.string.state_decorate_object_change_text_01')).onClick(() => {
        // [Start state_decorate_object_change_01]
        // class类型赋值
        this.title = new Model('Hi', new Person('ArkUI'));

        // [End state_decorate_object_change_01]
      })
      Button($r('app.string.state_decorate_object_change_text_02')).onClick(() => {
        // [Start state_decorate_object_change_02]
        // class属性的赋值
        this.title.value = 'Hi';

        // [End state_decorate_object_change_02]
      })
      Button($r('app.string.state_decorate_object_change_text_03')).onClick(() => {
        // [Start state_decorate_object_change_03]
        // 嵌套的属性赋值观察不到
        this.title.name.value = 'ArkUI';

        // [End state_decorate_object_change_03]
      })
    }
  }
}

@Component
export struct StateChangeObservationObject {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_change_observation_object'))
  }
}




