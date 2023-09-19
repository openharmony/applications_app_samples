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

import { TrashUserFileDataItem } from '../base/TrashUserFileDataItem';
import { Log } from '../utils/Log';
import { ItemDataSource } from '../common/ItemDataSource';
import { MenuContext } from './MenuContext'
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { BroadcastConstants } from '../constants/BroadcastConstants';

const TAG = 'BatchRecoverMenuOperation';

export class BatchRecoverMenuOperation extends ProcessMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  doAction(): void {
    Log.info(TAG, 'delete doAction');
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

    this.menuContext.broadCast.emit(BroadcastConstants.DELETE_PROGRESS_DIALOG,
      [$r('app.string.action_recover'), this.count]);

    if (dataSource == null) {
      this.items = this.menuContext.items;
    } else {
      this.items = dataSource.getSelectedItems();
    }
    this.processOperation();
  }

  // Delete a batch of data
  requestOneBatchOperation(): void {
    let item = this.items[this.currentBatch] as TrashUserFileDataItem;
    item.onRecover().then<void, void>((): void => {
      this.currentBatch++;
      this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);
      this.cyclicOperation();
    })
  }
}
