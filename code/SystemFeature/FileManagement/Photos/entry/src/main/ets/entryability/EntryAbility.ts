/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import deviceInfo from '@ohos.deviceInfo';
import Ability from '@ohos.app.ability.UIAbility';
import wantConstant from '@ohos.ability.wantConstant';
import { Log } from '../utils/Log';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';
import { broadcastManager } from '../common/BroadcastManager';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { userFileModel } from '../base/UserFileModel';
import router from '@system.router';
import { RouterOptions } from '@system.router';
import { GroupItemDataSource } from '../common/GroupItemDataSource';
import atManager from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import { MediaConstants } from '../constants/MediaConstants';
import { getResourceString } from '../utils/ResourceUtils';
import { GlobalContext } from '../common/GlobalContext';
import Want from '@ohos.app.ability.Want';

let mCallerUid: number = 0;
let mMaxSelectCount: number = 0;
let mFilterMediaType: number = MediaConstants.SELECT_TYPE_ALL;
let appBroadcast = broadcastManager.getBroadcast();
let pagePath: string = 'pages/Index';

export default class EntryAbility extends UIAbility {
  private TAG: string = 'EntryAbility';
  private static readonly RETRY_MAX_TIMES = 100;
  private static readonly ACTION_URI_SINGLE_SELECT = 'singleselect';
  private static readonly ACTION_URI_MULTIPLE_SELECT = 'multipleselect';
  private static readonly ACTION_URI_PHOTO_DETAIL = 'photodetail';
  private browserDataSource: GroupItemDataSource = new GroupItemDataSource();

  onCreate(want: Want, launchParam): void {
    Log.info(this.TAG, 'Application onCreate');
    // Ability is creating, initialize resources for this ability
    GlobalContext.getContext().setObject('appContext', this.context);
    userFileModel.onCreate(this.context);
    mFilterMediaType = MediaConstants.SELECT_TYPE_ALL;
    AppStorage.SetOrCreate<number>(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
    Log.info(this.TAG, 'Application onCreate end');
  }

  onNewWant(want: Want): void {
    AppStorage.SetOrCreate<number>(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
  }

  onDestroy(): void {
    // Ability is creating, release resources for this ability
    Log.info(this.TAG, 'Application onDestroy');
    AppStorage.Delete(Constants.ENTRY_FROM_HAP);
  }

  onWindowStageCreate(windowStage): void {
    // Main window is created, set main page for this ability
    Log.info(this.TAG, 'Application onWindowStageCreate');
    GlobalContext.getContext().setObject('photosWindowStage', windowStage);
    windowStage.getMainWindow().then((win: window.Window): void => {
      AppStorage.SetOrCreate<window.Window>(Constants.MAIN_WINDOW, win);
      screenManager.initializationSize(win).then<void, void>((): void => {
        windowStage.setUIContent(this.context, pagePath, null);
      }).catch<void>((): void => {
        Log.error(this.TAG, 'get device screen info failed.');
      });
    });
  }

  onWindowStageDestroy(): void {
  }

  onForeground(): void {
  }

  onBackground(): void {
  }
}
