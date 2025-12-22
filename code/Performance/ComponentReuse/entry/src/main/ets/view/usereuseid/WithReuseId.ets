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
import { FriendMomentsData } from '../../model/FriendMomentData'

/**
 * 复用组件嵌套结构会变更的场景，使用reuseId标记不同结构的组件构成 - 正例
 */

@Entry
@Component
struct WithReuseId {
  private momentData: FriendMomentsData = new FriendMomentsData(this.getUIContext().getHostContext());
  private readonly LIST_CACHE_COUNT: number = 5;
  private readonly LIST_SPACE: number = 18;

  aboutToAppear(): void {
    this.momentData.getFriendMomentFromRawFile();
  }

  build() {
    Column() {
      List({ space: this.LIST_SPACE }) {
        LazyForEach(this.momentData, (moment: FriendMoment) => {
          ListItem() {
            // 使用不同的reuseId标记，保证OneMoment中各个子组件在复用时，不重新创建
            OneMoment({ moment: moment })
              .reuseId((moment.image !== '') ? 'withImage_id' : 'noImage_id')
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

  build() {
    Column() {
      Text(this.moment.text)
        .width(Constants.LAYOUT_MAX)
        .fontSize(18)
        .fontWeight(500)
        .lineHeight(24)
        .opacity(0.6)

      if (this.moment.image !== '') {
        Flex({ wrap: FlexWrap.Wrap }) {
          Image($r(this.moment.image))
            .width(Constants.LAYOUT_MAX)
            .height('27.5%')
            .borderRadius(16)
          Image($r(this.moment.image))
            .width(Constants.LAYOUT_MAX)
            .height('27.5%')
            .borderRadius(16)
            .margin({ top: 10 })
        }
        .width(Constants.LAYOUT_MAX)
        .margin({ top: 14 })
      }
    }
    .justifyContent(FlexAlign.Start)
    .margin({
      left: 16,
      right: 16
    })
  }
}

@Builder
function getWithReuseId(name: string): void {
  if (name === Constants.NAV_DESTINATION_ITEM_2) {
    NavDestination() {
      WithReuseId()
    }
    .title(title())
    .backgroundColor('#F1F3F5')
  }
}

@Builder
function title() {
  Text($r('app.string.nav_destination_item2'))
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

export const wrappedBuilderWithReuseId: WrappedBuilder<[string]> =
  wrapBuilder(getWithReuseId);

