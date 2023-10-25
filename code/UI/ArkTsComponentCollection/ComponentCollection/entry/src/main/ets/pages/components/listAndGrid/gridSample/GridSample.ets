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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { ArgumentsControlPanel } from './GridControlPanel';

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
  .backgroundColor($r('app.color.background_blue'))
}

@Entry
@Component
struct GridSample {
  @State columnTemplate : string = '1fr 1fr 1fr 1fr';
  @State rowsTemplate : string = '1fr 1fr 1fr 1fr';
  @State columnsGap : number = 0;
  @State rowGap : number = 0;
  private controller: Scroller = new Scroller();
  private itemsText: string[] = [];

  aboutToAppear() {
    for (let i = 1; i < 17; i++) {
      this.itemsText.push(i.toString());
    }
  }

  build() {
    Flex({direction: FlexDirection.Column ,alignItems :ItemAlign.Center, justifyContent: FlexAlign.Start}) {
      TitleBar({ title: $r('app.string.grid_title')})
        .flexGrow(0)
      // component
      Column() {
        Scroll(){
          Grid(this.controller) {
            ForEach(this.itemsText, (text: string) => {
              GridItem() {
                Text(text)
                  .itemStyle()
              }.margin(5)
            })
          }
          .columnsTemplate(this.columnTemplate)
          .rowsTemplate(this.rowsTemplate)
          .columnsGap(this.columnsGap)
          .rowsGap(this.rowGap)
          .height('100%')
          .width('100%')
        }
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({bottom : 16})
      .backgroundStyle()
      .height(200)
      .width('100%')
      .flexGrow(0)

      Scroll() {
        // 控制面板
        Column() {
          Column(){
            ArgumentsControlPanel(
              {
                columnTemplate :$columnTemplate,
                columnsGap : $columnsGap,
                rowGap: $rowGap,
                rowsTemplate: $rowsTemplate
              }
            )
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