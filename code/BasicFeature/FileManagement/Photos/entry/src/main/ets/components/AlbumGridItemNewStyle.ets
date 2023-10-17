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

import { EmptyAlbumComponent } from './EmptyAlbumComponent';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { broadcastManager } from '../common/BroadcastManager';
import { Log } from '../utils/Log';
import { Broadcast } from '../common/Broadcast';
import { screenManager } from '../common/ScreenManager';
import router from '@system.router';
import { Constants } from '../constants/Constants';
import { MediaConstants } from '../constants/MediaConstants';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { LazyItem } from '../common/ItemDataSource';

// The item of album grid, and it's new style.
const TAG = 'AlbumGridItemNewStyle'

@Component
export struct AlbumGridItemNewStyle {
  private staticIconList: Map<string, Resource> | null = null;

  private getStaticIconList(): Map<string, Resource> {
    if (this.staticIconList === null) {
      let icons: Map<string, Resource> = new Map<string, Resource>();
      icons.set(MediaConstants.ALBUM_ID_VIDEO, $r('app.media.ic_video'));
      icons.set(MediaConstants.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay'));
      this.staticIconList = icons;
    }
    return this.staticIconList;
  };

  item: AlbumDataItem = new AlbumDataItem('', 0, '', 0, '', 0, 0);
  lazyItem: LazyItem<AlbumDataItem> = new LazyItem(this.item, 0);
  @State isEmptyAlbum: boolean = false;
  @State selectable: boolean = true;
  @State icHeight: number = 0;
  @State bigWidth: number = 0;
  @State transformV: number = 0;
  @Provide isBigCard: boolean = false;
  @Provide gridHeight: number = 0;
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @Consume broadCast: Broadcast;
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
  @Consume @Watch('onIndexPageShow') isShow: boolean;
  gridAspectRatio = Constants.CARD_ASPECT_RATIO;
  albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
  iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  @State cardWidth: number = 0;
  @State cardHeight: number = 0;
  @State thumbnail: PixelMap | undefined = undefined;

  aboutToAppear(): void {
    Log.debug(TAG, 'aboutToAppear');
    this.selectable = this.item.id !== MediaConstants.ALBUM_ID_RECYCLE;
    screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, (): void => this.updateCardSize());
    this.item.load().then<void, void>(async (): Promise<void> => {
      this.thumbnail = await this.item.getThumbnail();
    })
    this.updateCardSize();
  }

  onIndexPageShow(): void {
    this.item.load().then<void, void>(async (): Promise<void> => {
      this.thumbnail = await this.item.getThumbnail();
    })
  }

  updateCard(): void {
    Log.debug(TAG, 'Album changed and update card size.');
    this.updateCardSize();
  }

