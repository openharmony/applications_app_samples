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
// [Start state_mixed_scene_built_type_v1_v2_not_recommend]
@Entry
@Component
struct ArrayCompV1 {
  @State arr: Array<number> = [1, 2, 3];

  build() {
    Column() {
      Text(`V1 ${this.arr[0]}`).onClick(() => {
        // V1代理，可触发ArrayCompV1的刷新并通知ArrayCompV2更新@Param的值
        this.arr[0]++;
      })
      // 传递给ArrayCompV2，被再次包装V2的代理
      ArrayCompV2({ arr: this.arr })
    }
    .height('100%')
    .width('100%')
  }
}

@ComponentV2
struct ArrayCompV2 {
  @Param arr: Array<number> = [1, 2, 3];

  build() {
    Column() {
      Text(`V2 ${this.arr[0]}`).onClick(() => {
        // V1V2双重代理，可触发ArrayCompV1和ArrayCompV2的刷新
        this.arr[0]++;
      })
    }
  }
}
// [End state_mixed_scene_built_type_v1_v2_not_recommend]
@Component
export struct StateMixedSceneBuiltTypeV1V2NotRecommend {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      ArrayCompV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_built_type_v1_v2_not_recommend'))
  }
}