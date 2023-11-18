/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import type image from '@ohos.multimedia.image';

export class PixelMapWrapper {
  pixelMap: image.PixelMap = undefined;
  width: number = 0;
  height: number = 0;

  constructor(pixelMap: image.PixelMap, width: number, height: number) {
    this.pixelMap = pixelMap;
    this.width = width;
    this.height = height;
  }

  release(): void {
    if (this.pixelMap !== null && this.pixelMap !== undefined) {
      this.pixelMap.release();
    }
    this.pixelMap = undefined;
    this.width = 0;
    this.height = 0;
  }
}

export class Size {
  width: number = 0
  height: number = 0
}

export enum CircleAngle {
  ONE_QUARTER_CIRCLE_ANGLE = 90,
  HALF_CIRCLE_ANGEL = 180,
  THREE_QUARTER_CIRCLE_ANGLE = 270,
  CIRCLE_ANGLE = 360
}

export class GlobalContext {
  private constructor() {};
  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    return this._objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }
}