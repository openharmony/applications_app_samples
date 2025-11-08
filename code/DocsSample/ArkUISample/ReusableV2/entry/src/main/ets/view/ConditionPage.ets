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
//[Start ConditionPage]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;

@ObservedV2
class Info {
  @Trace public age: number = 25;
}
const info: Info = new Info();
@Entry
@ComponentV2
struct Index {
  @Local condition: boolean = true;
  build() {
    Column() {
      Button('Reuse/Recycle')
        .onClick(() => {
          this.condition = !this.condition;
        })
      Button('Change value')
        .onClick(() => {
          info.age++;
        })
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
    hilog.info(DOMAIN, TAG, 'info.age change');
  }
  aboutToRecycle() {
    hilog.info(DOMAIN, TAG, 'aboutToRecycle');
    this.info.age++;
  }
  aboutToReuse() {
    hilog.info(DOMAIN, TAG, 'aboutToReuse');
    this.info.age++;
  }
  onRender(): string {
    hilog.info(DOMAIN, TAG, 'info.age onRender');
    return this.info.age.toString();
  }
  build() {
    Column() {
      Text(this.onRender())
    }
  }
}
//[End ConditionPage]
const conditionPage = Index;
export default conditionPage;