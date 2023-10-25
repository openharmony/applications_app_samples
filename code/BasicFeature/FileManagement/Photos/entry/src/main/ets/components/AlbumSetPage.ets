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

import { MoveMenuOperation } from '../menus/MoveMenuOperation';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { Constants } from '../constants/Constants';
import { screenManager } from '../common/ScreenManager';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { broadcastManager } from '../common/BroadcastManager';
import { AlbumSetNewMenuOperation } from '../menus/AlbumSetNewMenuOperation';
import { MenuContext } from '../menus/MenuContext';
import { MenuOperation } from '../menus/MenuOperation';
import { CustomDialogView } from './CustomDialogView';
import { Action } from '../models/Action';
import { ActionBar } from './ActionBar';
import { ActionBarProp } from '../common/ActionBarProp';
import { UserFileDataChangeCallback } from '../base/UserFileDataChangeCallback';
import { CommonObserverCallback } from '../common/CommonObserverCallback';
import { userFileObserver } from '../base/UserFileObserver';
import { Log } from '../utils/Log';
import { AlbumBarModel } from '../models/AlbumBarModel';
import { ToolBar } from './ToolBar';
import abilityAccessCtrl,{ PermissionRequestResult, Permissions} from '@ohos.abilityAccessCtrl';
import { GlobalContext } from '../common/GlobalContext';
import common from '@ohos.app.ability.common';
import {
  AlbumGridItemNewStyle
} from './AlbumGridItemNewStyle';
import {
  AlbumSetDeleteMenuOperation
} from '../menus/AlbumSetDeleteMenuOperation';
import {
  AlbumSetRenameMenuOperation
} from '../menus/AlbumSetRenameMenuOperation';
import { AlbumScrollBar } from './AlbumScrollBar';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { AlbumsDataSource } from '../common/AlbumsDataSource';
import { LazyItem } from '../common/ItemDataSource';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { userFileModel } from '../base/UserFileModel';
import { BusinessError } from '@ohos.base';

// Album Set Page
const TAG = 'AlbumSetPage'

@Component
export struct AlbumSetPage {
  @Provide @Watch('onModeChange') isAlbumSetSelectedMode: boolean =false;
  @Provide('selectedCount') @Watch('updateActionBar') selectedAlbumsCount: number = 0;
  @Provide isHideScrollBar: boolean = true;
  @State isEmpty: boolean = true;
  @Provide gridColumnsCount: number = 0;
  @Provide broadCast: Broadcast = new Broadcast();
  @Consume @Watch('onIndexPageShow') isShow: boolean;
  private dataObserver: CommonObserverCallback | null = new CommonObserverCallback(this as UserFileDataChangeCallback);
  appBroadcast: Broadcast = broadcastManager.getBroadcast();
  isActive = false; // Whether the page is in the foreground

  scroller: Scroller | null = new Scroller();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();

  @Provide moreMenuList: Action[] = [];
  private needNotify = false;
  private barModel: AlbumBarModel | null = new AlbumBarModel();
  private albumsDataSource: AlbumsDataSource = new AlbumsDataSource();
  private isMediaLibDataChanged: boolean = true;

  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @State toolBarMenuList: Action[] = [];

  updateActionBar(): void {
    if (this.barModel !== null) {
      this.actionBarProp = this.barModel.createActionBar(
        this.isAlbumSetSelectedMode,
        this.selectedAlbumsCount,
        this.albumsDataSource.isDisableRename(),
        this.albumsDataSource.isDisableDelete(),
      );

      this.toolBarMenuList = this.barModel.getMenuList(
        this.isAlbumSetSelectedMode,
        this.selectedAlbumsCount,
        this.albumsDataSource.isDisableRename(),
        this.albumsDataSource.isDisableDelete());
    }
  }

  onMenuClicked(action: Action, arg: Object[]): void {
    this.onMenuClickedBindImpl(action, arg);
  }

