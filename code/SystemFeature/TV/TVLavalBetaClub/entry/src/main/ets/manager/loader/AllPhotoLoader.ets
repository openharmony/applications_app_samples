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
import { AlbumModel, AlbumType, PhotoModel } from '../../models/PhotoModel';
import { BasePhotoLoader } from './BasePhotoLoader';
import { getAllMediaItems, USE_TASK } from './MediaTasks';
import { preferences } from '@kit.ArkData';
import LogManager from '../../common/Log/LogManager';

const TAG = 'PHOTOM_AllPhotoLoader'
const PREF_FILE_NAME = 'preferences_album'
const PRESET_STATE = 'preset_state'

export class AllPhotoLoader extends BasePhotoLoader {
  getTag(): string {
    return TAG
  }

  getAlbumModel(): AlbumModel {
    return new AlbumModel(AlbumType.ALL, $r('app.string.selected_picture'))
  }

  // 获取所有照片和视频
  async getMediaItems(context: Context): Promise<PhotoModel[]> {
    LogManager.hilogIWithTag(this.getTag(),'getMediaItems = ' + JSON.stringify(context))
    if (USE_TASK) {
      let fileAssets = await getAllMediaItems(TAG, context)
      return fileAssets
    } else {
      return await getAllMediaItems(TAG, context)
    }
  }
}