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

// [Start monitor_variable_base_derived_class]
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Base {
  @Trace public name: string;

  // 基类监听name属性
  @SyncMonitor('name')
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
  @SyncMonitor('name')
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
          this.derived.name = 'BBB'; // onDerivedNameChange方法会调用，父类的onBaseNameChange也会回调
        })
    }
  }
}
// [End monitor_variable_base_derived_class]