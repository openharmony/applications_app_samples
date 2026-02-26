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
export struct ParamUseSceneSet {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_use_scene_set'))
  }
}

// [Start Param_Use_Scene_Set]
@ComponentV2
struct Child {
  // 使用@Param接收父组件传入的Set类型变量。
  @Param message: Set<number> = new Set();

  build() {
    Column() {
      ForEach(Array.from(this.message.entries()), (item: [number, number]) => {
        Text(`${item[0]}`).fontSize(30)
        Divider()
      })
    }
    .width('100%')
  }
}

@Entry
@ComponentV2
struct Index {
  // 使用@Local装饰Set类型变量，作为数据源传递给子组件的@Param。
  @Local message: Set<number> = new Set([0, 1, 2, 3, 4]);

  build() {
    Row() {
      Column() {
        Child({ message: this.message })
        // 对Set整体重新赋值，触发子组件更新。
        Button('init set').onClick(() => {
          this.message = new Set([0, 1, 2, 3, 4]);
        })
        // 新增元素，触发子组件更新。
        Button('set new one').onClick(() => {
          this.message.add(5);
        })
        // 清空Set，触发子组件更新。
        Button('clear').onClick(() => {
          this.message.clear();
        })
        // 删除元素，触发子组件更新。
        Button('delete the first one').onClick(() => {
          this.message.delete(0);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Param_Use_Scene_Set]