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
import { selectManager } from './SelectManager';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

const TAG = 'AlbumDataItem';

let objectIndex = 0;

export class AlbumDataItem {
  index: number;
  id: string;
  uri: string;
  orientation: number;
  displayName: string;
  count: number;
  isDisableRename: boolean;
  isDisableDelete: boolean;
  innerId: number;
  selectType: number = MediaConstants.SELECT_TYPE_ALL;
  deviceId: string = '';
  isSelect: boolean = false;
  status: number = MediaConstants.UNDEFINED;
  objectIndex: number;
  albumType: number;
  albumSubType: number;
  fileUir: string = undefined;
  fileAsset: photoAccessHelper.PhotoAsset;
  thumbnail: PixelMap = undefined;

  constructor(id: string, count: number, displayName: string, selectType: number, deviceId: string, albumType: number, albumSubType: number) {
    this.id = id;
    this.displayName = displayName;
    this.count = count;
    this.isDisableRename = MediaConstants.ALBUM_DISABLE_RENAME_LIST.has(id);
    this.isDisableDelete = MediaConstants.ALBUM_DISABLE_DELETE_LIST.has(id);
    this.selectType = selectType;
    this.deviceId = deviceId;
    this.objectIndex = objectIndex++;
    this.albumType = albumType;
    this.albumSubType = albumSubType;
  }

  getHashCode(): string {
    return this.objectIndex + '' + this.id + ' ' + this.orientation + ' ' + this.isSelect;
  }

  async load(): Promise<void> {
    if (this.status >= MediaConstants.LOADED) {
      return;
    }
    if (this.fileUir !== undefined && this.fileUir !== null) {
      let fileAsset = (await userFileModel.getMediaItemByUri(this.fileUir));
      await this.update(fileAsset);
    }
  }

  async update(fileAsset: photoAccessHelper.PhotoAsset): Promise<void> {
    Log.info(TAG, 'this.uri ' + this.displayName);
    Log.info(TAG, 'this.uri ' + this.uri);
    if (fileAsset != null) {
      this.fileUir = fileAsset.uri;
      this.fileAsset = fileAsset;
      if (this.fileAsset != null) {
        await this.getThumbnail();
      }
      Log.info(TAG, 'this.fileUri ' + this.fileUir);
    }
    this.status = MediaConstants.LOADED;
    this.isSelect = selectManager.isSelect(this.id, this.isSelect);
  }

  async getThumbnail(): Promise<PixelMap> {
    if (this.thumbnail == undefined) {
      let size = { width: MediaConstants.DEFAULT_SIZE, height: MediaConstants.DEFAULT_SIZE };
      try {
        this.thumbnail = await this.fileAsset.getThumbnail(size)
      } catch (err) {
        Log.error(TAG, 'getThumbnail error: ' + JSON.stringify(err));
      }
    }
    return this.thumbnail;
  }

  async getVideoCount(): Promise<number> {
    if (this.selectType === MediaConstants.SELECT_TYPE_IMAGE) {
      return 0;
    }
    let fileAssets: photoAccessHelper.PhotoAsset[] = [];
    let albumPredicates = new dataSharePredicates.DataSharePredicates();
    albumPredicates.equalTo(photoAccessHelper.AlbumKeys.ALBUM_NAME, this.displayName)
    let albumFetchOption = {
      fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
      predicates: albumPredicates
    };
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, photoAccessHelper.PhotoType.VIDEO)
    predicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_ADDED);
    let fileFetchOption = {
      fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
      predicates: predicates
    };
    fileAssets = await userFileModel.getAllMediaItemsByType(this.albumType, this.albumSubType, albumFetchOption, fileFetchOption);
    return fileAssets.length;
  }

  setSelect(isSelect: boolean): void {
    this.isSelect = isSelect;
    selectManager.setSelect(this.id, this.isSelect);
  }

  async onDelete(): Promise<boolean> {
    try {
      Log.error(TAG, this.displayName);
      await userFileModel.deleteAlbum(this.displayName);
      selectManager.deleteSelect(this.uri);
      this.status = MediaConstants.TRASHED;
      return true;
    } catch (err) {
      Log.error(TAG, 'onDelete error: ' + JSON.stringify(err));
      return false;
    }
  }

  isDeleted(): boolean {
    return this.status === MediaConstants.TRASHED;
  }
}
