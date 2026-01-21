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

// [Start monitor_variables_in_observedv2_class]
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Info {
  @Trace public name: string = 'Tom';
  @Trace public region: string = 'North';
  @Trace public job: string = 'Teacher';
  public age: number = 25;

  // name被@Trace装饰，能够监听变化
  @SyncMonitor('name')
  onNameChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s',
      `name change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  // age未被@Trace装饰，不能监听变化
  @SyncMonitor('age')
  onAgeChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s',
      `age change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  // region与job均被@Trace装饰，能够监听变化
  @SyncMonitor('region', 'job')
  onChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      hilog.info(0xFF00, 'testTag', '%{public}s',
        `${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    })
  }
}

@Entry
@ComponentV2
struct Index {
  info: Info = new Info();

  build() {
    Column() {
      Button('change name')
        .onClick(() => {
          this.info.name = 'Jack'; // 能够触发onNameChange方法
        })
      Button('change age')
        .onClick(() => {
          this.info.age = 26; // 不能够触发onAgeChange方法
        })
      Button('change region')
        .onClick(() => {
          this.info.region = 'South'; // 能够触发onChange方法
        })
      Button('change job')
        .onClick(() => {
          this.info.job = 'Driver'; // 能够触发onChange方法
        })
    }
  }
}
// [End monitor_variables_in_observedv2_class]