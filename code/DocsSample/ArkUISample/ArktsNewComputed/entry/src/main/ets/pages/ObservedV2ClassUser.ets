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
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';
// [Start ObservedV2_Class_User]
@ObservedV2
class Name {
  @Trace private firstName: string = 'Hua';
  @Trace public lastName: string = 'Li';

  @Computed
  get fullName() {
    hilog.info(DOMAIN, TAG, BUNDLE + '---------Computed----------');
    return this.firstName + ' ' + this.lastName;
  }
}

const name: Name = new Name();

@Entry
@ComponentV2
export struct ObservedV2ClassUser {
  name1: Name = name;

  build() {
    // [StartExclude ObservedV2_Class_User]
    NavDestination() {
      // [EndExclude  ObservedV2_Class_User]
      Column() {
        Text(this.name1.fullName)
        Text(this.name1.fullName)
        Button('changed lastName').onClick(() => {
          this.name1.lastName += 'a';
        })
      }
    // [StartExclude ObservedV2_Class_User]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.computed_desc_2'))
    // [EndExclude  ObservedV2_Class_User]
  }
}
// [End ObservedV2_Class_User]