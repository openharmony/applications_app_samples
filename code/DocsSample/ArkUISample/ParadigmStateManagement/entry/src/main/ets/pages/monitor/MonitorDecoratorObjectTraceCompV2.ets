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
export struct MonitorDecoratorObjectTraceCompV2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_decorator_object_trace_comp_v2'))
  }
}

// [Start monitor_decorator_object_trace_comp_v2]
class Info {
  public name: string;
  public age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Entry
@ComponentV2
struct Index {
  @Local info: Info = new Info('Tom', 25);

  @Monitor('info')
  infoChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `info change`);
  }

  @Monitor('info.name')
  infoPropertyChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `info name change`);
  }

  build() {
    Column() {
      Text(`name: ${this.info.name}, age: ${this.info.age}`)
      Button('change info')
        .onClick(() => {
          this.info = new Info('Lucy', 18); // 能够监听到
        })
      Button('change info.name')
        .onClick(() => {
          this.info.name = 'Jack'; // 监听不到
        })
    }
  }
}
// [End monitor_decorator_object_trace_comp_v2]