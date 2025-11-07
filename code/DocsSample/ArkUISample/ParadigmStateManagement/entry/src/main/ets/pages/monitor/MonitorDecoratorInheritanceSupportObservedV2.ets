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

@Component
export struct MonitorDecoratorInheritanceSupportObservedV2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_decorator_inheritance_support_observed_v2'))
  }
}

// [Start monitor_decorator_inheritance_support_observed_v2]
@ObservedV2
class Base {
  @Trace public name: string;

  // 基类监听name属性
  @Monitor('name')
  onBaseNameChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `Base Class name change`);
  }

  constructor(name: string) {
    this.name = name;
  }
}

@ObservedV2
class Derived extends Base {
  // 继承类监听name属性
  @Monitor('name')
  onDerivedNameChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `Derived Class name change`);
  }

  constructor(name: string) {
    super(name);
  }
}

@Entry
@ComponentV2
struct Index {
  derived: Derived = new Derived('AAA');

  build() {
    Column() {
      Button('change name')
        .onClick(() => {
          this.derived.name = 'BBB'; // 能够先后触发onBaseNameChange、onDerivedNameChange方法
        })
    }
  }
}
// [End monitor_decorator_inheritance_support_observed_v2]