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

// [Start state_scene_type_array]
class Fruit {
  public name: string;

  constructor(name: string) {
    this.name = name;
  }
}

@Entry
@Component
struct ArraySample {
  @State fruits: Fruit[] = [new Fruit('apple'), new Fruit('banana')]; // 使用@State装饰Array类型变量

  build() {
    Row() {
      Column() {
        ForEach(this.fruits, (item: Fruit) => {
          Text(`${item.name}`)
            .fontSize(20)
            .margin(10)
        })
        // 对数组元素重新赋值，触发UI刷新
        Button('Set element at index 0')
          .onClick(() => {
            this.fruits[0] = new Fruit('orange');
          })
          .width(300)
          .margin(10)
        // 新增数组元素，触发UI刷新
        Button('Push element')
          .onClick(() => {
            this.fruits.push(new Fruit('cherry'));
          })
          .width(300)
          .margin(10)
        // 删除数组元素，触发UI刷新
        Button('Pop element')
          .onClick(() => {
            this.fruits.pop();
          })
          .width(300)
          .margin(10)
        // 对数组整体重新赋值，触发UI刷新
        Button('Reset array')
          .onClick(() => {
            this.fruits = [new Fruit('strawberry'), new Fruit('blueberry')];
          })
          .width(300)
          .margin(10)
        // 修改嵌套的属性，无法触发UI刷新
        Button('Modify element[0] property')
          .onClick(() => {
            this.fruits[0].name = 'pineapple';
          })
          .width(300)
          .margin(10)
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End state_scene_type_array]

@Component
export struct StateSceneTypeArray {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      ArraySample()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_scene_type_array'))
  }
}