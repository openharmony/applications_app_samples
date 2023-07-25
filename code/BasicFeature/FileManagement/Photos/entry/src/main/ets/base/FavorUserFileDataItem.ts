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
import { userFileModel } from '../base/UserFileModel';
import { MediaConstants } from '../constants/MediaConstants';
import { UserFileDataItem } from '../base/UserFileDataItem';

export class FavorUserFileDataItem extends UserFileDataItem {
  constructor(selections: string, selectionArgs: string[], index: number) {
    super(selections, selectionArgs, '', index);
  }

  async loadFileAsset(): Promise<photoAccessHelper.PhotoAsset> {
    return await userFileModel.getMediaItemByUri(this.uri);
  }

  async setFavor(): Promise<boolean> {
    let isSuccess: boolean = await super.setFavor();
    let isFavor: boolean = await super.isFavor();
    this.status = isFavor ? this.status : MediaConstants.TRASHED;
    return isSuccess;
  }
}
