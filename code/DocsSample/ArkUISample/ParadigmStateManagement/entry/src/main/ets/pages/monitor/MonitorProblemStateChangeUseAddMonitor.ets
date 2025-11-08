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
// [Start monitor_problem_state_change_use_addMonitor]
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class User {
  @Trace public age: number = 10;
}

@Entry
@ComponentV2
struct Page {
  @Local user: User | undefined | null = new User();

  @Monitor('user.age')
  onChange(mon: IMonitor) {
    mon.dirty.forEach((path: string) => {
      hilog.info(0xFF00, 'testTag', '%{public}s',
        `onChange: User property ${path} change from ${mon.value(path)?.before} to ${mon.value(path)?.now}`);
    });
  }

  build() {
    Column() {
      Text(`User age ${this.user?.age}`).fontSize(20)
      Button('set user to undefined').onClick(() => {
        // age：可访问 -> 不可访问
        this.user = undefined;
      })
      Button('set user to User').onClick(() => {
        // age：不可访问 ->可访问
        this.user = new User();
      })
      Button('set user to null').onClick(() => {
        // age：可访问->不可访问
        this.user = null;
      })
    }
  }
}
// [End monitor_problem_state_change_use_addMonitor]
@Component
export struct MonitorProblemStateChangeUseAddMonitor {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_problem_state_change_use_addMonitor'))
  }
}