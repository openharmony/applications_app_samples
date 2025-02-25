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
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { audio } from '@kit.AudioKit';
import { logger } from '../common/util/Logger';
import { BusinessError } from '@ohos.base';

/**
 * 扫码提示发声类
 */
export class PromptTone {
  public avPlayer: media.AVPlayer | undefined = undefined;
  private static instance: PromptTone | null = null;
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_NOTIFICATION,
    rendererFlags: 0
  };

  constructor(context: common.UIAbilityContext) {
    this.initPlayer(context);
  }

  public static getInstance(context: common.UIAbilityContext): PromptTone {
    if (PromptTone.instance === null) {
      PromptTone.instance = new PromptTone(context);
    }
    return PromptTone.instance;
  }

  public async initPlayer(context: common.UIAbilityContext): Promise<void> {
    if (!this.avPlayer) {
      try {
        this.avPlayer = await media.createAVPlayer();
      } catch (error) {
        logger.error(`Failed to create avPlayer. Code: ${error.code}`);
      }

      this.setAVPlayerCallback();
      let contextUsed = context as common.UIAbilityContext;
      try {
        let fileDescriptor: resourceManager.RawFileDescriptor = await contextUsed.resourceManager.getRawFd('di.ogg');
        this.avPlayer!.fdSrc = fileDescriptor;
      } catch (error) {
        logger.error(`Failed to invoke an API of getRawFd. Code: ${error.code}`);
      }
    }
  }

  public playDrip(): void {
    try {
      if (this.avPlayer) {
        this.avPlayer.play();
      }
    } catch (error) {
      logger.error(`Failed to play drip. Code: ${error.code}`);
    }
  }

  public prepareAVPlayer(): void {
    try {
      this.avPlayer!.prepare().catch((error: BusinessError) => {
        logger.error(`Failed to prepare avPlayer. Code: ${error.code}`);
      });
    } catch (error) {
      logger.error(`Failed to prepare avPlayer. Code: ${error.code}`);
    }
  }

  public setAVPlayerCallback(): void {
    if (!this.avPlayer) {
      return;
    }
    try {
      this.avPlayer.on('stateChange', async (state, _) => {
        switch (state) {
          case 'idle':
            this.prepareAVPlayer();
            break;
          case 'initialized':
            this.avPlayer!.audioRendererInfo = this.audioRendererInfo;
            try {
              this.avPlayer!.prepare()
                .then(() => {
                  // 设置音量50%
                  this.avPlayer!.setVolume(0.5);
                }, (error: BusinessError) => {
                  logger.error(`Failed to prepare avPlayer. Code: ${error.code}`);
                });
            } catch (error) {
              logger.error(`Failed to prepare avPlayer. Code: ${error.code}`);
            }
            break;
          case 'completed':
            break;
          case 'stopped':
            this.prepareAVPlayer();
            break;
          default:
            break;
        }
      });
    } catch (error) {
      logger.error(`Failed to on avPlayer. Code: ${error.code}`);
    }

  }
}