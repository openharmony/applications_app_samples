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

// [Start compare_syncmonitor_with_monitor]
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@ComponentV2
struct DocSampleArraySum {
  @Local sum: number = 0;
  arr: Array<number> = [1, 2, 3];
  @SyncMonitor('sum')
  syncSumMonitor(info: IMonitor) {
    let path = info.dirty[0];
    hilog.info(0xFF00, 'SyncMonitor', '%{public}s', `${path} changed from ${info.value(path)?.before} to ${info.value(path)?.now}`);
  }
  @Monitor('sum')
  asyncSumMonitor(info: IMonitor) {
    let path = info.dirty[0];
    hilog.info(0xFF00, 'Monitor', '%{public}s', `${path} changed from ${info.value(path)?.before} to ${info.value(path)?.now}`);
  }

  build() {
    Column() {
      Button('Calculate a sum')
        .onClick(() => {  // 修改sum时，syncSumMonitor会回调3次，asyncSumMonitor只回调1次。
          this.sum = 0;
          this.arr.forEach((element) => this.sum += element);
        })
    }
  }
}
// [End compare_syncmonitor_with_monitor]