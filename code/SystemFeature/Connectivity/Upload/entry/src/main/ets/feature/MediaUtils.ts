/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import type common from '@ohos.app.ability.common'
import DateTimeUtil from '../feature/DateTimeUtil'
import Logger from '../util/Logger'

const TAG: string = '[MediaUtils]'

export default class MediaUtils {
  private mediaTest: mediaLibrary.MediaLibrary = undefined
  private static instance: MediaUtils = undefined

  public static getInstance(context: common.Context): MediaUtils {
    if (this.instance === undefined) {
      this.instance = new MediaUtils(context)
    }
    return this.instance
  }

  constructor(context: common.Context) {
    this.mediaTest = mediaLibrary.getMediaLibrary(context)
  }

  async createAndGetUri(mediaType: number): Promise<mediaLibrary.FileAsset> {
    let result = {
      prefix: 'IMG_', suffix: '.jpg', directory: mediaLibrary.DirectoryType.DIR_IMAGE
    }
    let info = result
    let dateTimeUtil = new DateTimeUtil()
    let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
    let displayName = `${info.prefix}${name}${info.suffix}`
    Logger.info(TAG, `displayName = ${displayName},mediaType = ${mediaType}`)
    let publicPath = await this.mediaTest.getPublicDirectory(info.directory)
    Logger.info(TAG, `publicPath = ${publicPath}`)
    let asset = await this.mediaTest.createAsset(mediaType, displayName, publicPath)
    return asset
  }

  async getFdPath(fileAsset: mediaLibrary.FileAsset): Promise<number> {
    let fd = await fileAsset.open('Rw')
    Logger.info(TAG, `fd = ${fd}`)
    return fd
  }
}