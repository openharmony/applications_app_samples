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

/**
 * 避免对@Link/@ObjectLink/@Prop等自动更新的状态变量，在aboutToReuse方法中再进行更新 - 反例
 */

@Component
export struct UpdateStateVariableInAboutToReuse {
  @State firstVisibleItemIndex: number = 0; // The first visible item index
  private readonly DEFAULT_OFFSET: number = 1000;
  private readonly ANIMATION_DURATION: number = 500;
  private readonly DEFAULT_VISIBLE_BTN_INDEX: number = 3; // Show jump history button when scroll more than 3 item
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

@Reusable
@Component
export struct OneMoment {
  // 该类型的状态变量已包含自动刷新功能，不需要再重复进行刷新
  @ObjectLink moment: FriendMoment;

  // 此处aboutToReuse为多余刷新
  aboutToReuse(params: Record<string, Object>): void {
    this.moment.id = (params.moment as FriendMoment).id;
    this.moment.userName = (params.moment as FriendMoment).userName;
    this.moment.avatar = (params.moment as FriendMoment).avatar;
    this.moment.text = (params.moment as FriendMoment).text;
    this.moment.image = (params.moment as FriendMoment).image;
  }

  build() {
    Column() {
      Row() {
        Image($r(this.moment.avatar))
          .autoResize(false)
          .borderRadius(15)
          .width(30)
          .height(30)
        Column() {
          Text(this.moment.userName)
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
            .lineHeight(19)
            .fontWeight(FontWeight.Medium)
          Text($r('app.string.two_days_ago'))
            .fontSize(10)
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
            .lineHeight(14)
            .opacity(0.6)
        }
        .margin({ left: 8 })
        .alignItems(HorizontalAlign.Start)
      }
      .width(Constants.LAYOUT_MAX)
      .constraintSize({ minHeight: 38 })
      .padding({
        left: 12,
        top: 11,
        bottom: 11
      })

      Stack() {
        if (this.moment.image) {
          Column() {
            Image($r(this.moment.image))
              .id('singleImage')
              .width(Constants.LAYOUT_MAX)
              .height(278)
          }
          .alignItems(HorizontalAlign.Start)
          .width(Constants.LAYOUT_MAX)
          .padding({
            left: 12,
            right: 12
          })
        }
      }

      Row() {
        Text(this.moment.text)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .fontColor(Color.Black)
          .lineHeight(19)
      }
      .width(Constants.LAYOUT_MAX)
      .padding({
        left: 11,
        top: 8
      })

      Row() {
        Image($r('app.media.share'))
          .width(24)
          .height(24)
          .autoResize(false)

        Row() {
          interactiveButton({
            imageStr: $r('app.media.heart'),
            text: `${this.moment.share.heart}`
          })
          interactiveButton({
            imageStr: $r('app.media.star'),
            text: `${this.moment.share.star}`
          })
          interactiveButton({
            imageStr: $r('app.media.ellipsis_message'),
            text: `${this.moment.share.message}`
          })
        }
        .justifyContent(FlexAlign.End)
        .layoutWeight(1)
      }
      .width(Constants.LAYOUT_MAX)
      .padding({
        left: 12,
        top: 8,
        bottom: 12,
        right: 29.75
      })
    }
    .backgroundColor(Color.White)
    .width(Constants.LAYOUT_MAX)
    .borderRadius(16)
  }
}

@Builder
export function interactiveButton($$: Temp) {
  Row() {
    Image($$.imageStr)
      .width(24)
      .height(24)
      .objectFit(ImageFit.Contain)
      .autoResize(false)
    Text($$.text)
      .fontSize(12)
      .fontWeight(FontWeight.Medium)
      .fontColor(Color.Black)
      .lineHeight(16)
      .opacity(0.9)
      .margin({ left: 2 })
  }
  .alignItems(VerticalAlign.Center)
  .margin({ left: 12 })
}

class Temp {
  public imageStr: ResourceStr = '';
  public text: ResourceStr | string = '';
}

@Builder
function getUpdateStateVariableInAboutToReuse(name: string): void {
  if (name === Constants.NAV_DESTINATION_ITEM_1_3) {
    NavDestination() {
      UpdateStateVariableInAboutToReuse()
    }
    .title(title())
    .backgroundColor('#F1F3F5')
  }
}

@Builder
function title() {
  Text($r('app.string.nav_destination_item1_3'))
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

export const wrappedBuilderUpdateStateVariableInAboutToReuse: WrappedBuilder<[string]> =
  wrapBuilder(getUpdateStateVariableInAboutToReuse);