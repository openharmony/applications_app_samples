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
import userFileManager from '@ohos.filemanagement.userFileManager';
import BusinessError from "@ohos.base";
import Logger from '../model/Logger';

const TAG: string = '[Recorder.RecordModel]';

let avProfile: media.AVRecorderProfile = {
  audioBitrate: 100000, // 音频比特率
  audioChannels: 2, // 音频声道数
  audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前只支持aac
  audioSampleRate: 48000, // 音频采样率
  fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前只支持m4a
};

export class RecordModel {
  private audioRecorder: media.AVRecorder | undefined = undefined;
  private fd: number;
  private fileAsset: userFileManager.FileAsset;

  async initAudioRecorder() {
    await this.release();
    this.audioRecorder = await media.createAVRecorder();
    Logger.info(TAG, 'create audioRecorder success');

    this.audioRecorder.on('stateChange', (state: media.AVRecorderState, reason: media.StateChangeReason) => {
      Logger.info(TAG, `current state is ${state}`);
    })

    this.audioRecorder.on('error', (err: BusinessError.BusinessError) => {
      Logger.error(TAG, `avRecorder failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  async release() {
    Logger.info(TAG, 'audioRecorder release');
    if (this.audioRecorder !== undefined) {
      await this.audioRecorder.release();
    }
    this.audioRecorder = undefined;
  }

  startRecorder(pathName: string, fileAsset: userFileManager.FileAsset, callback) {
    Logger.info(TAG, `enter the startRecorder,pathName=${pathName}, audioRecorder=${JSON.stringify(this.audioRecorder)}`);
    this.fileAsset = fileAsset;
    this.fd = Number(pathName.split('/').pop());
    let avConfig: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      profile: avProfile,
      url: pathName
    };
    this.audioRecorder?.prepare(avConfig).then(async () => {
      Logger.info(TAG, 'Invoke prepare succeeded.');
      await this.audioRecorder.start();
      callback();
    }, (err: BusinessError.BusinessError) => {
      Logger.error(TAG, `Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
    })

  }

  async pause(callback) {
    Logger.info(TAG, 'audioRecorder pause called');
    if (this.audioRecorder !== undefined && this.audioRecorder.state === 'started') {
      await this.audioRecorder.pause();
      callback();
    }
  }

  async resume(callback) {
    Logger.info(TAG, 'audioRecorder resume called');
    if (this.audioRecorder !== undefined && this.audioRecorder.state === 'paused') {
      await this.audioRecorder.resume();
      callback();
    }
  }

  async finish(callback) {
    Logger.info(TAG, 'audioRecorder finish called');
    if (this.audioRecorder !== undefined && (this.audioRecorder.state === 'started'
      || this.audioRecorder.state === 'paused')) {
      await this.audioRecorder.stop();
      await this.audioRecorder.reset();
      await this.audioRecorder.release();
      await this.fileAsset.close(this.fd);
      callback();
    }
  }
}