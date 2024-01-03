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

const TAG = 'mAudioRenderer';

// 与使用AudioRenderer开发音频播放功能过程相似，关键区别在于audioRenderInfo参数和音频数据来源
export default class AudioRendererHelper {
  private renderModel: audio.AudioRenderer | null = null;
  private audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率
    channels: audio.AudioChannel.CHANNEL_2, // 通道数
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  private audioRendererInfo: audio.AudioRendererInfo = {
    // 需使用通话场景相应的参数
    content: audio.ContentType.CONTENT_TYPE_SPEECH, // 音频内容类型：语音
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION, // 音频流使用类型：语音通信
    rendererFlags: 0 // 音频渲染器标志：默认为0即可
  };
  private audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: this.audioStreamInfo,
    rendererInfo: this.audioRendererInfo
  };

  // 初始化，创建实例
  async init(): Promise<void> {
    try {
      this.renderModel = await audio.createAudioRenderer(this.audioRendererOptions);
      Logger.info(TAG,`creating AudioRenderer success`);
    } catch (err) {
      Logger.error(TAG,`creating AudioRenderer failed ${JSON.stringify(err)}`);
    }
  }

  // 开始一次音频渲染
  async start(): Promise<void> {
    if (!this.renderModel) {
      Logger.info(TAG,`start failed AudioRenderer is null`);
      return;
    }
    try {
      let stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED];
      if (stateGroup.indexOf(this.renderModel.state) === -1) { // 当且仅当状态为prepared、paused和stopped之一时才能启动渲染
        Logger.info(TAG,`start failed`);
        return;
      }
      await this.renderModel.start(); // 启动渲染
      await this.renderModel.setVolume(1.0); //调节音量
      Logger.info(TAG,`start AudioRenderer success`);
    } catch (err) {
      Logger.error(TAG,`start AudioRenderer failed ${JSON.stringify(err)}`);
    }
  }


  async write(buffer: ArrayBuffer): Promise<number> {
    try {
      let len: number = await this.renderModel.write(buffer);
      return len;
    } catch (err) {
      Logger.error(TAG,`AudioRenderer write  failed, error: ${JSON.stringify(err)}`);
    }
    return 0;
  }

  // 停止渲染
  async stop(): Promise<void> {
    try {
      // 只有渲染器状态为running或paused的时候才可以停止
      if (this.renderModel.state !== audio.AudioState.STATE_RUNNING && this.renderModel.state !== audio.AudioState.STATE_PAUSED) {
        Logger.info(TAG,`Renderer is not running or paused.`);
        return;
      }
      await this.renderModel.stop(); // 停止渲染
    } catch (err) {
      Logger.error(TAG,`AudioRenderer stop  failed, error: ${JSON.stringify(err)}`);
    }
  }

  // 销毁实例，释放资源
  async release(): Promise<void> {
    Logger.info(TAG,`Renderer  release`);
    try {
      // 渲染器状态不是released状态，才能release
      if (this.renderModel.state === audio.AudioState.STATE_RELEASED) {
        Logger.info(TAG,`Renderer already released`);
        return;
      }
      await this.renderModel.release(); // 释放资源
    } catch (err) {
      Logger.error(TAG,`AudioRenderer release failed, error: ${JSON.stringify(err)}`);
    }
  }
}
