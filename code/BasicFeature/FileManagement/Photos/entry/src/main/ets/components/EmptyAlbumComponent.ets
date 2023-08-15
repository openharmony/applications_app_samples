/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Constants } from '../constants/Constants';

// New style
@Component
export struct EmptyAlbumComponent {
  @Consume gridHeight: number;
  @Consume isBigCard: boolean;
  @State icHeight: number = 0;
  gridAspectRatio = Constants.CARD_ASPECT_RATIO;

  aboutToAppear(): void {
    let numberHeight = px2vp(fp2px(Constants.TEXT_SIZE_BODY2));
    let nameHeight = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE1));
    this.icHeight = this.gridHeight - Constants.ALBUM_SET_NEW_ICON_MARGIN - numberHeight - nameHeight;
  }

  build() {
    if (this.isBigCard) {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Image($r('app.media.ic_goto_photos'))
          .width($r('app.float.recycle_album_cover_icon_size'))
          .height($r('app.float.recycle_album_cover_icon_size'))
          .fillColor($r('app.color.empty_or_recycle_album_icon'))
      }
      .width('100%')
      .height(this.gridHeight)
      .backgroundColor($r('app.color.empty_or_recycle_album_back'))
      .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
    } else {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start
      }) {
        Stack({ alignContent: Alignment.Center }) {
          Image($r('app.media.ic_goto_photos'))
            .width($r('app.float.recycle_album_cover_icon_size'))
            .height($r('app.float.recycle_album_cover_icon_size'))
            .fillColor($r('app.color.empty_or_recycle_album_icon'))
        }
        .height(this.icHeight)
        .width('100%')
      }
      .aspectRatio(this.gridAspectRatio)
      .backgroundColor($r('app.color.empty_or_recycle_album_back'))
      .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
    }
  }
}

// Traditional style
@Component
export struct EmptyAlbumComponentForTraditionalStyle {
  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image($r('app.media.ic_goto_photos'))
        .width($r('app.float.album_set_icon_size'))
        .aspectRatio(1)
        .fillColor($r('sys.color.ohos_id_color_secondary'))
    }
    .aspectRatio(1)
    .backgroundColor($r('app.color.album_set_empty_album_bright')) // bright and dark mode
    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_s') })
  }
}