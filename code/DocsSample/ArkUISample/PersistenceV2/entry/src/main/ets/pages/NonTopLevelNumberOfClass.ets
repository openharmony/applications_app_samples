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

// [Start non_top_level_number_of_class]
import { PersistenceV2 } from '@kit.ArkUI';

@ObservedV2 class NumberClass {
  // Number类型不是顶层持久化数据类型，只能支持非顶层数据类型的持久化
  @Trace public value: Number = new Number(Infinity);
}

@Entry
@ComponentV2
struct Page1 {
  // Number类型只能作为NumberClass的子属性去持久化
  @Local number: NumberClass = PersistenceV2.globalConnect({
    type: NumberClass,
    defaultCreator: () => new NumberClass()
  })!;
  output: string[] = [];

  aboutToAppear(): void {
    this.output.push(`this.number.value: ${this.number.value}, is instanceof Number ${this.number.value instanceof Number}`);
    this.number.value = new Number(-this.number.value);
  }

  build() {
    Column() {
      Row() {
        // 第一次打开应用，界面显示'this.number.value: Infinity, is instanceof Number true'
        // 第二次打开应用，界面显示'this.number.value: -Infinity, is instanceof Number true'
        Text(this.output.join('\n\n'))
          .fontSize(24)
      }
    }
    .width('100%')
  }
}
// [End non_top_level_number_of_class]