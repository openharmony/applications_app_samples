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
import { AlbumDataItem } from './AlbumDataItem';
import { MediaConstants } from '../constants/MediaConstants';
import { userFileModel } from '../base/UserFileModel';
import { getAlbumDisplayName } from '../base/UserFileDataHelper';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

const TAG = 'AlbumDataImpl';

export class AlbumDataImpl {
  private blackList: string[] = [];
  private selectType: number = MediaConstants.SELECT_TYPE_ALL;
  private deviceId: string = '';

  setBlackList(blackList: string[]): void {
    this.blackList = blackList;
  }

  setSelectType(selectType: number): void {
    this.selectType = selectType;
  }

  setDeviceId(deviceId: string): void {
    this.deviceId = deviceId;
  }

  async reloadAlbumItemData(): Promise<AlbumDataItem[]> {
    Log.info(TAG, 'reloadAlbumItemData');
    let albumDataItems: AlbumDataItem[] = [];
    for (let i = 0;i < MediaConstants.ALBUM_DEFAULT_SORT_LIST.length; i++) {
      await this.getAlbumItem(MediaConstants.ALBUM_DEFAULT_SORT_LIST[i], albumDataItems);
    }
    await this.getAlbumItem(MediaConstants.ALBUM_ID_USER, albumDataItems);
    await this.getAlbumItem(MediaConstants.ALBUM_ID_RECYCLE, albumDataItems);
    return albumDataItems;
  }

  private async getAlbumItem(id: string, albumDataItems: AlbumDataItem[]): Promise<void> {
    Log.info(TAG, 'getAlbumItem: ' + id);
    if (this.blackList.indexOf(id) >= 0) {
      Log.debug(TAG, 'no need as in black list');
      return;
    }
    if (this.deviceId.length > 0 && (id !== MediaConstants.ALBUM_ID_SNAPSHOT && id !== MediaConstants.ALBUM_ID_CAMERA)) {
      Log.info(TAG, 'no need');
      return;
    }
    let albumType = MediaConstants.ALBUM_TYPE_SYSTEM;
    let albumSubType = MediaConstants.ALBUM_SUBTYPE_USER_GENERIC;
    switch (id) {
      case MediaConstants.ALBUM_ID_FAVOR:
        albumSubType = MediaConstants.ALBUM_SUBTYPE_FAVOR;
        break;
      case MediaConstants.ALBUM_ID_CAMERA:
        albumSubType = MediaConstants.ALBUM_SUBTYPE_CAMERA;
        break;
      case MediaConstants.ALBUM_ID_RECYCLE:
        albumSubType = MediaConstants.ALBUM_SUBTYPE_RECYCLE;
        break;
      case MediaConstants.ALBUM_ID_SNAPSHOT:
        albumSubType = MediaConstants.ALBUM_SUBTYPE_SNAPSHOT;
        break;
      case MediaConstants.ALBUM_ID_VIDEO:
        albumSubType = MediaConstants.ALBUM_SUBTYPE_VIDEO;
        break;
      case MediaConstants.ALBUM_ID_ALL:
        await this.getAllPhotoAlbum(albumDataItems);
        return;
      case MediaConstants.ALBUM_ID_USER:
        albumType = MediaConstants.ALBUM_TYPE_USER;
        albumSubType = MediaConstants.ALBUM_SUBTYPE_USER_GENERIC;
        break;
      case MediaConstants.ALBUM_ID_MOVING_PHOTO:
        await this.getMovingPhotoAbstractAlbum(albumDataItems);
        return;
      default:
        break;
    }
    await this.getAlbumItemByUserFileMgr(id, albumType, albumSubType, albumDataItems);
  }

