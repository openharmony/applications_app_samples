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

// [Start WaterFlowLayout]
import {
  DynamicLayout, DynamicLayoutAttribute, CustomLayoutAlgorithm, LayoutAlgorithm, FrameNode, LayoutConstraint, Position
} from '@kit.ArkUI';

// 瀑布流布局算法
class WaterfallLayout extends CustomLayoutAlgorithm {
  private columnCount: number = 2;
  private columnGap: number = 10;
  private rowGap: number = 10;

  onMeasure(self: FrameNode, constraint: LayoutConstraint): void {
    const childCount = self.getChildrenCount();
    const columnWidth = (constraint.maxSize.width - (this.columnCount - 1) * this.columnGap) / this.columnCount;
    // 记录每列的当前高度
    const columnHeights: number[] = new Array(this.columnCount).fill(0);
    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        // 通过将minSize和maxSize设置为相同值来约束子组件宽度
        const childConstraint: LayoutConstraint = {
          maxSize: {
            width: columnWidth,
            height: constraint.maxSize.height
          },
          minSize: {
            width: columnWidth,
            height: 0
          },
          percentReference: constraint.percentReference
        };
        child.measure(childConstraint);
        // 找到当前高度最小的列
        const minColumn = columnHeights.indexOf(Math.min(...columnHeights));
        columnHeights[minColumn] += child.getMeasuredSize().height + this.rowGap;
      }
    }
    const maxHeight = Math.max(...columnHeights);
    self.setMeasuredSize({
      width: constraint.maxSize.width,
      height: maxHeight
    });
  }

  onLayout(self: FrameNode, position: Position): void {
    const childCount = self.getChildrenCount();
    const measuredSize = self.getMeasuredSize();
    const columnWidth = (measuredSize.width - (this.columnCount - 1) * this.columnGap) / this.columnCount;
    // 记录每列的当前Y坐标
    const columnYs: number[] = new Array(this.columnCount).fill(0);
    for (let i = 0; i < childCount; i++) {
      const child = self.getChild(i);
      if (child) {
        const childSize = child.getMeasuredSize();
        // 找到当前Y坐标最小的列
        const minColumn = columnYs.indexOf(Math.min(...columnYs));
        const x = minColumn * (columnWidth + this.columnGap);
        const y = columnYs[minColumn];
        child.layout({ x, y });
        columnYs[minColumn] += childSize.height + this.rowGap;
      }
    }
    self.setLayoutPosition(position);
  }
}

@Entry
@ComponentV2
struct WaterfallLayoutExample {
  @Local algorithm: LayoutAlgorithm = new WaterfallLayout();

  // 商品数据
  private products: Product[] = [
    { id: '1', name: '时尚运动鞋', price: '¥399', height: 180, image: '商品图' },
    { id: '2', name: '休闲双肩包', price: '¥259', height: 220, image: '商品图' },
    { id: '3', name: '无线蓝牙耳机', price: '¥599', height: 150, image: '商品图' },
    { id: '4', name: '智能手表', price: '¥1299', height: 200, image: '商品图' },
    { id: '5', name: '太阳眼镜', price: '¥199', height: 130, image: '商品图' },
    { id: '6', name: '便携充电宝', price: '¥129', height: 170, image: '商品图' },
    { id: '7', name: '机械键盘', price: '¥459', height: 160, image: '商品图' },
    { id: '8', name: '游戏鼠标', price: '¥189', height: 140, image: '商品图' },
    { id: '9', name: '高清显示器', price: '¥1599', height: 210, image: '商品图' },
    { id: '10', name: '智能音箱', price: '¥299', height: 190, image: '商品图' }
  ];

  // 商品卡片组件
  @Builder ProductCard(product: Product) {
    Column() {
      Text(product.image)
        .fontSize(18)
        .margin({ bottom: 8 })
      Text(product.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(0x333333)
        .margin({ bottom: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(product.price)
        .fontSize(16)
        .fontColor(0xFF6B35)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(0xFAFAFA)
    .borderRadius(8)
    .border({ width: 1, color: 0xE0E0E0 })
    .height(product.height)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Text('商品列表 - 瀑布流布局')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Scroll() {
        DynamicLayout(this.algorithm) {
          ForEach(this.products, (product: Product) => {
            this.ProductCard(product)
          })
        }
        .width('100%')
        .backgroundColor(0xEFEFEF)
        .borderRadius(12)
        .padding(10)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
      .layoutWeight(1)

      Text('商品卡片自动分配到高度最小的列')
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 12 })
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }
}

// 商品数据模型
interface Product {
  id: string;
  name: string;
  price: string;
  height: number;
  image: string;
}
// [End WaterFlowLayout]