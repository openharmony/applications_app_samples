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
import Want from '@ohos.application.Want';
import { Log } from '../utils/Log';
import { Action } from '../models/Action';
import { MenuOperation } from '../menus/MenuOperation';
import { MenuContext } from '../menus/MenuContext';
import {
  GotoPhotosMenuOperation
} from '../menus/GotoPhotosMenuOperation';
import { BatchDeleteMenuOperation } from '../menus/BatchDeleteMenuOperation';
import { BatchRecoverMenuOperation } from '../menus/BatchRecoverMenuOperation';
import { ClearRecycleMenuOperation } from '../menus/ClearRecycleMenuOperation';
import { MediaConstants } from '../constants/MediaConstants';
import { MoveMenuOperation } from '../menus/MoveMenuOperation';
import { DateUtil } from '../utils/DateUtil';
import { CustomDialogView } from '../components/CustomDialogView';
import { Constants } from '../constants/Constants';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { broadcastManager } from '../common/BroadcastManager';
import { Constants as PhotoConstants } from '../constants/BrowserConstants';
import { PhotoBrowserBg } from '../components/PhotoBrowserBg';
import { PhotoBrowserActionBar } from '../components/PhotoBrowserActionBar';
import { ToolBar } from '../components/ToolBar';
import { PhotoSwiper } from '../components/PhotoSwiper';
import { screenManager } from '../common/ScreenManager';
import { JumpSourceToMain } from '../models/JumpSourceToMain';
import { RenameMenuOperation } from '../menus/RenameMenuOperation';
import { MediaOperationType } from '../models/MediaOperationType';
import { showToast } from '../utils/UiUtil';
import { getResourceString } from '../utils/ResourceUtils';
import { CommonObserverCallback } from '../common/CommonObserverCallback';
import { userFileObserver } from '../base/UserFileObserver';
import { mMultimodalInputManager } from '../common/MultimodalInputManager';
import { GroupItemDataSource } from '../common/GroupItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { InnerUserFileDataItem } from '../base/InnerUserFileDataItem';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { getAlbumDisplayName } from '../base/UserFileDataHelper';
import { startAbility, terminateSelf } from '../utils/AbilityUtils';
import { userFileDataItemCache } from '../base/UserFileDataItemCache';
import { GlobalContext } from '../common/GlobalContext';
// page of large photo

const TAG = 'PhotoBrowser';

