/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { GridDataSource } from './GridDataSource';
import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct GridScrollbar {
  numbers: GridDataSource = new GridDataSource([]);
  scroller: Scroller = new Scroller();
  @State gridPosition: number = 0; //0代表滚动到grid顶部，1代表中间值，2代表滚动到grid底部。

  aboutToAppear() {
    let list: string[] = [];
    for (let i = 0; i < 5; i++) {
      for (let j = 0; j < 5; j++) {
        list.push(j.toString());
      }
    }
    this.numbers = new GridDataSource(list);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.GridScrollbar_title') }) {
          Row({ space: 5 }) {
            Grid(this.scroller) {
              LazyForEach(this.numbers, (day: string) => {
                GridItem() {
                  Text()
                    .fontSize(16)
                    .backgroundColor(0xF9CF93)
                    .width('100%')
                    .height(80)
                    .textAlign(TextAlign.Center)
                }
              }, (index: number) => index.toString())
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
            .columnsGap(10)
            .rowsGap(10)
            .friction(0.6)
            .enableScrollInteraction(true)
            .supportAnimation(false)
            .multiSelectable(false)
            .edgeEffect(EdgeEffect.Spring)
            .scrollBar(BarState.Off)
            .scrollBarColor(Color.Grey)
            .scrollBarWidth(4)
            .width('90%')
            .backgroundColor(0xFAEEE0)
            .height(300)
            .margin({left:10})
            ScrollBar({ scroller: this.scroller }).height(300)

          }.width('100%').margin({ top: 5 })
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.GridScrollbar_title'))
  }
}