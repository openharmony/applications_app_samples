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

// [Start TagCloudLayout]
import {
  DynamicLayout, DynamicLayoutAttribute, CustomLayoutAlgorithm, LayoutAlgorithm, FrameNode, LayoutConstraint, Position
} from '@kit.ArkUI';

// 标签云布局算法
class TagCloudLayout extends CustomLayoutAlgorithm {
  private horizontalGap: number = 12;
  private verticalGap: number = 12;

  onMeasure(self: FrameNode, constraint: LayoutConstraint): void {
    const childCount = self.getChildrenCount();
    const maxWidth = constraint.maxSize.width;

    let currentLineWidth = 0;
    let totalHeight = 0;
    let maxLineWidth = 0;

    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        // 测量子组件，不限制宽高
        const childConstraint: LayoutConstraint = {
          maxSize: { width: maxWidth, height: Number.MAX_VALUE },
          minSize: { width: 0, height: 0 },
          percentReference: constraint.percentReference
        };
        child.measure(childConstraint);
        const childSize = child.getMeasuredSize();
        // 检查是否需要换行
        if (currentLineWidth + childSize.width > maxWidth && currentLineWidth > 0) {
          // 换行
          totalHeight += this.verticalGap;
          currentLineWidth = childSize.width;
          totalHeight += childSize.height;
          maxLineWidth = Math.max(maxLineWidth, currentLineWidth - this.horizontalGap);
        } else {
          // 继续当前行
          currentLineWidth += childSize.width + this.horizontalGap;
          if (i === 0) {
            totalHeight = childSize.height;
          }
          maxLineWidth = Math.max(maxLineWidth, currentLineWidth - this.horizontalGap);
        }
      }
    }
    self.setMeasuredSize({
      width: Math.min(maxLineWidth, maxWidth),
      height: totalHeight
    });
  }

  onLayout(self: FrameNode, position: Position): void {
    const childCount = self.getChildrenCount();
    const measuredSize = self.getMeasuredSize();
    const maxWidth = measuredSize.width;

    let currentX = 0;
    let currentY = 0;
    let currentLineHeight = 0;

    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        const childSize = child.getMeasuredSize();
        // 检查是否需要换行
        if (currentX + childSize.width > maxWidth && currentX > 0) {
          // 换行
          currentY += currentLineHeight + this.verticalGap;
          currentX = 0;
          currentLineHeight = 0;
        }
        // 布局子组件
        child.layout({ x: currentX, y: currentY })
        // 更新位置
        currentX += childSize.width + this.horizontalGap;
        currentLineHeight = Math.max(currentLineHeight, childSize.height);
      }
    }
    self.setLayoutPosition(position);
  }
}

@Entry
@ComponentV2
struct TagCloudExample {
  @Local algorithm: LayoutAlgorithm = new TagCloudLayout();

  // 热门标签数据
  private tags: string[] = [
    '标签1', '标签标签标签', '标签2', '标签标签', '标签标签标',
    '标签标签标', '标签标签标签标签', '标签标签', '标签标签',
    '标签标', '标签标签', '标签标签', '标签标签标签',
    '标签标', '标签标签', '标签标签', '标签标签标'
  ];

  // 标签组件
  @Builder TagItem(tag: string, index: number) {
    Text(tag)
      .fontSize(14)
      .fontColor([0xFF6B6B, 0x4ECDC4, 0x45B7D1, 0xFFA07A, 0x98D8C8, 0xF7DC6F][index % 6])
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .backgroundColor(0xF5F5F5)
      .borderRadius(16)
      .border({ width: 1, color: 0xE0E0E0 })
  }

  build() {
    Column() {
      Text('热门话题 - 标签云布局')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Scroll() {
        DynamicLayout(this.algorithm) {
          ForEach(this.tags, (tag: string, index: number) => {
            this.TagItem(tag, index)
          }, (tag: string, index: number) => `${index}_${tag}`)
        }
        .width('100%')
        .padding(16)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')

      Text('标签自动换行，紧凑排列')
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 12 })
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }
}
// [End TagCloudLayout]