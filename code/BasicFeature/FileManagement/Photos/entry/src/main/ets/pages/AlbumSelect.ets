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

import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import router, { ParamsInterface } from '@system.router';
import {
  AlbumSelectGridItemNewStyle
} from '../components/AlbumSelectGridItemNewStyle';
import { Constants } from '../constants/Constants';
import { screenManager } from '../common/ScreenManager';
import { Broadcast } from '../common/Broadcast';
import { NoPhotoComponent } from '../components/NoPhotoComponent';
import { Action } from '../models/Action';
import { ActionBar } from '../components/ActionBar';
import { ActionBarProp } from '../common/ActionBarProp';
import { UiUtil } from '../utils/AlbumUtil';
import { broadcastManager } from '../common/BroadcastManager';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { AlbumSelectBarModel } from '../models/AlbumSelectBarModel';
import { AlbumScrollBar } from '../components/AlbumScrollBar';
import { AlbumsDataSource } from '../common/AlbumsDataSource';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { LazyItem } from '../common/ItemDataSource';

const TAG = 'AlbumSelect';

@Entry
@Component
struct AlbumSelect {
  @State isEmpty: boolean = false;
  @State gridColumnsCount: number = 0;
  @Provide broadCast: Broadcast = new Broadcast();
  @Provide('selectedCount') totalSelectedCount: number = 0;
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Provide moreMenuList: Action[] = [];
  @Provide isHideScrollBar: boolean = true;
  @Provide('tabBarShow') isTabBarShow: boolean = false;
  private isActive = false;
  private scroller: Scroller = new Scroller();
  private barModel: AlbumSelectBarModel = new AlbumSelectBarModel();
  private albumsDataSource: AlbumsDataSource = new AlbumsDataSource();
  @State actionBarProp: ActionBarProp = new ActionBarProp();

  updateActionBar(): void {
    this.actionBarProp = this.barModel.createActionBar();
  }

  aboutToAppear(): void {
    this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number): void => {
      Log.info(TAG, 'ON_LOADING_FINISHED size: ' + size);
      this.isEmpty = size === 0;
      this.isHideScrollBar = (size <= (this.gridColumnsCount * Constants.NUMBER_3 - Constants.NUMBER_1));
    });
    let self = this;
    screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, (): void => {
      self.initGridRowCount();
    });
    this.onActive();

    this.gridColumnsCount = UiUtil.getAlbumGridCount(false);
    Log.info(TAG, 'the grid count in a line is: ' + this.gridColumnsCount);

    let param: ParamsInterface = router.getParams();
    if (param != null) {
      if (param.isNewAlbum != null && param.isNewAlbum === true) {
        AppStorage.SetOrCreate<boolean>(Constants.APP_KEY_NEW_ALBUM, true);
      } else {
        AppStorage.SetOrCreate<boolean>(Constants.APP_KEY_NEW_ALBUM, false);
      }
      let albumInfo: SimpleAlbumDataItem | null = null;
      if(param.albumInfo != null) {
        albumInfo = JSON.parse(param.albumInfo.toString());
      }
      if (albumInfo != null) {
        this.albumsDataSource.setBlackList([albumInfo.uri, MediaConstants.ALBUM_ID_RECYCLE]);
        Log.debug(TAG, 'the album Id is: ' + albumInfo.id);
      } else {
        this.albumsDataSource.setBlackList([MediaConstants.ALBUM_ID_RECYCLE]);
      }
      AppStorage.SetOrCreate<SimpleAlbumDataItem>(Constants.APP_KEY_NEW_ALBUM_TARGET, albumInfo);
    }

    this.loadAlbums();
    this.updateActionBar();
  }

  private loadAlbums(): void {
    this.albumsDataSource.reloadAlbumItemData().then<void, void>((isEmpty: boolean): void => {
      this.isEmpty = isEmpty;
      this.albumsDataSource.notifyDataReload();
    })
  }

  initGridRowCount(): void {
    Log.info(TAG, 'get screen width is : ' + screenManager.getWinWidth());
    Log.info(TAG, 'get screen height is : ' + screenManager.getWinHeight());

    let contentWidth = screenManager.getWinWidth();
    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
    / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
    Log.info(TAG, 'the grid count in a line is: ' + this.gridColumnsCount);

  }

  aboutToDisappear(): void {
  }

  onPageShow(): void {
    broadcastManager.getBroadcast().emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    this.onActive();
    this.isHideScrollBar = (this.albumsDataSource.totalCount() < (this.gridColumnsCount * Constants.NUMBER_3 - Constants.NUMBER_1));
  }

  onPageHide(): void {
    this.onInActive();
  }

  onBackPress(): boolean {
    AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
    AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
    return false;
  }

  // Callback when the page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
    }
  }

  // Callback when the page is in the background
  onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
    }
  }

  private onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.debug(TAG, 'onMenuClicked, action: ' + action.actionID);
    if (action === Action.CANCEL) {
      Log.info(TAG, 'clear SelectManager data');
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
      router.back();
    }
    return;
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start
    }) {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action)
      })

      Stack() {
        if (this.isEmpty) {
          NoPhotoComponent({ title: $r('app.string.title_no_albums') })
        }
        Grid(this.scroller) {
          LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>): void => {
            if ((item != undefined && item != null) && (item.get() != undefined && item.get() != null)) {
              if (item.index === 0){
                GridItem() {
                  AlbumSelectGridItemNewStyle({
                    item: item.get(),
                    isBigCard: true,
                  })
                }.columnStart(0).columnEnd(1)
              } else if (item != null) {
                GridItem() {
                  AlbumSelectGridItemNewStyle({
                    item: item.get(),
                    isBigCard: false,
                  })
                }
              }
            }
          }, (item: LazyItem<AlbumDataItem>): string => (item != undefined && item != null) && (item.get() != undefined && item.get() != null) ?
            item.getHashCode() : JSON.stringify(item))
        }
        .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
        .padding({
          left: $r('app.float.max_padding_start'),
          right: $r('app.float.max_padding_end'),
          top: $r('app.float.album_set_page_padding_top')
        })
        .columnsGap($r('app.float.album_set_grid_column_gap'))
        .rowsGap($r('app.float.album_set_grid_row_gap'))

        AlbumScrollBar({ scroller: this.scroller })
      }
    }
    .backgroundColor($r('app.color.default_background_color'))
    .padding({
      top: px2vp(this.leftBlank[1]),
      bottom: px2vp(this.leftBlank[3])
    })
  }

  pageTransition(): void {
    PageTransitionEnter({ type: RouteType.Push, duration: 300 }).slide(SlideEffect.Right)
      .opacity(0)
    PageTransitionEnter({ type: RouteType.Pop, duration: 1 })
      .opacity(0)
    PageTransitionExit({ type: RouteType.Push, duration: 1 })
      .opacity(0)
    PageTransitionExit({ type: RouteType.Pop, duration: 300 }).slide(SlideEffect.Right)
      .opacity(0)
  }
}
