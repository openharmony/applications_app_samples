/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { PropertiesControlPanel } from './GridItemControlPanel';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.Start)
}

@Extend(Text) function itemStyle() {
  .width('100%')
  .height('100%')
  .textAlign(TextAlign.Center)
}

@Entry
@Component
struct GridItemSample {
  @State rowStart: number = 0;
  @State rowEnd: number = 0;
  @State columnStart: number = 0;
  @State columnEnd: number = 0;
  @State gridItemStyle: number = 0;
  private itemsText: string[] = [];

  aboutToAppear() {
    for (let i = 1; i < 26; i++) {
      this.itemsText.push(i.toString());
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.grid_item_title') })
        .flexGrow(0)
      // component
      Column() {
        Grid() {
          ForEach(this.itemsText, (item: string, index: number) => {
            if (index === 0) {
              if (this.gridItemStyle === 0) {
                GridItem({ style: GridItemStyle.NONE }) {
                  Text(item)
                    .itemStyle()
                }
                .rowStart(this.rowStart)
                .rowEnd(this.rowEnd)
                .columnStart(this.columnStart)
                .columnEnd(this.columnEnd)
                .backgroundColor($r('app.color.background_blue'))
              } else {
                GridItem({ style: GridItemStyle.PLAIN }) {
                  Text(item)
                    .itemStyle()
                }
                .rowStart(this.rowStart)
                .rowEnd(this.rowEnd)
                .columnStart(this.columnStart)
                .columnEnd(this.columnEnd)
                .backgroundColor($r('app.color.background_blue'))
              }
            } else {
              GridItem({ style: GridItemStyle.NONE }) {
                Text(item)
                  .itemStyle()
              }
              .backgroundColor($r('app.color.background_blue'))
            }
          })
        }
        .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 20 })
      .backgroundStyle()
      .height(200)
      .width('100%')
      .flexGrow(0)

      Scroll() {
        // 控制面板
        Column() {
          IntroductionTitle({ introduction: $r('app.string.grid_item_introduction') })
          Column() {
            PropertiesControlPanel({
              rowStart: $rowStart,
              rowEnd: $rowEnd,
              columnStart: $columnStart,
              columnEnd: $columnEnd,
              gridItemStyle: $gridItemStyle
            })
          }
          .backgroundStyle()
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .height('100%')
      }
      .flexGrow(1)
      .height(100)
      .margin({ bottom: 10 })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}