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

import { Log } from '../utils/Log';
import { ItemDataSource } from '../common/ItemDataSource';
import { MenuContext } from './MenuContext';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { MediaConstants } from '../constants/MediaConstants';
import { AlbumDataImpl } from '../common/AlbumDataImpl';

const TAG = 'BatchRemoveMenuOperation';

export class BatchRemoveMenuOperation extends ProcessMenuOperation {
  private albumDataImpl: AlbumDataImpl = new AlbumDataImpl();

  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  doAction(): void {
    Log.info(TAG, 'remove doAction');
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

    this.confirmCallback = (): void => this.confirmCallbackBindImpl();
    this.cancelCallback = (): void => this.cancelCallbackBindImpl();

    let resource: Resource = this.getRemoveMessageResource(dataSource);
    let removeResource: Resource = $r('app.string.dialog_remove');
    this.menuContext.broadCast.emit(BroadcastConstants.SHOW_DELETE_DIALOG, [resource, removeResource, this.confirmCallback, this.cancelCallback]);
  }

  getResourceFromGrid(dataSource: ItemDataSource): Resource {
    if (dataSource != null && dataSource.isSelect()) {
      return $r('app.string.remove_all_files_tips');
    } else if (this.count === 1) {
      return $r('app.string.remove_single_file_tips');
    } else {
      return $r('app.string.remove_files_tips', this.count);
    }
  }

  getRemoveMessageResource(dataSource: ItemDataSource): Resource {
    let resource: Resource;
    resource = this.getResourceFromGrid(dataSource);
    return resource;
  }

  confirmCallback(): void {
    this.confirmCallbackBindImpl();
  }

  protected confirmCallbackBindImpl(): void {
    Log.info(TAG, 'Batch remove confirm');
    AppStorage.SetOrCreate<number>('isRemove', 1);

    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;

    // 2. onRemoveStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    if (onOperationStart != null) {
      onOperationStart();
    }

    this.menuContext.broadCast.emit(BroadcastConstants.DELETE_PROGRESS_DIALOG,
      [$r('app.string.action_remove'), this.count]);

    // 3. selectManager gets the URI of the data and starts processing deletion in the callback
    let dataSource: ItemDataSource = this.menuContext.dataSource;
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
      if(this.menuContext.albumId === MediaConstants.ALBUM_ID_USER){
        Log.error(TAG,'Remove from user album:'+this.menuContext.albumInfo.uri);
        this.albumDataImpl.removeFileFromAlbum(this.menuContext.albumInfo.uri,item.uri).then<void, void>((): void => {
          this.currentBatch++;
          this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);
          this.cyclicOperation();
        })
      }
    }
  }

  cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  protected cancelCallbackBindImpl(): void {
    Log.info(TAG, 'Batch remove cancel');
  }
}
