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
import { AlbumDataImpl } from './AlbumDataImpl';
import { LazyItem, ItemDataSource } from './ItemDataSource';
import { AlbumDataItem } from './AlbumDataItem';
import { MediaConstants } from '../constants/MediaConstants'

const TAG = 'AlbumsDataSource'

export class AlbumsDataSource extends ItemDataSource {
  private albumDataItems: AlbumDataItem[] = [];
  private albumDataImpl: AlbumDataImpl = new AlbumDataImpl();

  setBlackList(blackList: string[]): void {
    this.albumDataImpl.setBlackList(blackList);
  }

  setSelectType(selectType: number): void {
    this.albumDataImpl.setSelectType(selectType);
  }

  setDeviceId(deviceId: string): void {
    this.albumDataImpl.setDeviceId(deviceId);
  }

  totalCount(): number {
    return this.albumDataItems.length;
  }

  getData(index: number): LazyItem<AlbumDataItem> {
    return new LazyItem<AlbumDataItem>(this.getDataByIndex(index), index, (index: number): void => this.onDataUpdateBindImpl(index));
  }

  getDataByIndex(index: number): AlbumDataItem {
    if (index < 0 || index >= this.albumDataItems.length) {
      Log.warn(TAG, index + '/' + this.albumDataItems.length);
      return undefined;
    }
    this.albumDataItems[index].index = index;
    return this.albumDataItems[index];
  }

  isSelect(): boolean {
    let isSelect = true;
    for (let i = 0;i < this.albumDataItems.length; i++) {
      if (!this.albumDataItems[i].isSelect) {
        isSelect = false;
        break;
      }
    }
    return isSelect;
  }

  resetLoadState(): void {
    for (let i = 0;i < this.albumDataItems.length; i++) {
      if (this.albumDataItems[i].status === MediaConstants.LOADED) {
        this.albumDataItems[i].status = MediaConstants.UNDEFINED;
      }
    }
  }

  getAlbumDataItemById(id: string): AlbumDataItem | null {
    let albumDataItem: AlbumDataItem = null;
    for (let i = 0;i < this.albumDataItems.length; i++) {
      if (this.albumDataItems[i].id === id) {
        albumDataItem = this.albumDataItems[i];
      }
    }
    return albumDataItem;
  }

  getSelectedUris(): string[] {
    let uris: string[] = [];
    this.albumDataItems.forEach((item: AlbumDataItem): void => {
      if (item.isSelect) {
        uris.push(item.uri);
      }
    })
    return uris;
  }

  isDisableRename(): boolean {
    let isDisableRename = false;
    for (let i = 0;i < this.albumDataItems.length; i++) {
      if (this.albumDataItems[i].isSelect && this.albumDataItems[i].isDisableRename) {
        isDisableRename = true;
        break;
      }
    }
    return isDisableRename;
  }

  isDisableDelete(): boolean {
    let isDisableDelete = false;
    for (let i = 0;i < this.albumDataItems.length; i++) {
      if (this.albumDataItems[i].isSelect && this.albumDataItems[i].isDisableDelete) {
        isDisableDelete = true;
        break;
      }
    }
    return isDisableDelete;
  }

  setSelect(isSelect: boolean): void {
    this.albumDataItems.forEach((item: AlbumDataItem): void => {
      item.setSelect(isSelect);
    })
  }

  getSelectedCount(): number {
    let count = 0;
    for (let i = 0;i < this.albumDataItems.length; i++) {
      if (this.albumDataItems[i].isSelect) {
        count++;
      }
    }
    return count;
  }

  getSelectedItems(): Object[] {
    let items: AlbumDataItem[] = [];
    this.albumDataItems.forEach((item: AlbumDataItem): void => {
      if (item.isSelect) {
        items.push(item);
      }
    })
    return items;
  }

  onDataUpdate(index: number): void {
    this.onDataUpdateBindImpl(index);
  }

  private onDataUpdateBindImpl(index: number): void {
    Log.info(TAG, 'onDataUpdate ' + index);
    this.notifyDataChange(index);
  }

  dataReload(): void {
    this.reloadAlbumItemData().then<void, void>((isEmpty: boolean): void => {
      this.notifyDataReload();
    })
  }

  dataRemove(): void {
    for (let i = this.albumDataItems.length - 1;i >= 0; i--) {
      if (this.albumDataItems[i].isDeleted()) {
        this.albumDataItems.splice(i, 1);
        super.notifyDataDelete(i);
      }
    }
  }

  async reloadAlbumItemData(): Promise<boolean> {
    this.albumDataItems = await this.albumDataImpl.reloadAlbumItemData();
    return this.albumDataItems.length === 0;
  }

  async reloadAlbumListItemData(): Promise<boolean> {
    Log.info(TAG, 'reloadAlbumListItemData');
    this.albumDataItems = await this.albumDataImpl.reloadAlbumItemData();
    this.notifyDataReload();
    return this.albumDataItems.length === 0;
  }
}
