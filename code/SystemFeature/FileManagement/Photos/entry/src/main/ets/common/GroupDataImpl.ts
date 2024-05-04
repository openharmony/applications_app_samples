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
import { Log } from '../utils/Log';
import { Constants } from '../constants/Constants';
import { userFileModel } from '../base/UserFileModel';
import { screenManager } from './ScreenManager';
import { MediaConstants } from '../constants/MediaConstants';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { FavorUserFileDataItem } from '../base/FavorUserFileDataItem';
import { userFileDataItemCache } from '../base/UserFileDataItemCache';
import { trashUserFileDataItemCache } from '../base/TrashUserFileDataItemCache';
import { TrashUserFileDataItem } from '../base/TrashUserFileDataItem';
import dataSharePredicates from '@ohos.data.dataSharePredicates';


const TAG = 'GroupDataImpl';

export class GroupDataImpl {
  private selectType: number = MediaConstants.SELECT_TYPE_ALL;
  private albumId: string = '';
  private deviceId: string = '';
  private albumType: number = -1;
  private albumSubType: number = -1;
  private albumName: string = '';

  setSelectType(selectType: number): void {
    this.selectType = selectType;
  }

  setAlbumId(id: string): void {
    Log.info(TAG, 'setAlbumId: ' + id);
    this.albumId = id;
  }

  setDeviceId(id: string): void {
    Log.info(TAG, 'setDeviceId: ' + id);
    this.deviceId = id;
  }

  setAlbumType(albumType: number): void {
    Log.info(TAG, 'setAlbumType: ' + albumType);
    this.albumType = albumType;
  }

  setAlbumSubtype(albumSubType: number): void {
    Log.info(TAG, 'setAlbumSubtype: ' + albumSubType);
    this.albumSubType = albumSubType;
  }

  setAlbumName(name: string): void {
    Log.info(TAG, 'setAlbumName: ' + name);
    this.albumName = name;
  }

  async reloadGroupItemData(isGrid: boolean): Promise<UserFileDataItem[]> {
    if (isGrid) {
      return this.reloadGridGroupItemData();
    } else {
      return this.reloadBrowserGroupItemData();
    }
  }

  async reloadBrowserGroupItemData(): Promise<UserFileDataItem[]> {
    Log.info(TAG, 'reloadBrowserGroupItemData');
    let groupDataItem: UserFileDataItem[] = [];
    let mediaFileAssets = await this.getMediaItemFileAssets(this.albumName, this.albumType, this.albumSubType);
    if (this.albumId === MediaConstants.ALBUM_ID_FAVOR) {
      for (let i = 0;i < mediaFileAssets.length; i++) {
        let favorMediaItem = new FavorUserFileDataItem('', [], i);
        if (userFileDataItemCache.hasKey(mediaFileAssets[i].uri)) {
          favorMediaItem.favouriteStatus = userFileDataItemCache.get(mediaFileAssets[i].uri).favouriteStatus;
          favorMediaItem.orientation = userFileDataItemCache.get(mediaFileAssets[i].uri).orientation;
        }
        favorMediaItem.update(mediaFileAssets[i]);
        groupDataItem.push(favorMediaItem);
      }
    } else if (this.albumId === MediaConstants.ALBUM_ID_RECYCLE) {
      for (let i = 0;i < mediaFileAssets.length; i++) {
        let trashMediaItem = new TrashUserFileDataItem('', [], i);
        if (userFileDataItemCache.hasKey(mediaFileAssets[i].uri)) {
          trashMediaItem.favouriteStatus = userFileDataItemCache.get(mediaFileAssets[i].uri).favouriteStatus;
          trashMediaItem.orientation = userFileDataItemCache.get(mediaFileAssets[i].uri).orientation;
        }
        trashMediaItem.update(mediaFileAssets[i]);
        groupDataItem.push(trashMediaItem);
      }
    } else {
      for (let i = 0;i < mediaFileAssets.length; i++) {
        let mediaItem: UserFileDataItem = new UserFileDataItem('', [], this.deviceId, i);
        if (userFileDataItemCache.hasKey(mediaFileAssets[i].uri)) {
          mediaItem = userFileDataItemCache.get(mediaFileAssets[i].uri);
        } else {
          userFileDataItemCache.set(mediaFileAssets[i].uri, mediaItem);
        }
        mediaItem.update(mediaFileAssets[i]);
        groupDataItem.push(mediaItem);
      }
    }
    Log.info(TAG, 'reload finish');
    return groupDataItem;
  }

