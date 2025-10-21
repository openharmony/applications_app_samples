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
// [Start Use_in_ForEach_component]
import { ReusableV2Component9 } from '../common/ReusableV2Component9';
@Entry
@ComponentV2
struct Page12 {
  @Local simpleList: number[] = [0, 1, 2, 3, 4, 5];

  build() {
    Column() {
      ForEach(this.simpleList, (num: number, index) => {
        Row() {
          Button('点击修改').onClick(()=>{this.simpleList[index]++;})
          ReusableV2Component9({ num: num })
        }
      }) // 每次修改完key发生变化
    }
  }
}
// [End Use_in_ForEach_component]