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
// [Start main_button1]

// pages/Button1.ets
import { MyButtonModifier } from '../Common/ButtonModifier01'

@Entry
@Component
struct Button1 {
  // 支持用状态装饰器修饰，行为和普通的对象一致
  @State modifier: MyButtonModifier = new MyButtonModifier(true);

  build() {
    Row() {
      Column() {
        Button('Button')
          .attributeModifier(this.modifier)
          .onClick(() => {
            // 对象的一层属性被修改时，会触发UI刷新，重新执行applyNormalAttribute
            this.modifier.isDark = !this.modifier.isDark
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End main_button1]
