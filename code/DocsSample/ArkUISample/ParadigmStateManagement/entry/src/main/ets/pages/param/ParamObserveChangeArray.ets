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
export struct ParamObserveChangeArray {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_observe_change_array'))
  }
}

// [Start Param_Observe_Change_Array]
@Entry
@ComponentV2
struct Index {
  @Local numArr: number[] = [1, 2, 3, 4, 5];
  @Local dimensionTwo: number[][] = [[1, 2, 3], [4, 5, 6]];

  build() {
    Column() {
      Text(`${this.numArr[0]}`)
      Text(`${this.numArr[1]}`)
      Text(`${this.numArr[2]}`)
      Text(`${this.dimensionTwo[0][0]}`)
      Text(`${this.dimensionTwo[1][1]}`)
      Button('change array item')
        .onClick(() => {
          this.numArr[0]++;
          this.numArr[1] += 2;
          this.dimensionTwo[0][0] = 0;
          this.dimensionTwo[1][1] = 0;
        })
      Button('change whole array')
        .onClick(() => {
          this.numArr = [5, 4, 3, 2, 1];
          this.dimensionTwo = [[7, 8, 9], [0, 1, 2]];
        })
      Child({
        numArr: this.numArr,
        dimensionTwo: this.dimensionTwo
      })
    }
  }
}

@ComponentV2
struct Child {
  @Require @Param numArr: number[];
  @Require @Param dimensionTwo: number[][];

  build() {
    Column() {
      Text(`${this.numArr[0]}`)
      Text(`${this.numArr[1]}`)
      Text(`${this.numArr[2]}`)
      Text(`${this.dimensionTwo[0][0]}`)
      Text(`${this.dimensionTwo[1][1]}`)
    }
  }
}
// [End Param_Observe_Change_Array]