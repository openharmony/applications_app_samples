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

@Entry
@Component
struct RowLayoutVerticalAlignTop {
  build() {
    Row({}) {
      Column() {
      }.width('20%').height(30).backgroundColor(0xF5DEB3)

      Column() {
      }.width('20%').height(30).backgroundColor(0xD2B48C)

      Column() {
      }.width('20%').height(30).backgroundColor(0xF5DEB3)
    }.width('100%').height(200).alignItems(VerticalAlign.Top).backgroundColor('rgb(242,242,242)')
  }
}