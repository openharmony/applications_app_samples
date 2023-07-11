// @ts-nocheck
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
import fileIO from '@ohos.fileio';
import { stashOrGetObject } from '../utils/SingleInstanceUtils';
import { Log } from '../utils/Log';
import { startTrace, finishTrace } from '../utils/TraceControllerUtils';
import { hiSysEventDataQueryTimedOut } from '../utils/hisysEventUtil';
import userFileManager from '@ohos.filemanagement.userFileManager';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { MediaConstants } from '../constants/MediaConstants'

const TAG = 'UserFileModel'

export class UserFileModelItem {
  fileAsset: userFileManager.FileAsset;
  counts: number;
}

class UserFileModel {
  private userFileMgr: userFileManager.UserFileManager = undefined;

  constructor() {
  }

  onCreate(context): void {
    if (this.userFileMgr == undefined) {
      this.userFileMgr = userFileManager.getUserFileMgr(context);
    }
  }

  getUserFileMgr(): userFileManager.UserFileManager {
    return this.userFileMgr;
  }

  async createOne(displayName: string, albumUri: string): Promise<userFileManager.FileAsset> {
    Log.info(TAG, 'createOne displayName:' + displayName + ' albumUri: ' + albumUri);
    let fileAsset = await this.userFileMgr.createPhotoAsset(displayName, albumUri);
    let album = await this.getUserAlbumItemByUri(albumUri);
    await album.addPhotoAssets([fileAsset]);
    return fileAsset;
  }

  async getUserAlbumItemByUri(uri: string): Promise<userFileManager.Album> {
    let fetchResult = null
    let album: userFileManager.Album = null
    try {
      Log.info(TAG, 'getUserAlbumItemByUri');
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', uri)
      let fetchOptions = {
        fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
        predicates: predicates
      };
      fetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, fetchOptions);
      Log.info(TAG, 'get Album fetchResult, count: ' + fetchResult.getCount());
      if (fetchResult.getCount() > 0) {
        album = fetchResult.getFirstObject();
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

  async copyOne(source: userFileManager.FileAsset, target: userFileManager.FileAsset): Promise<void> {
    Log.info(TAG, 'copy start: src:' + source.uri + ' target: ' + target.uri);
    startTrace('openAssetR');
    let fd: Number = await this.openAsset('R', source);
    finishTrace('openAssetR');
    if (fd <= 0) {
      throw new Error('fd is invalid');
    }

    startTrace('openAssetRW');
    let targetFd: Number = await this.openAsset('RW', target);
    finishTrace('openAssetRW');
    if (targetFd <= 0) {
      throw new Error('targetFd is invalid');
    }

    startTrace('copyFile');
    await fileIO.copyFile(fd, targetFd);
    finishTrace('copyFile');

    startTrace('sourceClose');
    await this.closeAsset(fd, source);
    finishTrace('sourceClose');
    startTrace('targetClose');
    await this.closeAsset(targetFd, target);
    finishTrace('targetClose');

    Log.debug(TAG, 'copy end');
  }

  async deleteOne(uri: string): Promise<void> {
    Log.debug(TAG, 'deleteAsset uri: ' + uri);
    try {
      await this.userFileMgr.delete(uri);
    } catch (err) {
      Log.error(TAG, 'deleteOne with error: ' + err);
    }
  }

  async recover(fileAsset: userFileManager.FileAsset): Promise<void> {
    let albumFetchResult = null;
    try {
      Log.debug(TAG, 'recoverPhotoAssetsDemoPromise:' + fileAsset.displayName);
      albumFetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
      let album = await albumFetchResult.getFirstObject();
      Log.debug(TAG, 'album  get');
      album.recoverPhotoAssets([fileAsset]).then(() => {
        Log.debug(TAG, 'album recoverPhotoAssets successfully');
      }).catch((err) => {
        Log.info(TAG, 'album recoverPhotoAssets failed with error: ' + err);
      });
    } catch (err) {
      Log.error(TAG, 'recoverPhotoAssetsDemoPromise failed with error: ' + err);
    } finally {
      if (albumFetchResult != null) {
        albumFetchResult.close();
      }
    }
  }

  async permanentDelete(fileAsset: userFileManager.FileAsset): Promise<void> {
    let albumFetchResult = null;
    try {
      Log.debug(TAG, 'permanentDelete');
      albumFetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
      let album = await albumFetchResult.getFirstObject();
      album.deletePhotoAssets([fileAsset]).then(() => {
        Log.debug('album deletePhotoAssets successfully');
      }).catch((err) => {
        Log.error(TAG, 'album deletePhotoAssets failed with error: ' + err);
      });
    } catch (err) {
      Log.error(TAG, 'permanentDelete failed with error: ' + err);
    } finally {
      if (albumFetchResult != null) {
        albumFetchResult.close();
      }
    }
  }

  async deleteAlbum(albumName: string): Promise<void> {
    let fetchResult = null;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('album_name', albumName)
      let fetchOptions = {
        fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
        predicates: predicates
      };
      fetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, fetchOptions);
      for (let i = 0; i < fetchResult.getCount(); i++) {
        let albumAsset = await fetchResult.getPositionObject(i);
        Log.info(TAG, 'deleteAlbum albumUri' + albumAsset.albumUri);
        Log.info(TAG, 'deleteAlbum albumName' + albumAsset.albumName);
        this.userFileMgr.deleteAlbums([albumAsset]).then(() => {
          Log.info(TAG, 'deletePhotoAlbumsPromise successfully');
        }).catch((err) => {
          Log.error(TAG, 'deletePhotoAlbumsPromise failed with err: ' + err);
        });
      }
    } catch (err) {
      Log.error(TAG, 'deletePhotoAlbumsPromise failed with error: ' + err);
    } finally {
      if (fetchResult != null) {
        fetchResult.close();
      }
    }
  }

