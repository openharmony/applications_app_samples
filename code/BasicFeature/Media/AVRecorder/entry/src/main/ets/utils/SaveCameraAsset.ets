/*
 * Copyright (C) 2023-2024 Huawei Device Co., Ltd.
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

import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import DateTimeUtil from './DateTimeUtils';
import Logger from './Logger';

export default class SaveCameraAsset {
  private tag: string

  constructor(tag: string) {
    this.tag = tag;
  }

  private context = getContext(this) as common.UIAbilityContext;
  private lastSaveTime: string = '';
  private saveIndex: number = 0;
  public VideoPrepareFile?: fs.File;
  public AudioPrepareFile?: fs.File;

  public async createVideoFd() {
    Logger.info(this.tag, 'get Recorder File Fd');
    const mDateTimeUtil = new DateTimeUtil();
    const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.mp4';
    Logger.info(this.tag, 'get Recorder display name is: ' + displayName);
    this.VideoPrepareFile = fs.openSync(this.context.filesDir + '/' + displayName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let fdNumber: number = this.VideoPrepareFile.fd;
    Logger.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
    return fdNumber;
  }

  public async closeVideoFile() {
    if (this.VideoPrepareFile) {
      await fs.close(this.VideoPrepareFile);
      Logger.info(this.tag, 'close Video File end');
    }
  }

  public async createAudioFd() {
    Logger.info(this.tag, 'get Recorder File Fd');
    const mDateTimeUtil = new DateTimeUtil();
    const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.wav';
    Logger.info(this.tag, 'get Recorder display name is: ' + displayName);
    this.AudioPrepareFile = fs.openSync(this.context.filesDir + '/' + displayName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let fdNumber: number = this.AudioPrepareFile.fd;
    Logger.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
    return fdNumber;
  }

  public async closeAudioFile() {
    if (this.AudioPrepareFile) {
      await fs.close(this.AudioPrepareFile);
      Logger.info(this.tag, 'close Audio File end');
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