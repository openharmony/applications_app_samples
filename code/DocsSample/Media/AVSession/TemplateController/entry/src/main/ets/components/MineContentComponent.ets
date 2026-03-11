/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

import avMusicTemplate from '@ohos.multimedia.avMusicTemplate';
import { UserCardInfoComponent } from './UserCardInfoComponent';

const TAG = 'MineContentComponent';

/**
 * 我的Tab页签下的PageContent。
 */
@Component
export struct MineContentComponent {
  @State isLogin: boolean = false;
  private pageScroller: Scroller = new Scroller();
  @State userInfo: avMusicTemplate.UserInfo = {
    'userInfoId': '',
    'nickName': '',
    'profilePicUrl': '',
    'tips': '',
    'isLogin': false,
    'isVip': false
  };
  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
  }

  build() {
    Stack() {
      Scroll(this.pageScroller) {
        Column() {
          Row() {
            // 用户信息
            UserCardInfoComponent({ userInfo: this.userInfo })
              .layoutWeight(1)
          }

          Row() {
            Row() {
              Image($r('app.media.gearshape'))
                .width('28')
                .height('28')
                .fillColor($r('sys.color.ohos_id_color_primary'))

              Text('我的')
                .fontSize('16')
                .fontColor($r('sys.color.font_primary'))
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
                .margin({
                  left: 16,
                })
                .layoutWeight(1)

              Image($r('sys.media.ohos_ic_public_arrow_right'))
                .width(24)
                .height(24)
                .margin({
                  left: 16
                })
                .fillColor($r('sys.color.ohos_id_color_primary'))
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .height('100%')
            .layoutWeight(1)
            .padding(8)
            .margin({
              right: 24
            })
            .onClick(() => {

            })

            Row() {
              Image($r('app.media.questionmark_circle'))
                .width(28)
                .height(28)
                .fillColor($r('sys.color.ohos_id_color_primary'))

              Text('帮助与客服')
                .fontSize(16)
                .fontColor($r('sys.color.font_primary'))
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
                .margin({
                  left: 16,
                })
                .layoutWeight(1)

              Image($r('sys.media.ohos_ic_public_arrow_right'))
                .width(24)
                .height(24)
                .margin({
                  left: 16,
                  right: 4
                })
                .fillColor($r('sys.color.ohos_id_color_primary'))
            }
            .height('100%')
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .layoutWeight(1)
            .padding('8vp')
            .margin({
              left: '24vp',
            })
          }
          .borderRadius('12vp')
          .backgroundColor($r('sys.color.comp_background_list_card'))
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .height('72vp')
          .padding('4vp')
          .margin({
            top: '16vp'
          })
        }
        .padding({
          left: '32vp',
          right: '32vp',
          top: '8vp',
          // 全屏底部间距24; 分屏24 + 48(minibar高度)。
          bottom: '72vp'
        })
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical) // 滚动方向纵向。
      .scrollBarWidth(0)
      .edgeEffect(EdgeEffect.None)
    }
    .alignContent(Alignment.TopStart)
    .height('100%')
  }
}