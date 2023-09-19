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

import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { AsyncCallback } from './AsyncCallback';
import { Log } from '../utils/Log';
import { MenuOperationCallback } from './MenuOperationCallback';
import { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { userFileModel } from '../base/UserFileModel';

export enum FindSameOperation {
  NONE,
  REPLACE,
  SKIP
}

export interface Assets {
  sourceAsset: photoAccessHelper.PhotoAsset,
  targetAsset: photoAccessHelper.PhotoAsset
}

const TAG = 'ProcessMenuOperation';

export class ProcessMenuOperation implements MenuOperation, AsyncCallback<String[]>, MenuOperationCallback {
  // Number of data operated in a batch
  readonly BATCH_SIZE: number = 1;

  // Maximum progress
  readonly MAX_PROGRESS: number = 100;
  items: Object[] = [];
  menuContext: MenuContext;
  uris: string[];
  count: number;
  onOperationEnd: Function;

  // Total batches operated
  totalBatches: number;

  // Currently operated batch
  currentBatch: number = 0;
  successBatch: number = 0;
  isCancelled: boolean = false;
  startTime: number;
  isPause: boolean = false;
  isError: boolean = false;
  findSameOperation: number = FindSameOperation.NONE;
  requestTime: number;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
    this.requestTime = Date.now();
  }

  doAction(): void {
  }

  // Asynchronous callback for getSelection
  callback(uris: string[]): void {
    this.callbackBindImpl(uris);
  }

  protected callbackBindImpl(uris: string[]): void {
  }

  onCompleted(): void {
    Log.info(TAG, 'onCompleted ' + this.isPause);
    this.successBatch++;
    if (!this.isPause) {
      this.cyclicOperation();
    }
  }

  onError(): void {
    Log.error(TAG, 'Operate the ' + this.currentBatch + ' batch data error, total ' + this.totalBatches + ' batches');
    this.isError = true;
    this.cyclicOperation();
  }

  // Start processing operation
  processOperation(): void {
    Log.info(TAG, 'processOperation start');
    let length = this.items.length;
    Log.info(TAG, 'selected count: ' + this.count + ', uris length: ' + length);
    // Batch deletion
    this.totalBatches = Math.floor(length / this.BATCH_SIZE) + (((length % this.BATCH_SIZE) ? 1 : 0) as number);
    Log.info(TAG, 'The count to be operate is ' + length + ', operate in ' + this.totalBatches + ' batches');
    if (this.isCancelled) {
      this.isCancelled = false;
    }
    this.startTime = Date.now();

    this.requestOneBatchOperation();
  }

  // Batch circular deletion
  cyclicOperation(): void {
    Log.info(TAG, 'cyclicOperation');
    this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);

    if (this.isCancelled) {
      this.onProcessDone();
    }

    if (this.currentBatch >= this.totalBatches || this.isError) {
      this.onProcessDone();
    } else {
      this.requestOneBatchOperation();
    }
  }

  // Operate a batch of data
  requestOneBatchOperation(): void {
  }

  onProcessDone(): void {
    this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [100]);
    this.findSameOperation = FindSameOperation.NONE;
    if (this.startTime != null) {
      let operateCount = this.currentBatch >= this.totalBatches ? this.count : this.currentBatch * this.BATCH_SIZE;
      let costTime = Date.now() - this.startTime;
      Log.debug(TAG, 'process data operate done, operate ' + operateCount + ' items, cost time ' + costTime +
      ' ms, average ' + (costTime / operateCount) + ' ms/item.');
    }
    this.isCancelled = false;
    if (this.onOperationEnd != null) this.onOperationEnd(this.isError, this.successBatch, this.count);
  }

  // Operate cancel callback
  onOperateCancelled(): void {
    this.onOperateCancelledBindImpl();
  }

  protected onOperateCancelledBindImpl(): void {
    Log.info(TAG, 'Operate Cancel');
    this.isCancelled = true;
    this.onProcessDone();
  }

  // Operate cancel callback
  onOperatePause(): void {
    Log.info(TAG, 'Operate Pause');
    this.isPause = true;
  }

  // Calculate the operation progress according to the batch
  getExpectProgress(): number {
    Log.info(TAG, 'getExpectProgress');
    let progress = Math.min(
      Math.floor(this.MAX_PROGRESS * this.currentBatch * this.BATCH_SIZE / this.count), this.MAX_PROGRESS);
    return progress;
  }

  setFindSameOperation(newOperation: number): void {
    this.setFindSameOperationBindImpl(newOperation);
  }

  protected setFindSameOperationBindImpl(newOperation: number): void {
    Log.info(TAG, 'setFindSameOperation ' + newOperation);
    this.findSameOperation = newOperation;
  }
}