  async deleteAll(fetchOption: userFileManager.FetchOptions): Promise<void> {
    Log.info(TAG, 'deleteAll');
    startTrace('deleteAll');
    let fetchFileResult: userFileManager.FetchResult = null;
    try {
      fetchFileResult = await this.userFileMgr.getPhotoAssets(fetchOption);
      Log.debug(TAG, 'deleteAll getPhotoAssets');
      let deleteAllGetAllObject = hiSysEventDataQueryTimedOut('deleteAllGetAllObject')
      let fileAssets: userFileManager.FileAsset[] = await fetchFileResult.getAllObject();
      clearTimeout(deleteAllGetAllObject);
      for (let i = 0;i < fileAssets.length; i++) {
        await deleteOne(fileAssets[i].uri);
      }
      Log.debug(TAG, 'deleteAll getFirstObject');
    } catch (err) {
      Log.error(TAG, 'deleteAll error:' + JSON.stringify(err));
    } finally {
      if (fetchFileResult != null) {
        fetchFileResult.close();
      }
    }
    finishTrace('deleteAll');
    Log.debug(TAG, 'deleteAll finish');
  }

  async getAllMediaItems(): Promise<userFileManager.FileAsset[]> {
    let fileAssets: userFileManager.FileAsset[] = [];
    let photoFetchResult = null
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      let emptyFetchOption = {
        fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
        predicates: predicates
      };
      photoFetchResult = await this.userFileMgr.getPhotoAssets(emptyFetchOption);
      Log.info(TAG, 'getAllMediaItems count: ' + photoFetchResult.getCount());
      for (let i = 0;i < photoFetchResult.getCount(); i++) {
        fileAssets.push(await photoFetchResult.getPositionObject(i));
      }
    } catch (err) {
      Log.error(TAG, 'getAllMediaItems failed with err: ' + err);
    } finally {
      if (photoFetchResult != null) {
        photoFetchResult.close();
      }
    }
    return fileAssets
  }

  async getAllMediaItemsByType(type: number, subType: number, albumFetchOption, fileFetchOption): Promise<userFileManager.FileAsset[]> {
    let fileAssets: userFileManager.FileAsset[] = [];
    let fetchResult = null
    try {
      Log.info(TAG, 'getAllMediaItemsByUserFile');
      Log.info(TAG, 'type:' + type);
      Log.info(TAG, 'subType:' + subType);
      if (type == userFileManager.AlbumType.USER && albumFetchOption != null) {
        Log.info(TAG, 'albumFetchOption ！= null');
        fetchResult = await this.userFileMgr.getAlbums(type, subType, albumFetchOption);
      } else {
        fetchResult = await this.userFileMgr.getAlbums(type, subType);
      }
      Log.info(TAG, 'get Album fetchResult, count: ' + fetchResult.getCount());
      for (let i = 0; i < fetchResult.getCount(); i++) {
        let albumAsset = await fetchResult.getPositionObject(i);
        let photoFetchResult = null
        try {

          photoFetchResult = await albumAsset.getPhotoAssets(fileFetchOption);
          for (let i = 0; i < photoFetchResult.getCount(); i++) {
            let photoAsset = await photoFetchResult.getPositionObject(i);
            fileAssets.push(photoAsset)
            Log.info(TAG, 'getPhotoAssets successfully, file displayName: ' + photoAsset.displayName);
          }
        } catch (err) {
          Log.info(TAG, 'get Album getPhotoAssets failed with err: ' + err);
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
    Log.info(TAG, 'fileAssets: ' + fileAssets.length);
    return fileAssets;
  }

  async getMediaItemByUriFromTrash(uri: string): Promise<userFileManager.FileAsset> {
    Log.info(TAG, 'getMediaItemByUriFromTrash');
    Log.info(TAG, 'uri:' + uri);
    let albumFetchResult = null;
    let fileAsset: userFileManager.FileAsset = null;
    try {
      albumFetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.SYSTEM, userFileManager.AlbumSubType.TRASH);
      let albumAsset = await albumFetchResult.getFirstObject();
      let photoFetchResult = null
      try {
        let predicates = new dataSharePredicates.DataSharePredicates();
        let emptyFetchOption = {
          fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
          predicates: predicates
        };
        photoFetchResult = await albumAsset.getPhotoAssets(emptyFetchOption);
        for (let i = 0; i < photoFetchResult.getCount(); i++) {
          let photoAsset = await photoFetchResult.getPositionObject(i);
          if (photoAsset.uri == uri) {
            fileAsset = photoAsset;
            Log.info(TAG, 'getMediaItemByUriFromTrash success: ' + photoAsset.displayName);
            break;
          }
        }
      } catch (err) {
        Log.info(TAG, 'getMediaItemByUriFromTrash getPhotoAssets failed with err: ' + err);
      } finally {
        if (photoFetchResult != null) {
          photoFetchResult.close();
        }
      }
    } catch (err) {
      Log.error(TAG, 'getMediaItemByUriFromTrash failed with error: ' + err);
    } finally {
      if (albumFetchResult != null) {
        albumFetchResult.close();
      }
    }
    return fileAsset;
  }

  async getMediaItemByUri(uri: string): Promise<userFileManager.FileAsset> {
    Log.info(TAG, 'getMediaItemByUri');
    Log.info(TAG, 'uri:' + uri);
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('uri', uri)
    let fetchOptions = {
      fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
      predicates: predicates
    };
    let fileAsset: userFileManager.FileAsset = null;
    let fetchResult = null
    try {
      Log.info(TAG, 'fetchResult start');
      fetchResult = await this.userFileMgr.getPhotoAssets(fetchOptions);
      Log.info(TAG, 'fetchResult count ' + fetchResult.getCount());
      fileAsset = await fetchResult.getFirstObject();
      Log.info(TAG, 'fileAsset ' + fileAsset.displayName);
    } catch (err) {
      Log.error(TAG, 'getMediaItemByUri failed, message = ' + err);
    } finally {
      if (fetchResult != null) {
        fetchResult.close();
      }
    }
    return fileAsset;
  }

  async getMediaItemCountsByDisplayName(displayName: string): Promise<number> {
    Log.info(TAG, 'getMediaItemCountsByDisplayName');
    let count = 0;
    let fetchFileResult: userFileManager.FetchResult = null;
    let predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('display_name', 'displayName')
    let fetchOptions = {
      fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
      predicates: predicates
    };
    try {
      fetchFileResult = await this.userFileMgr.getPhotoAssets(fetchOptions);
      Log.debug(TAG, 'getMediaItemCountsByDisplayName getPhotoAssets');
      count = await fetchFileResult.getCount()
    } catch (err) {
      Log.error(TAG, 'getMediaItemCountsByDisplayName error:' + JSON.stringify(err));
    } finally {
      if (fetchFileResult != null) {
        fetchFileResult.close();
      }
    }
    Log.debug(TAG, 'getMediaItemCountsByDisplayName finish');
    return count;
  }

  async getUserAlbumCountByName(albumName: string): Promise<number> {
    Log.info(TAG, 'getUserAlbumCountByName');
    Log.info(TAG, 'album_name：' + albumName);
    startTrace('getUserAlbumCountByName');
    let count = 0;
    let fetchResult: userFileManager.FetchResult = null;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('album_name', albumName)
      let fetchOptions = {
        fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
        predicates: predicates
      };
      fetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, fetchOptions);
      Log.info(TAG, 'fetchResult' + fetchResult.getCount());
      count = fetchResult.getCount()
    } catch (err) {
      Log.error(TAG, 'getUserAlbumCountByName error:' + JSON.stringify(err));
    } finally {
      if (fetchResult != null) {
        fetchResult.close();
      }
    }
    finishTrace('getUserAlbumCountByName');
    Log.debug(TAG, 'getUserAlbumCountByName finish');
    return count;
  }

  async getActivePeers(): Promise<userFileManager.PeerInfo[]> {
    Log.info(TAG, 'getActivePeers');
    startTrace('getActivePeers');
    let peers: userFileManager.PeerInfo[] = [];
    try {
      let getActivePeers = hiSysEventDataQueryTimedOut('getActivePeers')
      peers = await this.userFileMgr.getActivePeers();
      clearTimeout(getActivePeers);
    } catch (err) {
      Log.error(TAG, 'getActivePeers error:' + JSON.stringify(err));
    }
    finishTrace('getActivePeers');
    Log.debug(TAG, 'getActivePeers finish');
    return peers;
  }

  async getUserAlbumByName(albumName: string): Promise<userFileManager.Album> {
    Log.info(TAG, 'getUserAlbumByName');
    Log.info(TAG, 'album_name' + albumName);
    startTrace('getUserAlbumByName');
    let fetchResult: userFileManager.FetchResult = null;
    let album = null;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('album_name', albumName)
      let fetchOptions = {
        fetchColumns: MediaConstants.EMPTY_FETCH_COLUMNS,
        predicates: predicates
      };
      fetchResult = await this.userFileMgr.getAlbums(userFileManager.AlbumType.USER, userFileManager.AlbumSubType.USER_GENERIC, fetchOptions);
      Log.info(TAG, 'fetchResult' + fetchResult.getCount());
      if (fetchResult.getCount() > 0) {
        album = fetchResult.getFirstObject();
      }
    } catch (err) {
      Log.error(TAG, 'getUserAlbumByName error:' + JSON.stringify(err));
    } finally {
      if (fetchResult != null) {
        fetchResult.close();
      }
    }
    finishTrace('getUserAlbumByName');
    Log.debug(TAG, 'getUserAlbumByName finish');
    return album;
  }

  async getAlbums(fetchOption: userFileManager.FetchOptions): Promise<userFileManager.Album[]> {
    Log.info(TAG, 'getAlbums');
    let albums: userFileManager.Album[] = [];
    try {
      albums = await this.userFileMgr.getAlbums(fetchOption);
      Log.info(TAG, 'getAlbums albums ' + albums.getCounts());
    } catch (err) {
      Log.error(TAG, 'getAlbums error:' + JSON.stringify(err));
    }
    Log.debug(TAG, 'getAlbums finish');
    return albums;
  }

  async openAsset(mode: string, fileAsset: userFileManager.FileAsset): Promise<number> {
    Log.debug(TAG, 'openAsset start');
    let fd: number = await fileAsset.open(mode);
    Log.info(TAG, 'openAsset end. fd: ' + fd);
    if (fd <= 0) {
      Log.info(TAG, 'openAsset Fail');
    }
    return fd;
  }

  async closeAsset(fd: number, fileAsset: userFileManager.FileAsset): Promise<void> {
    Log.debug(TAG, 'closeAsset start');
    await fileAsset.close(fd);
  }

  async addPhotoToAlbumByUserFileMgr(albumUri: string, uri: string) {
    Log.info(TAG, 'addPhotoAssetsDemoPromise');
    Log.info(TAG, 'albumUri' + albumUri);
    Log.info(TAG, 'mediaItem.uri' + uri);
    try {
      let album = await this.getUserAlbumItemByUri(albumUri);
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', uri)
      let fetchOptions = {
        fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
        predicates: predicates
      };
      this.userFileMgr.getPhotoAssets(fetchOptions, async (err, fetchResult) => {
        if (fetchResult != undefined) {
          Log.info(TAG, 'fetchResult success');
          let fileAsset = await fetchResult.getFirstObject();
          if (fileAsset != undefined) {
            Log.info(TAG, 'addPhotoToAlbumByUserFileMgr photo displayName : ' + fileAsset.displayName);
            album.addPhotoAssets([fileAsset]).then(() => {
              Log.info(TAG, 'album addPhotoAssets successfully');
            }).catch((err) => {
              Log.info(TAG, 'album addPhotoAssets failed with error: ' + err);
            });
          }
          fetchResult.close();
        } else {
          Log.info(TAG, 'fetchResult fail' + err);
        }
      });
    } catch (err) {
      Log.error(TAG, 'addPhotoAssetsDemoPromise failed with error: ' + err);
    }
  }
}

export let userFileModel: UserFileModel = stashOrGetObject<UserFileModel>(new UserFileModel(), TAG);
