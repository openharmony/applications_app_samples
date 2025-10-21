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

let alignRus001: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
}
let relConB: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': 'row1', 'align': VerticalAlign.Bottom },
  'left': { 'anchor': 'row1', 'align': HorizontalAlign.Start }
}
let marginLeft001: Record<string, number> = { 'left': 20 }
let bwc001: Record<string, number | string> = { 'width': 2, 'color': '#6699FF' }

@Entry
@Component
struct RelativeContainerSiblingComponentId {
  build() {
    RelativeContainer() {
      Row() {
        Text('row1')
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#00ae9d')
      .alignRules(alignRus001)
      .id('row1')

      Row() {
        Text('row2')
      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#a3cf62')
      .alignRules(relConB)
      .id('row2')
    }.width(300).height(300)
    .margin(marginLeft001)
    .border(bwc001)
  }
}
