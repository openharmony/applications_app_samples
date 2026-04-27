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
 

import { display, window as windowStage } from '@kit.ArkUI';
import Log from './Log';
import { WindowType, Rect, getWindowName } from './Constants';
import getSingleInstance from './SingleInstanceHelper';

const TAG = 'TintStateManager';
const LISTENER_SYSTEM_BAR_TINT_CHANGE = 'systemBarTintChange';

export interface TintStateListener { onTintStateChange(state: TintState): void }

export interface TintState {
  isEnable?: boolean;
  region?: Rect;
  backgroundColor?: string;
  contentColor?: string;
}

export class TintContentInfo {
  public contentColor = '#FFFFFFFF';
}

export function getOrCreateTintContentInfo(key: string): TintContentInfo {
  let storageKey = 'SystemUI_TintContentInfo_' + key;
  if (!AppStorage.has(storageKey)) {
    AppStorage.setOrCreate(storageKey, new TintContentInfo());
    Log.showInfo(TAG, `getOrCreateTintContentInfo, Create storageKey of ${storageKey}`);
  }
  return AppStorage.get(storageKey);
}

export default class TintStateManager {
  private mListeners: Map<WindowType, TintStateListener> = new Map();
  private mStates: Map<WindowType, TintState> = new Map();

  static getInstance(): TintStateManager {
    return getSingleInstance(TintStateManager, TAG);
  }

  constructor() {
    Log.showDebug(TAG, `init TintStateManager. ${LISTENER_SYSTEM_BAR_TINT_CHANGE}`);
    windowStage.on(LISTENER_SYSTEM_BAR_TINT_CHANGE, this.onSystemBarTintChange.bind(this));
  }

  registerListener(windowType: WindowType, listener: TintStateListener): void {
    let tintState = this.mStates.get(windowType);
    tintState && listener.onTintStateChange(tintState);
    let res = this.mListeners.set(windowType, listener);
    Log.showDebug(TAG, `registser listenerSize: ${res.size}`);
  }

  unregisterListener(windowType: WindowType): void {
    let res = this.mListeners.delete(windowType);
    Log.showDebug(TAG, `unregistser ${windowType}, res: ${res}`);
  }

  onSystemBarTintChange(data): Promise<void> {
    Log.showDebug(TAG, `onSystemBarTintChange, data: ${JSON.stringify(data)}`);
    if (!Array.isArray(data.regionTint)) {
      Log.showDebug(TAG, 'regionTint is not array.');
      return;
    }
    let dis = display.getDefaultDisplaySync();
    if (dis.id != data.displayId) {
      Log.showDebug(TAG, `Needn't change, displayId: ${data.displayId}`);
      return;
    }
    data.regionTint.forEach((regionTintData) => {
      Log.showDebug(TAG, `onSystemBarTintChange, type: ${getWindowName(regionTintData['type'])}`);
      let windowName = getWindowName(regionTintData['type']);
      if (!windowName) {
        return;
      }
      let tintState: TintState = {
        isEnable: regionTintData.isEnable,
        region: regionTintData.region,
        backgroundColor: regionTintData.backgroundColor,
        contentColor: regionTintData.contentColor,
      };
      Log.showDebug(TAG, `tintState: ${JSON.stringify(tintState)}`);
      this.mStates.set(windowName, tintState);
      this.mListeners.get(windowName)?.onTintStateChange(tintState);
    });
  }
}
