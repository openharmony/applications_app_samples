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
// [Start MonitorExample2_start]
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xFF00;
const TAG = '[Sample_StateMigration_App]';

@Entry
@ComponentV2
struct MonitorExample {
  @Local apple: number = 0;
  @Local orange: number = 0;

  // @Monitor回调，支持监听多个变量，可以获取变化前的值
  @Monitor('apple','orange')
  onFruitChange(monitor: IMonitor) {
    monitor.dirty.forEach((name: string) => {
      hilog.info(DOMAIN, TAG, `${name} changed from ${monitor.value(name)?.before} to ${monitor.value(name)?.now}`);
    });
  }

  build() {
    Column() {
      Text(`apple count: ${this.apple}`)
        .fontSize(20)
        .margin(10)
      Text(`orange count: ${this.orange}`)
        .fontSize(20)
        .margin(10)
      Button('add apple')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.apple++; // 点击触发onFruitChange回调
        })
      Button('add orange')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.orange++; // 点击触发onFruitChange回调
        })
    }
    .width('100%')
  }
}
// [End MonitorExample2_start]
const monitorExample2 = MonitorExample;
export default monitorExample2;