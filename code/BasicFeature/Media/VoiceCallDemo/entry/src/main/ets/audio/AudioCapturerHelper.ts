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

import audio from '@ohos.multimedia.audio';
import Logger from '../utils/Logger';

const TAG = 'mAudioCapturer';

// 与使用AudioCapturer开发音频录制功能过程相似，关键区别在于audioCapturerInfo参数和音频数据流向
export default class AudioCapturerHelper {
  private audioCapturer: audio.AudioCapturer | null = null;

  private audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率
    channels: audio.AudioChannel.CHANNEL_2, // 通道数
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  private audioCapturerInfo: audio.AudioCapturerInfo = {
    // 需使用通话场景相应的参数
    source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION, // 音源类型：语音通话
    capturerFlags: 0 // 音频采集器标志：默认为0即可
  };
  private audioCapturerOptions: audio.AudioCapturerOptions = {
    streamInfo: this.audioStreamInfo,
    capturerInfo: this.audioCapturerInfo
  };

  // 初始化，创建实例
  async init(): Promise<void> {
    try {
      this.audioCapturer = await audio.createAudioCapturer(this.audioCapturerOptions);
      Logger.info(TAG,`create AudioCapturer success`);
    } catch (err) {
      Logger.error(TAG,`Invoke createAudioCapturer failed ${JSON.stringify(err)}`);
    }

  }

  // 开始一次音频采集
  async start(callback: (buffer: ArrayBuffer, size: number) => void): Promise<void> {
    if (!this.audioCapturer) {
      Logger.info(TAG,`start failed AudioCapturer is null`);
      return;
    }

    let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
    if (stateGroup.indexOf(this.audioCapturer.state) === -1) { // 当且仅当状态为prepared、paused和stopped之一时才能启动采集
      Logger.info(TAG,`start failed`);
      return;
    }

    try {
      await this.audioCapturer.start(); // 启动采集
      Logger.info(TAG,`start AudioCapturer success`);
      let bufferSize: number = await this.audioCapturer.getBufferSize(); // rk打印出来2972? 先不用
      Logger.info(TAG,`read bufferSize ${bufferSize}`);
      while (true) {

        let buffer: ArrayBuffer = await this.audioCapturer.read(bufferSize, true);
        if (buffer === undefined) {
          Logger.error(TAG,`read buffer failed`);
        } else {
          if (callback) {
            callback(buffer, bufferSize);
          }
        }
      }
    } catch (err) {
      Logger.error(TAG,`start Capturer failed ${JSON.stringify(err)}`);
    }
  }

  // 停止采集
  async stop(): Promise<void> {
    Logger.info(TAG,`Capturer stop`);
    try {
      // 只有采集器状态为STATE_RUNNING或STATE_PAUSED的时候才可以停止
      if (this.audioCapturer.state !== audio.AudioState.STATE_RUNNING && this.audioCapturer.state !== audio.AudioState.STATE_PAUSED) {
        Logger.info(TAG,`Capturer is not running or paused`);
        return;
      }
      await this.audioCapturer.stop(); // 停止采集
    } catch (err) {
      Logger.error(TAG,`stop Capturer failed ${JSON.stringify(err)}`);
    }

  }

  // 销毁实例，释放资源
  async release(): Promise<void> {
    Logger.info(TAG,`Capturer release`);
    try {
      // 采集器状态不是STATE_RELEASED或STATE_NEW状态，才能release
      if (this.audioCapturer.state === audio.AudioState.STATE_RELEASED || this.audioCapturer.state === audio.AudioState.STATE_NEW) {
        Logger.info(TAG,`Capturer already released`);
        return;
      }
      await this.audioCapturer.release(); // 释放资源
    } catch (err) {
      Logger.error(TAG,`release Capturer failed ${JSON.stringify(err)}`);
    }
  }
}
