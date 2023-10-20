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
import { ImageGridItemComponent } from '../components/ImageGridItemComponent';
import { Action } from '../models/Action';
import { ActionBar } from '../components/ActionBar';
import { ActionBarProp } from '../common/ActionBarProp';
import { CustomDialogView } from '../components/CustomDialogView';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { Constants } from '../constants/Constants';
import { NoPhotoComponent } from '../components/NoPhotoComponent';
import { screenManager } from '../common/ScreenManager';
import { broadcastManager } from '../common/BroadcastManager';
import { MenuContext } from '../menus/MenuContext';
import { MoveMenuOperation } from '../menus/MoveMenuOperation';
import { JumpSourceToMain } from '../models/JumpSourceToMain';
import { GridScrollBar } from '../components/GridScrollBar';
import { NewAlbumBarModel } from '../models/NewAlbumBarModel';
import { GroupItemDataSource } from '../common/GroupItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { LazyItem } from '../common/ItemDataSource';

const TAG = 'NewAlbumPage';

@Entry
@Component
struct NewAlbumPage {
  @State isSelectUpperLimited: boolean = false;
  @State isEmpty: boolean = false;
  @State isHideScrollBar: boolean = true;
  @State gridRowCount: number = 0;
  @Provide @Watch('updateActionBar') isSelectedMode: boolean = true;
  @Provide isAllSelected: boolean = false;
  @Provide('selectedCount') @Watch('updateActionBar') totalSelectedCount: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @Provide broadCast: Broadcast = new Broadcast();
  @Provide isShow: boolean = true;
  @Provide isShowBar: boolean = true;
  @Provide moreMenuList: Action[] = [];
  @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  private scroller: Scroller = new Scroller();
  private isActive = false;
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  private isNewAlbum: boolean | undefined = AppStorage.Get<boolean>(Constants.APP_KEY_NEW_ALBUM);
  private targetAlbum: SimpleAlbumDataItem | undefined = AppStorage.Get<SimpleAlbumDataItem>(Constants.APP_KEY_NEW_ALBUM_TARGET);
  private barModel: NewAlbumBarModel = new NewAlbumBarModel();
  private groupDataSource: GroupItemDataSource = new GroupItemDataSource();
  @State actionBarProp: ActionBarProp = new ActionBarProp();

  updateActionBar(): void {
    this.actionBarProp = this.barModel.createActionBar(this.isSelectedMode, this.totalSelectedCount);
  }

  onIndexChange(): void {
    Log.info(TAG, 'onIndexChange ' + this.PhotoGridPageIndex)
    if (this.PhotoGridPageIndex != Constants.INVALID) {
      this.scroller.scrollToIndex(this.PhotoGridPageIndex);
    }
  }

  onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.info(TAG, 'onMenuClicked, action: ' + action.actionID);
    if (action === Action.CANCEL) {
      this.groupDataSource.setSelect(false)
      router.back();
    } else if (action === Action.OK) {
      if (this.groupDataSource.getSelectedCount() === 0) {
        Log.info(TAG, 'onMenuClicked, action: ' + action.actionID + ', count = 0');
      } else {
        Log.info(TAG, 'onMenuClicked, action: ' + action.actionID + ' newAlbum: ' + this.isNewAlbum);
        if (this.isNewAlbum) {
          AppStorage.SetOrCreate<UserFileDataItem[]>(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.groupDataSource.getSelectedItems() as UserFileDataItem[]);
          this.groupDataSource.setSelect(false)
          let url = 'pages/Index'
          router.back({
            uri: url,
            params: {
              jumpSource: JumpSourceToMain.ALBUM
            }
          })
        } else {
          this.moveOperation();
          this.groupDataSource.setSelect(false)
        }
      }
    }
  }

  onModeChange(): void {
    Log.info(TAG, 'onModeChange');
  }

  onPageShow(): void {
    this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
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
    }
    this.groupDataSource.dataRemove();
  }

  // The callback when current page is in the background
  onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
    }
  }

  onUpdateFavorAndSelectState(item: UserFileDataItem): void {
    this.onUpdateFavorAndSelectStateBindImpl(item)
  }

  private onUpdateFavorAndSelectStateBindImpl(item: UserFileDataItem): void {
    this.onUpdateFavorState(item);
    this.onSelect(this.groupDataSource.getIndexByItem(item));
  }

  onUpdateFavorState(item: UserFileDataItem): void {
    Log.debug(TAG, 'onUpdateFavorState');
    let index = this.groupDataSource.getIndexByItem(item);
    if (index !== -1) {
      this.groupDataSource.notifyDataChange(index);
    }
  }

  onBackPress(): boolean {
    this.groupDataSource.setSelect(false);
    return false;
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
    AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
    AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
    AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    if (this.isNewAlbum) {
      let url = 'pages/index'
      router.back({
        uri: url,
        params: {
          jumpSource: JumpSourceToMain.ALBUM
        }
      })
    } else {
      router.back({
        uri: 'pages/PhotoGridPage',
      });
    }
  }

  private moveOperation(): void {
    let menuContext = new MenuContext();
    if (this.targetAlbum !== undefined) {
      menuContext
        .withDataSource(this.groupDataSource)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onOperationEnd())
        .withBroadCast(this.broadCast)
        .withAlbumInfo(this.targetAlbum);
    }
    let menuOperation = new MoveMenuOperation(menuContext);
    menuOperation.doAction();
  }

  aboutToAppear(): void {
    let param: ParamsInterface = router.getParams();
    if (param.item != null) {
      Log.debug(TAG, 'After router.getParams, param is: ' + JSON.stringify(param));
      let item = JSON.parse(param.item.toString()) as AlbumDataItem;
      this.groupDataSource.setAlbumId(item.id)
      this.groupDataSource.setAlbumType(item.albumType)
      this.groupDataSource.setAlbumSubtype(item.albumSubType)
      this.groupDataSource.setAlbumName(item.displayName)
    }
    this.groupDataSource.reloadGroupItemData(true).then<void, void>((isEmpty: boolean): void => {
      this.isEmpty = isEmpty
      this.groupDataSource.notifyDataReload()
      this.isHideScrollBar = (this.groupDataSource.totalCount() <= Constants.GRID_SCROLL_BAR_VISIBLE_THRESHOLD)
    })
    this.broadCast.on(BroadcastConstants.SELECT, (index: number): void => this.onSelect(index));

    this.broadCast.on(BroadcastConstants.JUMP_PHOTO_BROWSER, (name: string, item: UserFileDataItem): void => {
      this.jumpToPhotoBrowser(name, item)
    })

    this.appBroadcast.on(BroadcastConstants.UPDATE_DATA_SOURCE, (item: UserFileDataItem): void => this.onUpdateFavorAndSelectStateBindImpl(item));

    this.initGridRowCount();
    this.moreMenuList = [];
    this.moreMenuList.push(Action.INFO);

    this.updateActionBar();
  }

  private initGridRowCount(): void {
    let contentWidth = screenManager.getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    this.gridRowCount = Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin)
      + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
    Log.info(TAG, 'initGridRowCount contentWidth: ' + contentWidth);
  }

  private onSelect(index: number): void {
    Log.info(TAG, 'onSelect');
    this.totalSelectedCount = this.groupDataSource.getSelectedCount();
    this.isAllSelected = this.groupDataSource.isSelect();
    this.groupDataSource.notifyDataChange(index);
  }

  private jumpToPhotoBrowser(name: string, item: UserFileDataItem): void {
    let children: UserFileDataItem[] = this.groupDataSource.getItems();
    let targetIndex = children.indexOf(item);
    if (targetIndex === Constants.NOT_FOUND) {
      Log.warn(TAG, 'targetIndex is not found');
      return;
    }
    Log.info(TAG, 'jump to photo browser at index: ' + targetIndex);
    AppStorage.SetOrCreate<UserFileDataItem[]>(Constants.APP_KEY_PHOTO_BROWSER, children);
    router.push({
      uri: 'pages/PhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
      }
    });
  }

  aboutToDisappear(): void {
    this.broadCast.off(null, null);
    this.appBroadcast.off(BroadcastConstants.UPDATE_DATA_SOURCE, (item: UserFileDataItem): void => this.onUpdateFavorAndSelectStateBindImpl(item));
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action)
      })
      if (this.isEmpty) {
        NoPhotoComponent({
          title: $r('app.string.no_distributed_photo_head_title_album')
        })
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
            }, (item: LazyItem<AlbumDataItem>): string => item.getHashCode())
          }
          .columnsTemplate('1fr '.repeat(this.gridRowCount))
          .columnsGap(Constants.GRID_GUTTER)
          .rowsGap(Constants.GRID_GUTTER)
          .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

          GridScrollBar({ scroller: this.scroller, isHideScrollBar: $isHideScrollBar });
        }
        .layoutWeight(1)
      }
      CustomDialogView()
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
    PageTransitionExit({ type: RouteType.Pop, duration: 300 }).slide(SlideEffect.Right)
      .opacity(0)
  }
}
