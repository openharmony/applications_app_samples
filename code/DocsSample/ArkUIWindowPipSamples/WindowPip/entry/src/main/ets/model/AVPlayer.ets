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

// [Start pip_common_avplayer]
// model/AVPlayer.ets
// 简易播放器实现
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { Logger } from '../util/LogUtil';

export class AVPlayer {
  private avPlayer?: media.AVPlayer;
  public surfaceID: string = '';

  setAVPlayerCallback() {
    this.avPlayer?.on('seekDone', (seekDoneTime: number) => {
      Logger.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    })
    this.avPlayer?.on('stateChange', async (state, reason) => {
      if (!this.avPlayer) {
        return;
      }
      switch (state) {
        case 'idle':
          this.avPlayer.release();
          break;
        case 'initialized':
          this.avPlayer.surfaceId = this.surfaceID;
          this.avPlayer.prepare().then(() => {
            Logger.info('AVPlayer prepare succeeded.');
          }, (err: BusinessError) => {
            Logger.error(`Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'prepared':
          this.avPlayer.play();
          break;
        case 'stopped':
          this.avPlayer.reset();
          break;
        default:
          break;
      }
    })
  }

  async avPlayerFdSrc() {

    try {
      this.avPlayer = await media.createAVPlayer();
    } catch(err) {
      Logger.error(`create AVPlayer failed`);
    };
    this.setAVPlayerCallback();
    let uiContext = AppStorage.get('UIContext') as UIContext;
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let fileDescriptor = await context.resourceManager.getRawFd('xxx.mp4');

    if (this.avPlayer) {
      this.avPlayer.fdSrc = fileDescriptor;
    }
  }
}
// [End pip_common_avplayer]