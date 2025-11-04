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
// [Start Use_in_Repeat_component]
import { ReusableV2Component7 } from '../common/ReusableV2Component7';
@Entry
@ComponentV2
struct Page10 {
  @Local simpleList: number[] = [1, 2, 3, 4, 5];
  @Local condition: boolean = true;
  build() {
    Column() {
      // $r('app.string.EntryAbility_title1')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($('app.string.EntryAbility_title1')).onClick(()=>{this.condition=!this.condition;})
      Button($('app.string.EntryAbility_title2')).onClick(()=>{this.simpleList.push(this.simpleList.length+1);})
      Button($('app.string.EntryAbility_title3')).onClick(()=>{this.simpleList.pop();})
      Button($('app.string.EntryAbility_title4')).onClick(()=>{this.simpleList[0]++;})
      if (this.condition) {
        List({ space: 10 }) {
          Repeat(this.simpleList)
            .each((obj: RepeatItem<number>) => {
              ListItem() {
                Column() {
                  ReusableV2Component7({ num: obj.item })
                }
              }
            })
        }
      }
    }
  }
}
// [End Use_in_Repeat_component]
