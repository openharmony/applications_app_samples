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

import userFileManager from '@ohos.filemanagement.userfile_manager'
import Logger from '../../utils/Logger'

class UserFileManager {
  requestPermission(context): void {
    let permissions = [
      'ohos.permission.READ_IMAGEVIDEO',
      'ohos.permission.WRITE_IMAGEVIDEO'
    ]
    context.requestPermissionsFromUser(permissions, (code, result) => {
      Logger.debug('permissionRequest ' + JSON.stringify(code) + ' Result: ' + JSON.stringify(result))
    })
  }

  getUserFileMgr(context): userFileManager.UserFileManager {
    Logger.debug('begin getUserFileMgr')
    return userFileManager.getUserFileMgr(context)
  }

  async getFileAssetsByType(context, fileType): Promise<userFileManager.FetchFileResult> {
    Logger.debug('begin getFileAssetsByType')
    let option = {
      selections: '',
      selectionArgs: [],
    }
    let fetchFileResult = undefined
    try {
      fetchFileResult = await this.getUserFileMgr(context).getFileAssets([fileType], option)
      Logger.debug('file count：' + fetchFileResult.getCount())
    } catch (error) {
      Logger.error('fetchFileResult Error: ' + JSON.stringify(error))
    }
    return fetchFileResult
  }
}

export default new UserFileManager()