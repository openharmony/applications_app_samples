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
import Log from './Log';

export default class AudioUtils {
  public avPlayer: media.AVPlayer | null = null;
  public state: string = '';
  public surfaceId: string = '';
  private callbackMap: Map<string, Function> = new Map();
  private playState: SubscribedAbstractProperty<number>;

  constructor() {
    Log.info(`AVPlayer seek succeede in `);
    this.playState = AppStorage.SetAndLink('playState', -1);
  }

  public async init() {
    this.avPlayer = await media.createAVPlayer();
    this.setAVPlayerCallback();
    return this.avPlayer;
  }

  setAVPlayerCallback() {
    if (!this.avPlayer) {
      Log.info('no acPlayer');
      return;
    }
    this.avPlayer.on('seekDone', (seekDOneTime) => {
      Log.info(`AVPlayer seek succeeded, seek time is ${seekDOneTime}`);
    })
    this.avPlayer.on('error', (err) => {
      Log.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      this.avPlayer?.reset();
    })
    this.avPlayer.on('stateChange', async (state) => {
      this.state = state;
      switch (state) {
        case 'idle':
          Log.info('AVPlayer state idle called.');
          this.callbackMap = new Map();
          break;
        case 'initialized':
          Log.info('AVPlayer state initialized called.');
          if (this.avPlayer && this.surfaceId) {
            this.avPlayer.surfaceId = this.surfaceId;
          }
          try {
            this.avPlayer?.prepare().then(() => {
              Log.info('AVPlayer prepare succeeded.');
            });
          } catch(err) {
            Log.info(`Invoke prepare failed, err : ${JSON.stringify(err)}`)
          }
          break;
        case 'prepared':
          Log.info('AVPlayer state prepare called.');
          if (this.callbackMap.get('prepared')) {
            this.callbackMap.get('prepared');
            Log.info('AVPlayer state prepare start.');
            this.callbackMap.set('prepared', ()=>{});
          }
          break;
        case 'playing':
          Log.info('AVPlayer state playing called.');
          break;
        case 'paused':
          Log.info('AVPlayer state paused called.');
          break;
        case 'completed':
          Log.info('AVPlayer state completed called.');
          this.playState.set(-1);
          break;
        case 'stopped':
          Log.info('AVPlayer state stopped called.');
          break;
        case 'released':
          Log.info('AVPlayer state released called.');
          break;
        default:
          Log.info('AVPlayer state unknown called.');
          break;
      }
    })
  }

  public on(event: string, callback: Function) {
    this.callbackMap.set(event, callback)
  }

  public async loadFromSrcFd(fileDescriptor: media.AVFileDescriptor) {
    Log.info('loadFromSrcFd: ' + JSON.stringify(fileDescriptor));
    if (!this.avPlayer) {
      Log.info('no acPlayer');
      return;
    }
    if (this.state !== 'idle') {
      await this.avPlayer.reset();
    }
    this.avPlayer.fdSrc = fileDescriptor;
    return this.avPlayer;
  }

  public async loadFromRawFile(fileName: string) {
    Log.info('loadFromRawFile: ' + fileName);
    if (!this.avPlayer) {
      Log.info('no avplayer');
      return;
    }
    if (this.state !== 'idle') {
      await this.avPlayer.reset();
    }
    const context = getContext(this) as common.UIAbilityContext;
    const fileDescriptor = await context.resourceManager.getRawFd(fileName);
    Log.info('fileDescriptor: ' + fileDescriptor);
    this.avPlayer.fdSrc = fileDescriptor;
    return this.avPlayer;
  }

  public async loadFromNetwork(url: string) {
    Log.info('loadFromNetwork: ' + url);
    if (!this.avPlayer) {
      Log.info('no avplayer');
      return;
    }
    if (this.state !== 'idle') {
      await this.avPlayer.reset();
    }
    this.avPlayer.url = url;
    return this.avPlayer;
  }
}