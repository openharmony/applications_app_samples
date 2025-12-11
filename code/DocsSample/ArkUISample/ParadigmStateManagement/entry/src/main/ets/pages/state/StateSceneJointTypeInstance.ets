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

// [Start state_scene_joint_type_instance]
@Entry
@Component
struct UnionTypeSample {
  @State count: number | undefined = 0; // 使用@State装饰联合类型变量

  build() {
    Row() {
      Column() {
        Text(`count: ${this.count}`)
        // 将联合类型变量从number切换为undefined，触发UI刷新
        Button('change to undefined')
          .onClick(() => {
            this.count = undefined;
          })
          .width(300)
          .margin(10)
        // 将联合类型变量从undefined切换为number，触发UI刷新
        Button('change to number')
          .onClick(() => {
            this.count = 10;
          })
          .width(300)
          .margin(10)
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End state_scene_joint_type_instance]

@Component
export struct StateSceneJointTypeInstance {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      UnionTypeSample()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_scene_joint_type_instance'))
  }
}