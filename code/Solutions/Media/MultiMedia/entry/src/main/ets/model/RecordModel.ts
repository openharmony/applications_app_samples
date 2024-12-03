/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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
import media from '@ohos.multimedia.media';
import Logger from '../model/Logger';

const avProfile = {
  audioBitrate: 48000, // set audioBitrate according to device ability
  audioChannels: 2, // set audioChannels, valid value 1-8
  audioCodec: media.CodecMimeType.AUDIO_AAC, // set audioCodec, AUDIO_AAC is the only choice
  audioSampleRate: 48000, // set audioSampleRate according to device ability
  fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // set fileFormat, for video is m4a
};
const audioConfig = {
  audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
  profile: avProfile,
  url: 'fd://'
};

export default class RecordModel {
  private tag: string = 'RecordModel'
  private audioRecorder: media.AVRecorder = undefined;

  async initAudioRecorder(handleStateChange: () => void) {
    this.release();
    this.audioRecorder = await media.createAVRecorder()
    Logger.info(this.tag, 'create audioRecorder success')

    this.audioRecorder.on('stateChange', (state, reason) => {
      Logger.info(this.tag, 'case state has changed, new state is' + state);
      switch (state) {
        case 'idle':
          break;
        case 'prepared':
          Logger.info(this.tag, 'setCallback  prepare case callback is called');
          this.audioRecorder.start()
          break;
        case 'started':
          Logger.info(this.tag, 'setCallback start case callback is called');
          handleStateChange()
          break;
        case 'paused':
          Logger.info(this.tag, 'audioRecorder pause finish');
          handleStateChange();
          break;
        case 'stopped':
          Logger.info(this.tag, 'audioRecorder stop called');
          break;
        case 'released':
          break;
        case 'error':
          Logger.info(this.tag, 'case error state!!!');
          break;
        default:
          Logger.info(this.tag, 'case start is unknown');
          break;
      }
    });
    this.audioRecorder.on('error', (err) => {
      Logger.info(this.tag, 'audioRecorder error:' + JSON.stringify(err))
    });
  }

  async release() {
    if (typeof (this.audioRecorder) !== `undefined`) {
      Logger.info(this.tag, 'audioRecorder  release')
      this.audioRecorder.release()
    }
  }

  async startRecorder(fd: number) {
    Logger.info(this.tag, `startRecorder, fd = ${fd}`);
    let fdPath = "fd://" + fd;
    if (typeof (this.audioRecorder) !== 'undefined') {
      Logger.info(this.tag, 'start prepare')
      audioConfig.url = fdPath;
      await this.audioRecorder.prepare(audioConfig);
    } else {
      Logger.error(this.tag, 'case failed, audioRecorder is null')
    }
  }

  pause() {
    Logger.info(this.tag, 'audioRecorder pause called')
    if (typeof (this.audioRecorder) !== `undefined`) {
      this.audioRecorder.pause()
    }
  }

  resume() {
    Logger.info(this.tag, 'audioRecorder resume called')
    if (typeof (this.audioRecorder) !== `undefined`) {
      this.audioRecorder.resume()
    }
  }

  async finish() {
    if (typeof (this.audioRecorder) !== `undefined`) {
      // 1. 停止录制
      await this.audioRecorder.stop();
      // 2.重置
      await this.audioRecorder.reset();
      // 3.释放录制实例
      await this.audioRecorder.release();
      this.audioRecorder = undefined;
    }
  }
}