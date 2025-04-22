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
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { audio } from '@kit.AudioKit';

// export default async function modelPredict(
export default class AVPlayerDemo {
  private count: number = 10;
  private isSeek: boolean = true; // 用于区分模式是否支持seek操作。
  private fileSize: number = -1;
  private fd: number = 0;
  // 注册avplayer回调函数。
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    // seek操作结果回调函数。
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      console.info(`MS_LITE_LOG: AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程。
    avPlayer.on('error', (err: BusinessError) => {
      console.error(`MS_LITE_LOG: Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      avPlayer.reset(); // 调用reset重置资源，触发idle状态。
    });
    // 状态机变化回调函数。
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报。
          console.info('MS_LITE_LOG: AVPlayer state idle called.');
          avPlayer.release(); // 调用release接口销毁实例对象。
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报。
          console.info('MS_LITE_LOG: AVPlayer state initialized called.');
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型：音乐。根据业务场景配置，参考StreamUsage。
            rendererFlags: 0 // 音频渲染器标志。
          };
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机。
          console.info('MS_LITE_LOG: AVPlayer state prepared called.');
          avPlayer.play(); // 调用播放接口开始播放。
          break;
        case 'playing': // play成功调用后触发该状态机上报。
          console.info('MS_LITE_LOG: AVPlayer state playing called.');
          if (this.count !== 0) {
            if (this.isSeek) {
              console.info('MS_LITE_LOG: AVPlayer start to seek.');
              avPlayer.seek(0); //seek到音频末尾。
            } else {
              // 当播放模式不支持seek操作时继续播放到结尾。
              console.info('MS_LITE_LOG: AVPlayer wait to play end.');
            }
          } else {
            setTimeout(() => {
              console.info('MS_LITE_LOG: AVPlayer playing wait to pause');
              avPlayer.pause(); // 播放3s后调用暂停接口暂停播放。
            }, 3000);
          }
          this.count++;
          break;
        case 'paused': // pause成功调用后触发该状态机上报。
          console.info('MS_LITE_LOG: AVPlayer state paused called.');
          setTimeout(() => {
            console.info('MS_LITE_LOG: AVPlayer paused wait to play again');
            avPlayer.play(); // 暂停3s后再次调用播放接口开始播放。
          }, 3000);
          break;
        case 'completed': // 播放结束后触发该状态机上报。
          console.info('MS_LITE_LOG: AVPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口。
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报。
          console.info('MS_LITE_LOG: AVPlayer state stopped called.');
          avPlayer.reset(); // 调用reset接口初始化avplayer状态。
          break;
        case 'released':
          console.info('MS_LITE_LOG: AVPlayer state released called.');
          break;
        default:
          console.info('MS_LITE_LOG: AVPlayer state unknown called.');
          break;
      }
    });
  }

  // 以下demo为使用资源管理接口获取打包在HAP内的媒体资源文件并通过fdSrc属性进行播放示例。
  async avPlayerFdSrcDemo() {
    console.warn('MS_LITE_LOG: begin to run avPlayerFdSrcDemo.');
    // 创建avPlayer实例对象。
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数。
    this.setAVPlayerCallback(avPlayer);
    console.warn('MS_LITE_LOG: begin to run setAVPlayerCallback.');
    // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址。
    // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度。
    let context = getContext(this) as common.UIAbilityContext;
    let fileDescriptor = await context.resourceManager.getRawFd('zh.wav');
    console.warn('MS_LITE_LOG: begin to run fileDescriptor.fd: ' + fileDescriptor.fd);
    console.warn('MS_LITE_LOG: begin to run fileDescriptor.offset: ' + fileDescriptor.offset);
    console.warn('MS_LITE_LOG: begin to run fileDescriptor.length: ' + fileDescriptor.length);

    let avFileDescriptor: media.AVFileDescriptor =
      { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    this.isSeek = true; // 支持seek操作。
    // 为fdSrc赋值触发initialized状态机上报。
    avPlayer.fdSrc = avFileDescriptor;
    console.warn('MS_LITE_LOG: run end.');
  }

}

