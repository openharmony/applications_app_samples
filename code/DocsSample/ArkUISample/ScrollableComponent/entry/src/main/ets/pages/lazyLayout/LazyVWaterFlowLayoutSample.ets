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
import { LengthMetrics, LazyVWaterFlowLayout, LazyVWaterFlowLayoutAttribute } from '@kit.ArkUI';

@Entry
@Component
export struct LazyVWaterFlowLayoutSample {
  @State arr1: number[] = [];
  @State arr2: number[] = [];

  private itemHeight(index: number): number {
    return 80 + (index * 37 % 60)
  }

  private itemColor(index: number): string {
    const colors: string[] = ['#FFE0B2', '#C8E6C9', '#BBDEFB', '#F8BBD0', '#D1C4E9', '#FFF9C4']
    return colors[index % colors.length]
  }

  aboutToAppear(): void {
    for (let i = 0; i < 6; i++) {
      this.arr1.push(i);
    }
    for (let i = 0; i < 5; i++) {
      this.arr2.push(i);
    }
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.lazyVWaterFlowLayout_columns_equal')替换为实际资源文件
        // 在本示例中该资源文件的value值为"设置多列等宽的瀑布流示例"
        ComponentCard({ title: $r('app.string.lazyVWaterFlowLayout_columns_equal') }) {
          Scroll() {
            // [Start build_a_lazy_vWaterFlow]
            LazyVWaterFlowLayout() {
              ForEach(this.arr1, (item: number) => {
                Text()
                  .height(this.itemHeight(item))
                  .width('100%')
                  .borderRadius(5)
                  .backgroundColor(this.itemColor(item))
                  .textAlign(TextAlign.Center)
              }, (item: number) => item.toString())
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(LengthMetrics.vp(10))
            .columnsGap(LengthMetrics.vp(10))
            // [End build_a_lazy_vWaterFlow]
          }
          .scrollable(ScrollDirection.Vertical)
          .layoutWeight(1)
        }

        // 请将$r('app.string.lazyVWaterFlowLayout_columns_unequal')替换为实际资源文件
        // 在本示例中该资源文件的value值为"设置多列不等宽的瀑布流示例"
        ComponentCard({ title: $r('app.string.lazyVWaterFlowLayout_columns_unequal') }) {
          Scroll() {
            // [Start build_a_lazy_vWaterFlow]
            LazyVWaterFlowLayout() {
              ForEach(this.arr2, (item: number) => {
                Text()
                  .height(this.itemHeight(item))
                  .width('100%')
                  .borderRadius(5)
                  .backgroundColor(this.itemColor(item))
                  .textAlign(TextAlign.Center)
              }, (item: number) => item.toString())
            }
            .columnsTemplate('1fr 2fr')
            .rowsGap(LengthMetrics.vp(10))
            .columnsGap(LengthMetrics.vp(10))
            // [End build_a_lazy_vWaterFlow]
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
    // 请将$r('app.string.lazyVWaterFlowLayout_title')替换为实际资源文件
    // 在本示例中该资源文件的value值为"懒加载瀑布流布局/LazyVWaterFlowLayout"
    .title($r('app.string.lazyVWaterFlowLayout_title'))
  }
}