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

import router, { ParamsInterface } from '@system.router';
import { Log } from '../utils/Log';
import { MediaOperationType } from '../models/MediaOperationType';
import { MediaOperationActionBar } from '../components/MediaOperationActionBar';
import { Broadcast } from '../common/Broadcast';
import { AlbumSetNewMenuOperation } from '../menus/AlbumSetNewMenuOperation';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { AlbumListCard } from '../components/AlbumListCard';
import { MenuContext } from '../menus/MenuContext';
import { Action } from '../models/Action';
import { JumpSourceToMain } from '../models/JumpSourceToMain';
import { CustomDialogView } from '../components/CustomDialogView';
import { screenManager, ColumnSize } from '../common/ScreenManager';
import { broadcastManager } from '../common/BroadcastManager';
import { AlbumsDataSource } from '../common/AlbumsDataSource'
import { AlbumDataItem } from '../common/AlbumDataItem';
import { MediaConstants } from '../constants/MediaConstants';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { LazyItem } from '../common/ItemDataSource';

const TAG = 'MediaOperationPage';

@Entry
@Component
struct MediaOperationPage {
  @StorageLink('screenColumns') screenColumns: number = screenManager.getScreenColumns();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Provide pageType: string = MediaOperationType.Move;
  @Provide broadCast: Broadcast = new Broadcast();
  @Provide moreMenuList: Action[] = [];
  @Provide loadingFinish: boolean = false;
  @State listCardWidth: number = 0;
  isActive: boolean = false; // Whether the page is in the foreground
  sourceAlbumId: string = '';
  private albumInfo: SimpleAlbumDataItem = new SimpleAlbumDataItem('', '', '', '', '', 0, 0);
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  private albumsDataSource: AlbumsDataSource = new AlbumsDataSource()
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    let blackList = Array.from<string>(MediaConstants.ALBUM_DISABLE_COPY_LIST)
    let param: ParamsInterface = router.getParams();
    if (param != null) {
      this.pageType = param.pageType.toString();
      if (param.albumInfo != null) {
        this.albumInfo = JSON.parse(param.albumInfo.toString()) as SimpleAlbumDataItem;
        this.sourceAlbumId = this.albumInfo.id;
        blackList.push(this.albumInfo.uri)
        Log.info(TAG, 'router getParams pageType:' + this.pageType + ',Album:' + this.sourceAlbumId);
      }
    }
    this.albumsDataSource.setBlackList(blackList)
    this.onActive();
    this.loadAlbums()
    this.broadCast.on(BroadcastConstants.MEDIA_OPERATION, (albumInfo: SimpleAlbumDataItem, completedFunc?: Function): void => {
      router.back({
        uri: '',
        params: {
          pageType: this.pageType,
          albumInfo: JSON.stringify(albumInfo)
        }
      });
      if(completedFunc != null) completedFunc();
    });
    this.updateListCardWidth();
  }

  private loadAlbums(): void {
    this.albumsDataSource.reloadAlbumListItemData().then<void, void>((isEmpty: boolean): void => {
      this.loadingFinish = true
      this.albumsDataSource.notifyDataReload()
    })
  }

  onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.info(TAG, 'onMenuClicked, actionID: ' + action.actionID);

    if (action === Action.CANCEL) {
      router.back({
        uri: '',
        params: {}
      });
    } else if (action === Action.NEW) {
      this.createNewAlbum();
    }
  }

  createNewAlbum(): void {
    Log.info(TAG, 'createNewAlbum');
    let menuContext = new MenuContext();
    menuContext
      .withOperationStartCallback((): void => this.onOperationStart())
      .withOperationEndCallback((): void => this.onOperationEnd())
      .withDataSource(this.albumsDataSource)
      .withAlbumInfo(this.albumInfo)
      .withBroadCast(this.broadCast)
      .withJumpSourceToMain(JumpSourceToMain.ALBUM);
    let menuOperation = new AlbumSetNewMenuOperation(menuContext);
    menuOperation.doAction();
  }

  onOperationStart(): void {
    this.onOperationStartBindImpl()
  }

  private onOperationStartBindImpl(): void {
  }

  onOperationEnd(): void {
    this.onOperationEndBindImpl()
  }

  private onOperationEndBindImpl(): void {
  }

  updateListCardWidth(): void {
    Log.info(TAG, 'updateListCardWidth start ' + this.screenColumns);
    if (this.screenColumns === ColumnSize.COLUMN_FOUR) {
      this.listCardWidth = screenManager.getColumnsWidth(ColumnSize.COLUMN_FOUR);
    } else if (this.screenColumns === ColumnSize.COLUMN_EIGHT) {
      this.listCardWidth = screenManager.getColumnsWidth(ColumnSize.COLUMN_SIX);
    } else if (this.screenColumns === ColumnSize.COLUMN_TWELVE) {
      this.listCardWidth = screenManager.getColumnsWidth(ColumnSize.COLUMN_EIGHT);
    } else {
      Log.warn(TAG, 'screenColumns is not init');
    }
    Log.info(TAG, 'updateListCardWidth ' + this.listCardWidth);
  }

  // Callback when the page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
    }
  }

  onBackPress(): boolean {
    Log.info(TAG, 'onBackPress');
    router.back({
      uri: '',
      params: {}
    });
    return true;
  }

  onPageShow(): void {
    this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
  }

  build() {
    Column() {
      MediaOperationActionBar({ onMenuClicked: (action: Action): void => this.onMenuClicked(action) })
      List({ scroller: this.scroller }) {
        ListItem() {
          Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center
          }) {
            List() {
              LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>): void => {
                ListItem() {
                  AlbumListCard({ item: item?.get() })
                }
              }, (item: LazyItem<AlbumDataItem>): string => item.getHashCode())
            }
            .divider({
              strokeWidth: 1,
              startMargin: $r('app.float.album_list_card_divider_margin_left')
            })
            .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
            .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
            .padding({
              left: $r('app.float.list_card_margin'),
              right: $r('app.float.list_card_margin')
            })
            .width(this.listCardWidth)
          }.width('100%')
        }.width('100%')
      }
      .scrollBar(BarState.Auto)
      .width('100%')
      .margin({
        top: $r('app.float.album_let_page_padding_top'),
        left: $r('app.float.max_padding_start'),
        right: $r('app.float.max_padding_end'),
        bottom: px2vp(this.leftBlank[3])
      })
      CustomDialogView()
    }
    .backgroundColor($r('app.color.default_background_color')) // ux: colorSubBackground
    .height('100%')
    .padding({
      top: px2vp(this.leftBlank[1]),
      bottom: px2vp(this.leftBlank[3])
    })
  }

  pageTransition(): void {
    PageTransitionEnter({ type: RouteType.None, duration: 1 })
      .opacity(0)
    PageTransitionExit({ type: RouteType.None, duration: 1 })
      .opacity(0)
  }
}
