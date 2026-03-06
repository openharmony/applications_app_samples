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

// [Start GridLayout]
import {
  DynamicLayout, DynamicLayoutAttribute, CustomLayoutAlgorithm, LayoutAlgorithm, FrameNode, LayoutConstraint, Position
} from '@kit.ArkUI';

// 2x2网格布局算法
export class GridLayout extends CustomLayoutAlgorithm {
  private gap: number = 12;
  private itemHeights: number[] = [];

  onMeasure(self: FrameNode, constraint: LayoutConstraint): void {
    const childCount = self.getChildrenCount();
    const columns = 2;
    const itemWidth = (constraint.maxSize.width - (columns - 1) * this.gap) / columns;
    this.itemHeights = [];

    // 第一遍测量：获取每个子组件的理想高度
    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        const childConstraint: LayoutConstraint = {
          maxSize: { width: itemWidth, height: Number.MAX_VALUE },
          minSize: { width: itemWidth, height: 0 },
          percentReference: constraint.percentReference
        };
        child.measure(childConstraint);
        this.itemHeights.push(child.getMeasuredSize().height);
      }
    }

    // 计算每行的最大高度
    const rows = Math.ceil(childCount / columns);
    const rowHeights: number[] = [];
    for (let r = 0; r < rows; r++) {
      let maxRowHeight = 0;
      for (let c = 0; c < columns; c++) {
        const index = r * columns + c;
        if (index < this.itemHeights.length && this.itemHeights[index] > maxRowHeight) {
          maxRowHeight = this.itemHeights[index];
        }
      }
      rowHeights.push(maxRowHeight);
    }

    // 计算总高度
    const totalHeight = rowHeights.reduce((sum, h) => sum + h, 0) + (rows - 1) * this.gap;

    // 第二遍测量：使用每行的统一高度重新测量子组件
    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        const row = Math.floor(i / columns);
        const rowHeight = rowHeights[row];
        const childConstraint: LayoutConstraint = {
          maxSize: { width: itemWidth, height: rowHeight },
          minSize: { width: itemWidth, height: rowHeight },
          percentReference: constraint.percentReference
        };
        child.measure(childConstraint);
      }
    }

    self.setMeasuredSize({
      width: constraint.maxSize.width,
      height: totalHeight
    });
  }

  onLayout(self: FrameNode, position: Position): void {
    const childCount = self.getChildrenCount();
    const measuredSize = self.getMeasuredSize();
    const columns = 2;
    const itemWidth = (measuredSize.width - (columns - 1) * this.gap) / columns;

    // 重新计算每行的最大高度
    const rows = Math.ceil(childCount / columns);
    const rowHeights: number[] = [];
    for (let r = 0; r < rows; r++) {
      let maxRowHeight = 0;
      for (let c = 0; c < columns; c++) {
        const index = r * columns + c;
        if (index < this.itemHeights.length && this.itemHeights[index] > maxRowHeight) {
          maxRowHeight = this.itemHeights[index];
        }
      }
      rowHeights.push(maxRowHeight);
    }

    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        const row = Math.floor(i / columns);
        const col = i % columns;
        const x = col * (itemWidth + this.gap);
        const y = row === 0 ? 0 : rowHeights.slice(0, row).reduce((sum, h) => sum + h, 0) + row * this.gap;
        child.layout({ x, y });
      }
    }

    self.setLayoutPosition(position);
  }
}

@Entry
@ComponentV2
struct GridLayoutExample {
  @Local algorithm: LayoutAlgorithm = new GridLayout();

  build() {
    Column() {
      Text('网格布局示例')
        .fontSize(18)
        .margin({ bottom: 20 })

      DynamicLayout(this.algorithm) {
        ForEach(['卡片1', '卡片2', '卡片3', '卡片4'], (title: string, index: number) => {
          Column() {
            Text(title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(0x333333)
              .margin({ bottom: 8 })
            Text('内容区域')
              .fontSize(12)
              .fontColor(0x666666)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(0xFAFAFA)
          .borderRadius(8)
          .border({ width: 1, color: 0xE0E0E0 })
        })
      }
      .width('100%')
      .backgroundColor(0xEFEFEF)
      .borderRadius(12)
      .padding(12)

      Text('同一行的子组件高度保持一致')
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 20 })
    }
    .padding(20)
    .width('100%')
  }
}
// [End GridLayout]