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
import { ListDataSource } from './ListDataSource';

@Entry
@Component
export struct LongList {
  private arr: ListDataSource = new ListDataSource([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.LongList_title') }) {
          List({ space: 20, initialIndex: 0 }) {
            LazyForEach(this.arr, (item: number) => {
              ListItem() {
                Text('' + item)
                  .width('100%').height(100).fontSize(16)
                  .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
              }
            }, (item: string) => item)
          }
          .listDirection(Axis.Vertical) // 排列方向
          .scrollBar(BarState.Off)
          .friction(0.6)
          .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
            console.info('first' + firstIndex);
            console.info('last' + lastIndex);
            console.info('center' + centerIndex);
          })
          .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
            console.log(' start index: ' + start.index +
              ' start item group area: ' + start.itemGroupArea +
              ' start index in group: ' + start.itemIndexInGroup);
            console.log(' end index: ' + end.index +
              ' end item group area: ' + end.itemGroupArea +
              ' end index in group: ' + end.itemIndexInGroup);
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset);
          })
          .width('90%')
        }
      }
      .backgroundColor(0xDCDCDC)
      .width('100%')
      .height('100%')
    }
    .title($r('app.string.LongList_title'))
  }
}