/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start wildcard_monitor_array_item_change]
import { hilog } from '@kit.PerformanceAnalysisKit';
@ObservedV2
class Person {
  @Trace public firstName: string;
  @Trace public lastName: string;
  constructor(first: string = 'no first', last: string = 'no last') {
    this.firstName = first;
    this.lastName = last;
  }
}

@ObservedV2
class ArrayOfPerson extends Array<Person> {}

@Entry
@ComponentV2
struct DocSampleArray {
  @Local arrayOrPerson: ArrayOfPerson =
    [new Person('Adrian'), new Person('Andrew'), new Person('Aaliyah'), new Person('Amir'), new Person('Angel')];

  @SyncMonitor('arrayOrPerson.*')
  arrayOfPersonMonitor(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `### SyncMonitor dirty: ${monitor.dirty.toString()}`);
  }

  build() {
    Column() {
      Button('#1 arrayOfPerson.push')
        .onClick(() => {
          this.arrayOrPerson.push(new Person('Austin'));
        })
      Button('#2 arrayOfPerson.splice(0,1,P)')
        .onClick(() => {
          this.arrayOrPerson.splice(0, 1, new Person('Addison'));
        })
      Button('#3 arrayOfPerson.assign new [1]')
        .onClick(() => {
          this.arrayOrPerson[1] = new Person('Amari');
        })
      Button('#4 arrayOfPerson shift')
        .onClick(() => {
          this.arrayOrPerson.shift();
        })
      Button('#5 arrayOfPerson length change')
        .onClick(() => {
          this.arrayOrPerson.length = this.arrayOrPerson.length +1;
        })
      Button('#6 arrayOfPerson  = new Array')
        .onClick(() => {
          this.arrayOrPerson = new ArrayOfPerson(new Person('Adrian'), new Person('Andrew'))
        })
      Button('#7 arrayOfPerson [1] last name')
        .onClick(() => {
          this.arrayOrPerson[1].lastName += '~'
        })
    }
  }
}
// [End wildcard_monitor_array_item_change]