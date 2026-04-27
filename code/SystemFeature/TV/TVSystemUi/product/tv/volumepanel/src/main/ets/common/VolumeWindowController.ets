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
 

import { window as windowStage } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Log from '@ohos/common/src/main/ets/default/Log';
import getSingleInstance from '@ohos/common/src/main/ets/default/SingleInstanceHelper';
import Trace from '@ohos/common/src/main/ets/default/Trace'
import VolumePanelService from '../model/VolumePanelService';
import { VolumeInfo } from './Constants';

const TAG = 'VolumeWindowController';
const SINGLE_STANCE_KEY = 'VolumeWindowController';
const INTERVAL = 3 * 1000;

// VolumeWindowController 实现音量面板的自动显示/隐藏逻辑。
// 采用"操作后延时关闭"而非"固定定时器"策略，是为了应对遥控器连续长按音量键的场景：
// 每次音量变化都刷新 mLastActionTime，只有真正停止操作后才关闭面板，避免面板频繁闪烁。
export default class VolumeWindowController {
  public mWindowHandle: windowStage.Window | null = null;
  public mInterval: number = INTERVAL;
  public mLastActionTime: number = 0;
  public mIsWindowShown: boolean = false;

  static getInstance(): VolumeWindowController {
    return getSingleInstance((): VolumeWindowController => new VolumeWindowController(), SINGLE_STANCE_KEY);
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

  setWindowHandle(windowHandle: windowStage.Window): void {
    Log.showInfo(TAG, `setWindowHandle windowHandle:${windowHandle}`);
    this.mWindowHandle = windowHandle;
  }

  // 收到音量变化时不直接操作窗口，而是通过记录时间戳后交给 setTimeout 判断是否需要关闭，
  // 这样可以在多次快速调用时自然合并为一次关闭决策，减少不必要的窗口 show/hide 系统调用。
  updateVolumeInfo(volumeInfo: VolumeInfo | null): void {
    Log.showDebug(TAG, `updateVolumeInfo, volumeInfo: ${JSON.stringify(volumeInfo)} `);
    if (volumeInfo !== null && !volumeInfo.updateUi && !this.mIsWindowShown) {
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
        .catch((err: BusinessError) =>
          Log.showError(TAG, `Can't set volueme window: ${JSON.stringify(err)}.`));
    }
  }
}
