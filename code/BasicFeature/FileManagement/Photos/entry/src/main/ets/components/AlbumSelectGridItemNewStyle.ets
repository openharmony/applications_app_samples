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

import router from '@system.router';
import { Log } from '../utils/Log';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { EmptyAlbumComponent } from './EmptyAlbumComponent';
import { MediaConstants } from '../constants/MediaConstants';
import { Constants } from '../constants/Constants';
import { Broadcast } from '../common/Broadcast';
import { screenManager } from '../common/ScreenManager';

const TAG = 'AlbumSelectGridItemNewStyle'
// The item of album grid, and it's new style.
@Component
export struct AlbumSelectGridItemNewStyle {
  private staticIconList: Map<string, Resource> | null = null;

  private getStaticIconList(): Map<string, Resource> {
    if(this.staticIconList === null) {
      let icons: Map<string, Resource> = new Map<string, Resource>();
      icons.set(MediaConstants.ALBUM_ID_VIDEO, $r('app.media.ic_video'));
      icons.set(MediaConstants.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay'));
      this.staticIconList = icons;
    }
    return this.staticIconList;
  };

  item: AlbumDataItem = new AlbumDataItem('', 0, '', 0, '', 0, 0);
  @State isEmptyAlbum: boolean = false;
  @Provide isBigCard: boolean = false;
  @Provide gridHeight: number = 0;
  @State bigWidth: number = 0;
  @Consume broadCast: Broadcast;
  gridAspectRatio = Constants.CARD_ASPECT_RATIO;
  albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
  iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  @State cardWidth: number = 0;
  @State cardHeight: number = 0;
  @State transformV: number = 0;
  @State thumbnail: PixelMap | undefined = undefined;

  aboutToAppear(): void {
    Log.debug(TAG, 'aboutToAppear + ' + this.item.uri);
    screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, (): void  => this.updateCardSize());
    this.item.load().then<void, void>(async (): Promise<void>  => {
      this.thumbnail = await this.item.getThumbnail()
    })
    this.updateCardSize();
  }

  private updateCardSize(): void {
    let contentWidth = screenManager.getWinWidth();
    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    let count: number = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER) /
    (maxCardWidth + Constants.ALBUM_SET_GUTTER));
    let gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER) / count) -
    Constants.ALBUM_SET_GUTTER;
    this.gridHeight = gridWidth / this.gridAspectRatio;
    this.bigWidth = gridWidth * 2 + Constants.ALBUM_SET_GUTTER;
    Log.info(TAG, 'is big card : ' + this.isBigCard);

    if (MediaConstants.ROTATE_ONCE === this.item.orientation || MediaConstants.ROTATE_THIRD === this.item.orientation) {
      this.cardWidth = this.gridHeight;
      if (this.isBigCard) {
        this.cardHeight = this.bigWidth;
      } else {
        this.cardHeight = gridWidth;
      }
      this.transformV = (this.cardHeight - this.cardWidth) / 2;
    } else {
      if (this.isBigCard) {
        this.cardWidth = this.bigWidth;
      } else {
        this.cardWidth = gridWidth;
      }
      this.cardHeight = this.gridHeight;
      this.transformV = 0;
    }
  }

  updateCard(): void {
    Log.debug(TAG, 'Album changed and update card size.');
    this.updateCardSize();
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.isEmptyAlbum) {
        EmptyAlbumComponent();
      }

      if (this.isBigCard) {
        Row() {
          Image(this.thumbnail)
            .width(this.cardWidth)
            .height(this.cardHeight)
            .transform({ y: this.transformV })
            .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
            .rotate({
              centerX: this.cardWidth / 2,
              centerY: this.cardHeight / 2,
              z: 1,
              angle: this.item.orientation
            })
            .onError((): void => {
              Log.debug(TAG, 'album is empty or its cover is error');
              this.isEmptyAlbum = true;
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .width(this.bigWidth)
        .height(this.gridHeight)
      } else {
        Row() {
          Image(this.thumbnail)
            .width(this.cardWidth)
            .height(this.cardHeight)
            .translate({ x: this.transformV })
            .rotate({
              centerX: this.cardWidth / 2,
              centerY: this.cardHeight / 2,
              z: 1,
              angle: this.item.orientation
            })
            .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
            .onError((): void => {
              Log.debug(TAG, 'album is empty or its cover is error');
              this.isEmptyAlbum = true;
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .height(this.gridHeight)
      }


      Image($r('app.media.gradient_mask_layer'))
        .height('50%')
        .width('100%')
        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
      Column() {
        Text(this.item.displayName)
          .margin({ right: $r('app.float.album_set_name_margin_right') })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
          .fontColor($r('app.color.white'))

        Text(String(this.item.count))
          .margin({ right: this.albumCountMarginRight })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontColor($r('app.color.white'))
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ left: $r('app.float.album_set_count_margin_left'),
        bottom: $r('app.float.album_set_count_margin_bottom') })


      if (this.getStaticIconList().has(this.item.id)) {
        Image(this.getStaticIconList().get(this.item.id))
          .height($r('app.float.album_set_new_style_icon'))
          .aspectRatio(1)
          .position({ x: '100%', y: '100%' })
          .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
      }
    }
    .height(this.gridHeight)
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_default_l'),
      width: $r('app.float.album_cover_stroke_width'),
      color: $r('app.color.album_cover_stroke_color')
    })
    .onClick((): void => {
      Log.info(TAG, 'After onClick, MediaSet is: ' + JSON.stringify(this.item));
      router.push({
        uri: 'pages/NewAlbumPage',
        params: {
          item: JSON.stringify(this.item)
        }
      })
    })
  }
}