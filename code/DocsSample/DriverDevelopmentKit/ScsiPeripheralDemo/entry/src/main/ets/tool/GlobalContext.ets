/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

const TAG = 'GlobalContext';

export default class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();
  private isDebug: boolean = false;

  public static getContext(): GlobalContext {
    if (GlobalContext.instance == null){
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  public getObject(key: string): Object | undefined{
    let result = this._objects.get(key);
    this.printLog('getObject: ' + key + ' -> ' + (result != null));
    return result;
  }

  public hasObject(key: string): boolean {
    return this._objects.has(key);
  }

  public setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
    this.printLog('setObject: ' + key);
  }

  public printLog(message: string): void {
    if(!this.isDebug){
      return;
    }
    console.info(TAG, message);
  }
}