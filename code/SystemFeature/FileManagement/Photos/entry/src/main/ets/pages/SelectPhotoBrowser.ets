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
import { Action } from '../models/Action';
import { Constants } from '../constants/Constants';
import { RouterConstants } from '../constants/RouterConstants';
import { PhotoBrowserBg } from '../components/PhotoBrowserBg';
import { Constants as PhotoConstants } from '../constants/BrowserConstants';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { broadcastManager } from '../common/BroadcastManager';
import { PhotoSwiper } from '../components/PhotoSwiper';
import { mMultimodalInputManager } from '../common/MultimodalInputManager';
import { screenManager } from '../common/ScreenManager';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { GroupItemDataSource } from '../common/GroupItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { terminateSelfWithResult } from '../utils/AbilityUtils';
import Want from '@ohos.app.ability.Want'
import common from '@ohos.app.ability.common'

const TAG = 'SelectPhotoBrowser';

// select mode
@Entry
@Component
struct SelectPhotoBrowser {
  @Provide browserBackgroundColor: Resource = $r('app.color.default_background_color');
  @Provide('selectedCount') totalSelectedCount: number = 0;
  @Provide broadCast: Broadcast = new Broadcast();
  @Provide isSelected: boolean = true;
  @Provide isShowBar: boolean = true;
  @Provide isPullingDown: boolean = false;
  @Provide moreMenuList: Action[] = [];
  @Provide pageFrom: number = RouterConstants.ENTRY_FROM.NORMAL;
  @Provide canSwipe: boolean = true;
  isMultiPick = true;
  selectPhotoTransition: string = '';
  controller: SwiperController = new SwiperController();
  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') currentIndex: number = 0;
  // The global Broadcast of the application process. Event registration and destruction should be paired
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  private browserDataSource: GroupItemDataSource = new GroupItemDataSource();

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    screenManager.setNavigationBarColor('#FFF1F3F5', '#FF000000');
    this.browserBackgroundColor = $r('app.color.black');
    mMultimodalInputManager.registerListener((control: number): void => {
      Log.info(TAG, 'key control : ' + control + ' index ' + this.currentIndex);
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
    if (param.pageFrom != null) {
      this.pageFrom = 0
      if (!Number.isNaN(param.pageFrom)) {
        this.pageFrom = new Number(param.pageFrom).valueOf();
      }
    }
    if (this.isMultiPick === true) {
      this.totalSelectedCount = this.browserDataSource.getSelectedCount();
    }
    if (param.albumInfo != null) {
      this.browserDataSource.setAlbumId((param.albumInfo as SimpleAlbumDataItem).id);
      this.browserDataSource.setAlbumType((param.albumInfo as SimpleAlbumDataItem).albumType)
      this.browserDataSource.setAlbumSubtype((param.albumInfo as SimpleAlbumDataItem).albumSubType)
      this.browserDataSource.setAlbumName((param.albumInfo as SimpleAlbumDataItem).displayName)
    }

    let items: UserFileDataItem[] | undefined = AppStorage.Get<UserFileDataItem[]>(Constants.APP_KEY_PHOTO_BROWSER);
    if (items !== undefined) {
      this.browserDataSource.groupDataItem = items;
    }

    let pos = 0;
    if (!Number.isNaN(param.position)) {
      pos = new Number(param.position).valueOf()
    }
    this.onPhotoChanged(pos);
    this.isSelected = this.getCurrentPhoto().isSelect;
    this.totalSelectedCount = this.browserDataSource.getSelectedCount();
    if (param.transition != null) {
      this.selectPhotoTransition = param.transition.toString();
    } else {
      this.selectPhotoTransition = '';
    }
    // register event handling
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, (event: Object): void => {
      Log.info(TAG, 'TOGGLE_BAR : ' + JSON.stringify(event));
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_END, (event: Object): void => {
      Log.info(TAG, 'PULL_DOWN_END : ' + JSON.stringify(event));
      this.onBackPress();
    });

    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number): void => {
      this.onDataSizeChanged(size);
    });

    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, (size: number): void => {
      // onContentChanged only the current item is updated
      Log.info(TAG, 'DATA_CONTENT_CHANGED : ' + size);
      this.onPhotoChanged(this.currentIndex);
    });

    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean): void => {
      Log.info(TAG, 'set swiper swipe ' + value);
      this.canSwipe = value;
    });
  }

  aboutToDisappear(): void {
    screenManager.setNavigationBarColor('#00FFFFFF', '#FF000000');
    this.broadCast.release();
    mMultimodalInputManager.unregisterListener();
  }

  onToggleBars(): void {
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, 'onDataSizeChanged, size is ' + size);
    if (size === 0) {
      this.onBackPress();
    }
  }

  onPhotoChanged(index: number): void {
    this.onPhotoChangedBindImpl(index)
  }

  private onPhotoChangedBindImpl(index: number): void {
    this.currentIndex = index;
    this.isSelected = this.getCurrentPhoto().isSelect;
    this.browserDataSource.notifyDataChange(index);
  }

  private selectStateChange(): void {
    Log.info(TAG, 'change selected');
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    currentPhoto.setSelect(!currentPhoto.isSelect);
    this.isSelected = currentPhoto.isSelect;
    this.totalSelectedCount = this.browserDataSource.getSelectedCount();
    this.appBroadcast.emit(BroadcastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    Log.info(TAG, 'totalSelectedCount: ' + this.totalSelectedCount + ' after state change');
  }

  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
  }

  onPageHide(): void {
    Log.info(TAG, 'onPageHide');
  }

  onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.debug(TAG, 'onMenuClicked, action: ' + action.actionID);
    if (action === Action.BACK) {
      this.onBackPress();
    } else if (action === Action.MATERIAL_SELECT || action === Action.SELECTED) {
      this.selectStateChange();
      return;
    } else if (action === Action.OK) {
      Log.info(TAG, 'click OK');
      this.setPickResult();
    }
  }

  getCurrentPhoto(): UserFileDataItem {
    if (this.browserDataSource.groupDataItem !== undefined) {
      return this.browserDataSource.groupDataItem[this.currentIndex];
    } else {
      return new UserFileDataItem('', [], '', 0);
    }
  }

  onBackPress(): boolean {
    Log.info(TAG, 'onBackPress');
    router.back({ params: { index: this.currentIndex } });
    return true;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserBg()
      PhotoSwiper({
        dataSource: this.browserDataSource,
        photoSwiperTransition: this.selectPhotoTransition,
        onPhotoChanged: (index: number): void => this.onPhotoChanged(index),
        swiperController: this.controller
      })
    }
  }

  private setPickResult(): void {
    let uriArray: string[];
    if (this.isMultiPick) {
      uriArray = this.browserDataSource.getSelectedUris();
      Log.debug(TAG, 'uri size: ' + uriArray);
    } else {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      uriArray = [currentPhoto.uri];
    }
    let param1: Map<string, string[]> = new Map<string, string[]>();
    param1.set('select-item-list', uriArray);

    let abilityResult: common.AbilityResult = {
      resultCode: 0,
      want: {
        parameters: { 'select-item-list': uriArray }
      } as Want
    };
    terminateSelfWithResult(abilityResult);
  }

  pageTransition(): void {
    PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }
}
