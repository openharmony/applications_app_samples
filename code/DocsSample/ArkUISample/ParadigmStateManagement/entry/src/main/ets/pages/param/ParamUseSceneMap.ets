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
export struct ParamUseSceneMap {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_use_scene_map'))
  }
}

// [Start Param_Use_Scene_Map]
@ComponentV2
struct Child {
  // 使用@Param接收父组件传入的Map类型变量。
  @Param value: Map<number, string> = new Map();

  build() {
    Column() {
      ForEach(Array.from(this.value.entries()), (item: [number, string]) => {
        Text(`${item[0]}`).fontSize(30)
        Text(`${item[1]}`).fontSize(30)
        Divider()
      })
    }
  }
}

@Entry
@ComponentV2
struct Index {
  // 使用@Local装饰Map类型变量，作为数据源传递给子组件的@Param。
  @Local message: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);

  build() {
    Row() {
      Column() {
        Child({ value: this.message })
        // 对Map整体重新赋值，触发子组件更新。
        Button('init map').onClick(() => {
          this.message = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);
        })
        // 新增键值对，触发子组件更新。
        Button('set new one').onClick(() => {
          this.message.set(4, 'd');
        })
        // 清空Map，触发子组件更新。
        Button('clear').onClick(() => {
          this.message.clear();
        })
        // 更新键值对，触发子组件更新。
        Button('replace the first one').onClick(() => {
          this.message.set(0, 'aa');
        })
        // 删除键值对，触发子组件更新。
        Button('delete the first one').onClick(() => {
          this.message.delete(0);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Param_Use_Scene_Map]