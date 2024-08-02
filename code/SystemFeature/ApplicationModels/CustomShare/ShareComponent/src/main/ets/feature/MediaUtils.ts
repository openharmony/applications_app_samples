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

import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import Logger from '../util/Logger'

const TAG: string = 'MediaUtils'

class MediaUtils {
  async getFileAssetsFromType(mediaType: number, context: any) {
    let mediaList: Array<photoAccessHelper.PhotoAsset> = [];
    let mediaLib: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    Logger.info(TAG, `getFileAssetsFromType,mediaType: ${mediaType}`);
    // 获取文件资源
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [`${mediaType}`],
      predicates: predicates
    };
    try {
      let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await mediaLib.getAssets(fetchOptions);
      if (fetchResult !== undefined) {
        Logger.info(TAG, 'fetchResult success');
        Logger.info(TAG, `getFileAssetsFromType,fetchFileResult.count: ${fetchResult.getCount()}`)
        // getCount 获取文件检索结果中的文件总数。
        if (fetchResult.getCount() > 0) {
          mediaList = await fetchResult.getAllObjects() // 获取文件检索结果中的所有文件资产。此方法返回FileAsset结果集。
        }
      }
    } catch (err) {
      Logger.error(TAG,`getAssets failed, error: ${err.code}, ${err.message}`);
    }
    return mediaList
  }
}

export default new MediaUtils()