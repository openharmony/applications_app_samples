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
struct GridColOffset {
  //[Start gridOffset_start]
  gOffset:Record<string,number> = { 'xs': 1, 'sm': 2, 'md': 3, 'lg': 4 }

  // [End gridOffset_start]
  build() {
    //[Start gridOffset_start]
    // [StartExclude gridOffset_start]
    GridRow({ gutter: { x: 20, y: 50 } }) {
      // [EndExclude gridOffset_start]
      GridCol({ offset: 2, span: 1 }) {
        // [StartExclude gridOffset_start]
        Row() {
          Text('1')
        }.width('100%').height('50')

        // [EndExclude gridOffset_start]
      }
      // [StartExclude gridOffset_start]
      .backgroundColor('rgb(150,150,150)')

      // [EndExclude gridOffset_start]
      GridCol({ offset: { xs: 2, sm: 2, md: 2, lg: 2 }, span: 1 }) {
        // [StartExclude gridOffset_start]
        Row() {
          Text('2')
        }.width('100%').height('50')

        // [EndExclude gridOffset_start]
      }
      // [StartExclude gridOffset_start]
      .backgroundColor('rgb(213,213,213)')

      // [EndExclude gridOffset_start]
      GridCol({ span: 1 }) {
        // [StartExclude gridOffset_start]
        Row() {
          Text('4')
        }.width('100%').height('50')

        // [EndExclude gridOffset_start]
      }.offset(this.gOffset)
      // [StartExclude gridOffset_start]
      .backgroundColor('rgb(39,135,217)')
    }
    .height(200)
    .border({ color: 'rgb(39,135,217)', width: 2 })

    // [EndExclude gridOffset_start]
    // [End gridOffset_start]
  }
}