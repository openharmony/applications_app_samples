/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Logger from './Logger';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@ohos.base';

const TAG = '[AudioPlayer]';

class AudioPlayer {
  private avPlayer;

  private setAVPlayerCallback(): void {
    this.avPlayer.reset();
    this.avPlayer.on('stateChange', async (state) => {
      switch (state) {
        case 'idle':
          Logger.info(TAG, 'state idle called');
          break;
        case 'initialized':
          Logger.info(TAG, 'state initialized called ');
          this.avPlayer.prepare().then(() => {
            Logger.info(TAG, 'prepare success');
          }, (err) => {
            Logger.info(TAG, 'prepare filed,error message is :' + err.message);
          });
          break;
        case 'prepared':
          Logger.info(TAG, 'state prepared called');
          this.avPlayer.play();
          break;
        case 'playing':
          Logger.info(TAG, 'state playing called');
          break;
        case 'completed':
          Logger.info(TAG, 'state completed called');
          this.avPlayer.stop();
          break;
        case 'stopped':
          Logger.info(TAG, 'state stopped called');
          this.avPlayer.reset();
          break;
        case 'error':
          Logger.info(TAG, 'state error called');
          break;
        default:
          Logger.info(TAG, 'unknown state :' + state);
          break;
      }
    });
  }

  async playAudio(audioName: string): Promise<void> {
    if (this.avPlayer) {
      await this.avPlayer.reset();
    } else {
      this.avPlayer = await media.createAVPlayer();
      this.setAVPlayerCallback();
    }
    let rawFd = undefined;
    await globalThis.getContext()
      .resourceManager
      .getRawFd(audioName)
      .then(value => {
        rawFd = value;
        Logger.info(TAG, 'get audio resource successful');
        Logger.info(TAG, 'rawFd of audio:' + ' fd:' + rawFd.fd + ', offset:' + rawFd.offset + ', length: ' + rawFd.length);
      })
      .catch((error: BusinessError) => {
        Logger.info(TAG, 'get audio resource failed, err code:' + error.code + ' err msg:' + error.message);
      });
    this.avPlayer.fdSrc = rawFd;
  }
}

export default new AudioPlayer;
