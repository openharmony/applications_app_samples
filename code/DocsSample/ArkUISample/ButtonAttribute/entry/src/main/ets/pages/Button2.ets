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
// [Start main_button2]

// pages/Button2.ets
import { MyButtonModifier } from '../Common/ButtonModifier01'

@Entry
@Component
struct Button2 {
  @State modifier: MyButtonModifier = new MyButtonModifier(true);

  build() {
    Row() {
      Column() {
        // 先设置属性，后设置modifier，按钮颜色会跟随modifier的值改变
        Button('Button')
          .backgroundColor('#2787D9')
          .attributeModifier(this.modifier)
          .onClick(() => {
            this.modifier.isDark = !this.modifier.isDark
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End main_button2]