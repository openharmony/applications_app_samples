/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import image from '@ohos.multimedia.image';
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../../utils/Logger'

/**
 * 主要封装了mediaLibrary库相关的接口
 */
class MediaLibraryManager {
  requestPermission(context): void {
    let permissions = [
      'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA'
    ]
    context.requestPermissionsFromUser(permissions, (code, result) => {
      Logger.debug('permissionRequest ' + JSON.stringify(code) + ' Result: ' + JSON.stringify(result))
    })
  }

  async getPixelMapByFileAsset(fileAsset: mediaLibrary.FileAsset): Promise<image.PixelMap> {
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
      pixelMap = await imageSource.createPixelMap()
      Logger.debug('pixel size: ' + pixelMap.getPixelBytesNumber())
      fileAsset.close(fd)
    } catch (err) {
      Logger.debug('err: ' + JSON.stringify(err))
    }
    return pixelMap
  }

  getMediaLibrary(context): mediaLibrary.MediaLibrary {
    return mediaLibrary.getMediaLibrary(context)
  }

  async getFileAssets(context, fileType: mediaLibrary.MediaType): Promise<mediaLibrary.FetchFileResult> {
    Logger.debug('begin getFileAssets, fileType:' + fileType)
    let fileKeyObj = mediaLibrary.FileKey
    let imagesFetchOption = {
      selections: fileKeyObj.MEDIA_TYPE + '= ?',
      selectionArgs: [fileType.toString()],
    }
    let fetchFileResult: mediaLibrary.FetchFileResult = undefined
    try {
      fetchFileResult = await this.getMediaLibrary(context).getFileAssets(imagesFetchOption)
      Logger.debug('fetchFileResult count:' + fetchFileResult.getCount())
    } catch (error) {
      Logger.error('fetchFileResult Error: ' + JSON.stringify(error))
    }
    return fetchFileResult
  }

  async getFileAssetsByName(context, name: string): Promise<mediaLibrary.FileAsset> {
    Logger.debug('begin getFileAssetsByName: ' + name)
    let fileKeyObj = mediaLibrary.FileKey
    let imagesFetchOption = {
      selections: fileKeyObj.DISPLAY_NAME + '= ?',
      selectionArgs: [name.toString()],
    }
    let fetchFileResult: mediaLibrary.FetchFileResult = undefined
    let file: mediaLibrary.FileAsset = undefined
    try {
      fetchFileResult = await this.getMediaLibrary(context).getFileAssets(imagesFetchOption)
      Logger.debug('fetchFileResult count:' + fetchFileResult.getCount())
      file = await fetchFileResult.getFirstObject()
    } catch (error) {
      Logger.error('fetchFileResult Error: ' + JSON.stringify(error))
    }
    return file
  }

  async getThumbnail(fileAsset: mediaLibrary.FileAsset): Promise<image.PixelMap> {
    let thumbnail = undefined
    try {
      thumbnail = await fileAsset.getThumbnail()
      Logger.debug('PixelMap size: ' + thumbnail.getPixelBytesNumber())
    } catch (error) {
      Logger.error('getThumbnail Error: ' + JSON.stringify(error))
    }
    return thumbnail
  }

  async createFileAsset(context, mediaType: mediaLibrary.MediaType,
                        dir: mediaLibrary.DirectoryType, fileName: string): Promise<mediaLibrary.FileAsset> {
    Logger.debug('createFileAsset: ' + fileName)
    let media = this.getMediaLibrary(context)
    let path = await media.getPublicDirectory(dir);
    return await media.createAsset(mediaType, fileName, path);
  }

  async deleteFileAsset(context, fileAsset: mediaLibrary.FileAsset) {
    Logger.debug('deleteFileAsset: ' + fileAsset.displayName + ' uri: ' + fileAsset.uri)
    let media = this.getMediaLibrary(context)
    // @ts-ignore
    await media.deleteAsset(fileAsset.uri)
  }
}

export default new MediaLibraryManager()