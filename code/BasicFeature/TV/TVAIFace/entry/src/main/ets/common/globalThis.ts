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

import { common } from '@kit.AbilityKit';

export class globalThis {
  private constructor() {

  }

  private cameraSettingContext: common.UIAbilityContext;
  private static instance: globalThis;
  private _objects = new Map<string, Object>();

  public static get(): globalThis {
    if (!Boolean(globalThis.instance).valueOf()) {
      globalThis.instance = new globalThis();
    }
    return globalThis.instance;
  }

  getObject(value: string): Object {
    return this._objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }

  apply(value: string): void {
    const func = this._objects.get(value);
    if (func) {
      (func as Function)();
    }
  }

  apply1(value: string, value2: number | string) {
    const func = this._objects.get(value);
    if (func) {
      return (func as Function)(value2);
    }
  }

  public getCameraSettingContext(): common.UIAbilityContext {
    return this.cameraSettingContext;
  }

  public setCameraSettingContext(context: common.UIAbilityContext): void {
    this.cameraSettingContext = context;
  }
}