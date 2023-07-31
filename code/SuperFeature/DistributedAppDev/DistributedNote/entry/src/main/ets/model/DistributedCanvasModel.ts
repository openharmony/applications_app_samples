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

import distributedObject from '@ohos.data.distributedDataObject';
import Logger from './Logger';

const TAG: string = 'Sample_DistributedCanvasModel';

export default class DistributedCanvasModel {
  public distributedCanvas;
  public changeCallback?: () => void;
  public statusCallback?: (sessionId: string, networkId: string, status: 'online' | 'offline') => void;

  constructor() {
    this.distributedCanvas = distributedObject.createDistributedObject({
      pathArray: [],
    });
  }

  isContainString(path: string): number {
    return JSON.stringify(this.distributedCanvas.pathArray).indexOf(path);
  }

  genSessionId(): string {
    return distributedObject.genSessionId();
  }

  setChangeCallback(changeCallback: () => void): void {
    if (this.changeCallback === changeCallback) {
      Logger.info(TAG, 'same callback');
      return;
    }
    Logger.info(TAG, 'start off');
    if (this.changeCallback !== undefined) {
      this.distributedCanvas.off('change', this.changeCallback);
    }
    this.changeCallback = changeCallback;
    Logger.info(TAG, 'start watch change');
    this.distributedCanvas.on('change', this.changeCallback);
  }

  setStatusCallback(callback: (sessionId: string, networkId: string, status: 'online' | 'offline') => void): void {
    if (this.statusCallback === callback) {
      Logger.info(TAG, 'same callback');
      return;
    }
    Logger.info(TAG, 'start off');
    if (this.statusCallback !== undefined) {
      this.distributedCanvas.off('status', this.statusCallback);
    }
    this.statusCallback = callback;
    Logger.info(TAG, 'start watch change');
    this.distributedCanvas.on('status', this.statusCallback);
  }

  add(path: string): void {
    this.distributedCanvas.pathArray = [...this.distributedCanvas.pathArray,
      {
        path
      }];
  }

  clear(): void {
    Logger.info(TAG, 'doClear');
    this.distributedCanvas.pathArray = [];
    Logger.info(TAG, 'doClear finish');
  }

  off(): void {
    this.distributedCanvas.off('change');
    this.changeCallback = undefined;
    this.distributedCanvas.off('status');
    this.statusCallback = undefined;
  }
}
