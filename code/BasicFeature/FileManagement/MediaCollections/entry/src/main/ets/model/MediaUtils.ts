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
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import Logger from '../model/Logger';

const TAG: string = 'MediaUtils';

class MediaUtils {
  private mediaList: mediaLibrary.FileAsset[] = [];
  public mediaLib: mediaLibrary.MediaLibrary = undefined;

  async queryFile(id: string): Promise<mediaLibrary.FileAsset> {
    Logger.info(TAG, `queryFile,id = ${id}`);
    const fetchOp: mediaLibrary.MediaFetchOptions = {
      selections: `${mediaLibrary.FileKey.ID}=?`,
      selectionArgs: [id],
    };
    const fetchFileResult = await this.mediaLib.getFileAssets(fetchOp);
    Logger.info(TAG, `fetchFileResult.getCount() = ${fetchFileResult.getCount()}`);
    const fileAsset = await fetchFileResult.getAllObject();
    return fileAsset[0];
  }

  async getFdPath(fileAsset: any) {
    let fd = await fileAsset.open('Rw');
    Logger.info(TAG, `fd = ${fd}`);
    return fd;
  }

  async getFileAssetsFromType(mediaType: number) {
    Logger.info(TAG, `getFileAssetsFromType,mediaType = ${mediaType}`);
    let fileKeyObj = mediaLibrary.FileKey;
    let fetchOp = {
      selections: `${fileKeyObj.MEDIA_TYPE}=?`,
      selectionArgs: [`${mediaType}`],
    };
    let fetchFileResult = await this.mediaLib.getFileAssets(fetchOp);
    Logger.info(TAG, `getFileAssetsFromType,fetchFileResult.count = ${fetchFileResult.getCount()}`);
    if (fetchFileResult.getCount() > 0) {
      this.mediaList = await fetchFileResult.getAllObject();
    }
    return this.mediaList;
  }

  deleteFile(fileAsset: mediaLibrary.FileAsset): Promise<void> {
    Logger.info(TAG, `deleteFile,displayName=${fileAsset.displayName},uri = ${fileAsset.uri}`);
    return fileAsset.trash(true);
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