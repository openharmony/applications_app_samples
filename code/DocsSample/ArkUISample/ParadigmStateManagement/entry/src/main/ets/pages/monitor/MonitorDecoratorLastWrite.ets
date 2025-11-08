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
@Component
export struct MonitorDecoratorLastWrite {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_decorator_last_write'))
  }
}

// [Start monitor_decorator_last_write]
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Frequency {
  @Trace public count: number = 0;

  @Monitor('count')
  onCountChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s',
      `count change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }
}

@Entry
@ComponentV2
struct Index {
  frequency: Frequency = new Frequency();

  build() {
    Column() {
      Button('change count to 1000')
        .onClick(() => {
          for (let i = 1; i <= 1000; i++) {
            this.frequency.count = i;
          }
        })
      Button('change count to 0 then to 1000')
        .onClick(() => {
          for (let i = 999; i >= 0; i--) {
            this.frequency.count = i;
          }
          this.frequency.count = 1000; // 最终不触发onCountChange方法
        })
    }
  }
}
// [End monitor_decorator_last_write]