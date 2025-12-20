/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { media } from '@kit.MediaKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AVPlayerState } from '../../model/AVPlayerState';

const TAG = '[CommonUtils]';

export function secondToTime(seconds: number): string {
  let hourUnit = 60 * 60;
  let hour: number = Math.floor(seconds / hourUnit);
  let minute: number = Math.floor((seconds - hour * 60) / 60);
  let second: number = seconds % (60 * 60);
  let hourStr: string = hour < 10 ? `0${hour.toString()}` : `${hour.toString()}`;
  let minuteStr: string = minute < 10 ? `0${minute.toString()}` : `${minute.toString()}`;
  let secondStr: string = second < 10 ? `0${second.toString()}` : `${second.toString()}`;
  if (hour > 0) {
    return `${hourStr}:${minuteStr}:${secondStr}`;
  }
  if (minute > 0) {
    return `${minuteStr}:${secondStr}`;
  }
  return `00:${secondStr}`;
}

export function setSeek(avPlayer: media.AVPlayer | undefined, seek: number) {
  if (avPlayer === undefined) {
    hilog.error(0x0000, TAG, 'setSeek error! avPlayer undefined!');
    return;
  }
  if (avPlayer.state === AVPlayerState.PREPARED || avPlayer.state === AVPlayerState.PLAYING ||
    avPlayer.state === AVPlayerState.PAUSED || avPlayer?.state === AVPlayerState.COMPLETED) {
    avPlayer.seek(seek, media.SeekMode.SEEK_PREV_SYNC);
  }
}

export async function playVideo(avPlayer: media.AVPlayer | undefined, curIndex: number, index: number) {
  try {
    if (avPlayer === undefined) {
      hilog.error(0x0000, TAG, `playVideo error! avPlayer undefined! curIndex: ${curIndex}, index: ${index}.`);
      return;
    }
    if (avPlayer.state === AVPlayerState.PREPARED || avPlayer.state === AVPlayerState.PAUSED ||
      avPlayer?.state === AVPlayerState.COMPLETED) {
      hilog.info(0x0000, TAG, `playVideo. state:${avPlayer.state}, curIndex: ${curIndex}, index: ${index}.`);
      await avPlayer.play();
    }
  } catch (error) {
    hilog.error(0x0000, TAG, `playVideo catch error, code: ${error.code}, message: ${error.message}`);
    return;
  }
}

export async function pauseVideo(avPlayer: media.AVPlayer | undefined, curIndex: number, index: number) {
  if (avPlayer === undefined) {
    hilog.error(0x0000, TAG, `pauseVideo error! avPlayer undefined! curIndex: ${curIndex}, index: ${index}.`);
    return;
  }
  hilog.info(0x0000, TAG, `pauseVideo. state:${avPlayer.state}, curIndex: ${curIndex}, index: ${index}.`);
  await avPlayer.pause().catch((error: BusinessError) => {
    hilog.error(0x0000, TAG, `pauseVideo catch error, code: ${error.code}, message: ${error.message}`);
  });
}

export async function stopVideo(avPlayer: media.AVPlayer | undefined, curIndex: number, index: number) {
  if (avPlayer === undefined) {
    hilog.error(0x0000, TAG, `stopVideo error! avPlayer undefined! curIndex: ${curIndex}, index: ${index}.`);
    return;
  }
  if (avPlayer.state === AVPlayerState.PREPARED || avPlayer.state === AVPlayerState.PLAYING ||
    avPlayer.state === AVPlayerState.PAUSED || avPlayer?.state === AVPlayerState.COMPLETED) {
    hilog.info(0x0000, TAG, `stopVideo. state:${avPlayer.state}, curIndex: ${curIndex}, index: ${index}.`);
    await avPlayer.stop().catch((error: BusinessError) => {
      hilog.error(0x0000, TAG, `stopVideo catch error, code: ${error.code}, message: ${error.message}`);
    });
  }
}

export function releaseVideo(avPlayer: media.AVPlayer | undefined, curIndex: number, index: number) {
  if (avPlayer === undefined) {
    hilog.error(0x0000, TAG, `releaseVideo error! avPlayer undefined! curIndex: ${curIndex}, index: ${index}.`);
    return;
  }
  hilog.info(0x0000, TAG, `releaseVideo. state:${avPlayer.state}, curIndex: ${curIndex}, index: ${index}.`);
  avPlayer.off('timeUpdate');
  avPlayer.off('seekDone');
  avPlayer.off('speedDone');
  avPlayer.off('error');
  avPlayer.off('stateChange');
  avPlayer.release().catch((error: BusinessError) => {
    hilog.error(0x0000, TAG, `releaseVideo catch error, code: ${error.code}, message: ${error.message}`);
  });
}