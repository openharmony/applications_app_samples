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
// [Start main_button3]

// pages/Button3.ets
import { MyButtonModifier2 } from '../Common/ButtonModifier02';
import { MyButtonModifier3 } from '../Common/ButtonModifier03';

@Entry
@Component
struct Button3 {
  @State modifier: MyButtonModifier2 = new MyButtonModifier2(true);
  @State modifier2: MyButtonModifier3 = new MyButtonModifier3(true);

  build() {
    Row() {
      Column() {
        Button('Button')
          .attributeModifier(this.modifier)
          .attributeModifier(this.modifier2)
          .onClick(() => {
            this.modifier.isDark = !this.modifier.isDark
            this.modifier2.isDark2 = !this.modifier2.isDark2
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End main_button3]