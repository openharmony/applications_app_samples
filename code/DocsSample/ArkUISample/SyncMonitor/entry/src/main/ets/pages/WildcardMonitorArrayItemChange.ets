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
class ArrayOfPerson extends Array<Person> {
}

@Entry
@ComponentV2
struct DocSampleArray {
  @Local arrayOfPerson: ArrayOfPerson =
    [new Person('Adrian'), new Person('Andrew'), new Person('Aaliyah'), new Person('Amir'), new Person('Angel')];

  @SyncMonitor('arrayOfPerson.*')
  arrayOfPersonMonitor(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `### SyncMonitor dirty: ${monitor.dirty.toString()}`);
  }

  build() {
    Column() {
      Button('#1 arrayOfPerson.push')
        .onClick(() => {
          // arrayOfPersonMonitor回调触发
          this.arrayOfPerson.push(new Person('Austin'));
        })
      Button('#2 arrayOfPerson.splice(0,1,P)')
        .onClick(() => {
          // arrayOfPersonMonitor回调触发
          this.arrayOfPerson.splice(0, 1, new Person('Addison'));
        })
      Button('#3 arrayOfPerson.assign new [1]')
        .onClick(() => {
          if (this.arrayOfPerson.length > 1) {
            // arrayOfPersonMonitor回调触发
            this.arrayOfPerson[1] = new Person('Andy');
          }
        })
      Button('#4 arrayOfPerson shift')
        .onClick(() => {
          if (this.arrayOfPerson.length > 2) {
            // arrayOfPersonMonitor回调触发
            this.arrayOfPerson.shift();
          }
        })
      Button('#5 arrayOfPerson length change')
        .onClick(() => {
          // arrayOfPersonMonitor回调触发
          this.arrayOfPerson.length = this.arrayOfPerson.length + 1;
        })
      Button('#6 arrayOfPerson = new Array')
        .onClick(() => {
          // arrayOfPersonMonitor回调触发
          this.arrayOfPerson = new ArrayOfPerson(new Person('Adrian'), new Person('Andrew'))
        })
      Button('#7 arrayOfPerson [1] last name')
        .onClick(() => {
          if (this.arrayOfPerson.length > 1 && this.arrayOfPerson[1] instanceof Person) {
            // arrayOfPersonMonitor回调不触发
            this.arrayOfPerson[1].lastName += '~'
          }
        })
    }
  }
}
// [End wildcard_monitor_array_item_change]