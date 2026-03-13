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
export struct ParamUseSceneArray {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_use_scene_array'))
  }
}

// [Start Param_Use_Scene_Array]
@ComponentV2
struct Child {
  // 使用@Param接收父组件传入的Array类型变量。
  @Require @Param count: number[];

  build() {
    Column() {
      ForEach(this.count, (item: number) => {
        Text(`${item}`).fontSize(30)
        Divider()
      })
    }
    .width('100%')
  }
}

@Entry
@ComponentV2
struct Index {
  // 使用@Local装饰Array类型变量，作为数据源传递给子组件的@Param。
  @Local count: number[] = [1, 2, 3];

  build() {
    Row() {
      Column() {
        Child({ count: this.count })
        // 对数组整体重新赋值，触发子组件更新。
        Button('init array').onClick(() => {
          this.count = [9, 8, 7];
        })
        // 新增数组元素，触发子组件更新。
        Button('push').onClick(() => {
          this.count.push(0);
        })
        // 翻转数组元素，触发子组件更新。
        Button('reverse').onClick(() => {
          this.count.reverse();
        })
        // 使用同一元素填充数组，触发子组件更新。
        Button('fill').onClick(() => {
          this.count.fill(6);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Param_Use_Scene_Array]