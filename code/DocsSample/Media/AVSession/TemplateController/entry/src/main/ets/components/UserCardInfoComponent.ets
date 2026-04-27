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

import { avMusicTemplate } from '@kit.AVSessionKit';

/**
 * 我的页签下的用户信息卡片。
 */
const GRADIENT_ANGLE = 180;
const FACTOR_0 = 0.0;
const FACTOR_1 = 1.0;

@Component
export struct UserCardInfoComponent {
  @Link userInfo: avMusicTemplate.UserInfo;
  @State isLogin: boolean = false;
  private badgeSize: number = 8;

  aboutToAppear(): void {
  }

  build() {
    // 用户信息。
    Column() {
      Row() {
        Image(this.isLogin ? this.userInfo.profilePicUrl :
          $r('app.media.startIcon'))
          .alt($r('app.media.startIcon'))
          .width(40)
          .height(40)
          .borderRadius(20)

        Column() {
          Text(this.isLogin ? this.userInfo.nickName : '登录')
            .fontSize(18)
            .fontColor($r('sys.color.font_primary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .chainMode(Axis.Vertical, ChainStyle.PACKED)
          Text(this.userInfo.tips)
            .fontSize(12)
            .fontColor($r('sys.color.font_tertiary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .margin({
              top: 2,
            })
            .visibility(Visibility.None)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: 16,
        })
      }
      .padding({ left: 12, right: 12 })
      .attributeModifier(new UserInfoModifier())
      .margin({ top: 4 })
      .alignItems(VerticalAlign.Center)
      .height(60)
      .width('100%')
      .onClick(() => {

      })

      Divider()
        .vertical(false)
        .color($r('sys.color.comp_divider'))
        .height(1)
        .width('100%')
        .margin({
          top: 4,
          left: 12,
          right: 12
        })

      Row() {
        Row() {
          Text(this.isLogin ? this.userInfo.tips : '登录更精彩')
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Regular)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .margin({
              right: 16,
            })
          Badge({
            value: '',
            position: BadgePosition.Left,
            style: { badgeSize: this.badgeSize, badgeColor: '#FA2A2D' }
          }) {
            Image($r('sys.media.ohos_ic_public_arrow_right'))
              .fillColor($r('sys.color.ohos_id_color_primary'))
              .padding({
                left: 12
              })
              .width(24)
              .height(24)
              .margin({
                right: 16
              })
          }
          .width(101)
          .height(24)
        }
        .padding({ left: 12, right: 12 })
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)
        .height('100%')
        .attributeModifier(new UserInfoModifier())

        Button({ type: ButtonType.Capsule, stateEffect: true }) {
          Text('会员中心')
            .fontSize(12)
            .fontColor('#4D4339')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
        }
        .linearGradient({
          angle: GRADIENT_ANGLE,
          colors: [['#D2B483', FACTOR_0], ['#E2CA96', FACTOR_1]]
        })
        .margin({ left: 12, right: 12 })
        .height(28)
        .width(72)
      }
      .alignItems(VerticalAlign.Center)
      .height(56)
      .padding({ top:4, bottom: 4 })
    }
    .borderRadius(12)
    .padding({
      left: 4,
      right: 4,
    })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({
      right: 8,
    })
    .height('auto')
    .width('100%')
  }
}

export class UserInfoModifier implements AttributeModifier<RowAttribute> {
  applyPressedAttribute(instance: RowAttribute): void {
    instance
      .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      .borderRadius(10)
  }
}