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
// [Start Parent16_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0xFF00;
const TAG = '[Sample_StateMigration_App]';
const PARENT_INITIAL_LOCAL_VALUE = 10;

@ComponentV2
struct Child {
  @Local localValue: number = 0;
  @Param value: number = 0;

  @Monitor('value')
  onValueChange(mon: IMonitor) {
    hilog.info(DOMAIN, TAG, `value has been changed from ${mon.value()?.before} to ${mon.value()?.now}`);
    // 父组件value变化时，通知子组件value更新，回调Monitor函数，将更新的值覆写给本地的localValue
    this.localValue = this.value;
  }

  build() {
    Column() {
      Text(`${this.localValue}`).fontSize(25)
      Button('Child +100')
        .onClick(() => {
          // 改变localValue不会传递给父组件Parent
          this.localValue += 100;
        })
    }
  }
}

@Entry
@ComponentV2
struct Parent {
  @Local value: number = PARENT_INITIAL_LOCAL_VALUE;

  build() {
    Column() {
      Button('Parent +1')
        .onClick(() => {
          // 改变value的值，通知子组件Child value更新
          this.value += 1;
        })
      Child({ value: this.value })
    }
  }
}
// [End Parent16_start]
const parent16 = Parent;
export default parent16;