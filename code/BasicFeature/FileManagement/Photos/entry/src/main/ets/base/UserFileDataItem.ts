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
import { ViewType } from '../models/ViewType';
import { userFileModel } from './UserFileModel';
import { MediaConstants } from '../constants/MediaConstants';
import { selectManager } from '../common/SelectManager';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { screenManager } from '../common/ScreenManager';

const TAG = 'UserFileDataItem';
const STATUS_UNDEFINED = -1;
const STATUS_FALSE = 0;
const STATUS_TRUE = 1;

export interface DateAdded {
  dateAdded: number;
  viewType: ViewType;
}

export class UserFileDataItem implements DateAdded {
  viewType: ViewType = ViewType.ITEM;
  readonly hashIndex: number;
  index: number;
  dateAdded: number = 0;
  dateModified: number;
  dateTaken: number;
  status: number = MediaConstants.UNDEFINED;
  isSelect: boolean = false;
  uri: string;
  orientation: number;
  duration: number;
  size: number;
  width: number; // width changed by orientation
  height: number; // height changed by orientation
  imgWidth: number; // may be smaller than width, as width is too large
  imgHeight: number; // may be smaller than height, as height is too large
  path: string = '';
  title: string;
  displayName: string;
  mediaType: photoAccessHelper.PhotoType;
  favouriteStatus: number = STATUS_UNDEFINED;
  canRotate: number = STATUS_UNDEFINED;
  selections: string = '';
  selectionArgs: string[] = [];
  deviceId: string = '';
  fileAsset: photoAccessHelper.PhotoAsset = undefined;
  defaultThumbnail: PixelMap = undefined;
  thumbnailArray: Map<string, PixelMap> = new Map<string, PixelMap>();

  constructor(selections: string, selectionArgs: string[], deviceId: string, index: number) {
    this.selections = selections;
    this.selectionArgs = selectionArgs;
    this.deviceId = deviceId;
    this.hashIndex = index;
    this.index = index;
  }

  getHashCode(): string {
    // 时间线界面角度，收藏状态变更，都需要刷新界面；大图浏览界面角度变更，需要刷新界面
    return this.status === MediaConstants.UNDEFINED ?
      '' + this.hashIndex :
      this.uri + this.favouriteStatus + ' ' + this.orientation + ' ' + this.isSelect;
  }

  async loadFileAsset(): Promise<photoAccessHelper.PhotoAsset> {
    return await userFileModel.getMediaItemByUri(this.uri);
  }

  isLoad(): boolean {
    if (this.status > MediaConstants.UNDEFINED) {
      return true;
    }
    return false;
  }

  async load(isForce: boolean): Promise<void> {
    Log.info(TAG, 'load ' + this.status);
    if (this.status > (isForce ? MediaConstants.PART_LOADED : MediaConstants.UNDEFINED)) {
      return;
    }
    let fileAsset = await this.loadFileAsset();
    if (fileAsset != null) {
      this.update(fileAsset);
    }
    return;
  }

  async update(fileAsset: photoAccessHelper.PhotoAsset): Promise<void> {
    this.fileAsset = fileAsset;
    this.uri = fileAsset.uri;
    this.displayName = fileAsset.displayName;
    this.mediaType = fileAsset.photoType;
    this.width = screenManager.getWinWidth();
    this.height = screenManager.getWinHeight();
    this.orientation = MediaConstants.ROTATE_NONE;
    try {
      this.orientation = fileAsset.get(photoAccessHelper.PhotoKeys.ORIENTATION.toString()) as number;
      Log.info(TAG, 'orientation ' + this.orientation);
    } catch (err) {
      Log.error(TAG, 'get orientation ' + JSON.stringify(err));
    }
    try {
      this.duration = fileAsset.get(photoAccessHelper.PhotoKeys.DURATION.toString()) as number;
      Log.info(TAG, 'duration ' + this.duration);
    } catch (err) {
      Log.error(TAG, 'get duration ' + JSON.stringify(err));
    }
    try {
      if (this.orientation === MediaConstants.ROTATE_ONCE || this.orientation === MediaConstants.ROTATE_THIRD) {
        this.width = fileAsset.get(photoAccessHelper.PhotoKeys.HEIGHT.toString()) as number;
        this.height = fileAsset.get(photoAccessHelper.PhotoKeys.WIDTH.toString()) as number;
      } else {
        this.width = fileAsset.get(photoAccessHelper.PhotoKeys.WIDTH.toString()) as number;
        this.height = fileAsset.get(photoAccessHelper.PhotoKeys.HEIGHT.toString()) as number;
      }
      Log.info(TAG, 'width ' + this.width);
      Log.info(TAG, 'height ' + this.height);
    } catch (err) {
      Log.error(TAG, 'get width height ' + JSON.stringify(err));
    }
    try {
      this.title = fileAsset.get(photoAccessHelper.PhotoKeys.TITLE.toString()) as string;
      Log.info(TAG, 'title ' + this.title);
    } catch (err) {
      Log.error(TAG, 'get title ' + JSON.stringify(err));
    }
    try {
      this.dateAdded = fileAsset.get(photoAccessHelper.PhotoKeys.DATE_ADDED.toString()) as number * 1000;
      this.dateModified = fileAsset.get(photoAccessHelper.PhotoKeys.DATE_MODIFIED.toString()) as number * 1000;
      this.dateTaken = fileAsset.get(photoAccessHelper.PhotoKeys.DATE_TAKEN.toString()) as number * 1000;
      Log.info(TAG, 'dateAdded ' + this.dateAdded);
    } catch (err) {
      Log.error(TAG, 'get date ' + JSON.stringify(err));
    }
    try {
      this.favouriteStatus = fileAsset.get(photoAccessHelper.PhotoKeys.FAVORITE.toString()) as boolean ? STATUS_TRUE : STATUS_FALSE
      Log.info(TAG, 'favouriteStatus ' + this.favouriteStatus);
    } catch (err) {
      Log.error(TAG, 'get favouriteStatus ' + JSON.stringify(err));
    }
    try {
      this.size = fileAsset.get(photoAccessHelper.PhotoKeys.SIZE.toString()) as number;
      Log.info(TAG, 'size ' + this.size);
    } catch (err) {
      Log.error(TAG, 'get favouriteStatus ' + JSON.stringify(err));
    }
    let size = { width: MediaConstants.DEFAULT_SIZE, height: MediaConstants.DEFAULT_SIZE };
    if (fileAsset != null && this.defaultThumbnail == undefined) {
      try {
        this.defaultThumbnail = await this.fileAsset.getThumbnail(size);
      } catch (err) {
        Log.error(TAG, 'getThumbnail error: ' + JSON.stringify(err));
      }
    }
    this.isSelect = selectManager.isSelect(this.uri, this.isSelect);
    this.imgWidth = this.width;
    this.imgHeight = this.height;
    if (this.width > 0 && this.height > 0) {
      this.status = MediaConstants.LOADED;
    } else {
      this.status = MediaConstants.PART_LOADED;
    }
  }

