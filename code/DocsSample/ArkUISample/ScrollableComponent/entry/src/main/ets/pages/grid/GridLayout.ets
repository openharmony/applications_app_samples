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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct GridLayout {
  @State numbers: String[] = ['0', '1', '2', '3', '4', '5', '6', '7'];
  scroller: Scroller = new Scroller();
  layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: [1, 3, 4], // 索引为0和7的GridItem占用的列数由onGetIrregularSizeByIndex指定
    onGetIrregularSizeByIndex: (index: number) => {
      if (index === 0) {
        return [1, 5];
      }
      return [1, index % 6 + 1];
    }
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.GridLayout_titleRowSpacing') }) {
          Grid() {
            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')

            GridItem() {
            }.backgroundColor('#ffe0e2e4')
          }
          //设置行列间距
          .columnsGap(10)
          .rowsGap(15)
          .height(150)
          //设置行列数量与占比
          .rowsTemplate('1fr 1fr 1fr')
          .columnsTemplate('1fr 2fr 1fr')
        }

        ComponentCard({ title: $r('app.string.GridLayout_titleChildSpan') }) {
          Grid(undefined, this.layoutOptions) {
            ForEach(this.numbers, (day: string) => {
              GridItem() {
                Text(day)
                  .fontSize(16)
                  .backgroundColor('#ffe0e2e4')
                  .width('100%')
                  .height(60)
                  .textAlign(TextAlign.Center)
              }
            }, (day: string) => day)
          }
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .scrollBar(BarState.Off)
          .width('80%')
          .height(210)
        }

        ComponentCard({ title: $r('app.string.GridLayout_titleMainAxis') }) {
          Grid() {
            GridItem() {
              Text('1')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('2')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('3')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('4')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('5')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('6')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('7')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('8')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('9')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)
          }
          .maxCount(3)
          .columnsGap(4)
          .rowsGap(4)
          .layoutDirection(GridDirection.Row)

          Grid() {
            GridItem() {
              Text('1')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('2')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('3')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('4')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('5')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('6')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('7')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('8')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)

            GridItem() {
              Text('9')
            }.backgroundColor('#ffe0e2e4').width(30).height(30)
          }
          .maxCount(3)
          .columnsGap(4)
          .rowsGap(4)
          .layoutDirection(GridDirection.Column)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.GridLayout_title'))
  }
}