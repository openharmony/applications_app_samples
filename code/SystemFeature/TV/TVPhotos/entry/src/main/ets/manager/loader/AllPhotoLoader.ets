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
 
import { AlbumModel, AlbumType, PhotoModel } from '../../models/PhotoModel';
import { BasePhotoLoader } from './BasePhotoLoader';
import { taskpool } from '@kit.ArkTS';
import { getAllMediaItems, presetImages, USE_TASK } from './MediaTasks';
import { preferences } from '@kit.ArkData';
import Logger from '../../common/Logger';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG = 'PHOTOM_AllPhotoLoader'
const PREF_FILE_NAME = 'preferences_album'
const PRESET_STATE = 'preset_state'
const PRESET_DELAY = 200
const MAX_RETRIES = 3

export class AllPhotoLoader extends BasePhotoLoader {
  getTag(): string {
    return TAG
  }

  getAlbumModel(): AlbumModel {
    return new AlbumModel(AlbumType.ALL, $r('app.string.album_name_all'))
  }

  // 获取所有照片和视频
  async getMediaItems(context: Context): Promise<PhotoModel[]> {
    if (USE_TASK) {
      if (!this.getPresetState(context)) {
        try {
          // 增加重试机制，媒体库可能初始化失败
          let retryCount: number = 0;
          while (retryCount < MAX_RETRIES) {
            Logger.debug(`pre set image retry count: ${retryCount + 1}`)
            try {
              if (deviceInfo.sdkApiVersion > 11) {
                let presetTask = new taskpool.Task(presetImages, TAG, context);
                await taskpool.execute(presetTask);
              } else {
                presetImages(TAG, context);
              }
              this.setPresetState(context, true);
              break;
            } catch (e) {
              retryCount++;
              Logger.error(`pre set image fail, retry ${retryCount}/${MAX_RETRIES}: ${JSON.stringify(e)}`)
              if (retryCount >= MAX_RETRIES) {
                // 达到最大重试次数，抛出异常
                throw new Error(e);
              }
              // 增加延迟后重试
              await this.waitFor(PRESET_DELAY * retryCount);
            }
          }
        } catch (e) {
          // 预设失败，将状态设置为false
          this.setPresetState(context, false);
          Logger.error('pre set image fail:' + JSON.stringify(e));
        }
      }
      let fileAssets: PhotoModel[] = []
      if (deviceInfo.sdkApiVersion > 11) {
        let task = new taskpool.Task(getAllMediaItems, TAG, context)
        fileAssets = await taskpool.execute(task) as PhotoModel[]
      } else {
        fileAssets = await getAllMediaItems(TAG, context)
      }
      return fileAssets
    } else {
      return await getAllMediaItems(TAG, context)
    }
  }

  waitFor(millSecond: number): Promise<void> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve()
      }, millSecond)
    })
  }

  setPresetState(context: Context, state: boolean) {
    let preference = preferences.getPreferencesSync(context, { name: PREF_FILE_NAME })
    preference.putSync(PRESET_STATE, state)
    preference.flush()
  }

  getPresetState(context: Context): boolean {
    return preferences.getPreferencesSync(context, { name: PREF_FILE_NAME }).getSync(PRESET_STATE, false) as boolean
  }
}