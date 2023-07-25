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

import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { selectManager } from '../common/SelectManager';
import { userFileModel } from './UserFileModel';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { UserFileDataItem } from './UserFileDataItem';

const TAG = 'TrashUserFileDataItem';

export class TrashUserFileDataItem extends UserFileDataItem {
  constructor(selections: string, selectionArgs: string[], index: number) {
    super(selections, selectionArgs, '', index);
    this.setSelect(false);
  }

  async loadFileAsset(): Promise<photoAccessHelper.PhotoAsset> {
    Log.debug(TAG, 'loadFileAsset' + this.uri);
    return await userFileModel.getMediaItemByUriFromTrash(this.uri);
  }

  async onRecover(): Promise<boolean> {
    try {
      let fileAsset = await this.loadFileAsset();
      if (fileAsset == null) {
        Log.error(TAG, 'onRecover error: cant find file');
        return false;
      }
      await userFileModel.recover(fileAsset);
      selectManager.deleteSelect(this.uri);
      this.status = MediaConstants.TRASHED;
      return true;
    } catch (err) {
      Log.error(TAG, 'onRecover error: ' + JSON.stringify(err));
      return false;
    }
  }

  async onDelete(): Promise<boolean> {
    try {
      let fileAsset = await this.loadFileAsset();
      await userFileModel.permanentDelete(fileAsset);
      selectManager.deleteSelect(this.uri);
      this.status = MediaConstants.TRASHED;
      return true;
    } catch (err) {
      Log.error(TAG, 'onDelete error: ' + JSON.stringify(err));
      return false;
    }
  }
}
