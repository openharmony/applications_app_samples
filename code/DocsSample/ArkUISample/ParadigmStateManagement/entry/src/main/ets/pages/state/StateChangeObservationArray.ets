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
// [Start state_change_observation_array]
class Model {
  public value: number;

  constructor(value: number) {
    this.value = value;
  }
}
// [End state_change_observation_array]

@Entry
@Component
struct Index {
  // [Start state_decorate_type_array]
  // 数组类型
  @State title: Model[] = [new Model(11), new Model(1)];

  // [End state_decorate_type_array]

  build() {
    Column({ space: 10 }) {
      Text(JSON.stringify(this.title))
      Button($r('app.string.state_decorate_array_change_text_01')).onClick(() => {
        // [Start state_decorate_array_change_01]
        // 数组赋值
        this.title = [new Model(2)];
        // [End state_decorate_array_change_01]
      })
      Button($r('app.string.state_decorate_array_change_text_02')).onClick(() => {
        // [Start state_decorate_array_change_02]
        // 数组项赋值
        this.title[0] = new Model(2);
        // [End state_decorate_array_change_02]
      })
      Button($r('app.string.state_decorate_array_change_text_03')).onClick(() => {
        // [Start state_decorate_array_change_03]
        // 数组项更改
        this.title.pop();
        // [End state_decorate_array_change_03]
      })
      Button($r('app.string.state_decorate_array_change_text_04')).onClick(() => {
        // [Start state_decorate_array_change_04]
        // 数组项更改
        this.title.push(new Model(12));
        // [End state_decorate_array_change_04]
      })
      Button($r('app.string.state_decorate_array_change_text_05')).onClick(() => {
        // [Start state_decorate_array_change_05]
        // 嵌套的属性赋值观察不到
        this.title[0].value = 6;
        // [End state_decorate_array_change_05]
      })

    }
  }
}

@Component
export struct StateChangeObservationArray {
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
