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

import { ItemDataSource } from '../common/ItemDataSource';
import { MenuContext } from './MenuContext';
import { BatchDeleteMenuOperation } from './BatchDeleteMenuOperation';
import { Log } from '../utils/Log';
import { BroadcastConstants } from '../constants/BroadcastConstants';

const TAG = 'ClearRecycleMenuOperation';

export class ClearRecycleMenuOperation extends BatchDeleteMenuOperation {
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
      //@ts-ignore
      this.count = dataSource.getItems().length;
    }
    if (this.count <= 0) {
      Log.warn(TAG, 'count <= 0, return');
      return;
    }

    this.confirmCallback = (): void => this.confirmCallbackBindImpl();
    this.cancelCallback = (): void => this.cancelCallbackBindImpl();

    this.menuContext.broadCast.emit(BroadcastConstants.SHOW_DELETE_DIALOG, [$r('app.string.recycleAlbum_clear_message'), $r('app.string.dialog_clear'), this.confirmCallback, this.cancelCallback]);
  }

  confirmCallback(): void {
    this.confirmCallbackBindImpl();
  }

  protected confirmCallbackBindImpl(): void {
    Log.info(TAG, 'Clear Recycle confirm');
    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;

    // 2. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    if (onOperationStart != null) onOperationStart();

    this.menuContext.broadCast.emit(BroadcastConstants.DELETE_PROGRESS_DIALOG,
      [$r('app.string.action_delete'), this.count]);

    // 3. selectManager gets the URI of the data and starts processing deletion in the callback
    let dataSource: ItemDataSource = this.menuContext.dataSource;
    if (dataSource == null) {
      this.items = this.menuContext.items;
    } else {
      //@ts-ignore
      this.items = dataSource.getItems();
    }
    this.processOperation();
  }
}
