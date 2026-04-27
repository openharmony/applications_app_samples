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
 

import { audio } from '@kit.AudioKit';

class GetAudioManager {
  public audioManager = {} as audio.AudioManager;
  public audioVolumeManager = {} as audio.AudioVolumeManager
  public audioVolumeGroupManager = {} as audio.AudioVolumeGroupManager
  public groupId: number = audio.DEFAULT_VOLUME_GROUP_ID;
  public audioRenderer = {} as audio.AudioRenderer
  public audioRoutingManager = {} as audio.AudioRoutingManager
  public audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
    channels: audio.AudioChannel.CHANNEL_1,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  };
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
    rendererFlags: 0
  };
  private audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: this.audioStreamInfo,
    rendererInfo: this.audioRendererInfo
  };

  async init() {
    this.audioManager = audio.getAudioManager();
    this.audioVolumeManager = this.audioManager.getVolumeManager();
    this.audioRoutingManager = this.audioManager.getRoutingManager();
    this.audioVolumeGroupManager = await this.audioVolumeManager.getVolumeGroupManager(this.groupId)
  }
}

export const audioManager = new GetAudioManager();
