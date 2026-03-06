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

// [Start ChangeLayoutWithMediaQuery]
import {
  DynamicLayout, DynamicLayoutAttribute, ColumnLayoutAlgorithm, LayoutAlgorithm, LengthMetrics, mediaquery,
  GridLayoutAlgorithm
} from '@kit.ArkUI';

// 商品数据模型
interface Product {
  id: string;
  name: string;
  price: string;
  image: string;
}

@Entry
@ComponentV2
struct ProductListExample {
  @Local algorithm: LayoutAlgorithm = new ColumnLayoutAlgorithm({
    space: LengthMetrics.vp(12)
  });
  @Local currentOrientation: string = '竖屏';
  // 商品数据
  private products: Product[] = [
    { id: '1', name: '智能手机 Pro', price: '¥5999', image: '商品' },
    { id: '2', name: '无线耳机', price: '¥899', image: '商品' },
    { id: '3', name: '智能手表', price: '¥1999', image: '商品' },
    { id: '4', name: '平板电脑', price: '¥3999', image: '商品' }
  ];

  // 监听横屏事件
  listener: mediaquery.MediaQueryListener = this.getUIContext().getMediaQuery().matchMediaSync('(orientation: landscape)');

  // 当满足媒体查询条件时，触发回调
  onOrientationChange(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches) {
      // 横屏：使用2x2网格布局
      this.algorithm = new GridLayoutAlgorithm({
        columnsTemplate: '1fr 1fr',
        columnsGap: LengthMetrics.vp(10),
        rowsGap: LengthMetrics.vp(10)
      });
      this.currentOrientation = '横屏';
    } else {
      // 竖屏：使用列表布局（每行一个商品）
      this.algorithm = new ColumnLayoutAlgorithm({
        space: LengthMetrics.vp(12)
      });
      this.currentOrientation = '竖屏';
    }
  }

  aboutToAppear() {
    // 绑定回调函数
    this.listener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
      this.onOrientationChange(mediaQueryResult);
    });
  }

  aboutToDisappear() {
    // 解绑listener中注册的回调函数
    this.listener.off('change');
  }

  // 商品卡片组件
  @Builder ProductCard(product: Product) {
    Row() {
      Text(product.image)
        .fontSize(20)
        .margin({ right: 12 })
      Column() {
        Text(product.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(0x333333)
          .margin({ bottom: 4 })
        Text(product.price)
          .fontSize(18)
          .fontColor(0xFF6B35)
          .fontWeight(FontWeight.Bold)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ right: 12 })
      Button('购买')
        .fontSize(14)
        .height(32)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(0xFAFAFA)
    .borderRadius(8)
    .border({ width: 1, color: 0xE0E0E0 })
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('商品列表')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(0x333333)
        Blank()
        Text(`${this.currentOrientation}`)
          .fontSize(12)
          .fontColor(0x999999)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(0xF0F0F0)
          .borderRadius(4)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(Color.White)

      // 商品列表
      Scroll() {
        DynamicLayout(this.algorithm) {
          ForEach(this.products, (product: Product) => {
            this.ProductCard(product)
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding(12)
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor(0xF5F5F5)

      // 提示信息
      Text('旋转设备可查看不同布局效果')
        .fontSize(12)
        .fontColor(0x999999)
        .textAlign(TextAlign.Center)
        .padding(12)
        .width('100%')
        .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }
}
// [End ChangeLayoutWithMediaQuery]