  updateCardSize(): void {
    let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
    let contentWidth = screenManager.getWinWidth() - sideBarWidth;
    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    let count: number = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
    / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
    let gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER) / count)
    - Constants.ALBUM_SET_GUTTER;
    this.gridHeight = gridWidth / this.gridAspectRatio;
    this.bigWidth = gridWidth * 2 + Constants.ALBUM_SET_GUTTER;
    this.icHeight = this.gridHeight - Constants.ALBUM_SET_NEW_ICON_MARGIN - Constants.TEXT_SIZE_BODY2 - Constants.TEXT_SIZE_SUB_TITLE1;
    if (this.isBigCard) {
      this.cardWidth = this.bigWidth;
    } else {
      this.cardWidth = gridWidth;
    }
    this.cardHeight = this.gridHeight;
    this.transformV = 0;
  }

  onModeChange(): void {
    if (!this.isAlbumSetSelectedMode) {
      this.item.setSelect(false);
    }
  }

  selectStateChange(): void {
    Log.info(TAG, 'change selected.');

    if (!this.isAlbumSetSelectedMode) {
      this.isAlbumSetSelectedMode = true;
    }

    if (this.selectable) {
      this.item.setSelect(!this.item.isSelect);
      if (this.lazyItem != null) {
        this.lazyItem.update(this.item)
      }
      this.broadCast.emit(BroadcastConstants.SELECT, [this.item.index]);

    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.isEmptyAlbum || this.item.count === 0) {
        EmptyAlbumComponent();
      }

      if (this.isBigCard) {
        if (this.item.id === MediaConstants.ALBUM_ID_RECYCLE) {
          Column() {
            Stack({ alignContent: Alignment.Center }) {
              Image($r('app.media.ic_gallery_public_delete_line'))
                .width($r('app.float.recycle_album_cover_icon_size'))
                .height($r('app.float.recycle_album_cover_icon_size'))
                .fillColor($r('app.color.empty_or_recycle_album_icon'))
            }
            .height(this.icHeight)
            .width('100%')
          }
          .height(this.gridHeight)
          .width(this.bigWidth)
          .backgroundColor($r('app.color.empty_or_recycle_album_back'))
          .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        } else {
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
                angle: 0
              })
              .onError((): void => {
                Log.debug(TAG, 'album is empty or its cover is error');
                this.isEmptyAlbum = true;
              })
          }
          .width(this.bigWidth)
          .height(this.gridHeight)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
        }
      } else {
        if (this.item.id === MediaConstants.ALBUM_ID_RECYCLE) {
          Column() {
            Stack({ alignContent: Alignment.Center }) {
              Image($r('app.media.ic_gallery_public_delete_line'))
                .width($r('app.float.recycle_album_cover_icon_size'))
                .height($r('app.float.recycle_album_cover_icon_size'))
                .fillColor($r('app.color.empty_or_recycle_album_icon'))
            }
            .height(this.icHeight)
            .width('100%')
          }
          .width(this.cardWidth)
          .height(this.gridHeight)
          .backgroundColor($r('app.color.empty_or_recycle_album_back'))
          .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        } else {
          Row() {
            Image(this.thumbnail)
              .width(this.cardWidth)
              .height(this.cardHeight)
              .translate({ x: this.transformV })
              .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
              .rotate({
                centerX: this.cardWidth / 2,
                centerY: this.cardHeight / 2,
                z: 1,
                angle: 0
              })
              .onError((): void => {
                Log.error(TAG, 'album is empty or its cover is error ' + this.thumbnail);
                this.isEmptyAlbum = true;
              })
          }
          .height(this.gridHeight)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
        }
      }
      if (!this.item.isSelect || !this.isAlbumSetSelectedMode || !this.selectable) {
        Image($r('app.media.gradient_mask_layer'))
          .height('50%')
          .width('100%')
          .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
      }
      Column() {
        Text(this.item.displayName)
          .margin({ right: $r('app.float.album_set_name_margin_right') })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
          .fontColor($r('app.color.white'))
        // shadow and shadow's fuzzy

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
      .margin({
        left: $r('app.float.album_set_count_margin_left'),
        bottom: $r('app.float.album_set_count_margin_bottom')
      })

      if (this.getStaticIconList().has(this.item.id) && !this.isAlbumSetSelectedMode) {
        Image(this.getStaticIconList().get(this.item.id))
          .height($r('app.float.album_set_new_style_icon'))
          .aspectRatio(1)
          .position({ x: '100%', y: '100%' })
          .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
      }

      Column()
        .height('100%')
        .width('100%')
        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
        .backgroundColor(this.item.isSelect && this.isAlbumSetSelectedMode && this.selectable
          ? $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))

      if (this.isAlbumSetSelectedMode && this.selectable) {
        Image(this.item.isSelect ? $r('app.media.ic_checkbox_on') : $r('app.media.ic_checkbox_off_overlay'))
          .height($r('app.float.album_set_new_style_icon'))
          .aspectRatio(1)
          .position({ x: '100%', y: '100%' })
          .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
      }

      Column()
        .height('100%')
        .width('100%')
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_default_l'),
          width: $r('app.float.album_cover_stroke_width'),
          color: $r('app.color.album_cover_stroke_color')
        })
    }
    .height(this.gridHeight)
    .gesture(
    LongPressGesture()
      .onAction((): void => {
        this.selectStateChange();
      })
    )
    .onClick((): void => {
      if (this.isAlbumSetSelectedMode) {
        this.selectStateChange();
      } else {
        Log.info(TAG, 'After onClick, MediaSet is: ' + JSON.stringify(this.item));
        router.push({
          uri: 'pages/PhotoGridPage',
          params: {
            item: JSON.stringify(this.item)
          }
        });
      }
    })
  }
}
