/*
 * Copyright (c) 2023-2024 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import DateTimeUtil from '../utlis/DateTimeUtil';
import { GlobalContext } from '../utlis/GlobalContext';
import common from '@ohos.app.ability.common';
import Logger from '../utlis/Logger';

const TAG = '[MediaModel]';

type FileInfo = {
  prefix: string;
  suffix: string;
};

export default class MediaModel {
  private accessHelper: photoAccessHelper.PhotoAccessHelper = undefined;
  private static mediaInstance: MediaModel = undefined;

  constructor() {
    let cameraContext: common.UIAbilityContext = GlobalContext.getContext().getCameraAbilityContext();
    this.accessHelper = photoAccessHelper.getPhotoAccessHelper(cameraContext);
  }

  public static getMediaInstance(): MediaModel {
    if (this.mediaInstance === undefined) {
      this.mediaInstance = new MediaModel();
    }
    return this.mediaInstance;
  }

  async createAndGetUri(mediaType: photoAccessHelper.PhotoType): Promise<photoAccessHelper.PhotoAsset> {
    let dateTimeUtil: DateTimeUtil = new DateTimeUtil();
    let info: FileInfo = this.getInfoFromMediaType(mediaType);
    let name: string = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`;
    let displayName: string = `${info.prefix}${name}${info.suffix}`;
    Logger.info(TAG, `displayName = ${displayName},mediaType = ${mediaType}`);
    let fileAsset: photoAccessHelper.PhotoAsset = await this.accessHelper.createAsset(displayName);
    return fileAsset;
  }

  async getFdPath(fileAsset: photoAccessHelper.PhotoAsset): Promise<number> {
    let fd: number = await fileAsset.open('rw');
    Logger.info(TAG, `fd = ${fd}`);
    return fd;
  }

  getInfoFromMediaType(mediaType: photoAccessHelper.PhotoType): FileInfo {
    let fileInfo: FileInfo = {
      prefix: '',
      suffix: ''
    };
    switch (mediaType) {
      case photoAccessHelper.PhotoType.IMAGE:
        fileInfo.prefix = 'IMG_';
        fileInfo.suffix = '.jpg';
        break;
      case photoAccessHelper.PhotoType.VIDEO:
        fileInfo.prefix = 'VID_';
        fileInfo.suffix = '.mp4';
        break;
      default:
        break;
    }
    return fileInfo;
  }
}
