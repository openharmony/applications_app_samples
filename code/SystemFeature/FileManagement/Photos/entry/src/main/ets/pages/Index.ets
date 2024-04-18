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

import { AlbumSetPage } from '../components/AlbumSetPage';
import { Log } from '../utils/Log';
import { JumpSourceToMain } from '../models/JumpSourceToMain';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { broadcastManager } from '../common/BroadcastManager';
import { Constants } from '../constants/Constants';
import router, { ParamsInterface } from '@system.router';
import app from '@system.app';

@Entry
@Component
struct Index {
  private TAG: string = 'IndexPage';
  private preIndex: number = Constants.TIMELINE_PAGE_INDEX;
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Provide isShow: boolean = false;
  @Provide isSelectedMode: boolean = false;
  private currentIndex: number = this.preIndex;

  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  private jumpSource: number = 0;
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  @StorageLink('permissionStatus') @Watch('onUpdate') permission: boolean = false;
  @State isUpdate: boolean = false;

  onUpdate(): void {
    this.isUpdate = !this.isUpdate;
  }

  aboutToAppear(): void {
    app.setImageCacheCount(100);
    app.setImageRawDataCacheSize(100 * 1024 * 1024);
    if (AppStorage.Get<boolean>(Constants.BACK_FROM_FORM_DETAIL) != null) {
      AppStorage.SetOrCreate<boolean>(Constants.BACK_FROM_FORM_DETAIL, false);
      this.currentIndex = Constants.ALBUM_PAGE_INDEX;
    }
    let param: ParamsInterface = router.getParams();
    Log.info(this.TAG, 'param: ' + JSON.stringify(param));
    if (param != null) {
      if (param.jumpSource != undefined && param.jumpSource != null && !Number.isNaN(param.jumpSource)) {
        this.jumpSource = new Number(param.jumpSource).valueOf()
      } else {
        this.jumpSource = 0
      }
      if (this.jumpSource === JumpSourceToMain.CAMERA) {
        this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
        this.entryFromHap = Constants.ENTRY_FROM_NONE;
        Log.info(this.TAG, 'Camera in, switch to Tab ' + this.currentIndex + '.');
      }
    }
  }

  onPageShow(): void {
    Log.debug(this.TAG, 'IndexPage.onPageShow entryFromHap: ' + this.entryFromHap);
    this.appBroadcast.emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
    Log.info(this.TAG, 'IndexPage.onPageShow: router.clear ' + this.jumpSource);
    if (this.jumpSource === JumpSourceToMain.CAMERA) {
      router.clear();
    } else if (this.jumpSource === JumpSourceToMain.ALBUM) {
      router.clear();
    }
  }

  onPageHide(): void {
    this.isShow = false;
  }

  onBackPress(): boolean {
    let isProcessed = false;
    let func = (isModeChanged: boolean): void => {
      isProcessed = isModeChanged;
    }
    this.appBroadcast.emit(BroadcastConstants.BACK_PRESS_EVENT, [func]);
    return isProcessed;
  }

  build() {
    Row() {
      AlbumSetPage()
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