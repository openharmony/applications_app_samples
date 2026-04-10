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

import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import Log from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogDecorator';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import Audio from '@ohos.multimedia.audio';

interface VolumeChangeData {
  volumeType: Audio.AudioVolumeType
  volume: number
}

let cachedAudioManager: Audio.AudioManager | null = null;

export function getAudioManager() : Audio.AudioManager {
  if (cachedAudioManager === null) {
    cachedAudioManager = Audio.getAudioManager();
  }
  return cachedAudioManager;
}

export function registerObserver() : void{
  try {
    let audioManager = getAudioManager();
    audioManager.on('ringerModeChange', (mode: Audio.AudioRingMode) => {
      AppStorage.setOrCreate('ringerModeSilent', mode === Audio.AudioRingMode.RINGER_MODE_SILENT);
      AppStorage.setOrCreate('ringerModeNormal', mode === Audio.AudioRingMode.RINGER_MODE_NORMAL);
    })

    audioManager.on('volumeChange', (data: VolumeChangeData) => {
      if (data.volumeType === Audio.AudioVolumeType.RINGTONE) {
        AppStorage.setOrCreate('volume_ringtone', data.volume);
      } else if (data.volumeType === Audio.AudioVolumeType.VOICE_CALL) {
        AppStorage.setOrCreate('volume_voicecall', data.volume);
      } else if (data.volumeType === Audio.AudioVolumeType.MEDIA) {
        AppStorage.setOrCreate('volume_media', data.volume);
      }
    })
  } catch (e) {
    console.error('VolumeControlModel', 'registerObserver error ：' + JSON.stringify(e))
  }
}


export class VolumeModel extends BaseModel {
  private volumeType: Audio.AudioVolumeType;
  private audioManager: Audio.AudioManager;
  private volume: number = 0;
  private TAG = ConfigData.TAG + 'VolumeModel ';
  private oldVolume: number = 0;

  constructor(volumeType: Audio.AudioVolumeType) {
    super();
    this.volumeType = volumeType;
    this.audioManager = getAudioManager();
    this.audioManager.getVolume(this.volumeType, (err: Error, data: number) => {
      if (err) {
        return;
      }
      this.initState(data);
      this.volume = data;
      this.oldVolume = data;
    })
  }

  /**
   * Get volume value in the VolumeModel
   */
  @Log
  public initState(volume: number) : void{
    if (this.volumeType === Audio.AudioVolumeType.RINGTONE) {
      AppStorage.setOrCreate('volume_ringtone', volume);
    } else if (this.volumeType === Audio.AudioVolumeType.MEDIA) {
      AppStorage.setOrCreate('volume_media', volume);
    } else if (this.volumeType === Audio.AudioVolumeType.VOICE_CALL) {
      AppStorage.setOrCreate('volume_voicecall', volume);
    }
    return;
  }

  /**
   * Set value
   */
  @Log
  public setVolume(volume: number) : void{
    if (volume === this.oldVolume) {
      return;
    } else {
      LogUtil.info(`${this.TAG} setVolume start, volume: ${volume}`);
      this.audioManager.setVolume(this.volumeType, volume).then(() => {
        LogUtil.info(`${this.TAG} setVolume callback in, volume: ${volume}`);
      });
      this.oldVolume = volume;
      LogUtil.info(`${this.TAG} setVolume end, volume: ${volume}`);
      return;
    }
  }
}

export class RingerModel extends BaseModel {
  private modeTag: Audio.AudioRingMode;
  private audioManager: Audio.AudioManager;
  private TAG = ConfigData.TAG + 'RingerModel ';

  constructor(mode: Audio.AudioRingMode) {
    super();
    this.audioManager = getAudioManager();
    this.modeTag = mode;
    this.initState();
  }

  /**
   * Update ringer Mode
   */
  @Log
  public initState() : void {
    this.audioManager.getRingerMode((error: Error, action: Audio.AudioRingMode) => {
      LogUtil.info(`${this.TAG} updateMode.`);
      if (error) {
        return;
      }
      AppStorage.setOrCreate('ringerModeSilent', action === Audio.AudioRingMode.RINGER_MODE_SILENT);
      AppStorage.setOrCreate('ringerModeNormal', action === Audio.AudioRingMode.RINGER_MODE_NORMAL);
      LogUtil.info(`${this.TAG} updateMode sucess.`);
    });
  }

  /**
   * Set  ringer mode
   */
  @Log
  public setRingerMode(): void {
    this.audioManager.setRingerMode(this.modeTag, (err) => {
      LogUtil.info(`${this.TAG} setRingerMode.`);
      LogUtil.info(`${this.TAG} setRingerMode sucess.`);
    });
    return;
  }
}
