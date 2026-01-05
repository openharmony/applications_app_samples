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

// [Start top_level_date]
import { PersistenceV2, UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Page1 {
  // 支持直接持久化Date类型的数据
  @Local date: Date = PersistenceV2.globalConnect({
    type: Date,
    defaultCreator: () => UIUtils.makeObserved(new Date())
  })!;

  build() {
    Column({ space: 40 }) {
      Text(`date: ${this.date.toISOString()}`)
        .fontSize(24)
      // 点击'date.setTime( Date.now() )', 杀掉应用，进入应用后，显示日期
      Button('date.setTime( Date.now() )')
        .onClick(() => {
          this.date.setTime(Date.now());
        })
        .fontSize(24)
    }
    .width('100%')
  }
}
// [End top_level_date]