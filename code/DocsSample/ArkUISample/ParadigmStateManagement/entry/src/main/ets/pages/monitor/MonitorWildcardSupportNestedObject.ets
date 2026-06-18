/*
* Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start monitor_wildcard_support_nested_object]
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
struct MonitorWildcardNestedObject {
  @Local class0: Class0 | number = new Class0();

  // 使能通配符，监听嵌套对象
  @Monitor({}, 'class0.class1.person.*')
  onPersonChange(info: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', 'onPersonChange, dirty: ' + info.dirty.toString());
  }

  build() {
    Column({ space: 5 }) {
      Button('1. Class0 = new Class')
        .width(300)
        .margin(10)
        .onClick(() => {
          // @Monitor回调触发
          // 原因：class0, class1, person变更为新对象
          this.class0 = new Class0();
        })
      Button('2. Class0 = new Class, keep Class1')
        .width(300)
        .margin(10)
        .onClick(() => {
          // 当class0为Class0类型时，@Monitor回调不触发
          // 原因：即使class0变化了，路径'class0.class1.person.*'中通配符前最后一个确定值person也没有改变
          if (this.class0 instanceof Class0) {
            let newClass0 = new Class0();
            newClass0.class1.person = (this.class0 as Class0).class1.person;
            this.class0 = newClass0;
          }
        })
      Button('3. Class0.class1 = new Class1')
        .width(300)
        .margin(10)
        .onClick(() => {
          // 当class0为Class0类型时，@Monitor回调触发
          // 原因：class1、person变更为新对象
          if (this.class0 instanceof Class0) {
            (this.class0 as Class0).class1 = new Class1();
          }
        })
      Button('4. Class0.class1.person = new Person')
        .width(300)
        .margin(10)
        .onClick(() => {
          // 当class0为Class0类型时，@Monitor回调触发
          // 原因：person变更为新对象
          if (this.class0 instanceof Class0) {
            (this.class0 as Class0).class1.person = new Person();
          }
        })
      Button('5. Class0....person.last update')
        .width(300)
        .margin(10)
        .onClick(() => {
          // 当class0为Class0类型时，@Monitor回调触发
          // 原因：person的属性发生变化
          if (this.class0 instanceof Class0) {
            (this.class0 as Class0).class1.person.lastName += '+';
          }
        })
      Button('6. Class0 toggle number <=> new Class0')
        .width(300)
        .margin(10)
        .onClick(() => {
          // @Monitor回调触发
          // 原因：person在可访问与不可访问之间切换
          this.class0 = (typeof this.class0 === 'object') ? 500 : new Class0();
        })
    }
  }
}
// [End monitor_wildcard_support_nested_object]
@Component
export struct MonitorWildcardSupportNestedObject {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      MonitorWildcardNestedObject()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_wildcard_support_nested_object'))
  }
}
