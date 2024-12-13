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

import lazy { a } from './mod1'; // 'mod1' 未执行
import { c } from './mod2'; // 'mod2' 执行
import { b } from './mod1'; // 'mod1' 执行
import { hilog } from '@kit.PerformanceAnalysisKit';

console.info('main executed');
while (false) {
  let xx = a;
  let xy = b;
  let xz = c;
}

@Entry
@Component
struct Index {
  @State message: string = 'LazyImport';

  build() {
    Column() {
      Button('Call a')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          this.message = 'Call a success result: a = ' + a;
          console.info(a);
        })
      Button('Call b')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          this.message = 'Call b success result: b = ' + b;
          console.info(b);
        })
      Button('Call c')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          this.message = 'Call c success result: c = ' + c;
          console.info(c);
        })
      Button('Not advisable to use one')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          import('./middle').then((res: ESObject) => {
            console.info(res.c);
          }).catch((e: Error) => {
            hilog.error(0x0000, '[Sample_LazyImport]', 'Test  Assert error: %{public}s', e.toString());
            this.message = 'Not advisable to use one error: ' + e.toString();
          })
        })
      Button('Not advisable to use two')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          import('./middle').then((res: ESObject) => {
            console.info(res.ns.c);
          }).catch((e: Error) => {
            hilog.error(0x0000, '[Sample_LazyImport]', 'Test  Assert error: %{public}s', e.toString());
            this.message = 'Not advisable to use two error: ' + e.toString();
          })
        })
      Text(this.message)
        .fontSize(20)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}