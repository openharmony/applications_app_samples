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
export struct MonitorLimitationParameterStringConstraint {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_limitation_parameter_string_constraint'))
  }
}

// [Start monitor_limitation_parameter_string_constraint]
const t2: string = 't2'; // const常量

enum ENUM {
  T3 = 't3' // enum枚举值
};
let t4: string = 't4'; // 变量

@ObservedV2
class Info {
  @Trace public t1: number = 0;
  @Trace public t2: number = 0;
  @Trace public t3: number = 0;
  @Trace public t4: number = 0;
  @Trace public t5: number = 0;

  // 字符串字面量
  @Monitor('t1')
  onT1Change(monitor: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `t1 change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  @Monitor(t2)
  onT2Change(monitor: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `t2 change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  @Monitor(ENUM.T3)
  onT3Change(monitor: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `t3 change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  @Monitor(t4)
  onT4Change(monitor: IMonitor) {
    hilog.info(DOMAIN, 'testTag', '%{public}s', `t4 change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }
}

@Entry
@ComponentV2
struct Index {
  info: Info = new Info();

  build() {
    Column() {
      Button('Change t1')
        .onClick(() => {
          this.info.t1++; // 能够触发onT1Change方法
        })
      Button('Change t2')
        .onClick(() => {
          this.info.t2++; // 能够触发onT2Change方法
        })
      Button('Change t3')
        .onClick(() => {
          this.info.t3++; // 能够触发onT3Change方法
        })
      Button('Change t4')
        .onClick(() => {
          this.info.t4++; // 能够触发onT4Change方法
        })
      Button('Change var t4 to t5')
        .onClick(() => {
          t4 = 't5'; // 更改变量值为't5'
        })
      Button('Change t5')
        .onClick(() => {
          this.info.t5++; // onT4Change仍监听t4，不会触发
        })
      Button('Change t4 again')
        .onClick(() => {
          this.info.t4++; // 能够触发onT4Change方法
        })
    }
  }
}
// [End monitor_limitation_parameter_string_constraint]