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
//[Start Reset_the_internal_state_variables_of_the_component_before_reuse]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@ObservedV2
export class Info {
  @Trace public age: number = 25;
}
export const info: Info = new Info();

@Entry
@ComponentV2
struct ConditionPage {
  @Local condition: boolean = true;

  build() {
    Column() {
      // $r('app.string.EntryAbility_RecycleOrReuse')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($r('app.string.EntryAbility_RecycleOrReuse')).onClick(()=>{this.condition=!this.condition;})
      // $r('app.string.EntryAbility_ChangeValue')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($r('app.string.EntryAbility_ChangeValue')).onClick(()=>{info.age++;})
      if (this.condition) {
        ReusableV2Component()
      }
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2Component {
  @Local info: Info = info; // 仅做演示使用，并不建议@Local赋值全局变量
  @Monitor('info.age')
  onValChange() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'info.age change');
  }
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'aboutToRecycle');
    this.info.age++;
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'aboutToReuse');
    this.info.age++;
  }
  onRender(): string {
    hilog.info(DOMAIN, TAG, BUNDLE + 'info.age onRender');
    return this.info.age.toString();
  }
  build() {
    Column() {
      Text(this.onRender())
    }
  }
}
//[End Reset_the_internal_state_variables_of_the_component_before_reuse]