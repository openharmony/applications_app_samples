/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 
import Logger from '../common/Logger'
import fileUtil from '../manager/utils/FileUtils'
import Session from './client/Session'
import { DirectoryEntry, smbUtil } from 'smbProtocol'
import { image } from '@kit.ImageKit'

const TAG = 'NAS_LoaderUtil'

export const DEFAULT_ALBUM_WIDTH = 640

export async function getNasThumb(context: Context, session: Session, imageFile: DirectoryEntry,
  tag: string): Promise<string> {
  Logger.info(TAG, 'getThumb by uri = ' + JSON.stringify(imageFile, smbUtil.bigIntReplacer) + ' from ' + tag)
  const thumbPath = await getSavedNasThumbPath(context, session, imageFile)
  Logger.info(TAG, 'getThumb = ' + thumbPath)
  if (thumbPath) {
    Logger.info(TAG, 'return on cached= ' + 'file://' + thumbPath)
    return 'file://' + thumbPath
  } else {
    let result = await getNasImageThumb(context, session, imageFile)
    Logger.info(TAG, 'return on image thumb = ' + result)
    return result
  }
}

async function getSavedNasThumbPath(context: Context, session: Session,
  imageFile: DirectoryEntry): Promise<string | undefined> {
  const cacheDir = await fileUtil.getNasCacheDir(context)
  const imageName = fileUtil.getNasLocalFile(session.client.host, imageFile)
  const localPath = cacheDir + imageName
  const thumbExist = await fileUtil.fileExist(localPath)
  Logger.info(TAG, 'getSavedNasThumbPath localpath = ' + localPath + ' exist = ' + thumbExist)
  if (thumbExist) {
    return localPath
  } else {
    return undefined
  }
}

async function getNasImageThumb(context: Context, session: Session, imageFile: DirectoryEntry): Promise<string> {
  const result = await loadNasThumb(context, session, imageFile, DEFAULT_ALBUM_WIDTH)
  return 'file://' + (result as string)
}


@Concurrent
export async function loadNasThumb(context: Context, session: Session, imageFile: DirectoryEntry,
  defaultWidth: number): Promise<string> {
  const TAG = 'NAS_loadNasThumb'
  Logger.warn(TAG, 'loadImageThumb task start')
  const startTime = Date.now()
  let cacheDir = await fileUtil.getNasCacheDir(context)
  let imageName = fileUtil.getNasLocalFile(session.client.host, imageFile)
  let localPath = cacheDir + imageName
  let thumbExist = await fileUtil.fileExist(localPath)
  Logger.info(TAG, `path = ${localPath} exist = ${thumbExist}`)
  if (thumbExist) {
    return localPath
  }

  const buffer = await session.readFile(imageFile)
  const imageSource = image.createImageSource(buffer.buffer);
  const imageInfo = imageSource.getImageInfoSync()

  const widthScale = imageInfo.size.width / defaultWidth
  const heightScale = imageInfo.size.height / defaultWidth
  const scale = widthScale < heightScale ? widthScale : heightScale
  const thumbWidth = imageInfo.size.width / scale
  const thumbHeight = imageInfo.size.height / scale

  const decodingOptions: image.DecodingOptions = {
    desiredSize: { width: thumbWidth, height: thumbHeight },
    desiredPixelFormat: image.PixelMapFormat.RGBA_8888
  };
  const thumbnail = await imageSource.createPixelMap(decodingOptions);

  if (thumbnail) {
    Logger.info(TAG, `do save`)
    await fileUtil.savePixelMap(thumbnail, localPath)
  } else {
    throw new Error(`thumbnail create fail`)
  }
  Logger.warn(TAG, 'loadImageThumb task end' + (Date.now() - startTime))
  return localPath
}
