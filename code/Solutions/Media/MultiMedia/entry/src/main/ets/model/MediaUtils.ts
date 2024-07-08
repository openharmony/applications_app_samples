/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import userFileManager from '@ohos.filemanagement.userFileManager'
import fileAccess from '@ohos.file.fileAccess';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import DateTimeUtil from '../model/DateTimeUtil'
import Logger from '../model/Logger'
import common from '@ohos.app.ability.common';

export enum FileType {
  IMAGE = 1,
  VIDEO = 2,
  AUDIO = 3,
  FILE= 4
}

export default class MediaUtils {
  private tag: string = 'MediaUtils'
  private mediaTest: userFileManager.UserFileManager = undefined
  private static instance: MediaUtils = undefined

  public static getInstance(context: any) {
    if (this.instance === undefined) {
      this.instance = new MediaUtils(context)
    }
    return this.instance
  }

  constructor(context: any) {
    this.mediaTest = userFileManager.getUserFileMgr(context)
  }

  async createAndGetUri(mediaType: number): Promise<userFileManager.FileAsset> {
    let info = this.getInfoFromType(mediaType)
    let dateTimeUtil = new DateTimeUtil()
    let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
    let displayName = `${info.prefix}${name}${info.suffix}`
    Logger.info(this.tag, `displayName = ${displayName},mediaType = ${mediaType}`)
    let fetchFileResult: userFileManager.FileAsset = undefined;
    // 新建音频资源
    if (mediaType === FileType.AUDIO) {
      fetchFileResult = await this.mediaTest.createAudioAsset(displayName);
    } else {
      // 新建图片/视频资源
      fetchFileResult = await this.mediaTest.createPhotoAsset(displayName);
    }
    return fetchFileResult;
  }

  async getFdPath(fileAsset: any) {
    let fd = await fileAsset.open('Rw')
    Logger.info(this.tag, `fd = ${fd}`)
    return fd
  }

  async createFile(mediaType: number, context: common.UIAbilityContext) {
    let info = this.getInfoFromType(mediaType)
    let dateTimeUtil = new DateTimeUtil()
    let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
    let displayName = `${info.prefix}${name}${info.suffix}`
    Logger.info(this.tag, `displayName = ${displayName},mediaType = ${mediaType}`)
    let fd: number = -1;

    try {
      let fileAccessHelper = fileAccess.createFileAccessHelper(context);

      // 获取目录url
      let rootIterator: fileAccess.RootIterator = await fileAccessHelper.getRoots();
      let sourceUri: string = rootIterator.next().value.uri

      // 以异步方法创建文件到指定目录，返回新文件uri
      let fileUri = await fileAccessHelper.createFile(sourceUri, displayName);
      Logger.info(this.tag, "createFile success, fileUri: " + JSON.stringify(fileUri));

      // 以异步方法打开文件，返回文件描述符
      fd = await fileAccessHelper.openFile(fileUri, fileAccess.OPENFLAGS.WRITE_READ);
      Logger.info(this.tag, `openFile success, fd = ${fd}`)
    } catch (err) {
      Logger.info(this.tag, "createFile failed, err:" + JSON.stringify(err));
    }
    return fd;
  }

  async getFileAssetsFromType(mediaType: number): Promise<userFileManager.FileAsset[]> {
    Logger.info(this.tag, `getFileAssetsFromType,mediaType = ${mediaType}`);
    let fileAssets: Array<userFileManager.FileAsset> = [];

    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      let fetchOptions: userFileManager.FetchOptions = {
        fetchColumns: ['duration', 'date_added'],
        predicates: predicates
      }
      let fetchFileResult: userFileManager.FetchResult<userFileManager.FileAsset> = undefined;
      // 获取音频资源
      if (mediaType === FileType.AUDIO) {
        fetchFileResult = await this.mediaTest.getAudioAssets(fetchOptions);
        fileAssets = await fetchFileResult.getAllObject();
      } else {
        // 获取图片/视频资源
        fetchFileResult = await this.mediaTest.getPhotoAssets(fetchOptions);
        fileAssets = await fetchFileResult.getAllObject();
        // 过滤资源
        fileAssets = fileAssets.filter(item => item.fileType === mediaType)
      }
    } catch (err) {
      Logger.info(this.tag, `err ${JSON.stringify(err)}`);
    }
    Logger.info(this.tag, `getFileAssetsFromType = ${mediaType},fileAssets.count = ${fileAssets.length}`);
    return fileAssets
  }

  async getFileAssets(context: common.UIAbilityContext): Promise<fileAccess.FileInfo[]> {
    let isDone: boolean = false;
    let fileInfos: Array<fileAccess.FileInfo> = [];
    try {
      let fileAccessHelper = fileAccess.createFileAccessHelper(context);
      let rootIterator: fileAccess.RootIterator = await fileAccessHelper.getRoots();
      // 获取目录url
      let catalogueUrl: string = rootIterator.next().value.uri;
      let fileInfo: fileAccess.FileInfo = await fileAccessHelper.getFileInfoFromUri(catalogueUrl);
      let fileIterator = fileInfo.scanFile();
      while (!isDone) {
        let result = fileIterator.next();
        isDone = result.done;
        if (!isDone) {
          fileInfos.push(result.value);
        }
      }
    } catch (error) {
      Logger.info(this.tag, "getRoots failed, errCode:" + error.code + ", errMessage:" + error.message);
    }
    return fileInfos;
  }

  async getAlbums(context: common.UIAbilityContext) {
    Logger.info(this.tag, 'getAlbums begin')

    let albums = []
    const [ images, videos, audios, fileInfos ] = await Promise.all([
      this.getFileAssetsFromType(FileType.IMAGE),
      this.getFileAssetsFromType(FileType.VIDEO),
      this.getFileAssetsFromType(FileType.AUDIO),
      this.getFileAssets(context)
    ])
    albums.push({
      albumName: 'Documents', count: fileInfos.length, mediaType: FileType.FILE
    })
    albums.push({
      albumName: 'Pictures', count: images.length, mediaType: FileType.IMAGE
    })
    albums.push({
      albumName: 'Videos', count: videos.length, mediaType: FileType.VIDEO
    })
    albums.push({
      albumName: 'Audios', count: audios.length, mediaType: FileType.AUDIO
    })
    return albums
  }

  async deleteFile(mediaType: number, uri: string, context?: common.UIAbilityContext): Promise<void> {
    // 删除文件资源
    if (mediaType === 4 && context !== undefined) {
      try {
        let fileAccessHelper = fileAccess.createFileAccessHelper(context);
        let code = await fileAccessHelper.delete(uri);
        if (code != 0)
          Logger.info(this.tag, `delete failed, code: ${code}`);
      } catch (err) {
        Logger.info(this.tag, `delete failed, err: ${err}`);
      }
    } else {
      // 删除图片/视频/音频资源
      return this.mediaTest.delete(uri);
    }
  }

  getInfoFromType(mediaType: number) {
    let result = {
      prefix: '', suffix: ''
    }
    switch (mediaType) {
      case FileType.IMAGE:
        result.prefix = 'IMG_'
        result.suffix = '.jpg'
        break
      case FileType.VIDEO:
        result.prefix = 'VID_'
        result.suffix = '.mp4'
        break
      case FileType.AUDIO:
        result.prefix = 'AUD_'
        result.suffix = '.mp3'
        break
      default:
        result.prefix = 'FILE_'
        result.suffix = '.txt'
        break
    }
    return result
  }
}