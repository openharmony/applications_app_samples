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

import { Constants } from '../../common/Constants';
import { FriendMoment } from '../../model/BasicDataSource';
import { FriendMomentsData } from '../../model/FriendMomentData';
import { OneMoment } from './OneMoment';

/**
 * 减少组件复用的嵌套层级 - 正例
 */

@Component
export struct PageListSlideToHistory {
  @State firstVisibleItemIndex: number = 0;
  private readonly DEFAULT_OFFSET: number = 1000;
  private readonly ANIMATION_DURATION: number = 500;
  private readonly DEFAULT_VISIBLE_BTN_INDEX: number = 3;
  private readonly LIST_CACHE_COUNT: number = 3;
  private momentData: FriendMomentsData = new FriendMomentsData(this.getUIContext().getHostContext());
  private listScroller: ListScroller = new ListScroller();
  private historyOffset: number = 0;
  private isHistoricalRecord: boolean = false;

  aboutToAppear(): void {
    this.momentData.getFriendMomentFromRawFile();
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        List({ space: Constants.LIST_SPACE, scroller: this.listScroller }) {
          LazyForEach(this.momentData, (moment: FriendMoment, index: number) => {
            ListItem() {
              this.itemBuilder(moment, index);
            }
          }, (moment: FriendMoment) => moment.id)
        }
        .cachedCount(this.LIST_CACHE_COUNT)
        .width(Constants.LAYOUT_MAX)
        .height(Constants.LAYOUT_MAX)
        .margin({ top: 8 })
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .onScrollIndex((first: number) => {
          this.firstVisibleItemIndex = first;
        })
      }
      .width(Constants.LAYOUT_MAX)
      .height(Constants.LAYOUT_MAX)

      Row() {
        Image($r('app.media.ic_back_to_top'))
          .width(24)
          .height(24)
          .opacity(0.8)
      }
      .visibility(this.firstVisibleItemIndex >= this.DEFAULT_VISIBLE_BTN_INDEX ? Visibility.Visible : Visibility.None)
      .justifyContent(FlexAlign.Center)
      .width(48)
      .height(48)
      .backgroundColor('#0A59F7')
      .borderRadius(36)
      .margin({ right: 16 })
      .onClick(() => {
        if (this.firstVisibleItemIndex >= this.DEFAULT_VISIBLE_BTN_INDEX) {
          this.historyOffset = this.listScroller.currentOffset().yOffset;
          this.listScroller.scrollTo({
            xOffset: Constants.COMM_INIT,
            yOffset: Constants.COMM_INIT,
            animation: { duration: this.ANIMATION_DURATION, curve: Curve.LinearOutSlowIn }
          });
          this.isHistoricalRecord = true;
        }
      })
    }
  }

  @Builder
  itemBuilder(moment: FriendMoment, index: number) {
    Column() {
      if (index === Constants.COMM_INIT && this.isHistoricalRecord) {
        Text($r('app.string.jump_to_history'))
          .fontColor('#0A59F7')
          .fontSize(12)
          .margin({
            top: 24,
            bottom: 24
          })
          .onClick(() => {
            if (this.firstVisibleItemIndex < this.DEFAULT_VISIBLE_BTN_INDEX) {
              this.listScroller.scrollTo({
                xOffset: 0,
                yOffset: this.historyOffset === Constants.COMM_INIT ? this.DEFAULT_OFFSET : this.historyOffset,
                animation: {
                  duration: this.ANIMATION_DURATION,
                  curve: Curve.LinearOutSlowIn
                }
              });
              this.isHistoricalRecord = false;
            }
          })
      }
      OneMoment({ moment: moment })

    }
    .margin({
      left: 16,
      right: 16
    })
  }
}

@Builder
function getPageListSlideToHistory(name: string): void {
  if (name === Constants.NAV_DESTINATION_ITEM_0) {
    NavDestination() {
      PageListSlideToHistory()
    }
    .title(title())
    .backgroundColor('#F1F3F5')
  }
}

@Builder
function title() {
  Text($r('app.string.nav_destination_item0'))
    .fontSize(20)
    .fontColor($r('sys.color.font_primary'))
    .fontWeight(FontWeight.Bold)
    .margin({
      left: 8,
      top: 16
    })
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.MARQUEE })
    .lineHeight(24)
}

export const wrappedBuilderPageListSlideToHistory: WrappedBuilder<[string]> =
  wrapBuilder(getPageListSlideToHistory);