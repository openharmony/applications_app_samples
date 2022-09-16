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
struct GridRowSample3 {
  private bgColors: ResourceColor[] = [
    $r('sys.color.ohos_id_color_palette_aux1'),
    $r('sys.color.ohos_id_color_palette_aux2'),
    $r('sys.color.ohos_id_color_palette_aux3'),
    $r('sys.color.ohos_id_color_palette_aux4'),
    $r('sys.color.ohos_id_color_palette_aux5'),
    $r('sys.color.ohos_id_color_palette_aux6')
  ]

  build() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 },
      gutter: { x: { sm: 8, md: 16, lg: 24 }, y: { sm: 8, md: 16, lg: 24 } }
    }) {
      ForEach(this.bgColors, (bgColor) => {
        GridCol({ span: { sm: 2, md: 2, lg: 2 } }) {
          Row()
            .backgroundColor(bgColor)
            .height(30)
        }
      })
    }
  }
}