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
import userFileManager from '@ohos.filemanagement.userFileManager';
import { userFileModel } from '../base/UserFileModel';
import { Log } from '../utils/Log';
import { MenuContext } from './MenuContext';
import { ProcessMenuOperation, FindSameOperation } from './ProcessMenuOperation';
import { MediaOperationType } from '../models/MediaOperationType';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { startTraceWithTaskId, finishTraceWithTaskId } from '../utils/TraceControllerUtils';
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
    let item = this.items[this.currentBatch++] as UserFileDataItem;
    //this.moveOne(item);
    userFileModel.addPhotoToAlbumByUserFileMgr(this.albumInfo.uri, item.uri)
    this.onCompleted();
  }

  private async moveOne(item: UserFileDataItem): Promise<void> {
    let fileAsset = await item.loadFileAsset();
    let assets = await this.getFileCopyOrMoveInfo(fileAsset, this.albumInfo);
    if (assets.targetAsset != null) {
      if (assets.targetAsset.uri == assets.sourceAsset.uri) {
        Log.info(TAG, 'move same fileAsset');
        this.onOperateContinue();
        return;
      }
      Log.info(TAG, 'show find same file dialog');
      switch (this.findSameOperation) {
        case FindSameOperation.NONE:
          this.menuContext.broadCast.emit(BroadcastConstants.FIND_SAME_FILE_DIALOG,
            [assets, this.count, (): void => {
              this.move(assets.sourceAsset, this.albumInfo.uri, assets.targetAsset);
            }, (): void => this.onOperateContinueBindImpl(), (): void => this.onOperateCancelledBindImpl(),
              (newOp: number): void => this.setFindSameOperationBindImpl(newOp)]);
          break;
        case FindSameOperation.REPLACE:
          this.move(assets.sourceAsset, this.albumInfo.uri, assets.targetAsset);
          break;
        case FindSameOperation.SKIP:
          this.onOperateContinue();
          break;
        default:
          Log.warn(TAG, 'findSameOperation is error ' + this.findSameOperation);
          break;
      }
    } else {
      this.move(assets.sourceAsset, this.albumInfo.uri);
    }
  }

  async move(file: userFileManager.FileAsset, path: string, targetFile?): Promise<void> {
    startTraceWithTaskId('move', this.currentBatch);
    try {
      if (targetFile != null) {
        await userFileModel.deleteOne(targetFile.uri);
      }
      //TODO need to define move
      finishTraceWithTaskId('move', this.currentBatch);
      this.onCompleted();
    } catch (error) {
      Log.error(TAG, 'move error: ' + error)
      this.onError();
    }
  }

  cancelFunc(): void {
    this.cancelFuncBindImpl()
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
    this.onOperateContinueBindImpl()
  }

  private onOperateContinueBindImpl(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }
}
