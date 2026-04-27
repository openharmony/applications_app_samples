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

// 输入源插拔信息
@Observed
export class SourcePlugStateEntity {
  // 输入源id
  private _sourceId: number = 0;
  // 插拔状态
  private _isPlugIn: boolean = false;
  // 展示顺序
  private _displayOrder: number = 0;
  // 输入源名称
  private _sourceName: string = '';

  constructor(sourceId: number, isPlugIn: boolean, displayOrder: number, sourceName: string) {
    this._sourceId = sourceId;
    this._isPlugIn = isPlugIn;
    this._displayOrder = displayOrder;
    this._sourceName = sourceName;
  }

  public setSourceId(value: number) {
    this._sourceId = value;
  }

  public getSourceId(): number {
    return this._sourceId;
  }

  public setIsPlugIn(value: boolean) {
    this._isPlugIn = value;
  }

  public getIsPlugIn(): boolean {
    return this._isPlugIn;
  }

  public setDisplayOrder(value: number) {
    this._displayOrder = value;
  }

  public getDisplayOrder(): number {
    return this._displayOrder;
  }

  public setSourceName(value: string) {
    this._sourceName = value;
  }

  public getSourceName(): string {
    return this._sourceName;
  }
}
