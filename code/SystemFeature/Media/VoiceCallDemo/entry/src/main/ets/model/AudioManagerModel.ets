/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Logger from '../utils/Logger';

import audio from '@ohos.multimedia.audio';

const TAG = 'AudioManagerModel';

class AudioManagerModel {
  private mAudioManager: audio.AudioManager | null = null;
  private mAudioVolumeGroupManager: audio.AudioVolumeGroupManager | null = null;
  private mAudioRoutingManager: audio.AudioRoutingManager | null = null;

  async initManager(): Promise<void> {
    this.mAudioManager = audio.getAudioManager();
    this.mAudioRoutingManager = this.mAudioManager.getRoutingManager();
    this.mAudioVolumeGroupManager = await this.mAudioManager.getVolumeManager()
      .getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
  }

  async isMicrophoneMute(): Promise<boolean> {
    let ret: boolean = false;
    if (this.mAudioVolumeGroupManager) {
      ret = await this.mAudioVolumeGroupManager.isMicrophoneMute();
    }
    return ret;
  }

  //设置mic是否静音
  async setMicrophoneMute(mute: boolean): Promise<void> {
    Logger.info(TAG,` setMicrophoneMute ${mute} `);
    try {
      if (this.mAudioVolumeGroupManager) {
        await this.mAudioVolumeGroupManager.setMicrophoneMute(mute);
        Logger.info(TAG,` setMicrophoneMute sucess`);
      }
    }
    catch (err) {
      Logger.error(TAG,`setMicrophoneMute failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 设置通话场景
   AudioVolumeGroupManager.setAudioScene用于调整音频场景，属于系统接口。
   目前版本(4.0.7.1之后）已实现自动切换AudioScene。
   对于非系统应用，若使用AudioRenderer播放VOICE_CALL类型的音频，
   则调用start函数时会自动切换至AUDIO_SCENE_VOICE_CHAT，
   播放结束后自动切换回默认场景，无需调用setAudioScene。
   */
  async setVoiceScene(calling: boolean): Promise<void> {
    Logger.info(TAG,`setVoiceScene ${calling}`);
    if (!this.mAudioManager) {
      return;
    }
    try {
      if (calling) {
        await this.mAudioManager.setAudioScene(audio.AudioScene.AUDIO_SCENE_VOICE_CHAT);
        Logger.info(TAG,`setVoiceScene AUDIO_SCENE_VOICE_CHAT sucess`);
      } else {
        await this.mAudioManager.setAudioScene(audio.AudioScene.AUDIO_SCENE_DEFAULT);
        Logger.info(TAG,`setVoiceScene AUDIO_SCENE_DEFAULT sucess`);
      }
    } catch (err) {
      Logger.error(TAG,`setVoiceScene failed, code is ${err.code}, message is ${err.message}`);
    }

  }

  //设置是否打开扬声器
  async setSpeaker(speaker: boolean): Promise<void> {
    Logger.info(TAG,`setSpeaker ${speaker}`);
    try {
      if (!this.mAudioRoutingManager) {
        return;
      }
      await this.mAudioRoutingManager.setCommunicationDevice(audio.CommunicationDeviceType.SPEAKER, speaker);

      Logger.info(TAG,` setSpeaker  sucess`);
    } catch (err) {
      Logger.error(TAG,`setSpeaker failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  //设置是否打开扬声器
  async isSpeakerActive(): Promise<boolean> {
    if (!this.mAudioRoutingManager) {
      return false;
    }
    let isSpeakerActive: boolean = await this.mAudioRoutingManager.isCommunicationDeviceActive(audio.CommunicationDeviceType.SPEAKER);
    Logger.info(TAG,` isSpeakerActive : ${isSpeakerActive}`);
    return isSpeakerActive;
  }
}

let mModel = new AudioManagerModel();

export default mModel as AudioManagerModel;