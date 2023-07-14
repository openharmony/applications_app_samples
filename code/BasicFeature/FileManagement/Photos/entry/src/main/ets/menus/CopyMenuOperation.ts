/*
 * Copyright (c) 2022 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { MediaConstants } from '../constants/MediaConstants';
import { Log } from '../utils/Log';
import { MenuContext } from './MenuContext';
import { ProcessMenuOperation, FindSameOperation, Assets } from './ProcessMenuOperation';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { userFileModel } from '../base/UserFileModel';
import { MediaOperationType } from '../models/MediaOperationType';
import { ItemDataSource } from '../common/ItemDataSource';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { UserFileDataItem } from '../base/UserFileDataItem';

const TAG = 'CopyMenuOperation';

export class CopyMenuOperation extends ProcessMenuOperation {
  private albumInfo: SimpleAlbumDataItem;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.albumInfo = menuContext.albumInfo;
  }

  doAction(): void {
    Log.info(TAG, 'copy doAction');
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

    if (this.menuContext.deviceId != null) {
      this.menuContext.broadCast.emit(BroadcastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.download_progress_message'),
        MediaOperationType.Copy, (): void => this.cancelFuncBindImpl()]);
    } else {
      this.menuContext.broadCast.emit(BroadcastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.copy_progress_message', this.albumInfo.displayName),
        MediaOperationType.Copy, (): void => this.cancelFuncBindImpl()]);
    }

    if (dataSource == null) {
      this.items = this.menuContext.items;
    } else {
      this.items = dataSource.getSelectedItems();
    }
    this.processOperation();
  }

  requestOneBatchOperation(): void {
    let item = this.items[this.currentBatch++] as UserFileDataItem;
    this.copyOne(item);
  }

  private async copyOne(item: UserFileDataItem): Promise<void> {
    let fileAsset = await item.loadFileAsset();
    let assets: Assets = await this.getFileCopyOrMoveInfo(fileAsset, this.albumInfo);
    if (this.menuContext.deviceId != null) {
      let displayName = assets.sourceAsset.displayName;
      let index = displayName.lastIndexOf('.');
      let start = displayName.lastIndexOf('_');
      displayName = displayName.slice(0, start) + '_$' + new Date().getTime() + '$' + displayName.slice(index);
      let params: Object = {
        mediaType: assets.sourceAsset.photoType,
        name: displayName,
        path: this.albumInfo.uri
      };
      this.copy(assets.sourceAsset, null, params);
      return;
    }
    if (assets.targetAsset != null) {
      if (assets.targetAsset.uri == assets.sourceAsset.uri) {
        Log.info(TAG, 'copy same fileAsset');
        this.onOperateContinue();
        return;
      }
      Log.info(TAG, 'show find same file dialog');
      switch (this.findSameOperation) {
        case FindSameOperation.NONE:
          this.menuContext.broadCast.emit(BroadcastConstants.FIND_SAME_FILE_DIALOG,
            [assets, this.count, (): void => {
              this.copy(assets.sourceAsset, assets.targetAsset);
            }, (): void => this.onOperateContinueBindImpl(), (): void => this.onOperateCancelledBindImpl(),
              (newOp: number): void => this.setFindSameOperation(newOp)]);
          break;
        case FindSameOperation.REPLACE:
          this.copy(assets.sourceAsset, assets.targetAsset);
          break;
        case FindSameOperation.SKIP:
          this.onOperateContinue();
          break;
        default:
          Log.warn(TAG, 'findSameOperation is error ' + this.findSameOperation);
          break;
      }
    } else {
      let params: Object = {
        mediaType: assets.sourceAsset.photoType,
        name: assets.sourceAsset.displayName.replace('.', 'copy.'),
        path: this.albumInfo.uri
      };
      this.copy(assets.sourceAsset, null, params);
    }
  }

  async copy(source, target, param?): Promise<void> {
    try {
      if (!Boolean<object>(target).valueOf()) {
        target = await userFileModel.createOne(param.name, param.path);
        if (target == null) {
          Log.warn(TAG, 'Target file create failed when copyFile!');
          this.onError();
          return;
        }
      }
      await userFileModel.copyOne(source, target);
      this.onCompleted();
    } catch (error) {
      Log.error(TAG, 'copyFile is error ' + error);
      this.onError();
    }
  }

  cancelFunc(): void {
    this.cancelFuncBindImpl()
  }

  private cancelFuncBindImpl(): void {
    Log.info(TAG, 'progress cancel');
    this.onOperatePause();
    let cancelMessage = $r('app.string.copy_cancel_message', this.getExpectProgress().toString());

    if (this.menuContext.broadCast != null) {
      if (this.menuContext.deviceId != null) {
        this.menuContext.broadCast.emit(BroadcastConstants.DOWNLOAD_CANCEL_OPERATE,
          [cancelMessage, (): void => this.onOperateContinueBindImpl(), (): void => this.onOperateCancelledBindImpl()]);
      } else {
        this.menuContext.broadCast.emit(BroadcastConstants.CANCEL_OPERATE,
          [cancelMessage, (): void => this.onOperateContinueBindImpl(), (): void => this.onOperateCancelledBindImpl()]);
      }
    }

  }

  // Copy cancel callback
  onOperateContinue(): void {
    this.onOperateContinueBindImpl()
  }

  private onOperateContinueBindImpl(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }
}
