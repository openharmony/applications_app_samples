/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

const ID_GRID: string = "ID_GRID";

@Component
export struct GridView {
  @State children: Number[] = Array.from(Array<number>(900), (v, k) => k);

  build() {
    Column() {
      Scroll() {
        Grid() {
          ForEach(this.children, (item: Number[]) => {
            GridItem() {
              Stack() {
                Stack() {
                  Stack() {
                    Text(item.toString())
                      .fontColor(Color.White)
                  }.size({ width: "100%" })
                }.backgroundColor(Color.Blue)
              }.backgroundColor(Color.Yellow)
            }
          }, (item: string) => item)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(0)
        .rowsGap(0)
        .size({ width: "100%", height: "100%" })
        .id(ID_GRID)
      }
    }
  }
}