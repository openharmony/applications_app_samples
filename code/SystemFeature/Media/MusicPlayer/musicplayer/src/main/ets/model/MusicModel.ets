/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { util } from '@kit.ArkTS';
import CommonConstants from '../common/constants/CommonConstants';

/**
 * 歌词数据类，待扩展
 */
export class LyricsDataSource implements IDataSource {
  private lyricsTimeArr: Array<number> = [];
  private lyricsDataArr: Array<string> = [];

  constructor(lrcRes: string) {
    this.initLyricsDataArr(lrcRes);
  }

  async initLyricsDataArr(lrcRes: string) {
    const resourceManager = getContext().resourceManager;
    const lrcUInt8Arr: Uint8Array = await resourceManager.getRawFileContent(lrcRes);
    const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const lrcStr: string = textDecoder.decodeToString(lrcUInt8Arr, { stream: false });
    const lrcStrArr = lrcStr.split('\n');
    lrcStrArr.forEach((str) => {
      const strArrTmp = str.split(']');

      // 每句歌词对应的时间，换算成毫秒
      const timeStr = strArrTmp[0].substring(1);
      const timeStrArrTmp = timeStr.split(':');
      const timeRaw = parseInt(timeStrArrTmp[0]) * CommonConstants.SECONDS_IN_MINUTE + parseFloat(timeStrArrTmp[1]);
      this.lyricsTimeArr.push(timeRaw * 1000);

      // 每句歌词数据
      const lrcStrRaw = strArrTmp[1];
      this.lyricsDataArr.push(lrcStrRaw);
    })
  }

  getTimeByIndex(index: number): number {
    return this.lyricsTimeArr[index] || 0;
  }

  checkCurLine(time: number): number {
    let checkLineIndex = 0;
    while (checkLineIndex < this.lyricsTimeArr.length) {
      const checkLineTime = this.lyricsTimeArr[checkLineIndex];
      if (time < checkLineTime) {
        checkLineIndex--;
        break;
      }
      checkLineIndex++;
    }

    return checkLineIndex;
  }

  totalCount(): number {
    return this.lyricsDataArr.length;
  }

  getData(index: number): string {
    return this.lyricsDataArr[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

/**
 * 歌曲信息接口
 */
export interface MusicInfo {
  title: string,
  cover: string,
  singer: string,
  duration: number,
  res: string,
  lrcRes: string,
}

/**
 * 歌曲数据模型
 */
export class MusicModel {
  private titleRaw: string = '';

  public get title(): string {
    return this.titleRaw;
  }

  private coverRaw: string;

  public get coverRes(): Resource {
    return $rawfile(this.coverRaw);
  }

  public get cover(): string {
    return this.coverRaw;
  }

  private singerRaw: string = '';

  public get singer(): string {
    return this.singerRaw;
  }

  private rawTotalTime: number = 0;

  public get totalTime(): number {
    return this.rawTotalTime;
  }

  private curTimeRaw: number = 0;

  public get curTime(): number {
    return this.curTimeRaw;
  }

  private lyricsInfoRaw: LyricsDataSource;

  public get lyricsInfo(): LyricsDataSource {
    return this.lyricsInfoRaw;
  }

  private resRaw: string = '';

  public get res(): string {
    return this.resRaw;
  }

  private lrcResRaw: string = '';

  public get lrcRes(): string {
    return this.lrcResRaw;
  }

  constructor(options: MusicInfo) {
    this.titleRaw = options.title;
    this.coverRaw = options.cover;
    this.singerRaw = options.singer;
    this.rawTotalTime = options.duration;
    this.lyricsInfoRaw = new LyricsDataSource(options.lrcRes);
    this.resRaw = options.res;
    this.lrcResRaw = options.lrcRes;
  }
}