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

// [Start state_scene_type_class]
class Model {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

@Entry
@Component
struct EntryComponent {
  build() {
    Column() {
      // 此处指定的参数都将在初始渲染时覆盖本地定义的默认值，并不是所有的参数都需要从父组件初始化
      MyComponent({ count: 1, increaseBy: 2 })
        .width(300)
      MyComponent({ title: new Model('Hello World 2'), count: 7 })
    }
  }
}

@Component
struct MyComponent {
  @State title: Model = new Model('Hello World');
  @State count: number = 0;
  increaseBy: number = 1;

  build() {
    Column() {
      Text(`${this.title.value}`)
        .margin(10)
      Button(`Click to change title`)
        .onClick(() => {
          // @State变量的更新将触发上面的Text组件内容更新
          this.title.value = this.title.value === 'Hello ArkUI' ? 'Hello World' : 'Hello ArkUI';
        })
        .width(300)
        .margin(10)

      Button(`Click to increase count = ${this.count}`)
        .onClick(() => {
          // @State变量的更新将触发该Button组件的内容更新
          this.count += this.increaseBy;
        })
        .width(300)
        .margin(10)
    }
  }
}
// [End state_scene_type_class]

@Component
export struct StateSceneTypeClass {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      MyComponent()
      // [Start state_scene_type_class_local_init]
      // title没有外部传入，使用本地的值new Model('Hello World')进行初始化
      MyComponent({ count: 1, increaseBy: 2 })
      // increaseBy没有外部传入，使用本地的值1进行初始化
      MyComponent({ title: new Model('Hello World 2'), count: 7 })
      // [End state_scene_type_class_local_init]

      // [Start state_scene_type_class_out_value_init]
      // count和increaseBy均有外部传入，分别使用传入的1和2进行初始化
      MyComponent({ count: 1, increaseBy: 2 })
      // title和count均有外部传入，分别使用传入的new Model('Hello World 2')和7进行初始化
      MyComponent({ title: new Model('Hello World 2'), count: 7 })
      // [End state_scene_type_class_out_value_init]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_scene_type_class'))
  }
}