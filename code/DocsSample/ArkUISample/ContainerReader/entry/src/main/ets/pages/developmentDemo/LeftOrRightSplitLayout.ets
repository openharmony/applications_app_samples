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

// [Start LeftOrRightSplitLayout]
import { ContainerReader, ContainerReaderAttribute, Size } from '@kit.ArkUI';

@Entry
@Component
struct SplitLayoutExample {
  @State containerSize: Size = { width: 0, height: 0 };
  @State widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_MD;
  @State currentTabIndex: number = 0;
  private menuItems: string[] = ['选项一', '选项二', '选项三', '选项四'];

  build() {
    Column() {
      Text('分栏布局')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Flex({ direction: FlexDirection.Row }) {
        // 左侧：垂直方向的Tabs标签栏，固定宽度100
        Tabs({ barPosition: BarPosition.Start, index: this.currentTabIndex }) {
          ForEach(this.menuItems, (item: string, index?: number) => {
            TabContent() {
              // 右侧：ContainerReader感知TabContent区域宽度
              ContainerReader({
                size: this.containerSize!!,
                widthBreakpoint: this.widthBp!!
              }) {
                this.buildDetailContent()
              }
              .padding(10)
            }
            .tabBar(item)
          }, (item: string, index?: number) => `${index}`)
        }
        .onChange((index: number) => {
          this.currentTabIndex = index;
        })
        .vertical(true)
        .barWidth(100)
        .backgroundColor('#F7F7F7')
      }
      .width('100%')
      .height(300)
    }
    .width('100%')
    .padding(20)
  }

  // 根据断点切换详情区域布局
  @Builder
  buildDetailContent() {
    if (this.widthBp === WidthBreakpoint.WIDTH_XS || this.widthBp === WidthBreakpoint.WIDTH_SM) {
      // 窄屏：标题和内容上下排列
      Column({ space: 10 }) {
        Column() {
          Text('标题区域')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height(60)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text('内容区域')
            .fontSize(14)
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F0FAFF')
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
    } else {
      // 宽屏：标题和内容左右排列
      Row({ space: 10 }) {
        Column() {
          Text('标题区域')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }
        .width(120)
        .height('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text('内容区域')
            .fontSize(14)
        }
        .layoutWeight(1)
        .height('100%')
        .backgroundColor('#F0FAFF')
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
  }
}
// [End LeftOrRightSplitLayout]