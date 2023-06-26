/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import DateTimeUtil from '../utlis/DateTimeUtil';
import Logger from '../utlis/Logger';

const TAG = '[MediaModel]';

type FileInfo = {
  prefix: string;
  suffix: string;
  directory: number;
};

export default class MediaModel {
  private mediaLibraryTest: mediaLibrary.MediaLibrary = undefined;
  private static mediaInstance: MediaModel = undefined;

  constructor() {
    this.mediaLibraryTest = mediaLibrary.getMediaLibrary(globalThis.cameraContext);
  }

  public static getMediaInstance(): MediaModel {
    if (this.mediaInstance === undefined) {
      this.mediaInstance = new MediaModel();
    }
    return this.mediaInstance;
  }

  async createAndGetUri(mediaType: mediaLibrary.MediaType): Promise<mediaLibrary.FileAsset> {
    let dateTimeUtil: DateTimeUtil = new DateTimeUtil();
    let info: FileInfo = this.getInfoFromMediaType(mediaType);
    let name: string = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`;
    let displayName: string = `${info.prefix}${name}${info.suffix}`;
    Logger.info(TAG, `displayName = ${displayName},mediaType = ${mediaType}`);
    let publicPath: string = await this.mediaLibraryTest.getPublicDirectory(
      info.directory
    );
    Logger.info(TAG, `publicPath = ${publicPath}`);
    let fileAsset: mediaLibrary.FileAsset = await this.mediaLibraryTest.createAsset(
      mediaType,
      displayName,
      publicPath
    );
    return fileAsset;
  }

  async getFile(dataUri: mediaLibrary.FileAsset): Promise<mediaLibrary.FileAsset> {
    let fileKeyObj = mediaLibrary.FileKey;
    if (dataUri !== undefined) {
      let args = dataUri.id.toString();
      let fetchOp = {
        selections: `${fileKeyObj.ID}=?`,
        selectionArgs: [args],
      };
      const fetchFileResult: mediaLibrary.FetchFileResult = await this.mediaLibraryTest.getFileAssets(
        fetchOp
      );
      Logger.info(
        TAG,
        `fetchFileResult.getCount() = ${fetchFileResult.getCount()}`
      );
      const fileAssets = await fetchFileResult.getAllObject();
      let fileAsset: mediaLibrary.FileAsset = fileAssets[0];
      return fileAsset;
    }
    return null;
  }

  async getFdPath(fileAsset: mediaLibrary.FileAsset): Promise<number> {
    let fd: number = await fileAsset.open('Rw');
    Logger.info(TAG, `fd = ${fd}`);
    return fd;
  }

  async getFileAssetsFromMediaType(mediaType: number): Promise<Array<mediaLibrary.FileAsset>> {
    Logger.info(TAG, `getFileAssetsFromType,mediaType = ${mediaType}`);
    let fileKeyObj = mediaLibrary.FileKey;
    let fileAssets: Array<mediaLibrary.FileAsset> = [];

    try {
      let fetchOp = {
        selections: `${fileKeyObj.MEDIA_TYPE}=?`,
        selectionArgs: [`${mediaType}`],
      };
      const fetchFileResult: mediaLibrary.FetchFileResult = await this.mediaLibraryTest.getFileAssets(
        fetchOp
      );
      Logger.info(TAG, `getFileAssetsFromType,fetchFileResult.count = ${fetchFileResult.getCount()}`);
      if (fetchFileResult.getCount() > 0) {
        fileAssets = await fetchFileResult.getAllObject();
      }
    } catch (err) {
      console.info(`LSQ: err ${JSON.stringify(err)}`);
    }
    return fileAssets;
  }

  onDateChange(callback: () => void): void {
    this.mediaLibraryTest.on('albumChange', () => {
      Logger.info(TAG, 'albumChange called');
      callback();
    });
    this.mediaLibraryTest.on('imageChange', () => {
      Logger.info(TAG, 'imageChange called');
      callback();
    });
    this.mediaLibraryTest.on('audioChange', () => {
      Logger.info(TAG, 'audioChange called');
      callback();
    });
    this.mediaLibraryTest.on('videoChange', () => {
      Logger.info(TAG, 'videoChange called');
      callback();
    });
    this.mediaLibraryTest.on('fileChange', () => {
      Logger.info(TAG, 'fileChange called');
      callback();
    });
  }

  offDateChange(): void {
    this.mediaLibraryTest.off('albumChange');
    this.mediaLibraryTest.off('imageChange');
    this.mediaLibraryTest.off('audioChange');
    this.mediaLibraryTest.off('videoChange');
    this.mediaLibraryTest.off('fileChange');
  }

  getInfoFromMediaType(mediaType: mediaLibrary.MediaType): FileInfo {
    let fileInfo: FileInfo = {
      prefix: '',
      suffix: '',
      directory: 0
    };
    switch (mediaType) {
      case mediaLibrary.MediaType.FILE:
        fileInfo.prefix = 'FILE_';
        fileInfo.suffix = '.txt';
        fileInfo.directory = mediaLibrary.DirectoryType.DIR_DOCUMENTS;
        break;
      case mediaLibrary.MediaType.IMAGE:
        fileInfo.prefix = 'IMG_';
        fileInfo.suffix = '.jpg';
        fileInfo.directory = mediaLibrary.DirectoryType.DIR_IMAGE;
        break;
      case mediaLibrary.MediaType.VIDEO:
        fileInfo.prefix = 'VID_';
        fileInfo.suffix = '.mp4';
        fileInfo.directory = mediaLibrary.DirectoryType.DIR_VIDEO;
        break;
      case mediaLibrary.MediaType.AUDIO:
        fileInfo.prefix = 'AUD_';
        fileInfo.suffix = '.wav';
        fileInfo.directory = mediaLibrary.DirectoryType.DIR_AUDIO;
        break;
    }
    return fileInfo;
  }
}
