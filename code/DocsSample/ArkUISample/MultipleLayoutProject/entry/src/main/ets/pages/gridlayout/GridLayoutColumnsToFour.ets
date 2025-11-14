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
//[Start GridLayoutColumnsToFour_start]
// xxx.ets
@Entry
@Component
struct FixedFourColumnGrid {
  @State bgColors: ResourceColor[] =
    ['rgb(213,213,213)', 'rgb(150,150,150)', 'rgb(0,74,175)', 'rgb(39,135,217)', 'rgb(61,157,180)', 'rgb(23,169,141)',
      'rgb(255,192,0)', 'rgb(170,10,33)'];
  @State currentBp: string = 'unknown';
  build() {
    Row() {
      GridRow({ columns: 4 }) {
        ForEach(this.bgColors, (item: ResourceColor, index?: number | undefined) => {
          GridCol({ span: 1 }) {
            Row() {
              Text(`${index}`)
            }.width('100%').height('50')
          }.backgroundColor(item)
        })
      }
      .width('100%').height('100%')
    }
    .height(160)
    .border({ color: 'rgb(39,135,217)', width: 2 })
    .width('90%')
  }
}
// [End GridLayoutColumnsToFour_start]