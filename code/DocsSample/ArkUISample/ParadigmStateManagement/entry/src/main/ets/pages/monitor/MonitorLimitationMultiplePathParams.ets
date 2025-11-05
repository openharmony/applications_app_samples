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
export struct MonitorLimitationMultiplePathParams {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_limitation_multiple_path_params'))
  }
}

// [Start monitor_limitation_multiple_path_params]
@ObservedV2
class Info {
  @Trace public name: string = 'Tom';
  @Trace public age: number = 25;
  @Trace public position: string = 'North';

  @Monitor('name', 'age') // Monitor 1
  onNameAgeChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s',
        `onNameAgeChange path: ${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
  }

  @Monitor('name', 'position') // Monitor 2
  onNamePositionChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s',
        `onNamePositionChange path: ${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
  }

  // 重复监听name、position，仅最后定义的生效
  @Monitor('name', 'position') // Monitor3
  onNamePositionChangeDuplicate(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s',
        `onNamePositionChangeDuplicate path: ${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
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
          this.info.name = 'Jack'; // 同时触发onNameAgeChange与onNamePositionChangeDuplicate方法
        })
    }
  }
}
// [End monitor_limitation_multiple_path_params]