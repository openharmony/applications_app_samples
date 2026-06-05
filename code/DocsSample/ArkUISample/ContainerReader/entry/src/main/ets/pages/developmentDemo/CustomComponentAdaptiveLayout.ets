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

// [Start CustomComponentAdaptiveLayout]
import {ContainerReader, ContainerReaderAttribute, Size} from '@kit.ArkUI';

// 自适应卡片组件，内部使用ContainerReader感知容器尺寸
@Component
struct AdaptiveCard {
  @State containerSize: Size = { width: 0, height: 0 };
  @State widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_MD;
  @Prop title: string = 'Card Title';
  @Prop content: string = 'Card content text';

  build() {
    ContainerReader({
      size: this.containerSize!!,
      widthBreakpoint: this.widthBp!!
    }) {
      Text('width'+this.containerSize?.width)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#D5D5D5')
    .border({ width: 1, color: '#D5D5D5', radius: 8 })
  }

  // 根据断点切换卡片内容布局：小尺寸纵向排列，大尺寸横向排列
  @Builder
  buildCardContent() {
    if (this.widthBp === WidthBreakpoint.WIDTH_XS || this.widthBp === WidthBreakpoint.WIDTH_SM) {
      // 小尺寸：纵向排列，文本最多2行
      Column({ space: 10 }) {
        Column({ space: 5 }) {
          Text(this.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text(this.content)
            .fontSize(12)
            .fontColor('#707070')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .padding(10)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
    } else {
      // 大尺寸：横向排列，文本最多3行
      Row({ space: 10 }) {
        Column({ space: 5 }) {
          Text(this.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text(this.content)
            .fontSize(12)
            .fontColor('#707070')
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(10)
    }
  }
}

// 使用不同尺寸的容器展示AdaptiveCard的自适应效果
@Entry
@Component
struct AdaptiveCardExample {
  build() {
    Column({ space: 20 }) {
      Text('Adaptive Card Components')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Text('Small Container:')
        .fontSize(14)
        .fontColor('#707070')
        .alignSelf(ItemAlign.Start)

      // 小容器：触发小尺寸断点，纵向布局
      AdaptiveCard({
        title: 'Small Card',
        content: 'This card adapts to small containers with vertical layout.'
      })
        .width(200)
        .height(200)

      Text('Large Container:')
        .fontSize(14)
        .fontColor('#707070')
        .alignSelf(ItemAlign.Start)

      // 大容器：触发大尺寸断点，横向布局
      AdaptiveCard({
        title: 'Large Card',
        content: 'This card adapts to large containers with horizontal layout.'
      })
        .width(300)
        .height(150)
    }
    .width('100%')
    .padding(20)
  }
}
// [End CustomComponentAdaptiveLayout]