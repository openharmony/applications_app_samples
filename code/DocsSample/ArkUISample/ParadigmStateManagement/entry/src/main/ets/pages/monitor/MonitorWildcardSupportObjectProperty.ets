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
// [Start monitor_wildcard_support_object_property]
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class ClassA {
  @Trace public propA: number = 8;
  @Trace public propB: number = 99;

  constructor(a: number, b: number) {
    this.propA = a;
    this.propB = b;
  }
}

@Entry
@ComponentV2
struct MonitorWildcardObject {
  @Local cls: ClassA = new ClassA(100, 100);

  // 使能通配符
  @Monitor({}, 'cls.*')
  onClsChanged(m: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `onClsChanged, dirty: ${m.dirty.toString()}`);
  }

  build() {
    Column() {
      Button(`Change propA: ${this.cls.propA}`)
        .width(300)
        .margin(10)
        .onClick(() => {
          this.cls.propA += 1; // 触发onClsChanged
        })
      Button(`Change propB: ${this.cls.propB}`)
        .width(300)
        .margin(10)
        .onClick(() => {
          this.cls.propB += 1; // 触发onClsChanged
        })
      Button('Assign new object')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.cls = new ClassA(-200, -200); // 触发onClsChanged
        })
    }
    .width('100%')
  }
}
// [End monitor_wildcard_support_object_property]
@Component
export struct MonitorWildcardSupportObjectProperty {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      MonitorWildcardObject()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_decorator_wildcard_support_object'))
  }
}