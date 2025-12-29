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
// [Start state_mixed_scene_two_bit_array_v2_v1]
import { UIUtils } from '@kit.ArkUI';

@Component
struct Item {
  @ObjectLink itemArr: Array<string>;

  build() {
    Row() {
      ForEach(this.itemArr, (item: string, index: number) => {
        Text(`${index}: ${item}`)
      }, (item: string) => item + Math.random())
      // 新增数组元素
      Button('@ObjectLink push')
        .onClick(() => {
          this.itemArr.push('ObjectLink');
        })
    }
  }
}

@Entry
@ComponentV2
struct IndexPage {
  @Local arr: Array<Array<string>> =
    UIUtils.enableV2Compatibility(UIUtils.makeV1Observed([UIUtils.makeV1Observed(['apple']),
      UIUtils.makeV1Observed(['banana']), UIUtils.makeV1Observed(['orange'])]));

  build() {
    Column() {
      ForEach(this.arr, (itemArr: Array<string>) => {
        Item({ itemArr: itemArr })
      }, (itemArr: Array<string>) => JSON.stringify(itemArr) + Math.random())
      Divider()
      // 数组arr[0]新增元素
      Button('@Local push two-dimensional array item')
        .onClick(() => {
          this.arr[0].push('strawberry');
        })
      // 数组arr新增元素
      Button('@Local push array item')
        .onClick(() => {
          this.arr.push(UIUtils.makeV1Observed(['pear']));
        })
      // 修改数组项arr[0][0]的值
      Button('@Local change two-dimensional array first item')
        .onClick(() => {
          this.arr[0][0] = 'APPLE';
        })
      // 修改数组arr的第一个元素
      Button('@Local change array first item')
        .onClick(() => {
          this.arr[0] = UIUtils.makeV1Observed(['watermelon']);
        })
    }
  }
}
// [End state_mixed_scene_two_bit_array_v2_v1]
@Component
export struct StateMixedSceneTwoBitArrayV2V1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      IndexPage()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_two_bit_array_v2_v1'))
  }
}