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
//[Start GridColOrder_start]
let gOrder:Record<string,number> = { 'xs': 1, 'sm': 2, 'md': 3, 'lg': 4 }
//[End GridColOrder_start]
@Entry
@Component
struct GridColOrder {

  build() {
    GridRow({ gutter: { x: 20, y: 50 } }) {
      //[Start GridColOrder1_start]
      GridCol({ order: 2, span: 1 }){}
      GridCol({ order: { xs: 1, sm: 2, md: 3, lg: 4 }, span: 1 }){}
      GridCol({ span: 1 }){}.order(2)
      GridCol({ span: 1 }){}.order(gOrder)
      //[End GridColOrder1_start]
    }
    .height(200)
    .border({ color: 'rgb(39,135,217)', width: 2 })
  }
}