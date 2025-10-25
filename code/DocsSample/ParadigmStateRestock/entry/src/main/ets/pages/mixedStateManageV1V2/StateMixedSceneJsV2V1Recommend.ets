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
// [Start state_mixed_scene_js_v2_v1_recommend]
import { UIUtils } from '@kit.ArkUI';

class ObservedClass {
  public name: string = 'Tom';
}

@Entry
@ComponentV2
struct CompV2 {
  @Local observedClass: ObservedClass = UIUtils.enableV2Compatibility(UIUtils.makeV1Observed(new ObservedClass()));

  build() {
    Column() {
      // @Local原本能力仅可观察自身
      // 但是调用了UIUtils.makeV1Observed使其变成V1的状态变量，V1状态变量可观察第一层变化
      // 又调用UIUtils.enableV2Compatibility使其在V2中可观察
      // 所以当前可观察第一层属性的变化
      Text(`@Local observedClass: ${this.observedClass.name}`)
        .onClick(() => {
          this.observedClass.name += '!'; // 刷新
        })
      // @ObjectLink可接收@Observed装饰class的实例或者makeV1Observed的返回值
      CompV1({ observedClass: this.observedClass })
    }
  }
}

@Component
struct CompV1 {
  @ObjectLink observedClass: ObservedClass;

  build() {
    // 在CompV1中可观察第一层的变化
    Text(`@ObjectLink observedClass: ${this.observedClass.name}`)
      .onClick(() => {
        this.observedClass.name += '!'; // 刷新
      })
  }
}
// [End state_mixed_scene_js_v2_v1_recommend]
@Component
export struct StateMixedSceneJsV2V1Recommend {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      CompV2()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_js_v2_v1_recommend'))
  }
}