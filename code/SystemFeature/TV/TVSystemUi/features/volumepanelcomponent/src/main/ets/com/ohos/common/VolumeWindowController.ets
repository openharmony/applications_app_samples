/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 

import { deviceInfo } from '@kit.BasicServicesKit';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import getSingleInstance from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import Trace from '../../../../../../../../common/src/main/ets/default/Trace'
import VolumePanelService from '../model/VolumePanelService';
import { VolumeInfo } from '../common/Constants';

const TAG = 'VolumeWindowController';
const SINGLE_STANCE_KEY = 'VolumeWindowController';
const INTERVAL = 3 * 1000;

export default class VolumeWindowController {
  public mWindowHandle: any;
  public mInterval: number = INTERVAL;
  public private mLastActionTime: number;
  public private mIsWindowShown: boolean;

  static getInstance(): VolumeWindowController {
    return getSingleInstance(VolumeWindowController, SINGLE_STANCE_KEY);
  }

  constructor() {
    this.registerVolume();
  }

  registerVolume() {
    VolumePanelService.startService();
    VolumePanelService.registerListener(this);
    Log.showInfo(TAG, 'constructor done.');
  }

  setInterval(interval: number): void {
    this.mInterval = interval;
  }

  setWindowHandle(windowHandle): void {
    Log.showInfo(TAG, `setWindowHandle windowHandle:${windowHandle}`);
    this.mWindowHandle = windowHandle;
  }

  updateVolumeInfo(volumeInfo: VolumeInfo): void {
    Log.showDebug(TAG, `updateVolumeInfo, volumeInfo: ${JSON.stringify(volumeInfo)} `);
    if (volumeInfo && !volumeInfo.updateUi && !this.mIsWindowShown) {
      return;
    }
    this.setWindowState(true);
    this.mLastActionTime = (new Date()).getTime();
    setTimeout(() => {
      Log.showInfo(TAG, 'check need hide window or not.');
      if ((new Date()).getTime() - this.mLastActionTime >= this.mInterval) {
        this.setWindowState(false);
      }
    }, this.mInterval);
  }

  setWindowState(isShow: boolean): void {
    Log.showInfo(TAG, `setWindowState ${isShow}.`);
    if (isShow) {
      Trace.start(Trace.CORE_METHOD_START_VOLUMEPANEL);
    }
    if (this.mIsWindowShown == isShow) {
      Log.showInfo(TAG, `Neen't set volueme window state.`);
      return;
    }
    if (this.mWindowHandle) {
      this.mIsWindowShown = isShow;
      (isShow ? this.mWindowHandle.show() : this.mWindowHandle.hide())
        .then(() => {
          if (isShow) {
            Trace.end(Trace.CORE_METHOD_START_VOLUMEPANEL);
          }
          Log.showInfo(TAG, `updateShowStatus ${isShow}.`);
        })
        .catch((err) => Log.showError(TAG, `Can't set volueme window: ${JSON.stringify(err)}.`));
    }
  }
}
