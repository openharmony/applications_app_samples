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
// [Start custom_component_use]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';

@Entry
@ComponentV2
struct CustomComponentUse {
  @Local firstName: string = 'Li';
  @Local lastName: string = 'Hua';
  age: number = 20; // 无法触发Computed

  @Computed
  get fullName() {
    hilog.info(DOMAIN, TAG, BUNDLE + '---------Computed----------');
    return this.firstName + ' ' + this.lastName + this.age;
  }

  build() {
    Column() {
      Text(this.lastName + ' ' + this.firstName)
      Text(this.lastName + ' ' + this.firstName)
      Divider()
      Text(this.fullName)
      Text(this.fullName)
      Button('changed lastName')
        .onClick(() => {
          this.lastName += 'a';
        })

      Button('changed age')
        .onClick(() => {
          this.age++;  // 无法触发Computed
        })
    }
  }
}
// [End custom_component_use]

@Builder
export function CustomComponentUseFunc() {
  NavDestination() {
    CustomComponentUse()
  }
  .backgroundColor('#f1f2f3')
  .title($r('app.string.computed_title_3'))
}