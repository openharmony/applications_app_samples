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
import { MediaConstants } from '../constants/MediaConstants';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { screenManager } from '../common/ScreenManager';

export class InnerUserFileDataItem extends UserFileDataItem {
  constructor(uri: string, index: number) {
    super('', [] as string[], '', index);
    this.mediaType = photoAccessHelper.PhotoType.IMAGE;
    this.uri = uri;
    this.size = 256;
    this.orientation = 0;
  }

  async load(isForce: boolean): Promise<void> {
    if (this.status > (isForce ? MediaConstants.PART_LOADED : MediaConstants.UNDEFINED)) {
      return;
    }
    this.width = vp2px(screenManager.getWinWidth());
    this.height = vp2px(screenManager.getWinHeight());
    if (this.width === 0 || this.height === 0) {
      this.status = MediaConstants.PART_LOADED;
    } else {
      this.status = MediaConstants.LOADED;
    }
  }

  async isFavor(): Promise<boolean> {
    return false;
  }
}