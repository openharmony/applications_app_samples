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
// [Start state_mixed_scene_observed_class_v1_v2]
import { UIUtils } from '@kit.ArkUI';

@Observed
class ObservedClass {
  @Track public name: string = 'a';
  public count: number = 0;
}

@Entry
@Component
struct CompV1 {
  @State observedClass: ObservedClass = new ObservedClass();

  build() {
    Column() {
      Text(`@State observedClass: ${this.observedClass.name}`)
        .onClick(() => {
          this.observedClass.name += 'a'; // 触发刷新
        })
      // 调用UIUtils.enableV2Compatibility使V1的状态变量可在@ComponentV2中有观察能力。
      CompV2({ observedClass: UIUtils.enableV2Compatibility(this.observedClass) })
    }
  }
}

@ComponentV2
struct CompV2 {
  @Param observedClass: ObservedClass = new ObservedClass();

  build() {
    Column() {
      // V1状态变量在使能V2观察能力后，可以在V2观察第一层的变化
      Text(`@Param observedClass: ${this.observedClass.name}`)
        .onClick(() => {
          this.observedClass.name += '!'; // 刷新
        })

      // 使用非@Track的变量在V2中不会崩溃，但不会响应更新
      Text(`count: ${this.observedClass.count}`).onClick(() => {
        this.observedClass.count++; // 不触发刷新
      })
    }
  }
}
// [End state_mixed_scene_observed_class_v1_v2]
@Component
export struct StateMixedSceneObservedClassV1V2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      CompV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_observed_class_v1_v2'))
  }
}