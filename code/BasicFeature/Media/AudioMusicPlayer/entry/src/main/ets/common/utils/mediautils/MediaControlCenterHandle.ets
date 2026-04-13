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

import { resourceManager } from '@kit.LocalizationKit';
import Logger from '../Logger';
import audioPlayer from 'libentry.so'
import { MediaTools } from "./MediaTools";
import { MediaControlCenterCallbackAction } from './MediaControlCenterCallbackAction';
import { PreferencesUtil } from '../PreferencesUtil';
import { DEFAULT_VOLUME, SILENT_ID, VOLUME_ID, EFFECT_ID } from '../../constants/PlayerConstants';

const TAG = 'MediaControlCenterHandle';

export class MediaControlCenterHandle {
  private interval = -1;
  private isPlaying = false;
  private static mediaControlCenterHandle: MediaControlCenterHandle;

  public static getInstance(): MediaControlCenterHandle {
    if (!MediaControlCenterHandle.mediaControlCenterHandle) {
      Logger.info(TAG, 'no mediaControlCenterHandle')
      MediaControlCenterHandle.mediaControlCenterHandle = new MediaControlCenterHandle();
    }
    return MediaControlCenterHandle.mediaControlCenterHandle;
  }

  // Initialize the playback instance class and place it in this method.
  async init() {
    audioPlayer.initPlayer();
  }

  async create() {
    await this.init();
  }

  onProgress() {
    clearInterval(this.interval);
    this.interval = setInterval(() => {
      if (!this.isPlaying) {
        return;
      }
      let progress = audioPlayer.getProgress();
      Logger.info(TAG, `current progress is ${progress}`)
      MediaControlCenterCallbackAction.getInstance().doUpdateProgressAction(progress);
      let duration = Math.floor(AppStorage.get('totalMsTime')!);
      Logger.info(TAG, `duration is ${duration}`)
      if (this.isPlaying && progress >= duration) {
        MediaControlCenterCallbackAction.getInstance().doPlayNextAction();
        clearInterval(this.interval)
      }
    }, 500)
  }

  registerCallback() {
    audioPlayer.onPlayStatus((state) => {
      Logger.info(TAG, `onPlayStateChange is ${state}`)
      if (state === 3) {
        MediaControlCenterCallbackAction.getInstance().doStopAction();
      }
      if (state === 2) {
        MediaControlCenterCallbackAction.getInstance().doPauseAction();
      }
      if (state === 1) {
        MediaControlCenterCallbackAction.getInstance().doPlayAction();
      }
      if (state === 4) {
        MediaControlCenterCallbackAction.getInstance().doPlayCompleteAction();
      }
    })
    this.onProgress();
  }

  // Load the current song information. The song information can be obtained from this interface, including fd length offset
  loadSongAssent(songRawFileDescriptor: resourceManager.RawFileDescriptor, fileName: string) {
    audioPlayer.loadSongInfo(fileName, songRawFileDescriptor.fd, songRawFileDescriptor.length, songRawFileDescriptor.offset);


      Logger.info(TAG, `WJJTest loadSongAssent is ${fileName} fd ${songRawFileDescriptor.fd}, songFileSize ${songRawFileDescriptor.length}, songOffset ${songRawFileDescriptor.offset}`);
    this.registerCallback();
  }

  // Execute play
  play() {
    this.isPlaying = true;
    audioPlayer.playSong();
  }

  // Set speed
  setSpeed(speed: number) {
    audioPlayer.setPlayingSpeed(speed);
  }

  // Get Volume
  getVolume() {
    let volume: number | undefined;
    volume = PreferencesUtil.getInstance().getValue(VOLUME_ID) as number;
    if (volume === undefined) {
      return DEFAULT_VOLUME;
    } else {
      return volume
    }
  }

  // Set Volume
  setVolume(volume: number) {
    audioPlayer.setPlayingVolume(volume);
    if (!AppStorage.get('isSilentMode') || volume !== 0) {
      PreferencesUtil.getInstance().preferencesPut(VOLUME_ID, volume);
    }
    Logger.info(TAG, `setVolume is ${volume}`)
  }

  // Set whether to mute
  setSilentMode(isSilentMode: boolean) {
    audioPlayer.setSilentMode(isSilentMode);
    PreferencesUtil.getInstance().preferencesPut(SILENT_ID, isSilentMode);
  }

  setEffectMode(isEffectMode: boolean) {
    audioPlayer.setEffectMode(isEffectMode);
    PreferencesUtil.getInstance().preferencesPut(EFFECT_ID, isEffectMode);
  }

  // Execute pause
  pause() {
    audioPlayer.pauseSong();
    this.isPlaying = false;
  }

  // Stop progress update
  stopProgressUpdate() {
    this.isPlaying = false;
    Logger.info(TAG, 'stopProgressUpdate: isPlaying set to false');
  }

  // Execute seek
  seek(ms: number) {
    audioPlayer.seekPlaySong(ms)
  }

  // Execute stop
  async stop() {
    audioPlayer.stopSong();
  }

  // Execute release
  release() {
    clearInterval(this.interval);
    audioPlayer.releasePlayer();
  }

  // Get song duration
  getSongDuration(): number {
    return audioPlayer.getSongDuration();
  }
}