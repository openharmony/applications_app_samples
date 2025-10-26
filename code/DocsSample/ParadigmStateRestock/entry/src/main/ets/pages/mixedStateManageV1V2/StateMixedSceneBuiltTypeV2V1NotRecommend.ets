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
// [Start state_mixed_scene_built_type_v2_v1_not_recommend]
@Entry
@ComponentV2
struct ArrayCompV2 {
  @Local arr: Array<number> = [1, 2, 3];

  build() {
    Column() {
      Text(`V2 ${this.arr[0]}`).fontSize(20).onClick(() => {
        // 点击触发V2变化
        this.arr[0]++;
      })
      // 传递给@ObjectLink为非@Observed和makeV1Observed数据
      // 非法操作，@ObjectLink将不能观察属性变化
      ArrayCompV1({ arr: this.arr })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ArrayCompV1 {
  @ObjectLink arr: Array<number>;

  build() {
    Column() {
      Text(`V1 ${this.arr[0]}`).fontSize(20).onClick(() => {
        // V1不刷新，但可以触发V2的刷新
        this.arr[0]++;
      })
    }
  }
}
// [End state_mixed_scene_built_type_v2_v1_not_recommend]
@Component
export struct StateMixedSceneBuiltTypeV2V1NotRecommend {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      ArrayCompV2()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_built_type_v2_v1_not_recommend'))
  }
}