  async reloadGridGroupItemData(): Promise<UserFileDataItem[]> {
    Log.info(TAG, 'reloadGridGroupItemData');
    let groupDataItem: UserFileDataItem[] = [];
    let mediaFileAssets = await this.getMediaItemFileAssets(this.albumName, this.albumType, this.albumSubType);
    if (this.albumId === MediaConstants.ALBUM_ID_FAVOR) {
      for (let i = 0;i < mediaFileAssets.length; i++) {
        let item = new FavorUserFileDataItem('', [], i);
        if (userFileDataItemCache.hasKey(mediaFileAssets[i].uri)) {
          Log.info(TAG, 'hasKey');
          item = userFileDataItemCache.get(mediaFileAssets[i].uri);
        } else {
          userFileDataItemCache.set(mediaFileAssets[i].uri, item);
        }
        item.update(mediaFileAssets[i]);
        groupDataItem.push(item);
      }
    } else if (this.albumId === MediaConstants.ALBUM_ID_RECYCLE) {
      for (let i = 0;i < mediaFileAssets.length; i++) {
        let item = new TrashUserFileDataItem('', [], i);
        if (trashUserFileDataItemCache.hasKey(mediaFileAssets[i].uri)) {
          item = trashUserFileDataItemCache.get(mediaFileAssets[i].uri);
        } else {
          trashUserFileDataItemCache.set(mediaFileAssets[i].uri, item);
        }
        item.update(mediaFileAssets[i]);
        groupDataItem.push(item);
      }
    } else {
      for (let i = 0;i < mediaFileAssets.length; i++) {
        let item = new UserFileDataItem('', [], this.deviceId, i);
        if (userFileDataItemCache.hasKey(mediaFileAssets[i].uri)) {
          item = userFileDataItemCache.get(mediaFileAssets[i].uri);
        } else {
          userFileDataItemCache.set(mediaFileAssets[i].uri, item);
        }
        item.update(mediaFileAssets[i]);
        groupDataItem.push(item);
      }
    }
    Log.info(TAG, 'reload finish');
    return groupDataItem;
  }

  private async getMediaItemFileAssets(albumName: string, albumType: number, albumSubType: number): Promise<photoAccessHelper.PhotoAsset[]> {
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.AlbumKeys.ALBUM_NAME, albumName)
    let fetchOption = {
      fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
      predicates: predicates
    };
    Log.info(TAG, 'albumName:' + albumName);
    if (albumType === MediaConstants.ALBUM_TYPE_ALL) {
      return await userFileModel.getAllMediaItems();
    } else if (albumType === MediaConstants.ABSTRACT_ALBUM_TYPE_MOVING_PHOTO) {
      return await userFileModel.getAllMovingPhotoItems();
    }
    let emptyPredicates = new dataSharePredicates.DataSharePredicates();
    emptyPredicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_ADDED);
    let emptyFetchOption = {
      fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
      predicates: emptyPredicates
    };
    return await userFileModel.getAllMediaItemsByType(albumType, albumSubType, fetchOption, emptyFetchOption);
  }

  private getCount(): number {
    let contentWidth = screenManager.getWinWidth();
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    let columns = Math.max(Constants.GRID_MIN_COUNT, Math.ceil((contentWidth + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)));
    let contentHeight = screenManager.getWinHeight() - Constants.ACTION_BAR_HEIGHT - screenManager.getNaviBarHeight();
    let rows = Math.ceil((contentHeight + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)) + 4;
    return columns * rows;
  }
}
