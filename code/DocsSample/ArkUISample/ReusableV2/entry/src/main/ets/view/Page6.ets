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
//[Start Reset_the_internal_state_variables_of_the_component_before_reuse1]
import { ReusableV2Component3 } from '../common/ReusableV2Component3';
@ObservedV2
export class Info1 {
  @Trace private age: number;
  constructor(age: number) {
    this.age = age;
  }
}

@Entry
@ComponentV2
struct Page6 {
  @Local local: number = 0;
  @Provider('inherit') inheritProvider: number = 100;
  @Local condition: boolean = true;
  build() {
    Column() {
      // $r('app.string.EntryAbility_title6')需要替换为开发者所需的字符串（图像、数字等）资源文件。
      Button($('app.string.EntryAbility_title6')).onClick(()=>{this.condition=!this.condition;})
      Column() {
        Text($('app.string.EntryAbility_title12'))
        Text(`local: ${this.local}`).onClick(()=>{this.local++;})
        Text(`inheritProvider: ${this.inheritProvider}`).onClick(()=>{this.inheritProvider++;})
      }.borderWidth(2)
      if (this.condition) {
        ReusableV2Component3({
          paramOut: this.local,
          paramOnce: this.local,
          changeParam: () => {
            this.local++;
          }
        })
      }
    }
  }
}
//[End Reset_the_internal_state_variables_of_the_component_before_reuse1]