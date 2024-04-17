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
import { DateUtil } from '../utils/DateUtil';
import { Log } from '../utils/Log';
import { Action } from '../models/Action'
import { MenuOperation } from '../menus/MenuOperation';
import { PhotoBrowserActionBar } from '../components/PhotoBrowserActionBar';
import { Broadcast } from '../common/Broadcast';
import { screenManager } from '../common/ScreenManager';
import { broadcastManager } from '../common/BroadcastManager';
import { BroadcastConstants } from '../constants/BroadcastConstants';

@Entry
@Component
struct VideoBrowser {
  private TAG: string = 'VideoBrowser';
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Provide isShowBar: boolean = false;
  @Provide menuList: Action[] = [];
  @Provide moreMenuList: Action[] = [];
  private broadCast: Broadcast = new Broadcast();
  private myVideoController: VideoController = new VideoController();
  private uri: string = '';
  private dateAdded: number = 0;
  private previewUri: object | null = null;

  onBackPress(): boolean {
    Log.info(this.TAG, 'onBackPress');
    router.back();
    return true;
  }

  private onMenuClicked(action: Action): void {
    this.onMenuClickedBindImpl(action)
  }

  private onMenuClickedBindImpl(action: Action): void {
    Log.info(this.TAG, 'onMenuClicked, action: ' + action.actionID);
    if (action === Action.BACK) {
      this.onBackPress();
      return;
    }
  }

  aboutToAppear(): void {
    let param: ParamsInterface = router.getParams();
    if(param.uri != null ) this.uri = param.uri.toString();
    this.dateAdded = 0;
    if (!Number.isNaN(param.dateAdded)) {
      this.dateAdded = new Number(param.dateAdded).valueOf()
    }
    this.previewUri = param.previewUri;
    if (this.uri == undefined) {
      return;
    }
    Log.info(this.TAG, 'uri is ' + this.uri);
    this.photoDate = DateUtil.getLocalizedDate(this.dateAdded);
    this.timeAndLocation = DateUtil.getLocalizedTime(this.dateAdded);
    screenManager.setSystemUi(false);
  }

  aboutToDisappear(): void {
    this.myVideoController.stop();
    screenManager.setSystemUi(true);
  }

  onPageShow(): void {
    this.photoDate = DateUtil.getLocalizedDate(this.dateAdded);
    this.timeAndLocation = DateUtil.getLocalizedTime(this.dateAdded);
    broadcastManager.getBroadcast().emit(BroadcastConstants.THIRD_ROUTE_PAGE, []);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Video({ src: this.uri, controller: this.myVideoController })
        .controls(this.isShowBar)
        .objectFit(ImageFit.Contain)
        .onClick((): void => {
          this.isShowBar = !this.isShowBar;
        })
        .onStart((): void => {
          screenManager.setKeepScreenOn();
        })
        .onPause((): void => {
        })
        .onFinish((): void => {
          this.isShowBar = true;
          screenManager.setKeepScreenOff();
        })
        .autoPlay(true)

      PhotoBrowserActionBar({
        onMenuClicked: (action: Action): void => this.onMenuClicked(action), isVideoPage: true
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.black'))
  }

  pageTransition(): void {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
      .opacity(0)
    PageTransitionExit({ type: RouteType.None, duration: 0 })
      .opacity(0)
  }
}

