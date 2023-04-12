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

import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import MediaLibraryManager from '../../filemanager/medialibrary/MediaLibraryManager'
import Logger from '../../utils/Logger'

const DIR_DOWNLOAD: mediaLibrary.DirectoryType = mediaLibrary.DirectoryType.DIR_DOWNLOAD
const MOCK: string = 'mock_'

class LocalMockData {
  async createFileAsset(context, mediaType?: mediaLibrary.MediaType): Promise<mediaLibrary.FileAsset> {
    Logger.debug('mockFileAsset type: ' + mediaType)
    if (mediaType == undefined) {
      mediaType = mediaLibrary.MediaType.FILE
    }
    return await MediaLibraryManager.createFileAsset(context, mediaType, DIR_DOWNLOAD, this.mockFileName(mediaType))
  }

  mockFileName(mediaType: mediaLibrary.MediaType): string {
    Logger.debug('mockFileName type: ' + mediaType)
    return MOCK + Date.now() + '.txt'
  }

  isSupportPreview(fileName: string): boolean {
    if (fileName == undefined) {
      return false
    }
    return fileName.indexOf(MOCK) != 0
  }
}

export default new LocalMockData()