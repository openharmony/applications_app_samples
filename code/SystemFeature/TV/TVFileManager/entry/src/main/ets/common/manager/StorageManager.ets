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

import { MLog } from '../utils/MLog';
import { statfs } from '@kit.CoreFileKit';

const TAG: string = 'StorageManager';

export class StorageManager {
  public static getFreeSpaceSize(path: string): [number, number] {
    try {
      MLog.info(TAG, 'getFreeBytes path:' + path);
      let free: number = statfs.getFreeSizeSync(path);
      let total: number = statfs.getTotalSizeSync(path);
      MLog.info(TAG, `getFreeBytes FreeSize: ${free} TotalSize: ${total}`);
      return [free, total];
    } catch (err) {
      MLog.warn(TAG, 'getFreeSpaceSize failed with error:' + err);
    }
    return [0, 0];
  }
}
