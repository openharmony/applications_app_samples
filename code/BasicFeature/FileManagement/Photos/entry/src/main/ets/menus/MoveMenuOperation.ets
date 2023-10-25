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

import { userFileModel } from '../base/UserFileModel';
import { Log } from '../utils/Log';
import { MenuContext } from './MenuContext';
import { ProcessMenuOperation, FindSameOperation } from './ProcessMenuOperation';
import { MediaOperationType } from '../models/MediaOperationType';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { ItemDataSource } from '../common/ItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';

const TAG = 'MoveMenuOperation';

export class MoveMenuOperation extends ProcessMenuOperation {
  albumInfo: SimpleAlbumDataItem;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.albumInfo = menuContext.albumInfo;
  }

  doAction(): void {
    Log.info(TAG, 'move doAction');
    if (this.menuContext == null) {
      Log.warn(TAG, 'menuContext is null, return');
      return;
    }

    let dataSource: ItemDataSource = this.menuContext.dataSource;
    if (dataSource == null) {
      this.count = this.menuContext.items.length;
    } else {
      this.count = dataSource.getSelectedCount();
    }
    if (this.count <= 0) {
      Log.warn(TAG, 'count <= 0, return');
      return;
    }

    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart = this.menuContext.onOperationStart;

    if (onOperationStart != null) onOperationStart();

    this.menuContext.broadCast.emit(
      BroadcastConstants.SHOW_PROGRESS_DIALOG, [$r('app.string.move_progress_message', this.albumInfo.displayName),
    MediaOperationType.Move, (): void => this.cancelFuncBindImpl()]);

    if (dataSource == null) {
      this.items = this.menuContext.items;
    } else {
      this.items = dataSource.getSelectedItems();
    }
    this.processOperation();
  }

  requestOneBatchOperation(): void {
    let item = this.items[this.currentBatch] as UserFileDataItem;
    if (item != null) {
      item.addToAlbum(this.albumInfo.uri).then<void, void>((): void => {
        this.currentBatch++;
        this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);
        this.cyclicOperation();
      })
    }
  }

  cancelFunc(): void {
    this.cancelFuncBindImpl();
  }

  private cancelFuncBindImpl(): void {
    Log.info(TAG, 'progress cancel');
    this.onOperatePause();
    let cancelMessage = $r('app.string.move_cancel_message', this.getExpectProgress().toString());
    if (this.menuContext.broadCast != null) {
      this.menuContext.broadCast.emit(BroadcastConstants.CANCEL_OPERATE,
        [cancelMessage, (): void => this.onOperateContinueBindImpl(), (): void => this.onOperateCancelledBindImpl()]);
    }
  }

  // Move cancel callback
  onOperateContinue(): void {
    this.onOperateContinueBindImpl();
  }

  private onOperateContinueBindImpl(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }
}
