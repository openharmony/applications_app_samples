/*
* Copyright (c) 2025 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import window from '@ohos.window';
import Log from '../utils/Log';

const TAG = '[GlobalContext]';

export class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    let result = this._objects.get(value);
    Log.showInfo(TAG, ` GlobalContext.getObject(${value}) = ${JSON.stringify(result)}`);
    return result;
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }

  public setMainWindow(mWindow: window.Window): void {
    this.setObject('mWindow', mWindow);
  }

  public async setOrientation(orientation: window.Orientation, mWindow?: window.Window): Promise<void> {
    let windowInstance = mWindow ?? this.getObject('mWindow') as window.Window;
    let names: ('status' | 'navigation')[] = ['status', 'navigation'];
    if (!windowInstance) {
      throw new Error('setOrientation: No valid window instance found');
    }
    await windowInstance.setWindowSystemBarEnable(names);
    await windowInstance.setPreferredOrientation(orientation);
  }
}