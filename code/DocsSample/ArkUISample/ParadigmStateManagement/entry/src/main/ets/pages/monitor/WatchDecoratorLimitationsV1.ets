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
// [Start monitor_watch_decorator_limitations_v1]
import { hilog } from '@kit.PerformanceAnalysisKit';

@Observed
class Info {
  public name: string = 'Tom';
  public age: number = 25;
}

@Entry
@Component
struct Index {
  @State @Watch('onInfoChange') info: Info = new Info();
  @State @Watch('onNumArrChange') numArr: number[] = [1, 2, 3, 4, 5];

  onInfoChange() {
    hilog.info(0xFF00, 'testTag', '%{public}s', `info after change name: ${this.info.name}, age: ${this.info.age} `);
  }

  onNumArrChange() {
    hilog.info(0xFF00, 'testTag', '%{public}s', `numArr after change ${this.numArr}`);
  }

  build() {
    Row() {
      Column() {
        Button('change info name')
          .onClick(() => {
            this.info.name = 'Jack';
          })
        Button('change info age')
          .onClick(() => {
            this.info.age = 30;
          })
        Button('change numArr[2]')
          .onClick(() => {
            this.numArr[2] = 5;
          })
        Button('change numArr[3]')
          .onClick(() => {
            this.numArr[3] = 6;
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End monitor_watch_decorator_limitations_v1]

@Component
export struct MonitorWatchDecoratorLimitationsV1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_watch_decorator_limitations_v1'))
  }
}