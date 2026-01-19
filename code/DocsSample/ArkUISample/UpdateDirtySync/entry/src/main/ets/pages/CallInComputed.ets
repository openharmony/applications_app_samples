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

// [Start CallInComputed]
import { UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Page {
  @Local firstName: string = 'Hua';
  @Local lastName: string = 'Li';
  @Local count: number = 0;

  @Computed
  get fullName() {
    // 在computed中调用applySync、flushUpdates、flushUIUpdates运行时报错
    UIUtils.flushUIUpdates();
    UIUtils.flushUpdates();
    UIUtils.applySync(() => {
      this.count++;
    });
    return this.firstName + ' ' + this.lastName;
  }

  build() {
    Column() {
      Text(`${this.fullName}`)
      Text(`${this.count}`)
      Button('change fullName').onClick(() => {
        this.firstName = 'Zhang';
        this.lastName = 'San';
      })
    }
  }
}
// [End CallInComputed]

@Builder
export function callInComputed() {
  NavDestination() {
    Page();
  }
  .backgroundColor('#f1f2f3')
  .title($r('app.string.called_in_computed'))
}