  private async getAlbumItemByUserFileMgr(id: string, type: photoAccessHelper.AlbumType, subType: photoAccessHelper.AlbumSubtype, albumDataItems: AlbumDataItem[]): Promise<void> {
    let fetchResult:photoAccessHelper.FetchResult<photoAccessHelper.Album> = null;
    try {
      Log.info(TAG, 'getAlbumItemByUserFileMgr');
      fetchResult = await userFileModel.getUserFileMgr().getAlbums(type, subType);
      Log.info(TAG, 'type:' + type);
      Log.info(TAG, 'subType:' + subType);
      Log.info(TAG, 'get Album fetchResult, count: ' + fetchResult.getCount());
      for (let i = 0; i < fetchResult.getCount(); i++) {
        let albumAsset:photoAccessHelper.Album = await fetchResult.getObjectByPosition(i);
        Log.info(TAG, 'albumAsset albumType: ' + i + '---' + albumAsset.albumType);
        Log.info(TAG, 'albumAsset albumSubType: ' + i + '---' + albumAsset.albumSubtype);
        Log.info(TAG, 'albumAsset albumName: ' + i + '---' + albumAsset.albumName);
        Log.info(TAG, 'albumAsset albumUri: ' + i + '---' + albumAsset.albumUri);
        if (this.blackList.indexOf(albumAsset.albumUri) >= 0) {
          Log.debug(TAG, 'no need as in black list:'+albumAsset.albumUri);
          continue;
        }
        Log.info(TAG, 'albumAsset count: ' + i + '---' + albumAsset.count);
        Log.info(TAG, 'albumAsset coverUri: ' + i + '---' + albumAsset.coverUri);
        let photoFetchResult:photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = null;
        let fileAsset:photoAccessHelper.PhotoAsset = null;
        let count = 0;
        try {
          let predicates = new dataSharePredicates.DataSharePredicates();
          let fetchOptions = {
            fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
            predicates: predicates
          };
          photoFetchResult = await albumAsset.getAssets(fetchOptions);
          count = photoFetchResult.getCount();
          Log.info(TAG, 'photoFetchResult count: ' + count);
          let displayName = 'unknown';
          if (id === MediaConstants.ALBUM_ID_USER) {
            displayName = albumAsset.albumName;
          } else {
            displayName = await getAlbumDisplayName(id);
          }
          let albumType = albumAsset.albumType;
          let albumSubType = albumAsset.albumSubtype;
          let albumItem: AlbumDataItem = new AlbumDataItem(id, count, displayName, this.selectType, this.deviceId, albumType, albumSubType);
          albumItem.uri = albumAsset.albumUri;
          if (count > 0) {
            fileAsset = await photoFetchResult.getFirstObject();
            Log.info(TAG, 'getFirstObject file displayName: ' + fileAsset.displayName);
            await albumItem.update(fileAsset);
          }
          albumDataItems.push(albumItem);
        } catch (err) {
          Log.error(TAG, 'get Album getPhotoAssets failed with err: ' + err);
        } finally {
          if (photoFetchResult != null) {
            photoFetchResult.close();
          }
        }
      }
    } catch (err) {
      Log.error(TAG, 'get Album fetchResult failed with err: ' + err);
    } finally {
      if (fetchResult != null) {
        fetchResult.close();
      }
    }
  }

