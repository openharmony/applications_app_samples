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

const DOMAIN = 0x0000;

@Component
export struct MonitorDecoratorObjectSupport {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_decorator_object_support'))
  }
}

// [Start monitor_decorator_object_support]
@ObservedV2
class Info {
  @Trace public person: Person;

  @Monitor('person.name')
  onNameChange(monitor: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s',
      `name change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  @Monitor('person.age')
  onAgeChange(monitor: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s',
      `age change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  constructor(name: string, age: number) {
    this.person = new Person(name, age);
  }
}

@ObservedV2
class Person {
  @Trace public name: string;
  @Trace public age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Entry
@ComponentV2
struct Index {
  info: Info = new Info('Tom', 25);

  build() {
    Column() {
      Button('Step1: Only change name')
        .onClick(() => {
          this.info.person = new Person('Jack', 25); // 能够触发onNameChange方法，不触发onAgeChange方法
        })
      Button('Step2: Only change age')
        .onClick(() => {
          this.info.person = new Person('Jack', 18); // 能够触发onAgeChange方法，不触发onNameChange方法
        })
      Button('Step3: Change name and age')
        .onClick(() => {
          this.info.person = new Person('Lucy', 19); // 能够触发onNameChange、onAgeChange方法
        })
    }
  }
}
// [End monitor_decorator_object_support]