/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import Logger from '../../utils/Logger';
import { BusinessError } from '@ohos.base';
import image from '@ohos.multimedia.image';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import userFileManager from '@ohos.filemanagement.userFileManager';

/**
 * 主要封装了userFileManager库相关的接口
 */
class MediaLibraryManager {
  requestPermission(context): void {
    let permissions: Array<Permissions> = [
      'ohos.permission.WRITE_IMAGEVIDEO',
      'ohos.permission.READ_IMAGEVIDEO',
      'ohos.permission.FILE_ACCESS_MANAGER',
      'ohos.permission.READ_AUDIO',
      'ohos.permission.READ_WRITE_DOWNLOAD_DIRECTORY',
      'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED'
    ]
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(context, permissions, (code, result) => {
      Logger.debug('permissionRequest ' + JSON.stringify(code) + ' Result: ' + JSON.stringify(result))
    })
  }

  async getPixelMapByFileAsset(fileAsset: userFileManager.FileAsset): Promise<image.PixelMap> {
    if (fileAsset == undefined) {
      Logger.error('fileAsset undefined')
      // 异常情况下统一返回undefined，不建议使用null
      return undefined
    }
    Logger.debug('begin getPixelMapByFileAsset:' + fileAsset.displayName)
    let fd: number = undefined
    let pixelMap = undefined
    try {
      fd = await fileAsset.open('rw')
      Logger.debug('getPixelMapByFileAsset fd: ' + fd)
      let imageSource = image.createImageSource(fd)
      Logger.debug('imageSource: ' + JSON.stringify(imageSource))
      let decodingOptions = {
        sampleSize: 1,
        editable: true,
        desiredSize: { width: 3000, height: 4000 },
        rotate: 0,
        desiredPixelFormat: 3,
        desiredRegion: { size: { height: 6000, width: 8000 }, x: 0, y: 0 },
        index: 0
      }
      pixelMap = await imageSource.createPixelMap(decodingOptions)
      Logger.debug('pixel size: ' + pixelMap.getPixelBytesNumber())
      fileAsset.close(fd)
    } catch (err) {
      Logger.debug('err: ' + JSON.stringify(err))
    }
    return pixelMap
  }


  async getFileAssets(context, fileType: userFileManager.FileType): Promise<userFileManager.FetchResult<userFileManager.FileAsset>> {
    let mgr = userFileManager.getUserFileMgr(context);
    let fileKeyObj = userFileManager.ImageVideoKey;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: [],
      predicates: predicates.equalTo(fileKeyObj.FILE_TYPE.toString(), fileType)
    };
    let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset>;
    if (fileType === userFileManager.FileType.IMAGE || fileType === userFileManager.FileType.VIDEO) {
      fetchResult = await mgr.getPhotoAssets(fetchOptions);
    } else if (fileType === userFileManager.FileType.AUDIO) {
      fetchResult = await mgr.getAudioAssets(fetchOptions);
    }
    return fetchResult;
  }

  async getFileAssetsByName(context, name: string): Promise<userFileManager.FileAsset> {
    let mgr = userFileManager.getUserFileMgr(context);
    Logger.debug('begin getFileAssetsByName: ' + name);
    let fileKeyObj = userFileManager.ImageVideoKey;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: [],
      predicates: predicates.equalTo(fileKeyObj.DISPLAY_NAME.toString(), name.toString())
    };
    let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset>;
    let file: userFileManager.FileAsset = undefined;
    try {
      fetchResult = await mgr.getPhotoAssets(fetchOptions);
      file = await fetchResult.getFirstObject();
    } catch (error) {
      Logger.error('fetchFileResult Error: ' + JSON.stringify(error));
    }
    return file;
  }

  async getThumbnail(fileAsset: userFileManager.FileAsset): Promise<image.PixelMap> {
    let thumbnail: image.PixelMap = undefined;
    await fileAsset.getThumbnail().then((pixelMap) => {
      thumbnail = pixelMap;
      Logger.info('getThumbnail successful ' + pixelMap);
    }).catch((err: BusinessError) => {
      Logger.error('getThumbnail fail' + err);
    });
    return thumbnail;
  }

  async createFileAsset(context, mediaType: userFileManager.FileType, fileName: string): Promise<userFileManager.FileAsset> {
    Logger.debug('createFileAsset: ' + fileName);
    let mgr = userFileManager.getUserFileMgr(context);
    if (mediaType === 1 || mediaType === 2) {
      let fileAsset: userFileManager.FileAsset = undefined;
      try {
        let createOption: userFileManager.PhotoCreateOptions = {
          subType: userFileManager.PhotoSubType.DEFAULT
        }
        fileAsset = await mgr.createPhotoAsset(fileName, createOption);
        Logger.info('createPhotoAsset successfully file displayName' + fileAsset.displayName);
      } catch (err) {
        Logger.error('createPhotoAsset failed, message = ', err);
      }
      return fileAsset;
    } else if (mediaType === 3) {
      let fileAsset: userFileManager.FileAsset = undefined;
      try {
        fileAsset = await mgr.createAudioAsset(fileName);
      } catch (err) {
        Logger.error('createAudioAsset failed, message = ', err);
      }
      return fileAsset;
    }
  }

  async deleteFileAsset(context, fileAsset: userFileManager.FileAsset): Promise<void> {
    try {
      let mgr = userFileManager.getUserFileMgr(context);
      await mgr.delete(fileAsset.uri);
      Logger.info('delete successfully');
    } catch (err) {
      Logger.error('delete failed with error: ' + err);
    }
  }
}

export default new MediaLibraryManager()