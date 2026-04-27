/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import displaySetting from '@ohos.tvservice.displaySetting';

// 节目信息
interface TimingInfo {
  source: displaySetting.SourceType;
  width: number;
  height: number;
  frameRate: number;
  isInterlace?: boolean;
}

export class TimingInfoEntity {
  // 宽
  private _width: number = 0;
  // 高
  private _height: number = 0;
  // 帧率
  private _frameRate: number = 0;
  private _isInterlace: boolean = false;

  public setWidth(value: number) {
    this._width = value;
  }

  public getWidth(): number {
    return this._width;
  }

  public setHeight(value: number) {
    this._height = value;
  }

  public getHeight(): number {
    return this._height;
  }

  public setFrameRate(value: number) {
    this._frameRate = value;
  }

  public getFrameRate(): number {
    return this._frameRate;
  }

  public setIsInterlace(value: boolean) {
    this._isInterlace = value;
  }

  public getIsInterlace(): boolean {
    return this._isInterlace;
  }
}
