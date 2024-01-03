/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import media from '@ohos.multimedia.media';
import resourceManager from '@ohos.resourceManager';
import Logger from './Logger';

const TAG = 'mSoundUtil';

// 使用 AVPlayer 播放铃声
class SoundUtil {
  private avPlayer: media.AVPlayer | null = null;

  // 初始化，创建实例
  async playFd(fd: resourceManager.RawFileDescriptor): Promise<void> {
    Logger.info(TAG,`create AVPlayer playFd ${fd.fd}`);
    try {
      this.release();
      this.avPlayer = await media.createAVPlayer();
      this.avPlayer.on('stateChange', (state: media.AVPlayerState, reason: media.StateChangeReason) => {
        this.onStateChange(state, reason);
      });
      this.avPlayer.fdSrc = fd;
      Logger.info(TAG, `create AVPlayer success`);
    } catch (err) {
      Logger.error(TAG, `Invoke AVPlayer failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  async release(): Promise<void> {
    Logger.info(TAG, `avPlayer release`);
    try {
      if (this.avPlayer) {
        this.avPlayer.off('stateChange');
        if (this.avPlayer.state === 'prepared' || this.avPlayer.state === 'playing' || this.avPlayer.state === 'paused' || this.avPlayer.state === 'completed') {
          await this.avPlayer.stop();
        }
        await this.avPlayer.release();
        this.avPlayer = null;
      }
    } catch (err) {
      Logger.error(TAG, `release AVPlayer failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  private async onStateChange(state: media.AVPlayerState, reason: media.StateChangeReason): Promise<void> {
    Logger.info(TAG, `AVPlayer stateChange  ${reason}  :  ${state}`);
    try {
      switch (state) {
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          if (this.avPlayer) {
            await this.avPlayer.prepare();
            Logger.info(TAG, 'AVPlayer prepare succeeded.');
          }
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          if (this.avPlayer) {
            await this.avPlayer.play(); // 调用播放接口开始播放
            Logger.info(TAG, 'AVPlayer play succeeded.');
          }
          break;
        case 'completed': // 播放结束后触发该状态机上报
          if (this.avPlayer) {
            await this.avPlayer.play(); // 调用播放接口开始播放
          }
          break;
        case 'paused': // 播放结束后触发该状态机上报
        case 'stopped': // 播放结束后触发该状态机上报
        case 'error': // 播放错误时触发该状态机上报
          this.release();
          break;
      }
    } catch (err) {
      Logger.error(TAG, `AVPlayer onStateChange failed ${JSON.stringify(err)}`);
    }
  }
}


let mObject = new SoundUtil;

export default mObject as SoundUtil;
