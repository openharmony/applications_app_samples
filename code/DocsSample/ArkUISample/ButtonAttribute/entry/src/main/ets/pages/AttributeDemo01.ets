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

// [Start_attribute]
import { MyButtonModifier } from '../Common/button_modifier_01';
import { MyButtonModifier2 } from '../Common/button_modifier_02';
import { MyButtonModifier3 } from '../Common/button_modifier_03';
import { MyButtonModifier4 } from '../Common/button_modifier_04'

@Entry
@Component
struct attributeDemo_01 {
  @State modifier: MyButtonModifier = new MyButtonModifier(true);
  @State modifier2: MyButtonModifier = new MyButtonModifier(true);
  @State modifier3: MyButtonModifier2 = new MyButtonModifier2(true);
  @State modifier4: MyButtonModifier3 = new MyButtonModifier3(true);
  @State modifier5: MyButtonModifier4 = new MyButtonModifier4();

  build() {
    Row() {
      Column({space:20}) {
        Button('Button1')
          .id('btn')
          .attributeModifier(this.modifier)
          .onClick(() => {
            this.modifier.isDark = !this.modifier.isDark
          })
        Button('Button2')
          .id('btn2')
          .backgroundColor('#2787D9')
          .attributeModifier(this.modifier2)
          .onClick(() => {
            this.modifier2.isDark = !this.modifier2.isDark
          })
        Button('Button3')
          .id('btn3')
          .attributeModifier(this.modifier3)
          .attributeModifier(this.modifier4)
          .onClick(() => {
            this.modifier3.isDark = !this.modifier3.isDark
            this.modifier4.isDark2 = !this.modifier4.isDark2
          })
        Button('Button4')
          .id('btn4')
          .attributeModifier(this.modifier5)
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End_attribute]