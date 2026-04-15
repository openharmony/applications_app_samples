/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start CallInMonitor]
import { UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Page {
  @Local count: number = 0;

  @Monitor('count')
  onCountChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      console.info(`${path} changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
    UIUtils.flushUpdates(); // 在monitor中调用flushUpdates会运行时报错
    UIUtils.flushUIUpdates(); // 在monitor中调用flushUIUpdates会运行时报错
  }

  build() {
    Column() {
      Text(`${this.count}`)
      Button('change count')
        .onClick(() => {
        this.count++;
        })
        // [StartExclude CallInMonitor]
        .id('CallInMonitor')
        // [EndExclude CallInMonitor]
    }
  }
}
// [End CallInMonitor]

@Builder
export function callInMonitor() {
  NavDestination() {
    Page();
  }
  .backgroundColor('#f1f2f3')
  .title($r('app.string.called_in_monitor'))
}