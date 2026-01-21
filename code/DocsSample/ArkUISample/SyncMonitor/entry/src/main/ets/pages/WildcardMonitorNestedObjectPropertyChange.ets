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

// [Start wildcard_monitor_nested_object_property_change]
import { hilog } from '@kit.PerformanceAnalysisKit';
@ObservedV2
class Person {
  @Trace public firstName: string = 'first';
  @Trace public lastName: string = 'last';
}
@ObservedV2
class Class1 {
  @Trace public person: Person = new Person();
}
@ObservedV2
class Class0 {
  @Trace public class1: Class1 = new Class1();
}

@Entry
@ComponentV2
export struct DocSampleNestedClass {
  @Local class0 : Class0 | number = new Class0();

  @SyncMonitor('class0.class1.person.*')
  onPersonChange(info: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', '### onPersonChange, dirty: ' + info.dirty.toString());
  }

  build() {
    Column() {
      Button('#1 Class0 = new Class')
        .onClick(() => {
          this.class0 = new Class0();
        })
      Button('#2 Class0 = new Class, keep Class1')
        .onClick(() => {
          let newClass0 = new Class0();
          newClass0.class1.person = (this.class0 as Class0).class1.person;
          this.class0 = newClass0;
        })
      Button('#3 Class0.class1 = new Class1')
        .onClick(() => {
          (this.class0 as Class0).class1 = new Class1();
        })
      Button('#4 Class0.class1.person = new Person')
        .onClick(() => {
          (this.class0 as Class0).class1.person = new Person();
        })
      Button('#5 Class0....person.last update')
        .onClick(() => {
          if (typeof (this.class0) === 'object') {
            (this.class0 as Class0).class1.person.lastName += '+';
          } else {
          }
        })
      Button('#6 Class0 toggle number <=> new Class0')
        .onClick(() => {
          this.class0 = (typeof (this.class0) === 'object') ? 500 : new Class0();
        })
    }
  }
}
// [End wildcard_monitor_nested_object_property_change]