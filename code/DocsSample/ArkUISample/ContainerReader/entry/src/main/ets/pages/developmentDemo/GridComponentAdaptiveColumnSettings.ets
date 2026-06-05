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

// [Start GridComponentAdaptiveColumnSettings]
import {ContainerReader, ContainerReaderAttribute, Size} from '@kit.ArkUI';
@Entry
@Component
struct GridBreakpointExample {
  @State containerSize: Size = { width: 0, height: 0 };
  @State widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_MD;
  @State bgColors: ResourceColor[] =
    ['#707070', '#004AAF', '#2787D9', '#F7F7F7', '#F0FAFF'];

  build() {
    Column({ space: 10 }) {
      Text('Grid with Container Breakpoint')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      // ContainerReader包裹Grid，根据容器宽度断点动态调整列数
      Flex({ direction: FlexDirection.Column }) {
        ContainerReader({
          size: this.containerSize!!,
          widthBreakpoint: this.widthBp!!
        }) {
          Grid() {
            ForEach(this.bgColors, (color: ResourceColor, index?: number) => {
              GridItem() {
                Row() {
                  Text(`${index}`)
                }
                .width('100%')
                .height('50vp')
                .justifyContent(FlexAlign.Center)
              }
              .backgroundColor(color)
            })
          }
          // 根据断点值动态设置列模板
          .columnsTemplate(this.getColumnsTemplate())
          .columnsGap(10)
          .rowsGap(10)
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height(300)
        .backgroundColor('#FFFFFF')
      }
      .width('80%')
      .height(320)
      .padding(10)
      .backgroundColor('#D5D5D5')
      .border({ width: 1, color: '#D5D5D5' })
    }
    .width('100%')
    .padding(20)
  }

  // 根据宽度断点返回对应的列模板
  getColumnsTemplate(): string {
    if (this.widthBp === WidthBreakpoint.WIDTH_XS) {
      return '1fr';
    } else if (this.widthBp === WidthBreakpoint.WIDTH_SM) {
      return '1fr 1fr';
    } else if (this.widthBp === WidthBreakpoint.WIDTH_MD) {
      return '1fr 1fr 1fr';
    } else {
      return '1fr 1fr 1fr 1fr';
    }
  }
}
// [End GridComponentAdaptiveColumnSettings]