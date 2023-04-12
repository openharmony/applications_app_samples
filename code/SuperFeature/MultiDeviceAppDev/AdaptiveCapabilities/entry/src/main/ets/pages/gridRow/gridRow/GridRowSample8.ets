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

@Entry
@Component
struct GridRowSample8 {
  private elements: Object[] = [
    { 'index': 1, 'color': $r('sys.color.ohos_id_color_palette_aux1') },
    { 'index': 2, 'color': $r('sys.color.ohos_id_color_palette_aux2') },
    { 'index': 3, 'color': $r('sys.color.ohos_id_color_palette_aux3') },
    { 'index': 4, 'color': $r('sys.color.ohos_id_color_palette_aux4') },
    { 'index': 5, 'color': $r('sys.color.ohos_id_color_palette_aux5') },
    { 'index': 6, 'color': $r('sys.color.ohos_id_color_palette_aux6') }
  ]

  build() {
    GridRow() {
      ForEach(this.elements, (item) => {
        GridCol({ span: { sm: 4, lg: 3 }, offset: { sm: 2, lg: 1 },
          order: { sm: (6 - item.index), lg: item.index } }) {
          Row() {
            Text(`${item.index}`).fontSize(24)
          }
          .justifyContent(FlexAlign.Center)
          .backgroundColor(item.color)
          .height(30)
        }
      })
    }
  }
}