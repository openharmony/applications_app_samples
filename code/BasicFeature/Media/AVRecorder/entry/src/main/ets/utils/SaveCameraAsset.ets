/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import DateTimeUtil from './DateTimeUtils';
import Logger from './Logger';

export default class SaveCameraAsset {
  private tag: string

  constructor(tag) {
    this.tag = tag;
  }

  private lastSaveTime: string = '';
  private saveIndex: number = 0;
  public VideoPrepareFile: any;
  public AudioPrepareFile: any;

  public async createVideoFd(): Promise<number> {
    Logger.info(this.tag, 'get Recorder File Fd');
    const mDateTimeUtil = new DateTimeUtil();
    const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.mp4';
    Logger.info(this.tag, 'get Recorder display name is: ' + displayName);
    const media = mediaLibrary.getMediaLibrary(globalThis.abilityContext)
    Logger.info(this.tag, 'get Recorder File Fd publicPath')
    const fileKeyObj = mediaLibrary.FileKey;
    const mediaType = mediaLibrary.MediaType.VIDEO;
    let publicPath: string = await media.getPublicDirectory(mediaLibrary.DirectoryType.DIR_VIDEO);
    Logger.info(this.tag,  'get Recorder File publicPath: ' + JSON.stringify(publicPath));
    try {
      const dataUri = await media.createAsset(mediaType, displayName, publicPath);
      Logger.info(this.tag, 'get Recorder dataUri is: ' + dataUri);
      if (dataUri != undefined) {
        Logger.info(this.tag, 'dataUri is undefined');
        const args = dataUri.id.toString();
        const fetchOp = {
          selections: fileKeyObj.ID + "=?",
          selectionArgs: [args],
        }
        Logger.info(this.tag, 'fetchOp= ' + JSON.stringify(fetchOp))
        const fetchFileResult = await media.getFileAssets(fetchOp);
        Logger.info(this.tag, 'getFileAssets finished');
        this.VideoPrepareFile = await fetchFileResult.getFirstObject();
        const fdNumber = await this.VideoPrepareFile.open('rw');
        Logger.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
        return fdNumber
      }
    } catch (err) {
      Logger.error(this.tag, 'create Recorder File Fd ERROR: ' + err);
    }
  }

  public async createAudioFd(): Promise<number> {
    Logger.info(this.tag, 'get Recorder File Fd');
    const mDateTimeUtil = new DateTimeUtil();
    const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.m4a';
    Logger.info(this.tag, 'get Recorder display name is: ' + displayName);
    const media = mediaLibrary.getMediaLibrary(globalThis.abilityContext)
    Logger.info(this.tag, 'get Recorder File Fd publicPath')
    const fileKeyObj = mediaLibrary.FileKey;
    const mediaType = mediaLibrary.MediaType.AUDIO;
    let publicPath: string = await media.getPublicDirectory(mediaLibrary.DirectoryType.DIR_AUDIO);
    Logger.info(this.tag,  'get Recorder File publicPath: ' + JSON.stringify(publicPath));
    try {
      const dataUri = await media.createAsset(mediaType, displayName, publicPath);
      Logger.info(this.tag, 'get Recorder dataUri is: ' + dataUri);
      if (dataUri != undefined) {
        Logger.info(this.tag, 'dataUri is undefined');
        const args = dataUri.id.toString();
        const fetchOp = {
          selections: fileKeyObj.ID + "=?",
          selectionArgs: [args],
        }
        Logger.info(this.tag, 'fetchOp= ' + JSON.stringify(fetchOp))
        const fetchFileResult = await media.getFileAssets(fetchOp);
        Logger.info(this.tag, 'getFileAssets finished');
        this.AudioPrepareFile = await fetchFileResult.getFirstObject();
        const fdNumber = await this.AudioPrepareFile.open('rw');
        Logger.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
        return fdNumber
      }
    } catch (err) {
      Logger.error(this.tag, 'create Recorder File Fd ERROR: ' + err);
    }
  }

  private checkName(name: string): string {
    if (this.lastSaveTime == name) {
      this.saveIndex += 1;
      return `${name}_${this.saveIndex}`
    }
    this.lastSaveTime = name;
    this.saveIndex = 0;
    Logger.info(this.tag, 'get Recorder File name is: ' + name);
    return name;
  }
}