@Entry
@Component
struct PhotoBrowser {
  @State mOpacity: number = 1;
  @Provide browserBackgroundColor: Resource = $r('app.color.default_background_color');
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Provide menuList: Action[] = [];
  @State toolMenuList: Action[] = [];
  @Provide topMenuList: Action[] = [];
  @Provide moreMenuList: Action[] = [];
  @Provide broadCast: Broadcast = new Broadcast();
  @Provide isShowBar: boolean = true;
  @Provide isPullingDown: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @Provide canSwipe: boolean = false;
  @State @Watch('currentShowChange') currentShow: boolean = true;
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('TimelinePageIndex') TimelinePageIndex: number = Constants.INVALID;
  @StorageLink('PhotoGridPageIndex') PhotoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  photoBrowserTransition: string = '';
  @State isDataChanged:boolean = true;
  private isFromCard = false;

  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') currentIndex: number = 0;
  controller: SwiperController = new SwiperController();
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);

  // The global Broadcast of the application process. Event registration and destruction should be paired
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  private isFromCamera = false;
  private isFromViewData = false;

  // the source of jump to the index page
  private jumpSourceToMain: number = JumpSourceToMain.None;

  // time to view the current picture
  private checkedTransition: string = '';

  // When clicking quickly, only run aboutToAppear for the first time
  private hasAppeared: boolean = false;
  private albumInfo: SimpleAlbumDataItem = new SimpleAlbumDataItem('','','','','',0,0);
  private deviceName = '';
  private backFromCopy = false;
  private pullDownFlag: boolean = false;
  private browserDataSource: GroupItemDataSource = new GroupItemDataSource()
  private isToEdit = false;
  private globalThis = GlobalContext.getContext();

  onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.info(TAG, 'onMenuClicked, action: ' + action.actionID + ', isPullingDown: ' + this.isPullingDown);
    if (this.isPullingDown) {
      return;
    }
    let menuOperation: MenuOperation;
    let menuContext: MenuContext = new MenuContext();
    let currentPhoto = this.getCurrentPhoto();
    if (action === Action.BACK) {
      this.onBackPress();
      return;
    } else if (action === Action.INFO) {
      if (currentPhoto == undefined) {
        return;
      }
      this.broadCast.emit(BroadcastConstants.SHOW_DETAIL_DIALOG, [currentPhoto]);
      return;
    } else if (action === Action.NOT_FAVORITE || action === Action.FAVORITE) {
      if (currentPhoto == undefined) {
        return;
      }
      currentPhoto.setFavor().then<void, void>((isSuccess: boolean): void => { return this.setFavourite(isSuccess) })
      return;
    } else if (action === Action.DELETE) {
      if (currentPhoto == undefined) {
        return;
      }
      menuContext.withItems([currentPhoto])
        .withDeletePageFromType(BroadcastConstants.DELETE_FROM_BROWSER)
        .withAlbumId( Boolean<SimpleAlbumDataItem>(this.albumInfo) ? ( Boolean<string>(this.albumInfo.id) ? this.albumInfo.id : this.albumInfo.toString() ) : '')
        .withBroadCast(this.broadCast)
        .withOperationEndCallback((): void => this.onDeleteEndBindImpl())
      menuOperation = new BatchDeleteMenuOperation(menuContext);
    } else if (action === Action.CLEAR_RECYCLE) {
      if (currentPhoto == undefined) {
        return;
      }
      menuContext.withItems([currentPhoto])
        .withBroadCast(this.broadCast)
        .withOperationEndCallback((): void => this.onDeleteEndBindImpl())
      menuOperation = new ClearRecycleMenuOperation(menuContext);
    } else if (action === Action.RECOVER) {
      if (currentPhoto == undefined) {
        return;
      }
      menuContext = new MenuContext();
      menuContext.withItems([currentPhoto])
        .withOperationEndCallback(this.onDeleteEnd)
        .withBroadCast(this.broadCast)
      menuOperation = new BatchRecoverMenuOperation(menuContext);
    } else if (action === Action.GOTO_PHOTOS) {
      menuContext.withJumpSourceToMain(this.jumpSourceToMain);
      menuOperation = new GotoPhotosMenuOperation(menuContext);
    } else if (action === Action.RENAME) {
      if (currentPhoto == undefined) {
        return;
      }
      menuContext.withItems([currentPhoto])
        .withBroadCast(this.broadCast)
        .withAlbumInfo(this.albumInfo);
      menuOperation = new RenameMenuOperation(menuContext);
    } else if (action === Action.MOVE) {
      this.backFromCopy = true;
      this.routeSelectAlbumPage(MediaOperationType.Move);
      return;
    } else {
      return;
    }
    menuOperation.doAction();
  }

  private setFavourite(isSuccess: boolean): void {
    Log.debug(TAG, 'set favor !');

    if (isSuccess) {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      if (userFileDataItemCache.hasKey(currentPhoto.uri)) {
        userFileDataItemCache.get(currentPhoto.uri).favouriteStatus = currentPhoto.favouriteStatus;
      }
      // 收藏相册进入大图，点击取消收藏会导致Item成员变少，所以要dataRemove
      this.browserDataSource.reloadGroupItemData(false).then<void, void>((): void => {
        this.operateEnd();
      });
      this.updateMenu();
      this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    }
  }

  private operateEnd(): void {
    if (this.currentIndex === 0 || AppStorage.Get<number>('isLeftSwiper') === 0) {
      this.broadCast.emit(BroadcastConstants.ON_DATA_RELOADED, []);
    } else {
      Log.info(TAG, 'operateEnd curIndex : ' + this.currentIndex);
      this.broadCast.emit(BroadcastConstants.ON_DATA_RELOADED, []);
      this.currentIndex--;
    }
  }

  private onDeleteEnd(): void {
    this.onDeleteEndBindImpl()
  }

  private onDeleteEndBindImpl(): void {
    Log.debug(TAG, 'onDeleteEnd start');
    AppStorage.SetOrCreate<number>('isDelete', 0);
    this.operateEnd();
  }

  private setOrientation(): void {
    Log.debug(TAG, 'setOrientation');
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    this.browserDataSource.notifyDataChange(this.currentIndex);
    this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  onToggleBars(): void {
    if (this.isShowBar) {
      this.hideBars();
    } else {
      this.showBars();
    }
    Log.info(TAG, 'Toggle bars, isShowBar: ' + this.isShowBar);
  }

  showBars(): void {
    if (!this.isShowBar) {
      this.isShowBar = true;
      this.browserBackgroundColor = $r('app.color.default_background_color');
      screenManager.setSystemUi(true);
    }
  }

  hideBars(): void {
    if (this.isShowBar) {
      this.isShowBar = false;
      this.browserBackgroundColor = $r('app.color.black');
      screenManager.setSystemUi(false);
    }
  }

  routeSelectAlbumPage(pageType: string): void {
    router.push({
      uri: 'pages/MediaOperationPage',
      params: {
        pageType: pageType,
        albumInfo: JSON.stringify(this.albumInfo)
      }
    });
  }

  onPhotoChanged(index: number): void {
    this.onPhotoChangedBindImpl(index)
  }

  private onPhotoChangedBindImpl(index: number): void {
    index = Math.min(index, this.browserDataSource.totalCount() - 1);
    Log.info(TAG, 'onPhotoChanged start ' + index);
    this.currentIndex = this.isToEdit ? 0 : index;
    this.updateActionBar();
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, 'onDataSizeChanged, size is ' + size);
    if (size === 0) {
      if (this.pageFrom === Constants.ENTRY_FROM.CARD) {
        let menuContext: MenuContext = new MenuContext();
        menuContext.withJumpSourceToMain(this.jumpSourceToMain);
        let menuOperation = new GotoPhotosMenuOperation(menuContext);
        menuOperation.doAction();
      } else {
        this.onBackPress();
      }
    }
  }

  updateActionBar(): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined || this.isFromViewData) {
      Log.warn(TAG, 'currentPhoto is undefined: ' + (currentPhoto == undefined) + ' this.isFromViewData: ' + this.isFromViewData)
      return;
    }

    // PhotoItems 和 这里都会有load, 极端情况下可能产生一次无效的load
    currentPhoto.load(false).then<void, void>((): void => {
      this.photoDate = DateUtil.getLocalizedDate(currentPhoto.dateAdded);
      this.timeAndLocation = DateUtil.getLocalizedTime(currentPhoto.dateAdded);
      this.updateMenu();
    })
  }

  updateMenu(): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    this.toolMenuList = [];
    this.getActionList(currentPhoto).then<void, void>((list: Action[]): void => {
      if (this.pageFrom === Constants.ENTRY_FROM.CAMERA || this.pageFrom === Constants.ENTRY_FROM.CARD) {
        this.menuList = [Action.GOTO_PHOTOS, Action.INFO];
      } else if (this.pageFrom === Constants.ENTRY_FROM.RECYCLE) {
        this.menuList = [];
      } else {
        this.menuList = [Action.INFO];
      }
      if (this.isHorizontal) {
        this.menuList = this.menuList.concat(list);
      } else {
        this.toolMenuList = list;
      }
      this.updateMoreMenu();
    })
  }

  private async getActionList(currentPhoto: UserFileDataItem): Promise<Action[]> {
    Log.info(TAG,'this.pageFrom' + this.pageFrom)
    let list: Action[] = [];
    if (this.pageFrom === Constants.ENTRY_FROM.RECYCLE) {
      list.push(Action.RECOVER, Action.DELETE);
    } else {
      let isFavor = await currentPhoto.isFavor();
      Log.info(TAG,'isFavor' + isFavor)
      list.push(
        isFavor ? Action.FAVORITE : Action.NOT_FAVORITE,
        Action.RENAME,
        Action.DELETE,);
    }
    return list;
  }
  private currentShowChange(): void {
    this.updateMoreMenu();
  }

  private updateMoreMenu(): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    Log.info(TAG,'updateMenu')
  }
  getCurrentPhoto(): UserFileDataItem {
    return this.browserDataSource.getDataByIndex(this.currentIndex);
  }

  getPhotoByIndex(index: number): UserFileDataItem {
    return this.browserDataSource.getDataByIndex(index);
  }

  async onMoveEnd(err: object, count: number, total: number): Promise<void> {
    return await this.onMoveEndBindImpl(err, count, total)
  }

  async onMoveEndBindImpl(err: object, count: number, total: number): Promise<void> {
    Log.debug(TAG, 'onMoveEnd count: ' + count + ', total: ' + total);
    if (new Boolean(err).valueOf()) {
      getResourceString($r('app.string.move_failed_single')).then<void, void>((message: string): void => {
        showToast(message)
      })
      return;
    }
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    //currentPhoto.path = (await currentPhoto.loadFileAsset()).relativePath;
    this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  onCopyEnd(err: object, count: number, total: number): void {
    this.onCopyEndBindImpl(err, count, total)
  }

  private onCopyEndBindImpl(err: object, count: number, total: number): void {
    Log.debug(TAG, 'onCopyEnd count: ' + count + ', total: ' + total);
    this.dataSourceLoadFinish()
    if (new Boolean(err).valueOf()) {
      getResourceString($r('app.string.copy_failed_single')).then<void, void>((message: string): void => {
        showToast(message);
      })
    }
  }

  async onDownloadEnd(err: object, count: number, total: number): Promise<void> {
    return await this.onDownloadEndBindImpl(err, count, total)
  }

  async onDownloadEndBindImpl(err: object, count: number, total: number): Promise<void> {
    Log.debug(TAG, 'onDownloadEnd count: ' + count + ', total: ' + total);
    if (new Boolean(err).valueOf()) {
      getResourceString($r('app.string.download_failed_single')).then<void, void>((message: string): void => {
        showToast(message);
      })
    } else {
      getResourceString($r('app.string.download_progress_done')).then<void, void>((message: string): void => {
        showToast(message);
      })
    }
  }

  onBackPress(): boolean {
    Log.info(TAG, 'onBackPress');
    this.controller.finishAnimation((): void => this.onBackPressInnerBindImpl());
    return true;
  }

  onBackPressInner(): void {
    this.onBackPressInnerBindImpl()
  }

  private onBackPressInnerBindImpl(): void {
    Log.info(TAG, 'onBackPressInner ' + this.checkedTransition);
    if (this.checkedTransition === Constants.PHOTO_TRANSITION_TIMELINE) {
      Log.info(TAG, 'onBackPress TimelinePage');
      this.TimelinePageIndex = this.currentIndex; // call scrollTo
    } else if (this.checkedTransition === Constants.PHOTO_TRANSITION_ALBUM) {
      Log.info(TAG, 'onBackPress PhotoGridPage');
      this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
    } else if (this.checkedTransition === Constants.PHOTO_TRANSITION_CAMERA) {
      Log.info(TAG, 'onBackPress Camera');
      if (this.pageFrom === Constants.ENTRY_FROM.CARD && !this.pullDownFlag) {
        this.routerGridPaged();
      } else {
        if (this.pullDownFlag) {
          this.pullDownFlag = false;
        }
        // Entering from the camera does not need to return to close directly
        terminateSelf();
      }
      return;
    }
    router.back({
      params: {
        index: this.currentIndex
      }
    });
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    screenManager.setNavigationBarColor('#00FFFFFF', '#FF000000');
    if (!this.isShowBar) {
      screenManager.setSystemUi(true);
    }
    // Click the thumbnail quickly, hasAppeared is false if it is not the first click. Return directly
    if (!this.hasAppeared) {
      return;
    }
    userFileObserver.unregisterObserver(this.dataObserver);
    mMultimodalInputManager.unregisterListener();
  }

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    AppStorage.SetOrCreate<number>('isDelete', 0);
    AppStorage.SetOrCreate<number>('isLeftSwiper', 0);
    screenManager.setNavigationBarColor('#FFF1F3F5', '#FF000000');
    this.hasAppeared = true;
    mMultimodalInputManager.registerListener((control: number): void => {
      Log.info(TAG, 'key control: ' + control + ' index ' + this.currentIndex);
      if (control === 0) {
        if (this.currentIndex > 0) {
          this.onPhotoChanged(this.currentIndex - 1);
        }
      } else if (control === 1) {
        if (this.currentIndex < this.browserDataSource.totalCount() - 1) {
          this.onPhotoChanged(this.currentIndex + 1);
        }
      } else {
        this.onBackPress();
      }
    });
    let param: ParamsInterface = router.getParams();
    if (param != null) {
      Log.info(TAG, 'photoBrowser start with param');
      Log.debug(TAG, 'param: ' + JSON.stringify(param));
      if (param.pageFrom != null) {
        this.pageFrom = Number(param.pageFrom.toString());
      }
      if (this.pageFrom === Constants.ENTRY_FROM.CAMERA) {
        this.isFromCamera = true;
        this.albumInfo = new SimpleAlbumDataItem(MediaConstants.ALBUM_ID_CAMERA, '', '', '', '',-1,-1)
        this.browserDataSource.setAlbumId(this.albumInfo.id)
        this.browserDataSource.setAlbumType(this.albumInfo.albumType)
        this.browserDataSource.setAlbumSubtype(this.albumInfo.albumSubType)
        this.browserDataSource.setAlbumName(this.albumInfo.displayName)
        this.jumpSourceToMain = JumpSourceToMain.CAMERA;
      } else if (this.pageFrom === Constants.ENTRY_FROM.VIEW_DATA) {
        this.isFromViewData = true;
      }

      if (param.albumInfo != null) {
        this.albumInfo = param.albumInfo as SimpleAlbumDataItem;
        this.deviceName = this.albumInfo.deviceName;
        this.browserDataSource.setAlbumId(this.albumInfo.id)
        this.browserDataSource.setDeviceId(this.albumInfo.deviceId);
        this.browserDataSource.setAlbumType(this.albumInfo.albumType)
        this.browserDataSource.setAlbumSubtype(this.albumInfo.albumSubType)
        this.browserDataSource.setAlbumName(this.albumInfo.displayName)
      }

      let items: UserFileDataItem[] | undefined;
      if (param.viewData != null) {
        items = []
        let uriArr: string[] = String(param.viewData).split(',');
        for (let i = 0;i < uriArr.length; i++) {
          items.push(new InnerUserFileDataItem(uriArr[i], i));
        }
      } else {
        items = AppStorage.Get<UserFileDataItem[]>(Constants.APP_KEY_PHOTO_BROWSER);
      }

      if ((items != null && items != undefined) && !this.isFromCamera) {
        this.browserDataSource.groupDataItem = items;
        if (!Number.isNaN(param.position)) {
          this.onPhotoChanged(new Number(param.position).valueOf());
        } else {
          this.onPhotoChanged(0);
        }
      } else {
        this.browserDataSource.reloadGroupItemData(false).then<void, void>((isEmpty: boolean): void => {
          this.onPhotoChanged(0);
          this.browserDataSource.notifyDataReload();
        })
      }
      let transition: string = '';
      if(param.transition != null) {
        transition = param.transition.toString();
      }
      this.photoBrowserTransition = (this.isFromCamera || this.isFromViewData)
        ? Constants.PHOTO_TRANSITION_CAMERA : transition;
    } else {
      Log.info(TAG, 'photoBrowser start without param');
      if (this.entryFromHap === Constants.ENTRY_FROM_FORM_ABILITY) {
        this.isFromCard = true;
        this.pageFrom = Constants.ENTRY_FROM.CARD;
        let albumId = AppStorage.Get<string>(Constants.FROM_ALBUM_ID);
        this.albumInfo = new SimpleAlbumDataItem(albumId === undefined ? '' : albumId, '', '', '', '', -1, -1);
      } else {
        this.pageFrom = Constants.ENTRY_FROM.CAMERA;
        this.albumInfo = new SimpleAlbumDataItem(MediaConstants.ALBUM_ID_CAMERA, '', '', '', '',-1,-1);
      }
      AppStorage.SetOrCreate<number>(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
      this.browserDataSource.setAlbumId(this.albumInfo.id);
      this.browserDataSource.setAlbumType(this.albumInfo.albumType)
      this.browserDataSource.setAlbumSubtype(this.albumInfo.albumSubType)
      this.browserDataSource.setAlbumName(this.albumInfo.displayName)
      this.browserDataSource.reloadGroupItemData(false).then<void, void>((isEmpty: boolean): void => {
        this.isDataChanged = isEmpty;
        if (!Number.isNaN(AppStorage.Get<number>(Constants.FROM_CURRENT_INDEX))) {
          let currentIndex = AppStorage.Get<number>(Constants.FROM_CURRENT_INDEX);
          this.onPhotoChanged(currentIndex === undefined ? 0 : currentIndex);
        } else {
          this.onPhotoChanged(0);
        }
        this.browserDataSource.notifyDataReload()
      });
      this.isFromCamera = true;
      this.jumpSourceToMain = JumpSourceToMain.CAMERA;

      this.photoBrowserTransition = Constants.PHOTO_TRANSITION_CAMERA;
    }

    userFileObserver.registerObserver(this.dataObserver);
    this.checkedTransition = this.photoBrowserTransition;


    // register event handling
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, (): void => {
      this.onToggleBars();
    });

    this.broadCast.on(PhotoConstants.HIDE_BARS, (): void => {
      this.hideBars();
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_START, (): void => {
      Log.info(TAG, 'pulling down start');
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_END, (): void => {
      this.pullDownFlag = true;
      this.onBackPress();
    });

    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number): void => {
      this.onDataSizeChanged(size);
    });

    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, (): void => {
      this.onPhotoChanged(this.currentIndex);
    });

    this.broadCast.on(PhotoConstants.RENAME, (result: string[]): void => {
      Log.info(TAG, 'rename refresh: ' + result[0] + ', ' + result[1]);
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      currentPhoto.title = result[0];
      currentPhoto.displayName = result[1];
      this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_START, (event: Object): void => {
      Log.debug(TAG, 'pulling down start: ' + JSON.stringify(event));
      this.isPullingDown = true;
    })

    this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, (): void => {
      Log.info(TAG, 'pulling down cancel');
      this.isPullingDown = false;
    })

    this.broadCast.on(PhotoConstants.PHOTO_SHOW_STATE, (state: boolean): void => {
      Log.debug(TAG, 'current photo show state change');
      this.currentShow = state;
    });

    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean): void => {
      Log.info(TAG, 'set swiper swipe ' + value);
      this.canSwipe = value;
    });
  }

  private async dataSourceLoadFinish(): Promise<void> {
    await this.browserDataSource.reloadGroupItemData(false);
    if (this.browserDataSource.groupDataItem !== undefined) {
      for (let i = 0;i < this.browserDataSource.groupDataItem.length; i++) {
        await this.browserDataSource.groupDataItem[i].load(false);
      }
    }
    this.onPhotoChanged(this.currentIndex);
    this.browserDataSource.notifyDataChange(this.currentIndex);
    if (this.isToEdit) {
      this.isToEdit = false;
      this.appBroadcast.emit(BroadcastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
    }
  }

  onPageShow(): void {
    this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    this.broadCast.emit(BroadcastConstants.CHANGE_SWIPER_DURATION, [400]);
    let params = router.getParams();
    if (params != null && params.pageType != null && this.backFromCopy) {
      Log.debug(TAG, 'MediaOperation back ' + JSON.stringify(params))
      let menuContext = new MenuContext();
      let menuOperation: MenuOperation | undefined = undefined;
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'MediaOperation currentPhoto is undefined');
        return;
      }
      let albumInfo: string = '';
      if(params.albumInfo != null) {
        albumInfo = params.albumInfo.toString();
      }
      if (params.pageType === MediaOperationType.Move) {
        menuContext.withItems([currentPhoto])
          .withBroadCast(this.broadCast)
          .withAlbumInfo(JSON.parse(albumInfo) as SimpleAlbumDataItem)
          .withOperationEndCallback(this.onMoveEnd);
        menuOperation = new MoveMenuOperation(menuContext);
      }

      if(menuOperation !== undefined){
        menuOperation.doAction();
      }
    }
    this.backFromCopy = false;
  }

  onPageHide(): void {
    this.showBars();
  }

  onUserFileDataChange(changeType: string): void {
    Log.info(TAG, 'onUserFileDataChange type: ' + changeType);
    this.dataSourceLoadFinish();
  }

  async routerGridPaged(): Promise<void> {
    AppStorage.SetOrCreate<boolean>(Constants.BACK_FROM_FORM_DETAIL, true);
    let displayName = await getAlbumDisplayName(MediaConstants.ALBUM_ID_CAMERA)
    let item: SimpleAlbumDataItem = new SimpleAlbumDataItem(MediaConstants.ALBUM_ID_CAMERA, displayName, '', '', '',-1,-1)
    Log.info(TAG, 'item.displayName: ' + item.displayName + ' item ' + JSON.stringify(item));
    router.replace({
      uri: 'pages/PhotoGridPage',
      params: {
        item: JSON.stringify(item)
      }
    });
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserBg()
      if (!this.isDataChanged || !this.isFromCard === true) {
        PhotoSwiper({
          dataSource: this.browserDataSource,
          photoSwiperTransition: this.photoBrowserTransition,
          swiperController: this.controller,
          onPhotoChanged: (index: number): void => this.onPhotoChangedBindImpl(index)
        })
      }
      if (!this.isFromViewData) {
        if (this.isShowBar) {
          PhotoBrowserActionBar({
            onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          })
          ToolBar({
            toolMenuList: $toolMenuList,
            onMenuClicked: (action: Action): void => this.onMenuClicked(action),
            isFromPhotoBrowser: true
          })
        }
        CustomDialogView()
      } else {
        Column() {
          if (this.isShowBar) {
            PhotoBrowserActionBar({
              onMenuClicked: (action: Action): void => { this.onMenuClicked(action) }
            })
          }
        Text('' + (this.currentIndex + 1) + '/' + this.browserDataSource.totalCount())
            .height($r('app.float.menu_height'))
            .fontColor($r('app.color.text_color_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .markAnchor({ x: '0%', y: '0%' })
            .position({
              x: '0%',
              y: screenManager.getStatusBarHeight() + Constants.ActionBarHeight
            })
        }.alignItems(HorizontalAlign.Start)
      }
    }
  }

  pageTransition(): void {
    PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }
}
