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
import { userFileModel } from '../base/UserFileModel';
import { Log } from '../utils/Log';
import { ItemDataSource } from '../common/ItemDataSource';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { MenuOperationCallback } from './MenuOperationCallback';
import { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { getResourceString } from '../utils/ResourceUtils';
import { showToast } from '../utils/UiUtil';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { MediaConstants } from '../constants/MediaConstants';


const TAG = 'AlbumSetRenameMenuOperation';

export class AlbumSetRenameMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private onOperationEnd: Function;
  private item: AlbumDataItem;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.warn(TAG, 'menuContext is null, return');
      return;
    }
    let dataSource: ItemDataSource = this.menuContext.dataSource;
    let count: number;
    let items: Object[];
    if (dataSource == null) {
      count = this.menuContext.items.length;
      items = this.menuContext.items;
    } else {
      count = dataSource.getSelectedCount();
      items = dataSource.getSelectedItems();
    }
    if (count !== 1) {
      Log.warn(TAG, 'count is invalid');
      return;
    }

    this.item = items[0] as AlbumDataItem;

    this.confirmCallback = (newName: string): Promise<void> => this.confirmCallbackBindImpl(newName);
    this.cancelCallback = (): void => this.cancelCallbackBindImpl();

    Log.info(TAG, 'The name of clicked album is ' + this.item.displayName);

    this.menuContext.broadCast.emit(BroadcastConstants.SHOW_RENAME_PHOTO_DIALOG,
      [this.item.displayName, this.confirmCallback, this.cancelCallback]);
  }

  private async confirmCallback(newName: string): Promise<void> {
    return await this.confirmCallbackBindImpl(newName);
  }

  private async confirmCallbackBindImpl(newName: string): Promise<void> {
    Log.info(TAG, 'AlbumSet rename confirm and the new name is: ' + newName);

    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;
    if (onOperationStart != null) onOperationStart();

    this.rename(newName);
  }

  private async checkAlbumExit(simpleAlbumDataItem: SimpleAlbumDataItem): Promise<boolean> {
    return await userFileModel.getUserAlbumCountByName(simpleAlbumDataItem.displayName) > 0;
  }

  private async rename(name): Promise<void> {
    try {
      let simpleAlbumDataItem: SimpleAlbumDataItem = new SimpleAlbumDataItem('', name, this.item.uri, '', '', -1, -1);
      if (name != undefined && name != null) {
        let isExit = await this.checkAlbumExit(simpleAlbumDataItem);
        if (isExit) {
          getResourceString($r('app.string.name_already_use')).then<void, void>((message: string): void => {
            showToast(message);
          })
          Log.warn(TAG, 'album is miss');
          this.onError();
          return;
        }
      }
      Log.info(TAG, 'change album_name:' + this.item.displayName + ' to ' + name);
      let albums: photoAccessHelper.Album = await userFileModel.getUserAlbumByName(this.item.displayName);
      albums.albumName = name;
      await albums.commitModify();
      this.onCompleted();
    } catch (error) {
      Log.error(TAG, 'AlbumSet rename failed: ' + error);
      this.onError();
    }
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, 'AlbumSet rename cancel');
  }

  onCompleted(): void {
    Log.info(TAG, 'Rename data succeed!');
    if (this.onOperationEnd != null) this.onOperationEnd();
  }

  onError(): void {
    Log.error(TAG, 'Rename data failed!');
    if (this.onOperationEnd != null) this.onOperationEnd();
  }
}
