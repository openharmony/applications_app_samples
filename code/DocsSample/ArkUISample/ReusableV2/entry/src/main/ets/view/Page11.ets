import { ReusableV2Component8 } from '../common/ReusableV2Component8';
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
// [Start Rep_each_list_Comp]
@Entry
@ComponentV2
struct Page11 {
  @Local simpleList: number[] = [1, 2, 3, 4, 5];
  @Local condition: boolean = true;

  build() {
    Column() {
      Button('删除/创建Repeat').onClick(()=>{this.condition=!this.condition;})
      Button('增加元素').onClick(()=>{this.simpleList.push(this.simpleList.length+1);})
      Button('删除元素').onClick(()=>{this.simpleList.pop();})
      Button('更改元素').onClick(()=>{this.simpleList[0]++;})
      if (this.condition) {
        List({ space: 10 }) {
          Repeat(this.simpleList)
            .each((obj: RepeatItem<number>) => {
              ListItem() {
                Column() {
                  ReusableV2Component8({ num: obj.item })
                }
              }
            })
        }
      }
    }
  }
}// [Start Rep_each_list_Comp]
