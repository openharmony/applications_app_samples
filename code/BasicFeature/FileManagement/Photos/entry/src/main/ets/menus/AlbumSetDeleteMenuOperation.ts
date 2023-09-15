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
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { ItemDataSource } from '../common/ItemDataSource';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { MenuContext } from './MenuContext';
import { ProcessMenuOperation } from './ProcessMenuOperation';

const TAG = 'AlbumSetDeleteMenuOperation';

export class AlbumSetDeleteMenuOperation extends ProcessMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.warn(TAG, 'menuContext is null, return');
      return;
    }
    let dataSource: ItemDataSource = this.menuContext.dataSource;
    if (dataSource == null) {
      this.count = this.menuContext.items.length;
      this.items = this.menuContext.items;
    } else {
      this.count = dataSource.getSelectedCount();
      this.items = dataSource.getSelectedItems();
    }
    if (this.count as number <= 0) {
      Log.warn(TAG, 'count <= 0, return');
      return;
    }

    this.confirmCallback = (): void => this.confirmCallbackBindImpl();
    this.cancelCallback = (): void => this.cancelCallbackBindImpl();

    let deleteResource: Resource = $r('app.string.dialog_delete');
    this.getDialogTitle().then<void, void>((dialogTitle: Resource): void => {
      this.menuContext.broadCast.emit(BroadcastConstants.SHOW_DELETE_DIALOG, [dialogTitle, deleteResource, this.confirmCallback, this.cancelCallback]);
    })
  }

  private async getDialogTitle(): Promise<Resource> {
    let videoCount = 0;
    let photoCount = 0;
    for (let i = 0; i < this.items.length; i++) {
      let itemVideoCount = await  (this.items[i] as AlbumDataItem).getVideoCount();
      videoCount += itemVideoCount;
      photoCount += ((this.items[i] as AlbumDataItem).count - itemVideoCount);
    }

    if (this.count as number === 1) {
      if (videoCount > 0 && photoCount > 0) {
        return $r('app.string.recycle_single_album_tips', photoCount, videoCount);
      }
      if (videoCount > 0 && photoCount <= 0) {
        return $r('app.string.recycle_single_album_with_videos_tips', videoCount);
      }
      if (videoCount <= 0 && photoCount > 0) {
        return $r('app.string.recycle_single_album_with_photos_tips', photoCount);
      }
    } else {
      if (videoCount > 0 && photoCount > 0) {
        return $r('app.string.recycle_albums_tips', this.count, photoCount, videoCount);
      }
      if (videoCount > 0 && photoCount <= 0) {
        return $r('app.string.recycle_albums_with_videos_tips', this.count, videoCount);
      }
      if (videoCount <= 0 && photoCount > 0) {
        return $r('app.string.recycle_albums_with_photos_tips', this.count, photoCount);
      }
    }
  }

  requestOneBatchOperation(): void {
    let item = this.items[this.currentBatch] as AlbumDataItem;
    let promise: Promise<boolean> = item.onDelete();
    promise.then<void, void>((): void => {
      this.currentBatch++;
      this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);
      this.cyclicOperation();
    }).catch<void>((): void => {
      this.onError();
    })
    }

  private confirmCallback(): void {
    this.confirmCallbackBindImpl();
  }

  private confirmCallbackBindImpl(): void {
    Log.info(TAG, 'AlbumSet delete confirm');
    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;

    if (onOperationStart != null) onOperationStart();

    this.menuContext.broadCast.emit(BroadcastConstants.DELETE_PROGRESS_DIALOG, [$r('app.string.action_delete'), this.count]);
    this.processOperation();
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, 'AlbumSet delete cancel');
  }
}