  private onMenuClickedBindImpl(action: Action, arg: Object[]): void {
    Log.info(TAG, 'onMenuClicked, action: ' + action.actionID);
    let menuContext: MenuContext;
    let menuOperation: MenuOperation;
    if (action === Action.NEW) {
      menuContext = new MenuContext();
      menuContext
        .withOperationStartCallback((): void => this.onOperationStartBindImpl())
        .withOperationEndCallback((): void => this.onNewEndBindImpl())
        .withDataSource(this.albumsDataSource)
        .withBroadCast(this.broadCast);
      menuOperation = new AlbumSetNewMenuOperation(menuContext);
      menuOperation.doAction();
    } else if (action === Action.CANCEL) {
      this.isAlbumSetSelectedMode = false;
    } else if (action === Action.RENAME) {
      menuContext = new MenuContext();
      menuContext
        .withDataSource(this.albumsDataSource)
        .withOperationStartCallback((): void => this.onOperationStartBindImpl())
        .withOperationEndCallback((): void => this.onRenameEndBindImpl())
        .withBroadCast(this.broadCast);
      menuOperation = new AlbumSetRenameMenuOperation(menuContext);
      menuOperation.doAction();
    } else if (action === Action.DELETE) {
      menuContext = new MenuContext();
      menuContext
        .withDataSource(this.albumsDataSource)
        .withOperationStartCallback((): void => this.onOperationStartBindImpl())
        .withOperationEndCallback((): void => this.onDeleteEndBindImpl())
        .withBroadCast(this.broadCast);
      menuOperation = new AlbumSetDeleteMenuOperation(menuContext);
      menuOperation.doAction();
    }
  }

  onOperationStart(): void {
    this.onOperationStartBindImpl();
  }

  private onOperationStartBindImpl(): void {
    Log.debug(TAG, 'onOperationStart');
    userFileObserver.unregisterObserver(this.dataObserver);
  }

  private onDeleteEnd(): void {
    this.onDeleteEndBindImpl();
  }

  private onDeleteEndBindImpl(): void {
    this.isAlbumSetSelectedMode = false;
    this.albumsDataSource.dataRemove();
    userFileObserver.registerObserver(this.dataObserver);
  }

  onNewEnd(): void {
    this.onNewEndBindImpl();
  }

  private onNewEndBindImpl(): void {
    Log.debug(TAG, 'onNewEnd');
    this.isAlbumSetSelectedMode = false;
    userFileObserver.registerObserver(this.dataObserver);
  }

  onRenameEnd(): void {
    this.onRenameEndBindImpl();
  }

  private onRenameEndBindImpl(): void {
    Log.debug(TAG, 'onRenameEnd');
    this.isAlbumSetSelectedMode = false;
    this.albumsDataSource.notifyDataReload();
    userFileObserver.registerObserver(this.dataObserver);
  }

  onOperationEnd(): void {
    this.onOperationEndBindImpl();
  }

  private onOperationEndBindImpl(): void {
    Log.debug(TAG, 'onOperationEnd');
    this.isAlbumSetSelectedMode = false;
    this.isMediaLibDataChanged = true;
    this.selectedAlbumsCount = 0;
    this.loadItem();
    userFileObserver.registerObserver(this.dataObserver);
    AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'AlbumSetPageAboutToAppear');
    this.appBroadcast.on(BroadcastConstants.BACK_PRESS_EVENT, (clbk: Function): void => this.onIndexBackPressBindImpl(clbk));
    this.appBroadcast.on(BroadcastConstants.RESET_ZERO, (pageNumber: number): void => this.onResetZeroBindImpl(pageNumber));

    userFileObserver.registerObserver(this.dataObserver);

    this.initGridRowCount();

    let self = this;
    this.broadCast.on(BroadcastConstants.SELECT, (index: number): void => this.onSelect(index));

    screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, (): void => {
      self.initGridRowCount();
    });
    this.onIndexPageShow();	//TabContent uses lazy loading, call onIndexPageShow() the first time
    this.updateActionBar();
    this.getPermission();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.broadCast.off(null, null);
    this.appBroadcast.off(BroadcastConstants.BACK_PRESS_EVENT, (clbk: Function): void => this.onIndexBackPressBindImpl(clbk));
    this.appBroadcast.off(BroadcastConstants.RESET_STATE_EVENT, (index: number): void => this.onStateResetBindImpl(index));
    this.appBroadcast.off(BroadcastConstants.RESET_ZERO, (pageNumber: number): void => this.onResetZeroBindImpl(pageNumber));
    userFileObserver.unregisterObserver(this.dataObserver);
    this.dataObserver = null;
    this.scroller = null;
    this.barModel = null;
  }

  // Callback when the page is show.
  onIndexPageShow(): void {
    Log.info(TAG, 'onIndexPageShow');
    if (this.isShow) {
      this.onActive();
      this.createAlbum();
    } else if (!this.isShow) {
      this.onInActive();
    } else {
      Log.info(TAG, 'other condition');
    }
  }

  createAlbum(): void {
    let newAlbum = AppStorage.Get<boolean>(Constants.APP_KEY_NEW_ALBUM);
    if (newAlbum != null) {
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
      this.moveOperation();
    }
  }

  private moveOperation(): void {
    this.moveOperationBindImpl();
  }

  private async moveOperationBindImpl(): Promise<void> {
    let mediaItems = AppStorage.Get<UserFileDataItem[]>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    let targetAlbum = AppStorage.Get<SimpleAlbumDataItem>(Constants.APP_KEY_NEW_ALBUM_TARGET);
    if (mediaItems == undefined || undefined == targetAlbum) {
      return;
    }
    let albumName = targetAlbum.displayName;
    Log.info(TAG,'targetAlbum.displayName:'+albumName);
    let newAlbum = await userFileModel.createAlbum(albumName);
    if(newAlbum != undefined) {
      Log.info(TAG,'  successfully, album: ' + newAlbum.displayName + ' album uri: ' + newAlbum.uri);
      let menuContext = new MenuContext();
      menuContext.withItems(mediaItems)
        .withOperationStartCallback((): void => this.onOperationStartBindImpl())
        .withOperationEndCallback((): void => this.onOperationEndBindImpl())
        .withBroadCast(this.broadCast)
        .withAlbumInfo(newAlbum);
      let menuOperation = new MoveMenuOperation(menuContext);
      menuOperation.doAction();
    }
  }

  onModeChange(): void {
    Log.info(TAG, 'onModeChange ' + this.isAlbumSetSelectedMode);
    if (!this.isAlbumSetSelectedMode) {
      this.albumsDataSource.setSelect(false);
      this.selectedAlbumsCount = 0;
    }
    this.updateActionBar();
  }

  onIndexBackPress(callback: Function): void {
    this.onIndexBackPressBindImpl(callback);
  }

  private onIndexBackPressBindImpl(callback: Function): void {
    if (this.isAlbumSetSelectedMode) {
      callback(true);
      this.isAlbumSetSelectedMode = false;
    } else {
      callback(false);
    }
  }

  onStateReset(index: number): void {
    this.onStateResetBindImpl(index);
  }

  private onStateResetBindImpl(index: number): void {
    if (index === Constants.ALBUM_PAGE_INDEX) {
      this.isAlbumSetSelectedMode = false;
    }
  }

  // Callback when the page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.albumsDataSource.dataRemove();
    }
    this.loadItem();
  }

  // Callback when the page is in the background
  onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
    }
  }

  private onResetZeroBindImpl(pageNumber: number): void {
    if (pageNumber === Constants.ALBUM_PAGE_INDEX) {
      this.scroller?.scrollEdge(Edge.Top);
    }
  }

  initGridRowCount(): void {
    Log.info(TAG, 'get screen width is : ' + screenManager.getWinWidth());
    Log.info(TAG, 'get screen height is : ' + screenManager.getWinHeight());

    let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;

    let contentWidth = screenManager.getWinWidth() - sideBarWidth;
    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    this.gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
    / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
    Log.info(TAG, 'the grid count in a line is: ' + this.gridColumnsCount);
  }

  onUserFileDataChange(changeType: string): void {
    Log.info(TAG, 'onUserFileDataChange type: ' + changeType);
    this.isMediaLibDataChanged = true;
    this.albumsDataSource.resetLoadState();
    this.loadItem();
  }

  private loadItem(): void {
    if (this.isActive && this.isMediaLibDataChanged) {
      this.albumsDataSource.reloadAlbumItemData().then<void, void>((isEmpty: boolean): void => {
        this.isEmpty = isEmpty;
        this.albumsDataSource.notifyDataReload();
        this.isHideScrollBar = (this.albumsDataSource.totalCount() <= (this.gridColumnsCount * Constants.NUMBER_3 - Constants.NUMBER_1));
      })
    } else if (this.isActive) {
      this.albumsDataSource.dataRemove();
    }
  }

  private onSelect(index: number): void {
    this.selectedAlbumsCount = this.albumsDataSource.getSelectedCount();
    this.albumsDataSource.notifyDataChange(index);
  }
  getPermission() {
    let array: Array<Permissions> = [
      'ohos.permission.READ_IMAGEVIDEO',
      'ohos.permission.WRITE_IMAGEVIDEO',
    ];
    let appContext: common.UIAbilityContext = GlobalContext.getContext().getObject('appContext') as common.UIAbilityContext;
    let AtManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    //requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    AtManager.requestPermissionsFromUser(appContext, array).then((data:PermissionRequestResult) => {
      Log.info(TAG,'data type:' + typeof(data));
      Log.info(TAG,'data:' + data);
      Log.info(TAG,'data permissions:' + data.permissions);
      Log.info(TAG,'data result:' + data.authResults);
      //reload
      this.onUserFileDataChange('None');
    }).catch((err:BusinessError) => {
      Log.error(TAG,'Failed to start ability'+ err.code);
    })
  }

  @Builder LocalAlbumSet() {
    Stack() {
      Grid(this.scroller) {
        LazyForEach(this.albumsDataSource, (item: LazyItem<AlbumDataItem>): void => {
          if ((item != undefined && item != null) && (item.get() != undefined && item.get() != null) && item.get().index === 0) {
            GridItem() {
              AlbumGridItemNewStyle({
                lazyItem: item,
                item: item.get(),
                isBigCard: true,
              })
            }.columnStart(0).columnEnd(1)
          } else if (item != null && item.get() != null) {
            GridItem() {
              AlbumGridItemNewStyle({
                item: item.get(),
                isBigCard: false,
              })
            }
          }
        }, (item: LazyItem<AlbumDataItem>): string => (item != undefined && item != null) && (item.get() != undefined && item.get() != null) ?
          item.getHashCode() : JSON.stringify(item))
      }
      .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
      .padding({
        left: $r('app.float.max_padding_start'),
        right: $r('app.float.max_padding_end'),
        top: $r('app.float.album_set_page_padding_top'),
        bottom: (this.isSidebar ? $r('app.float.album_set_page_padding_end') : $r('app.float.album_set_page_padding_end_112'))
      })
      .columnsGap($r('app.float.album_set_grid_column_gap'))
      .rowsGap($r('app.float.album_set_grid_row_gap'))

      AlbumScrollBar({ scroller: this.scroller, hasSideBar: this.isSidebar })
    }
  }


  build() {
    Stack() {
      Column() {
        if (!this.isEmpty) {
          ActionBar({
            actionBarProp: $actionBarProp,
            onMenuClicked: (action: Action, arg: Object[]): void => this.onMenuClicked(action, arg)
          })
          Column() {
            this.LocalAlbumSet()
          }
        }
        if (this.isAlbumSetSelectedMode) {
          ToolBar({
            toolMenuList: $toolBarMenuList,
            onMenuClicked: (action: Action, arg: Object[]): void => this.onMenuClicked(action, arg)
          })
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)

      CustomDialogView()
    }
  }

  pageTransition(): void {
    PageTransitionExit({ type: RouteType.Push, duration: 1 })
      .opacity(0)
    PageTransitionEnter({ type: RouteType.Pop, duration: 1 })
      .opacity(0)
  }
}
