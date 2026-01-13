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

// [Start FlushUIUpdatesUse]
import { UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello';

  @Monitor('message')
  onMessageChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      console.info(`${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
  }

  build() {
    Column() {
      Text(`message: ${this.message}`)
      Button('change size')
        .margin(20)
        .onClick(() => {
          // test1：调用applySync接口，日志打印两次
          // UIUtils.applySync(() => {
          //   this.message = 'Hello World';
          // })

          // test2：调用flushUpdates接口，日志打印两次
          // this.message = 'Hello World';
          // UIUtils.flushUpdates();

          // test3：调用flushUIUpdates接口，日志打印一次
          this.message = 'Hello World';
          UIUtils.flushUIUpdates();
          this.message = 'Hello ArkUI';
        })
        // [StartExclude FlushUIUpdatesUse]
        .id('flushUIUpdatesButton')
        // [EndExclude FlushUIUpdatesUse]
    }
  }
}
// [End FlushUIUpdatesUse]

@Builder
export function flushUIUpdatesUse() {
  NavDestination() {
    Index();
  }
  .backgroundColor('#f1f2f3')
  .title($r('app.string.flushUIUpdates_use_title'))
}