  async getThumbnail(width: number, height: number): Promise<PixelMap> {
    Log.debug(TAG, 'getThumbnail ' + this.status);
    if (this.status !== MediaConstants.LOADED && this.status !== MediaConstants.PART_LOADED) {
      Log.warn(TAG, 'getThumbnail fail as status: ' + this.status);
      return undefined;
    }
    if (width === MediaConstants.DEFAULT_SIZE && height === MediaConstants.DEFAULT_SIZE) {
      return this.defaultThumbnail;
    }
    let newThumbnail: PixelMap = undefined;
    let size = { width: width, height: height };
    let cacheThumbnail = this.thumbnailArray.get(width.toString() + height.toString());
    if (cacheThumbnail != null) {
      return cacheThumbnail;
    }
    if (this.fileAsset != undefined) {
      try {
        newThumbnail = await this.fileAsset.getThumbnail(size);
        this.thumbnailArray.set(width.toString() + height.toString(), newThumbnail);
      } catch (err) {
        Log.error(TAG, 'getThumbnail error: ' + JSON.stringify(err));
      }
    }
    return newThumbnail;
  }

  getAlt(): Resource {
    if (this.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      return $r('app.media.alt_video_placeholder');
    } else {
      return $r('app.media.alt_placeholder');
    }
  }

  setSelect(isSelect: boolean): void {
    this.isSelect = isSelect;
    selectManager.setSelect(this.uri, this.isSelect);
  }

  async onDelete(): Promise<boolean> {
    try {
      await userFileModel.deleteOne(this.uri);
      selectManager.deleteSelect(this.uri);
      this.status = MediaConstants.TRASHED;
      return true;
    } catch (err) {
      Log.error(TAG, 'onDelete ' + this.index + ' error: ' + JSON.stringify(err));
      return false;
    }
  }

  async addToAlbum(albumUri:string): Promise<boolean> {
    try {
      await userFileModel.addPhotoToAlbumByUserFileMgr(albumUri, this.uri);
      selectManager.deleteSelect(this.uri);
      this.status = MediaConstants.TRASHED;
      return true;
    } catch (err) {
      Log.error(TAG, 'addToAlbum ' + this.index + ' error: ' + JSON.stringify(err));
      return false;
    }
  }

  isDeleted(): boolean {
    return this.status === MediaConstants.TRASHED;
  }

  async isFavor(): Promise<boolean> {
    if (this.favouriteStatus === STATUS_UNDEFINED) {
      let fileAsset = await this.loadFileAsset();
      try {
        this.favouriteStatus = (fileAsset.get(photoAccessHelper.PhotoKeys.FAVORITE.toString()) as boolean) ? STATUS_TRUE : STATUS_FALSE;
      } catch (err) {
        Log.error(TAG, 'isFavor error: ' + JSON.stringify(err));
      }
    }
    return this.favouriteStatus === STATUS_TRUE;
  }

  async setFavor(): Promise<boolean> {
    let status = !(await this.isFavor());
    try {
      let fileAsset = await this.loadFileAsset();
      await fileAsset.setFavorite(status);
      this.favouriteStatus = status ? STATUS_TRUE : STATUS_FALSE;
      return true;
    } catch (err) {
      return false;
    }
  }

  async setName(name: string): Promise<void> {
    let fileAsset = await this.loadFileAsset();
    let displayName = fileAsset.displayName;
    let index = displayName.lastIndexOf('.');
    displayName = name + displayName.slice(index);
    this.displayName = displayName;
    this.title = name;
    try {
      fileAsset.set(photoAccessHelper.PhotoKeys.TITLE.toString(), name);
      await fileAsset.commitModify();
    } catch (err) {
      Log.error(TAG, 'setName error: ' + JSON.stringify(err));
    }
  }
}
