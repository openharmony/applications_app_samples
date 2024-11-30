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

// @ts-nocheck
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import userFileManager from '@ohos.filemanagement.userFileManager';
import Logger from '../model/Logger';

const TAG: string = 'MediaUtils';

class MediaUtils {
  private mediaList: userFileManager.FileAsset[] = [];
  public mediaLib: userFileManager.UserFileManager = undefined;

  async getFileAssetsFromType(mediaType: number) {
    Logger.info(TAG, `getFileAssetsFromType,mediaType = ${mediaType}`);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    // 过滤图片资源、且保证音视频时长均大于0
    predicates.greaterThan("duration", 0)
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: ['duration'],
      predicates: predicates
    };
    try {
      let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset> = undefined
      if (mediaType === userFileManager.FileType.AUDIO) {
        // 获取音频资源
        fetchResult = await this.mediaLib.getAudioAssets(fetchOptions);
      } else if (mediaType === userFileManager.FileType.VIDEO) {
        fetchOptions.fetchColumns = [
          'title',
          'duration',
          'width',
          'height',
          'orientation'
        ];
        // 获取视频资源
        fetchResult = await this.mediaLib.getPhotoAssets(fetchOptions);
      }
      Logger.info(TAG, `mediaType = ${mediaType} getFileAssetsFromType,fetchResult.count = ${fetchResult.getCount()}`);
      if (fetchResult != undefined) {
        Logger.info(TAG,'fetchResult success');
        this.mediaList = await fetchResult.getAllObject();
      }
    } catch (err) {
      Logger.info(TAG,'getMediaAssets failed, message = ', err);
    }
    return this.mediaList;
  }

  deleteFile(fileAsset: userFileManager.FileAsset): Promise<void> {
    Logger.info(TAG, `deleteFile,displayName=${fileAsset.displayName},uri = ${fileAsset.uri}`);
    return this.mediaLib.delete(fileAsset.uri);
  }

  onDateChange(audioCallback: () => void, videoCallback: () => void) {
    this.mediaLib.on('audioChange', () => {
      Logger.info(TAG, 'videoChange called');
      audioCallback();
    });
    this.mediaLib.on('videoChange', () => {
      Logger.info(TAG, 'videoChange called');
      videoCallback();
    });
  }

  offDateChange() {
    this.mediaLib.off('videoChange');
    this.mediaLib.off('audioChange');
  }
}

export default new MediaUtils();