  async getUserAlbumItemByUri(uri: string): Promise<photoAccessHelper.Album> {
    let fetchResult:photoAccessHelper.FetchResult<photoAccessHelper.Album> = null;
    let album: photoAccessHelper.Album = null;
    try {
      Log.info(TAG, 'getUserAlbumItemByUri');
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.AlbumKeys.URI, uri);
      let fetchOptions = {
        fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
        predicates: predicates
      };
      fetchResult = await userFileModel.getUserFileMgr().getAlbums(photoAccessHelper.AlbumType.USER, photoAccessHelper.AlbumSubtype.USER_GENERIC, fetchOptions);
      Log.info(TAG, 'get Album fetchResult, count: ' + fetchResult.getCount());
      if (fetchResult.getCount() > 0) {
        album = await fetchResult.getFirstObject();
      }
    } catch (err) {
      Log.error(TAG, 'get Album fetchResult failed with err: ' + err);
    } finally {
      if (fetchResult != null) {
        fetchResult.close();
      }
    }
    return album;
  }

  async removeFileFromAlbum(albumUri: string, uri: string): Promise<boolean> {
    let album = await this.getUserAlbumItemByUri(albumUri);
    let fileAsset = await userFileModel.getMediaItemByUri(uri);
    if (album != null && fileAsset != null) {
      try {
        await album.removeAssets([fileAsset]);
        return true;
      } catch (err) {
        Log.error(TAG, 'album removePhotoAssets failed with error: ' + err);
      }
    }
    return false;
  }

  async getAllPhotoAlbum(albumDataItems: AlbumDataItem[]): Promise<void> {
    let photoFetchResult = null;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      let fetchOptions = {
        fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
        predicates: predicates
      };
      photoFetchResult = await userFileModel.getUserFileMgr().getAssets(fetchOptions);
      let count = photoFetchResult.getCount();
      Log.info(TAG, 'getAllPhotoAlbum count: ' + count);
      let displayName = '';
      let id = MediaConstants.ALBUM_ID_ALL;
      displayName = await getAlbumDisplayName(id);
      let albumItem: AlbumDataItem = new AlbumDataItem(id, count, displayName, this.selectType, this.deviceId, -1, -1);
      if (count > 0) {
        let fileAsset = await photoFetchResult.getFirstObject();
        await albumItem.update(fileAsset);
        Log.info(TAG, 'getFirstObject file displayName: ' + fileAsset.displayName);
      }
      albumDataItems.push(albumItem);
    } catch (err) {
      Log.error(TAG, 'get Album getPhotoAssets failed with err: ' + err);
    } finally {
      if (photoFetchResult != null) {
        photoFetchResult.close();
      }
    }
  }

  async getMovingPhotoAbstractAlbum(albumDataItems: AlbumDataItem[]): Promise<void> {
    let photoFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = null;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(MediaConstants.PHOTO_SUBTYPE, MediaConstants.MOVING_PHOTO);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
        predicates: predicates
      };
      photoFetchResult = await userFileModel.getUserFileMgr().getAssets(fetchOptions);
      let count = photoFetchResult.getCount();
      Log.info(TAG, 'getMovingPhotoAbstractAlbum count: ' + count);
      let id = MediaConstants.ALBUM_ID_MOVING_PHOTO;
      let albumName = await getAlbumDisplayName(id);
      let albumItem: AlbumDataItem = new AlbumDataItem(id, count, albumName, this.selectType, this.deviceId,
        MediaConstants.ABSTRACT_ALBUM_TYPE_MOVING_PHOTO, -1);
      if (count > 0) {
        let fileAsset = await photoFetchResult.getFirstObject();
        await albumItem.update(fileAsset);
        Log.info(TAG, 'first moving photo displayName: ' + fileAsset.displayName);
      }
      albumDataItems.push(albumItem);
    } catch (err) {
      Log.error(TAG, 'getMovingPhotoAbstractAlbum failed with err: ' + err);
    } finally {
      if (photoFetchResult != null) {
        photoFetchResult.close();
      }
    }
  }

  async reloadAlbumListItemData(): Promise<AlbumDataItem[]> {
    Log.info(TAG, 'reloadAlbumListItemData start');
    let albumDataItems: AlbumDataItem[] = [];
    for (let i = 0;i < MediaConstants.ALBUM_DEFAULT_SORT_LIST.length; i++) {
      await this.getAlbumItem(MediaConstants.ALBUM_DEFAULT_SORT_LIST[i], albumDataItems);
    }
    await this.getCommonListAlbumItem(albumDataItems);
    return albumDataItems;
  }

  private async getCommonListAlbumItem(albumDataItems: AlbumDataItem[]): Promise<void> {
    let predicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions = {
      fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
      predicates: predicates
    };
    let albums: photoAccessHelper.Album[] = await userFileModel.getAlbums(fetchOptions);
    await this.getAlbumDataItem(albumDataItems, albums);
  }

  private async getAlbumDataItem(albumDataItems: AlbumDataItem[], albums: photoAccessHelper.Album[]): Promise<void> {
    for (let i = 0;i < albums.length; i++) {
      let album: photoAccessHelper.Album = albums[i];
      if (this.blackList.indexOf(album.albumUri.toString()) >= 0) {
        continue;
      }
      let predicates = new dataSharePredicates.DataSharePredicates();
      let fetchOptions = {
        fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
        predicates: predicates
      };
      let fetchFileResult = await album.getAssets(fetchOptions);
      try {
        let count = fetchFileResult.getCount();
        if (count === 0) {
          continue;
        }
        let item = new AlbumDataItem(MediaConstants.ALBUM_ID_USER, count, album.albumName, this.selectType, this.deviceId, 0, 0);
        item.uri = album.albumUri;
        await item.update(await fetchFileResult.getFirstObject());
        albumDataItems.push(item);
      } catch (err) {
        Log.error(TAG, 'on err: ' + JSON.stringify(err));
      } finally {
        fetchFileResult.close();
      }
    }
  }
}
