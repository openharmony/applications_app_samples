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

// [Start monitor_object_variable]
import { hilog } from '@kit.PerformanceAnalysisKit';

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

  @SyncMonitor('info')
  infoChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `info change`);
  }

  build() {
    Column() {
      Text(`name: ${this.info.name}, age: ${this.info.age}`)
      Button('change info')
        .onClick(() => {
          this.info = new Info('Lucy', 18); // 能够监听到
        })
    }
  }
}
// [End monitor_object_variable]