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
import { MediaConstants } from '../constants/MediaConstants';
import { ToolBar } from '../components/ToolBar';
import { ImageGridItemComponent } from '../components/ImageGridItemComponent';
import { Action } from '../models/Action';
import { ActionBar } from '../components/ActionBar';
import { ActionBarProp } from '../common/ActionBarProp';
import { CustomDialogView } from '../components/CustomDialogView';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { Constants } from '../constants/Constants';
import { MenuOperation } from '../menus/MenuOperation';
import { MenuContext } from '../menus/MenuContext';
import { BatchDeleteMenuOperation } from '../menus/BatchDeleteMenuOperation';
import { BatchRemoveMenuOperation } from '../menus/BatchRemoveMenuOperation';
import { screenManager } from '../common/ScreenManager';
import { broadcastManager } from '../common/BroadcastManager';
import { JumpSourceToMain } from '../models/JumpSourceToMain';
import { getResourceString } from '../utils/ResourceUtils';
import { MediaOperationType } from '../models/MediaOperationType';
import { MoveMenuOperation } from '../menus/MoveMenuOperation';
import { GridScrollBar } from '../components/GridScrollBar';
import { BatchRecoverMenuOperation } from '../menus/BatchRecoverMenuOperation';
import { ClearRecycleMenuOperation } from '../menus/ClearRecycleMenuOperation';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { userFileObserver } from '../base/UserFileObserver';
import { UserFileDataChangeCallback } from '../base/UserFileDataChangeCallback';
import { CommonObserverCallback } from '../common/CommonObserverCallback';
import { NoPhotoComponent } from '../components/NoPhotoComponent';
import { PhotoGridBarModel } from '../models/PhotoGridBarModel';
import { GroupItemDataSource } from '../common/GroupItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { showToast } from '../utils/UiUtil';
import { LazyItem } from '../common/ItemDataSource';

const TAG = 'PhotoGridPage';
// Album Page
@Entry
@Component
struct PhotoGridPage {
  @State isSelectUpperLimited: boolean = false;
  @State isHideScrollBar: boolean = true;
  @Provide @Watch('updateActionBar') isEmpty: boolean = false;
  @State gridRowCount: number = 0;
  @Provide @Watch('updateActionBar') isSelectedMode: boolean = false;
  @Provide @Watch('updateActionBar') isAllSelected: boolean = false;
  @Provide('selectedCount') @Watch('updateActionBar') totalSelectedCount: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @Provide broadCast: Broadcast = new Broadcast();
  @Provide isShow: boolean = true;
  @Provide isShowBar: boolean = true;
  @Provide moreMenuList: Action[] = [];
  @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  private albumInfo: SimpleAlbumDataItem = new SimpleAlbumDataItem('', '', '', '', '', 0, 0);
  title: string = '';
  deviceName: string = '';
  scroller: Scroller | null = new Scroller();
  isDataFreeze = false;
  isActive = false;
  deleteMode: boolean = false;
  deleteReady = true;
  routerStart = false;
  private dataObserver: CommonObserverCallback | null = new CommonObserverCallback(this as UserFileDataChangeCallback);
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  private barModel: PhotoGridBarModel | null = new PhotoGridBarModel();
  private groupDataSource: GroupItemDataSource = new GroupItemDataSource();
  private isMediaLibDataChanged: boolean = true;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @State toolBarMenuList: Action[] = [];

  updateActionBar(): void {
    if (this.barModel !== undefined && this.barModel !== null) {
      this.actionBarProp = this.barModel.createActionBar(this.title, this.isSelectedMode,
        this.totalSelectedCount, this.isAllSelected, this.isEmpty);
      this.toolBarMenuList = this.barModel.getMenuList(this.isSelectedMode, this.totalSelectedCount,
        this.isAllSelected, this.isEmpty);
    }

  }

  onIndexChange(): void {
    Log.info(TAG, 'onIndexChange ' + this.PhotoGridPageIndex)
    if (this.PhotoGridPageIndex !== Constants.INVALID) {
      this.scroller?.scrollToIndex(this.PhotoGridPageIndex);
    }
  }

  onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.info(TAG, 'onMenuClicked, action: ' + action.actionID);
    let menuContext: MenuContext;
    let menuOperation: MenuOperation;
    if (action === Action.BACK) {
      if (AppStorage.Get<boolean>(Constants.BACK_FROM_FORM_DETAIL) != null) {
        this.routerAlbumSetPage();
      } else {
        router.back();
      }
    } else if (action === Action.CANCEL) {
      this.onModeChange();
    } else if (action === Action.SELECT_ALL || action === Action.DESELECT_ALL) {
      this.isAllSelected = !this.groupDataSource.isSelect()
      this.groupDataSource.setSelect(this.isAllSelected)
      this.onSelect()
    } else if (action === Action.DELETE) {
      menuContext = new MenuContext();
      menuContext
        .withDeletePageFromType(BroadcastConstants.DELETE_FROM_GRID)
        .withAlbumId(this.albumInfo.id)
        .withDataSource(this.groupDataSource)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((err: object): void => this.onDeleteEnd(err))
        .withBroadCast(this.broadCast)
        .withAlbumInfo(this.albumInfo)
      menuOperation = new BatchDeleteMenuOperation(menuContext);
      menuOperation.doAction();
    } else if (action === Action.INFO) {
      this.openDetailsDialog();
    } else if (action === Action.CLEAR_RECYCLE) {
      menuContext = new MenuContext();
      menuContext
        .withDataSource(this.groupDataSource)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((err: object): void => this.onDeleteEnd(err))
        .withBroadCast(this.broadCast)
      menuOperation = new ClearRecycleMenuOperation(menuContext)
      menuOperation.doAction();
    } else if (action === Action.RECOVER) {
      menuContext = new MenuContext();
      menuContext
        .withDataSource(this.groupDataSource)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((err: object): void => this.onDeleteEnd(err))
        .withBroadCast(this.broadCast)
      menuOperation = new BatchRecoverMenuOperation(menuContext);
      menuOperation.doAction();
    } else if (action === Action.MOVE) {
      this.routeSelectAlbumPage(MediaOperationType.Move);
    } else if (action === Action.REMOVE) {
      menuContext = new MenuContext();
      menuContext
        .withAlbumId(this.albumInfo.id)
        .withDataSource(this.groupDataSource)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((err: object): void => this.onDeleteEnd(err))
        .withBroadCast(this.broadCast)
        .withAlbumInfo(this.albumInfo)
      menuOperation = new BatchRemoveMenuOperation(menuContext);
      menuOperation.doAction();
    } else if (action === Action.NEW) {
      this.routeToAddMediaPage();
    }
  }

  async openDetailsDialog(): Promise<void> {
    let items: UserFileDataItem[] = this.groupDataSource.getSelectedItems() as UserFileDataItem[];
    if (items.length === 0) {
      Log.warn(TAG, 'no select error');
    } else if (items.length === 1) {
      Log.info(TAG, 'totalSelectedCount is 1');
      this.broadCast.emit(BroadcastConstants.SHOW_DETAIL_DIALOG, [items[0]]);
    } else {
      let size = 0;
      items.forEach((item: UserFileDataItem): void => {
        Log.debug(TAG, 'openDetailsDialog item.size: ' + item.size);
        size = size + item.size;
      })
      Log.info(TAG, 'openDetailsDialog size: ' + size);
      this.broadCast.emit(BroadcastConstants.SHOW_MULTI_SELECT_DIALOG, [items.length, size]);
    }
  }
  private routeSelectAlbumPage(pageType: string): void {
    this.routerStart = true;
    router.push({
      uri: 'pages/MediaOperationPage',
      params: {
        pageType: pageType,
        albumInfo: JSON.stringify(this.albumInfo)
      }
    });
  }
  private routerAlbumSetPage(): void {
    router.replace({
      uri: 'pages/index',
      params: {
        jumpSource: JumpSourceToMain.ALBUM,
      }
    });
  }

  private routeToAddMediaPage(): void {
    router.push({
      uri: 'pages/AlbumSelect',
      params: {
        albumInfo: JSON.stringify(this.albumInfo)
      }
    });
  }

  onCopyStart(): void {
    this.onCopyStartBindImpl()
  }

  private onCopyStartBindImpl(): void {
    Log.info(TAG, 'onCopyStart');
    userFileObserver.unregisterObserver(this.dataObserver);
  }

  onCopyEnd(err: object, count: number, total: number): void {
    this.onCopyEndBindImpl(err, count, total)
  }

  onCopyEndBindImpl(err: object, count: number, total: number): void {
    Log.info(TAG, 'onCopyEnd count: ' + count + ', total: ' + total);
    this.onModeChange();
    userFileObserver.registerObserver(this.dataObserver);
    if (new Boolean(err).valueOf()) {
      getResourceString($r('app.string.copy_failed_single')).then<void, void>((message: string): void => {
        showToast(message);
      })
    } else {
      animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, (): void => this.groupDataSource.dataReload(true));
      this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
    }
  }

  onDownloadStart(): void {
    this.onDownloadStartBindImpl()
  }

  private onDownloadStartBindImpl(): void {
    Log.info(TAG, 'onDownloadStart');
    userFileObserver.unregisterObserver(this.dataObserver);
  }

  async onDownloadEnd(err: object, count: number, total: number): Promise<void> {
    return await this.onDownloadEndBindImpl(err, count, total)
  }

  async onDownloadEndBindImpl(err: object, count: number, total: number): Promise<void> {
    Log.info(TAG, 'onDownloadEnd count: ' + count + ', total: ' + total);
    this.onModeChange();
    userFileObserver.registerObserver(this.dataObserver);
    if (new Boolean(err).valueOf()) {
      if (total > 1) {
        Log.warn(TAG, 'get selectItems is error ' + count);
        let str = await getResourceString($r('app.string.download_failed_multi'));
        let message = str.replace('%d', count.toString());
        showToast(message);
      } else {
        getResourceString($r('app.string.download_failed_single')).then<void, void>((message: string): void => {
          showToast(message);
        })
      }
      ;
    } else {
      getResourceString($r('app.string.download_progress_done')).then<void, void>((message: string): void => {
        showToast(message);
      })
    }
  }

  onMoveStart(): void {
    this.onMoveStartBindImpl()
  }

  private onMoveStartBindImpl(): void {
    Log.info(TAG, 'onMoveStart');
    userFileObserver.unregisterObserver(this.dataObserver);
  }

  onMoveEnd(err: object, count: number, total: number): void {
    this.onMoveEndBindImpl(err, count, total)
  }

  private onMoveEndBindImpl(err: object, count: number, total: number): void {
    Log.info(TAG, 'onMoveEnd count: ' + count + ', total: ' + total);
    this.onModeChange();
    userFileObserver.registerObserver(this.dataObserver);
    if (new Boolean(err).valueOf()) {
      getResourceString($r('app.string.move_failed_single')).then<void, void>((message: string): void => {
        showToast(message);
      })
    } else {
      animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, (): void => this.groupDataSource.dataReload(true));
    }
  }

  onDeleteStart(): void {
    this.onDeleteStartBindImpl()
  }

  private onDeleteStartBindImpl(): void {
    Log.info(TAG, 'onDeleteStart');
    userFileObserver.unregisterObserver(this.dataObserver);
  }

  onDeleteEnd(err: object): void {
    this.onDeleteEndBindImpl(err)
  }

  private onDeleteEndBindImpl(err: object): void {
    Log.info(TAG, 'onDeleteEnd');
    this.onModeChange();
    userFileObserver.registerObserver(this.dataObserver);

    animateTo({ duration: Constants.DELETE_ANIMATE_DURATION }, (): void => {
      this.groupDataSource.dataRemove();
      if (this.groupDataSource.groupDataItem) {
        this.isEmpty = this.groupDataSource.groupDataItem.length == 0 ? true : false;
      }
      this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
    })
    //for NAPI notify delete bug to load manually
    this.onUserFileDataChange(MediaConstants.MEDIA_TYPE_IMAGE);
  }

  /**
   * Just change select mode to false
   */
  onModeChange(): void {
    Log.info(TAG, 'onModeChange');
    if (this.isSelectedMode) {
      this.isSelectedMode = false;
      this.groupDataSource.setSelect(false);
      this.onSelect();
    }
  }

  onPageShow(): void {
    Log.error(TAG,"onPageShow" + this.isActive)
    this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
    let params: ParamsInterface = router.getParams();
    if (this.routerStart && params != null
      && params.pageType != null
      && params.albumInfo != null) {
      Log.info(TAG, 'MediaOperation back');
      if (params.pageType === MediaOperationType.Move) {
        this.moveOperation(JSON.parse(params.albumInfo.toString()));
      }
    }
    this.routerStart = false;
    this.onActive();
  }

  onPageHide(): void {
    this.isShow = false;
    this.onInActive();
  }

  // The callback when current page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.loadItem();
    }
  }

  // The callback when current page is in the background
  onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
    }
  }

  private onUpdateFavorAndSelectState(item: UserFileDataItem): void {
    this.onUpdateFavorAndSelectStateBindImpl(item)
  }

  private onUpdateFavorAndSelectStateBindImpl(item: UserFileDataItem): void {
    this.onUpdateFavorState(item);
    this.onSelect();
  }

  private onUpdateFavorState(item: UserFileDataItem): void {
    Log.debug(TAG, 'onUpdateFavorState favor');
    let index = this.groupDataSource.getIndexByItem(item);
    if (index !== -1) {
      this.groupDataSource.notifyDataChange(index);
    }
  }

  onBackPress(): boolean {
    if (AppStorage.Get<boolean>(Constants.BACK_FROM_FORM_DETAIL) != null) {
      this.routerAlbumSetPage();
      return true;
    }
    if (this.isSelectedMode) {
      this.onModeChange();
      return true;
    }
    return false;
  }

  private moveOperation(albumInfo: SimpleAlbumDataItem): void {
    let menuContext = new MenuContext();
    menuContext.withDataSource(this.groupDataSource)
      .withOperationStartCallback((): void => this.onMoveStart())
      .withOperationEndCallback((err: object, count: number, total: number): void => this.onMoveEnd(err, count, total))
      .withBroadCast(this.broadCast)
      .withAlbumInfo(albumInfo);
    let menuOperation = new MoveMenuOperation(menuContext);
    menuOperation.doAction();
  }

  aboutToAppear(): void {
    let param: ParamsInterface = router.getParams();
    if (param.item != undefined && param.item != null) {
      Log.debug(TAG, 'After router.getParams, param is: ' + JSON.stringify(param));
      this.albumInfo = JSON.parse(param.item.toString()) as SimpleAlbumDataItem;
      this.title = this.albumInfo.displayName;
      this.barModel?.setAlbumId(this.albumInfo.id)
      this.groupDataSource.setAlbumId(this.albumInfo.id)
      this.groupDataSource.setAlbumType(this.albumInfo.albumType)
      this.groupDataSource.setAlbumSubtype(this.albumInfo.albumSubType)
      this.groupDataSource.setAlbumName(this.albumInfo.displayName)
    }
    Log.info(TAG, 'reloadGroupItemData');

    userFileObserver.registerObserver(this.dataObserver);

    this.broadCast.on(BroadcastConstants.SELECT, (index: number): void => { this.onSelect() });
    this.broadCast.on(BroadcastConstants.JUMP_PHOTO_BROWSER, (name: string, item: UserFileDataItem): void => {
      this.jumpToPhotoBrowser(name, item);
    });

    this.broadCast.on(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, (name: string, item: UserFileDataItem): void => {
      this.jumpToThirdPhotoBrowser(name, item);
    });
    this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number): void => {
      Log.info(TAG, 'ON_LOADING_FINISHED size: ' + size);
    });
    this.appBroadcast.on(BroadcastConstants.UPDATE_DATA_SOURCE, (item: UserFileDataItem): void => this.onUpdateFavorAndSelectStateBindImpl(item));

    if (this.albumInfo.deviceId != null) {
      Log.info(TAG, 'deviceId size: ' + this.albumInfo.deviceId);
      this.appBroadcast.on(BroadcastConstants.ON_REMOTE_CHANGED, (res: string, deviceId: number): void => this.onUpdateRemoteDeviceBindImpl(res, deviceId));
    }

    screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, (): void => {
      this.initGridRowCount();
    });

    this.initGridRowCount();
    if (this.albumInfo.albumType==MediaConstants.ALBUM_TYPE_USER){
      this.moreMenuList = [Action.MOVE, Action.REMOVE, Action.INFO];
    } else {
      this.moreMenuList = [Action.MOVE, Action.INFO];
    }

    this.updateActionBar();
  }

  private initGridRowCount(): void {
    let contentWidth = screenManager.getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.TIME_GRID_MAX_SIZE_RATIO;
    this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
    + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
    Log.info(TAG, 'initGridRowCount contentWidth: ' + contentWidth);
  }

  private onUpdateRemoteDevice(res: string, deviceId: number): void {
    this.onUpdateRemoteDeviceBindImpl(res, deviceId)
  }

  private onUpdateRemoteDeviceBindImpl(res: string, deviceId: Object): void {
    Log.info(TAG, 'onUpdateRemoteDevice');
    if (String(deviceId) !== this.albumInfo.deviceId || this.isActive === false) {
      Log.debug(TAG, 'other device');
      return;
    }
    if (res === Constants.DEVICE_STATE_OFFLINE) {
      Log.debug(TAG, 'device offline route to album main');
      router.back({
        uri: 'pages/index',
        params: {
          jumpSource: JumpSourceToMain.ALBUM,
        }
      });
    } else {
      Log.warn(TAG, 'res code is err ' + res);
      return;
    }
  }

  onUserFileDataChange(changeType: string): void {
    Log.info(TAG, 'onUserFileDataChange type: ' + changeType);
    this.isMediaLibDataChanged = true;
    this.loadItem();
  }

  private loadItem(): void {
    if (this.isActive && this.isMediaLibDataChanged) {
      this.groupDataSource.reloadGroupItemData(true).then<void, void>((isEmpty: boolean): void => {
        Log.info(TAG, 'onMediaLibDataChange load finish');
        this.isEmpty = isEmpty;
        this.groupDataSource.notifyDataReload();
        this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
      })
    } else if (this.isActive) {
      this.groupDataSource.dataRemove();
      if (this.groupDataSource.groupDataItem !== undefined) {
        this.isEmpty = this.groupDataSource.groupDataItem.length == 0 ? true : false;
      }

    }
  }

  private onSelect(): void {
    Log.info(TAG, 'onSelect');
    this.totalSelectedCount = this.groupDataSource.getSelectedCount();
    this.isAllSelected = this.groupDataSource.isSelect();
    if (this.totalSelectedCount > 0) {
      if (this.albumInfo.albumType === MediaConstants.ALBUM_TYPE_USER){
        this.moreMenuList = [Action.MOVE, Action.REMOVE, Action.INFO];
      } else {
        this.moreMenuList = [Action.MOVE, Action.INFO];
      }
    } else {
      if (this.albumInfo.albumType === MediaConstants.ALBUM_TYPE_USER){
        this.moreMenuList = [Action.MOVE_INVALID, Action.REMOVE_INVALID, Action.INFO_INVALID];
      } else {
        this.moreMenuList = [Action.MOVE_INVALID, Action.INFO_INVALID];
      }
    }
  }

  private jumpToPhotoBrowser(name: string, item: UserFileDataItem): void {
    let children: UserFileDataItem[] = this.groupDataSource.getItems();
    let targetIndex = children.indexOf(item);
    if (targetIndex === Constants.NOT_FOUND) {
      Log.warn(TAG, 'targetIndex is not found');
      return;
    }
    AppStorage.SetOrCreate<UserFileDataItem[]>(Constants.APP_KEY_PHOTO_BROWSER, children);
    let pageEntryFrom: number = Constants.ENTRY_FROM.NORMAL
    if (this.albumInfo != null && this.albumInfo.id === MediaConstants.ALBUM_ID_RECYCLE) {
      pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
    } else {
      pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
    }
    router.push({
      uri: 'pages/PhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
        albumInfo: this.albumInfo,
        pageFrom: pageEntryFrom
      }
    });
  }

  private jumpToThirdPhotoBrowser(name: string, item: UserFileDataItem): void {
    let children: UserFileDataItem[] = this.groupDataSource.getItems();
    let targetIndex = children.indexOf(item);
    if (targetIndex === Constants.NOT_FOUND) {
      Log.warn(TAG, 'targetIndex is not found');
      return;
    }
    AppStorage.SetOrCreate<UserFileDataItem[]>(Constants.APP_KEY_PHOTO_BROWSER, children);
    let pageEntryFrom: number = Constants.ENTRY_FROM.NORMAL;
    if (this.albumInfo != null && this.albumInfo.id === MediaConstants.ALBUM_ID_RECYCLE) {
      pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
    } else {
      pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
    }
    router.push({
      uri: 'pages/SelectPhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
        albumInfo: this.albumInfo,
        pageFrom: pageEntryFrom
      }
    });
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.broadCast.off(null, null);
    this.appBroadcast.off(BroadcastConstants.UPDATE_DATA_SOURCE, (item: UserFileDataItem): void => this.onUpdateFavorAndSelectStateBindImpl(item));
    this.appBroadcast.off(BroadcastConstants.ON_REMOTE_CHANGED, (res: string, deviceId: number): void => this.onUpdateRemoteDeviceBindImpl(res, deviceId));
    userFileObserver.unregisterObserver(this.dataObserver);
    this.dataObserver = null;
    this.scroller = null;
    this.barModel = null;
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action)
      })

      if (this.isEmpty) {
        NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
      } else {
        Stack() {
          Grid(this.scroller) {
            LazyForEach(this.groupDataSource, (item: LazyItem<UserFileDataItem>): void => {
              GridItem() {
                ImageGridItemComponent({
                  lazyItem: item,
                  mediaItem: item.get(),
                  pageName: Constants.PHOTO_TRANSITION_ALBUM,
                  isSelectUpperLimited: $isSelectUpperLimited
                })
              }
              .aspectRatio(1)
              .columnStart(item.get().index % this.gridRowCount)
              .columnEnd(item.get().index % this.gridRowCount)
            }, (item: LazyItem<UserFileDataItem>): string => item.getHashCode())
          }
          .columnsTemplate('1fr '.repeat(this.gridRowCount))
          .columnsGap(Constants.GRID_GUTTER)
          .rowsGap(Constants.GRID_GUTTER)
          .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

          if (this.scroller !== null && this.scroller !== undefined) {
            GridScrollBar({ scroller: this.scroller, isHideScrollBar: $isHideScrollBar });
          }
        }.layoutWeight(1)
        .padding({
          bottom: ((this.isSelectedMode || (this.albumInfo.id === MediaConstants.ALBUM_ID_RECYCLE)) && !this.isHorizontal) ? Constants.ActionBarHeight : 0
        })
      }

      CustomDialogView();
      if (this.isSelectedMode || (this.albumInfo.id === MediaConstants.ALBUM_ID_RECYCLE) && !this.isEmpty) {
        ToolBar({
          toolMenuList: $toolBarMenuList,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action)
        })
      }
    }
    .backgroundColor($r('app.color.default_background_color'))
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
