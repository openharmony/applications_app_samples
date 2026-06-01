/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { ComponentCard } from '../../common/Card';
import { LengthMetrics, LazyColumnLayout, LazyColumnLayoutAttribute } from '@kit.ArkUI';

@Entry
@Component
export struct LazyColumnLayoutSample {
  @State numbers: number[] = [];

  aboutToAppear(): void {
    for (let i = 0; i < 3; i++) {
      this.numbers.push(i);
    }
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.lazyColumnLayout_space_alignItemsStart')替换为实际资源文件
        // 在本示例中该资源文件的value值为"设置行间距和水平起始位置对齐方式示例"
        ComponentCard({ title: $r('app.string.lazyColumnLayout_space_alignItemsStart') }) {
          Scroll() {
            // [Start build_a_lazy_column]
            LazyColumnLayout() {
              ForEach(this.numbers, (item: number) => {
                Text()
                  .height(64)
                  .width('50%')
                  .borderRadius(5)
                  .backgroundColor('#ffe0e2e4')
                  .textAlign(TextAlign.Center)
              }, (item: number) => item.toString())
            }
            .space(LengthMetrics.vp(10))
            .alignItems(HorizontalAlign.Start)
            // [End build_a_lazy_column]
          }
          .scrollable(ScrollDirection.Vertical)
          .layoutWeight(1)
        }

        // 请将$r('app.string.lazyColumnLayout_space_alignItemsCenter')替换为实际资源文件
        // 在本示例中该资源文件的value值为"设置行间距和水平居中对齐方式示例"
        ComponentCard({ title: $r('app.string.lazyColumnLayout_space_alignItemsCenter') }) {
          Scroll() {
            // [Start build_a_lazy_column]
            LazyColumnLayout() {
              ForEach(this.numbers, (item: number) => {
                Text()
                  .height(64)
                  .width('50%')
                  .borderRadius(5)
                  .backgroundColor('#ffe0e2e4')
                  .textAlign(TextAlign.Center)
              }, (item: number) => item.toString())
            }
            .space(LengthMetrics.vp(10))
            .alignItems(HorizontalAlign.Center)
            // [End build_a_lazy_column]
          }
          .scrollable(ScrollDirection.Vertical)
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.lazyColumnLayout_title')替换为实际资源文件
    // 在本示例中该资源文件的value值为"懒加载线性布局/LazyColumnLayout"
    .title($r('app.string.lazyColumnLayout_title'))
  }
}