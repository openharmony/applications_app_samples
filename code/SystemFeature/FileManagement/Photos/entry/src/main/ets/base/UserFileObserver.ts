/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { stashOrGetObject } from '../utils/SingleInstanceUtils';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { userFileModel } from './UserFileModel';
import { UserFileObserverCallback } from './UserFileObserverCallback';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG = 'UserFileObserver';

class UserFileObserver {
  callbacks: UserFileObserverCallback[] = [];
  private static readonly OBSERVER_IMAGE_CHANGE: string = 'imageChange';
  private static readonly OBSERVER_VIDEO_CHANGE: string = 'videoChange';
  private static readonly OBSERVER_DEVICE_CHANGE: string = 'deviceChange';
  private static readonly OBSERVER_ALBUM_CHANGE: string = 'albumChange';
  private static readonly OBSERVER_REMOTE_FILE_CHANGE: string = 'remoteFileChange';

  registerObserver(callback: UserFileObserverCallback | null): void {
    Log.info(TAG, 'registerObserver');
    if (callback == null) {
      Log.warn(TAG, 'registerObserver with empty callback');
      return;
    }

    if (this.callbacks.indexOf(callback) < 0) {
      this.callbacks.push(callback);
    } else {
      Log.info(TAG, 'registerObserver already exist');
      return;
    }

    if (this.callbacks.length === 1) {
      Log.info(TAG, 'registerObserver register media');
      try {
        userFileModel.getUserFileMgr().registerChange(photoAccessHelper.DefaultChangeUri.DEFAULT_PHOTO_URI, true, (): void => {
          Log.info(TAG, 'registerObserver on image');
          this.sendNotify(MediaConstants.MEDIA_TYPE_IMAGE);
        });
        userFileModel.getUserFileMgr().registerChange(photoAccessHelper.DefaultChangeUri.DEFAULT_ALBUM_URI, true, (): void => {
          Log.info(TAG, 'registerObserver on album');
          this.sendNotify(MediaConstants.MEDIA_TYPE_ALBUM);
        });
      } catch (err) {
        Log.error(TAG, 'registerObserver faild, err: ' + JSON.stringify(err));
      }
    }
  }

  sendNotify(mediaType: string): void {
    Log.info(TAG, 'registerObserver sendNotify size: ' + this.callbacks.length);
    for (let callback of this.callbacks) {
      callback.onChange(mediaType);
    }
  }

  unregisterObserver(callback: UserFileObserverCallback | null): void {
    Log.info(TAG, 'unregisterObserver');
    const pos = this.callbacks.indexOf(callback);
    if (pos >= 0) {
      this.callbacks.splice(pos, 1);
    }
  }
}

export let userFileObserver: UserFileObserver = stashOrGetObject<UserFileObserver>(new UserFileObserver(), TAG);
