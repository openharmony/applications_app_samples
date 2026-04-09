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
import { AlbumModel, PhotoModel } from '../../models/PhotoModel';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BasePhotoLoader } from './BasePhotoLoader';
import { getSubTypeMediaItems, USE_TASK } from './MediaTasks';
import { taskpool } from '@kit.ArkTS';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG = 'PHOTOM_PHOTOM_SubTypeLoader'

export abstract class SubTypeLoader extends BasePhotoLoader {
  abstract getAlbumModel(): AlbumModel

  abstract getSubType(): photoAccessHelper.AlbumSubtype

  async getMediaItems(context: Context): Promise<PhotoModel[]> {
    if (USE_TASK) {
      let fileAssets: PhotoModel[] = []
      if (deviceInfo.sdkApiVersion > 11) {
        let task = new taskpool.Task(getSubTypeMediaItems, TAG, context, this.getSubType())
        fileAssets = await taskpool.execute(task) as PhotoModel[]
      } else {
        fileAssets = await getSubTypeMediaItems(TAG, context, this.getSubType())
      }
      return fileAssets
    } else {
      return await getSubTypeMediaItems(TAG, context, this.getSubType())
    }
  }
}