/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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

// [Start ChangeLayoutWithConditionVariable]
import {
  DynamicLayout, DynamicLayoutAttribute, RowLayoutAlgorithm, ColumnLayoutAlgorithm, LengthMetrics
} from '@kit.ArkUI';

@Entry
@ComponentV2
struct ConditionalLayoutExample {
  @Local isHorizontal: boolean = true;

  build() {
    Column() {
      // 使用三元运算符根据条件选择布局算法
      DynamicLayout(
        this.isHorizontal
          ? new RowLayoutAlgorithm({ space: LengthMetrics.vp(10) })
          : new ColumnLayoutAlgorithm({ space: LengthMetrics.vp(10) })
      ) {
        Text('Item 1')
          .width(80)
          .height(40)
          .fontSize(14)
          .backgroundColor(0xF5DEB3)
        Text('Item 2')
          .width(80)
          .height(40)
          .fontSize(14)
          .backgroundColor(0xD2B48C)
        Text('Item 3')
          .width(80)
          .height(40)
          .fontSize(14)
          .backgroundColor(0xF5DEB3)
      }
      .width('100%')
      .height(150)
      .backgroundColor(0xEFEFEF)

      Button('切换方向')
        .onClick(() => {
          this.isHorizontal = !this.isHorizontal;
        })
    }
    .padding(20)
  }
}
// [End ChangeLayoutWithConditionVariable]