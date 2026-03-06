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

// [Start CustomLayoutBasic]
import {
  DynamicLayout, DynamicLayoutAttribute, CustomLayoutAlgorithm, FrameNode, LayoutConstraint, Position, LayoutAlgorithm
} from '@kit.ArkUI';

// 自定义布局算法类
class MyCustomLayout extends CustomLayoutAlgorithm {
  onMeasure(self: FrameNode, constraint: LayoutConstraint): void {
    // 1. 获取子组件数量
    const childCount = self.getChildrenCount();
    let totalWidth = 0;
    let maxHeight = 0;
    // 2. 遍历子组件，进行测量
    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        // 3. 创建子组件的布局约束
        const childConstraint: LayoutConstraint = {
          maxSize: { width: 150, height: 150},
          minSize: { width: 150, height: 150},
          percentReference: constraint.percentReference
        };
        // 4. 测量子组件
        child.measure(childConstraint);
        // 5. 获取子组件测量后的尺寸
        const childSize = child.getMeasuredSize();
        totalWidth += childSize.width;
        maxHeight = Math.max(maxHeight, childSize.height);
      }
    }
    const measuredSize: Size = {
      width: Math.min(totalWidth, constraint.maxSize.width),
      height: Math.min(maxHeight, constraint.maxSize.height)
    };
    // 6. 设置自身的测量尺寸
    self.setMeasuredSize(measuredSize);
  }

  onLayout(self: FrameNode, position: Position): void {
    // 1. 获取子组件数量
    const childCount = self.getChildrenCount();
    let offsetX = 0;
    // 2. 遍历子组件，设置布局位置
    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        // 3. 获取子组件测量后的尺寸
        const childSize = child.getMeasuredSize();
        const childPosition: Position = {
          x: offsetX,
          y: 0
        };
        // 4. 设置子组件的布局位置
        child.layout(childPosition);
        // 5. 更新偏移量
        offsetX += childSize.width;
      }
    }
    // 6. 设置自身的布局位置
    self.setLayoutPosition(position);
  }
}

@Entry
@ComponentV2
struct CustomLayoutBasic {
  @Local algorithm: LayoutAlgorithm = new MyCustomLayout()
  build() {
    Column({ space: 10 }) {
      DynamicLayout(this.algorithm) {
        Text('Item 1')
          .fontSize(14)
          .backgroundColor(0xF5DEB3)
        Text('Item 2')
          .fontSize(14)
          .fontSize(14)
          .backgroundColor(0xD2B48C)
        Text('Item 3')
          .fontSize(14)
          .backgroundColor(0xF5DEB3)
        Text('Item 4')
          .fontSize(14)
          .backgroundColor(0xD2B48C)
      }
      .width('100%')
      .height(200)
      .backgroundColor(0xEFEFEF)
    }
    .padding(20)
  }
}
// [End CustomLayoutBasic]