/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { CACHE_ALBUM_MIN_WIDTH, DEFAULT_ALBUM_WIDTH, PhotoModel } from '../../models/PhotoModel';
import fileUtil from '../utils/FileUtils';
import { taskpool } from '@kit.ArkTS';
import { loadImageThumb, loadVideoThumb } from '../VideoThumbLoader';
import Logger from '../../common/Logger';

const TAG = 'PHOTOM_loadUtil'

export const PHOTO_FETCH_COLUMNS = [photoAccessHelper.PhotoKeys.URI, photoAccessHelper.PhotoKeys.PHOTO_TYPE,
  photoAccessHelper.PhotoKeys.DISPLAY_NAME, photoAccessHelper.PhotoKeys.DURATION,
  photoAccessHelper.PhotoKeys.DATE_TRASHED_MS, photoAccessHelper.PhotoKeys.DATE_DAY, photoAccessHelper.PhotoKeys.WIDTH,
  photoAccessHelper.PhotoKeys.HEIGHT];

export function fileModelsEquals(models1: PhotoModel[], models2: PhotoModel[]): boolean {
  if (models1.length === models2.length) {
    for (let i = 0; i < models1.length; i++) {
      if (models1[i].uri !== models2[i].uri) {
        return false
      }
    }
    return true
  } else {
    return false
  }

}

export function delay(millSeconds: number): Promise<void> {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve()
    }, millSeconds)
  })
}


export async function getThumbByUri(context: Context, photoModel: PhotoModel, tag: string, isDistributed?: boolean): Promise<string> {
  Logger.info(TAG, 'getThumb by uri = ' + JSON.stringify(photoModel) + " from " + tag)
  const thumbPath = await getSavedThumbPath(context, photoModel.uri)
  if (thumbPath) {
    Logger.info(TAG, 'return on cached= ' + 'file://' + thumbPath)
    return 'file://' + thumbPath
  } else {
    if (photoModel.photoType === photoAccessHelper.PhotoType.IMAGE) {
      if (photoModel.width === undefined || photoModel.width <= CACHE_ALBUM_MIN_WIDTH) {
        Logger.info(TAG, 'return on image small= ' + photoModel.uri)
        return photoModel.uri
      } else {
        let result = await getImageThumb(context, photoModel.uri, photoModel.width ?? DEFAULT_ALBUM_WIDTH,
          photoModel.height ?? DEFAULT_ALBUM_WIDTH)
        Logger.info(TAG, 'return on image thumb = ' + result)
        return result
      }
    } else {
      let result = await getVideoAlbum(context, isDistributed ? photoModel.remoteUri as string : photoModel.uri,
        photoModel.width ?? DEFAULT_ALBUM_WIDTH, photoModel.height ?? DEFAULT_ALBUM_WIDTH)
      Logger.info(TAG, 'return on video thumb = ' + result)
      return result
    }
  }
}


async function getSavedThumbPath(context: Context, uri: string): Promise<string | undefined> {
  const cacheDir = await fileUtil.getCacheDir(context)
  const imageName = fileUtil.getLocalFilePathByUri(uri)
  const localPath = cacheDir + imageName
  const thumbExist = await fileUtil.fileExist(localPath)
  if (thumbExist) {
    return localPath
  } else {
    return undefined
  }
}

async function getImageThumb(context: Context, uri: string, width: number,
  height: number): Promise<string> {
  const widthScale = width / DEFAULT_ALBUM_WIDTH
  const heightScale = height / DEFAULT_ALBUM_WIDTH
  const scale = widthScale < heightScale ? widthScale : heightScale
  const thumbWidth = width / scale
  const thumbHeight = height / scale
  const task = new taskpool.Task(loadImageThumb, context, uri, thumbWidth, thumbHeight)
  const result = await taskpool.execute(task);
  return 'file://' + (result as string)
}

async function getVideoAlbum(context: Context, uri: string, width: number,
  height: number): Promise<string> {
  const widthScale = width / DEFAULT_ALBUM_WIDTH
  const heightScale = height / DEFAULT_ALBUM_WIDTH
  const scale = widthScale < heightScale ? widthScale : heightScale
  const thumbWidth = width / scale
  const thumbHeight = height / scale

  const task = new taskpool.Task(loadVideoThumb, context, uri, thumbWidth, thumbHeight)
  const result = await taskpool.execute(task)
  return 'file://' + (result as string)
}