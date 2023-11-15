/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import media from '@ohos.multimedia.media';
import common from  '@ohos.app.ability.common';

const TAG = 'AVCastDemo';

export  default class AudioUtils {
  public avPlayer: media.AVPlayer | null = null;
  public state: string = '';
  public surfaceId: string = '';
  private callbackMap: Map<string, Function> = new Map();

  constructor() {
    console.log(TAG, `AVPlayer seek succeede in }`);
  }

  public async init() {
    this.avPlayer = await media.createAVPlayer();
    this.setAVPlayerCallback();
    return this.avPlayer;
  }

  setAVPlayerCallback() {
    if (!this.avPlayer) {
      console.log(TAG, 'no acPlayer');
      return;
    }
    this.avPlayer.on('seekDone', (seekDOneTime) => {
      console.log(TAG, `AVPlayer seek succeeded, seek time is ${seekDOneTime}`);
    })
    this.avPlayer.on('error', (err) => {
      console.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      this.avPlayer?.reset();
    })
    this.avPlayer.on('stateChange', async (state) => {
      this.state = state;
      switch (state) {
        case 'idle':
          console.log(TAG, 'AVPlayer state idle called.');
          this.callbackMap = new Map();
          break;
        case 'initialized':
          console.log(TAG, 'AVPlayer state initialized called.');
          if (this.surfaceId) {
            this.avPlayer.surfaceId = this.surfaceId;
          }
          this.avPlayer?.prepare().then(() => {
            console.log(TAG, 'AVPlayer prepare succeeded.');
          }), (err) => {
            console.log(TAG, `Invoke prepare failed, code is ${err.code}, message is ${err.message}`)
          }
          break;
        case 'prepared':
          console.log(TAG, 'AVPlayer state prepare called.');
          if (this.callbackMap.get('prepared')) {
            this.callbackMap.get('prepared').call(() => {
              console.log(TAG, 'AVPlayer state prepare start.');
            });
            this.callbackMap.set('prepared', null);
          }
          break;
        case 'playing':
          console.log(TAG, 'AVPlayer state playing called.');
          break;
        case 'paused':
          console.log(TAG, 'AVPlayer state paused called.');
          break;
        case 'completed':
          console.log(TAG, 'AVPlayer state completed called.');
          break;
        case 'stopped':
          console.log(TAG, 'AVPlayer state stopped called.');
          break;
        case 'released':
          console.log(TAG, 'AVPlayer state released called.');
          break;
        default:
          console.log(TAG, 'AVPlayer state unknown called.');
          break;
      }
    })
  }

  public on(event: 'prepared', callback) {
    this.callbackMap.set(event, callback)
  }

  public async loadFromSrcFd(fileDescriptor: media.AVFileDescriptor) {
    console.log(TAG, 'loadFromSrcFd: ' + JSON.stringify(fileDescriptor));
    if (!this.avPlayer) {
      console.log(TAG, 'no acPlayer');
      return;
    }
    if (this.state !== 'idle') {
      await this.avPlayer.reset();
    }
    this.avPlayer.fdSrc = fileDescriptor;
    return this.avPlayer;
  }

  public async loadFromRawFile(fileName: string) {
    console.log(TAG, 'loadFromRawFile: ' + fileName);
    if (!this.avPlayer) {
      console.log(TAG, 'no avplayer');
      return;
    }
    if (this.state !== 'idle') {
      await this.avPlayer.reset();
    }
    const context = getContext(this) as common.UIAbilityContext;
    const fileDescriptor = await context.resourceManager.getRawFd(fileName);
    console.log(TAG, 'fileDescriptor: ' + fileDescriptor);
    this.avPlayer.fdSrc = fileDescriptor;
    return this.avPlayer;
  }

  public async loadFromNetwork(url: string) {
    console.log(TAG, 'loadFromNetwork: ' + url);
    if (!this.avPlayer) {
      console.log(TAG, 'no avplayer');
      return;
    }
    if (this.state !== 'idle') {
      await this.avPlayer.reset();
    }
    this.avPlayer.url = url;
    return this.avPlayer;
  }
}