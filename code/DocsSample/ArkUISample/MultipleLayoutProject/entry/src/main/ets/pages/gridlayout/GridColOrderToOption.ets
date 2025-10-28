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
//[Start GridColOrderToOption_start]
@Entry
@Component
struct GridRowExample1 {
  @State currentBp: string = 'unknown'

  build() {
    Column({ space: 5 }) {
      GridRow({ columns: 12 }) {
        GridCol({
          order: { xs: 1, sm: 5, md: 3, lg: 7 }, span: 1 }) {
          Row() {
            Text('1')
          }.width('100%').height('50vp')
        }.backgroundColor('rgb(213,213,213)')

        GridCol({
          order: { xs: 2, sm: 2, md: 6, lg: 1 }, span: 1 }) {
          Row() {
            Text('2')
          }.width('100%').height('50vp')
        }.backgroundColor('rgb(150,150,150)')

        GridCol({ order: { xs: 3, sm: 3, md: 1, lg: 6 }, span: 1 }) {
          Row() {
            Text('3')
          }.width('100%').height('50vp')
        }.backgroundColor('rgb(0,74,175)')

        GridCol({ order: { xs: 4, sm: 4, md: 2, lg: 5 }, span: 1 }) {
          Row() {
            Text('4')
          }.width('100%').height('50vp')
        }.backgroundColor('rgb(39,135,217)')
      }.border({ width: 1, color: 'rgb(39,135,217)' }).height('200vp').onBreakpointChange((breakpoint) => {
        this.currentBp = breakpoint
      })

      Text(this.currentBp)
    }
  }
}
// [End GridColOrderToOption_start]