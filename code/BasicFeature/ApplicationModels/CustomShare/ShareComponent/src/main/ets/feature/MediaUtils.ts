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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../util/Logger'

const TAG: string = 'MediaUtils'

class MediaUtils {
  async getFileAssetsFromType(mediaType: number, context: any) {
    let mediaList: Array<mediaLibrary.FileAsset> = []
    let mediaLib: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary(context)
    Logger.info(TAG, `getFileAssetsFromType,mediaType: ${mediaType}`)
    let fileKeyObj = mediaLibrary.FileKey

    let fetchOption = {
      selections: `${fileKeyObj.MEDIA_TYPE}=?`,
      selectionArgs: [`${mediaType}`]
    }

    // 获取文件资源
    let fetchFileResult = await mediaLib.getFileAssets(fetchOption)
    Logger.info(TAG, `getFileAssetsFromType,fetchFileResult.count: ${fetchFileResult.getCount()}`)
    // getCount 获取文件检索结果中的文件总数。
    if (fetchFileResult.getCount() > 0) {
      mediaList = await fetchFileResult.getAllObject() // 获取文件检索结果中的所有文件资产。此方法返回FileAsset结果集。
    }
    return mediaList
  }
}

export default new MediaUtils()