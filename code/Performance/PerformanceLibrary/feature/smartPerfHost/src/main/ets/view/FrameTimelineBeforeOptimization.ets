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
@Component
export struct FrameTimelineBeforeOptimization {
  // 创建长度500的空数组，使用每个元素的索引作为元素的值，生成包含数字0-499的数组
  @State children: number[] = Array.from<undefined, number>(Array(500).fill(undefined), (item: undefined, index) => index);
  build() {
    Scroll() {
      Grid() {
        ForEach(this.children, (item: number) => {
          GridItem() {
            Stack() {
              Stack() {
                Stack() {
                  Text(item.toString())
                    .fontSize(32)
                }
              }
            }
          }
        }, (item: number) => item.toString())
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(0)
      .rowsGap(0)
      .size({ width: "100%", height: "100%" })
    }
  }
}