/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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


@Preview
@Component
export struct Menus {
  gridNum: number = 1

  @Styles pressedStyles() {
    .backgroundColor('#2d099999')
  }

  build() {
    GridRow() {
      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('Home').width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)

      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('Products').width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)

      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('Market').width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)

      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('About').textAlign(TextAlign.Start).width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)
    }
  }
}
