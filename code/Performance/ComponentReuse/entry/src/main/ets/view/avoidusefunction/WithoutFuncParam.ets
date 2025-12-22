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
 * 避免使用函数/方法作为复用组件创建时的入参 - 正例
 */

@Entry
@Component
struct WithoutFuncParam {
  @State sum: number = 0;
  private momentData: FriendMomentsData =
    new FriendMomentsData(this.getUIContext().getHostContext(), Constants.NAV_DESTINATION_ITEM_3);
  private readonly LIST_CACHE_COUNT: number = 5;
  private readonly LIST_SPACE: number = 18;
  private readonly MOCK_ASYNC_DEFAULT_NUM: number = 1000000;

  aboutToAppear(): void {
    this.momentData.getFriendMomentFromRawFile();
    this.countAndReturn();
  }

  // 真实场景的函数中可能存在未知的耗时操作逻辑，此处用循环函数模拟耗时操作
  async countAndReturn(): Promise<void> {
    let temp: number = 0;
    for (let index = 0; index < this.MOCK_ASYNC_DEFAULT_NUM; index++) {
      temp += index;
    }
    // 将结果放入状态变量中
    this.sum = temp;
  }

  build() {
    Column() {
      List({ space: this.LIST_SPACE }) {
        LazyForEach(this.momentData, (moment: FriendMoment) => {
          ListItem() {
            // 子组件的传参通过状态变量进行
            OneMoment({
              moment: moment,
              sum: this.sum
            })
          }
        }, (moment: FriendMoment) => moment.id)
      }
      .cachedCount(this.LIST_CACHE_COUNT)
      .margin({ top: 8 })
      .width(Constants.LAYOUT_MAX)
      .height(Constants.LAYOUT_MAX)
    }
  }
}

@Reusable
@Component
export struct OneMoment {
  @ObjectLink moment: FriendMoment;
  @State sum: number = 0;
  private readonly LAST_ITEM_INDEX: number = 2;

  aboutToReuse(params: Record<string, Object>): void {
    this.sum = params.sum as number;
  }

  build() {
    Column() {
      Text(this.moment.text)
        .fontSize(18)
        .textAlign(TextAlign.Center)
        .fontWeight(500)
        .lineHeight(24)
        .fontColor(Color.Black)
        .opacity(0.6)
      Column() {
        this.item();
        this.item();
        this.item(this.LAST_ITEM_INDEX);
      }
      .borderRadius(16)
      .margin({ top: 14 })
      .padding({
        left: 12,
        right: 12,
        top: 13,
        bottom: 13
      })
      .backgroundColor(Color.White)
      .width(Constants.LAYOUT_MAX)
    }
    .alignItems(HorizontalAlign.Start)
    .margin({
      left: 16,
      right: 16
    })
  }

  @Builder
  item(index?: number) {
    Column() {
      Row() {
        Text(this.moment.userName)
          .fontSize(16)
          .fontWeight(500)
          .lineHeight(22)
          .textAlign(TextAlign.Start)
          .opacity(0.9)
        Text(`${this.moment.id}/${this.sum}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(19)
          .textAlign(TextAlign.End)
          .layoutWeight(1)
          .opacity(0.6)
      }
      .width(Constants.LAYOUT_MAX)
    }

    if (index !== this.LAST_ITEM_INDEX) {
      Row()
        .width(Constants.LAYOUT_MAX)
        .height(1)
        .backgroundColor(Color.Black)
        .margin({
          top: 12.5,
          bottom: 13
        })
        .opacity(0.1)
    }
  }
}

@Builder
function getWithoutFuncParam(name: string): void {
  if (name === Constants.NAV_DESTINATION_ITEM_3) {
    NavDestination() {
      WithoutFuncParam()
    }
    .title(title())
    .backgroundColor('#F1F3F5')
  }
}

@Builder
function title() {
  Text($r('app.string.nav_destination_item3'))
    .fontSize(20)
    .fontColor($r('sys.color.font_primary'))
    .fontWeight(FontWeight.Bold)
    .textOverflow({ overflow: TextOverflow.MARQUEE })
    .margin({
      left: 8,
      top: 16
    })
    .maxLines(1)
    .lineHeight(24)
}

export const wrappedBuilderWithoutFuncParam: WrappedBuilder<[string]> =
  wrapBuilder(getWithoutFuncParam);