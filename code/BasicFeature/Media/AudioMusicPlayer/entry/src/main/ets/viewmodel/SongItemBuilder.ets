/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { SongItem } from './SongData';
import Logger from '../common/utils/Logger';

export default class SongItemBuilder {
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private rawFileDescriptor?: resourceManager.RawFileDescriptor;
  private songItem: SongItem | null = null;

  public async build(songItem: SongItem): Promise<SongItem> {
    this.songItem = songItem;
    if (!this.context) {
      return this.songItem;
    }
    let rawFileDescriptor = await this.context.resourceManager.getRawFd(songItem.src)
      .catch((error: BusinessError) => {
        Logger.error(`resourceManager error code ${error.code} message ${error.message}`);
      })
    if (rawFileDescriptor) {
      this.rawFileDescriptor = rawFileDescriptor;
    }
    Logger.info('MediaAssetBuilder build rawFileDescriptor:' + this.rawFileDescriptor);
    return this.songItem;
  }

  public getRawFileDescriptor(): resourceManager.RawFileDescriptor | undefined {
    Logger.info(`rawFileDescriptor: ${this.rawFileDescriptor}`);
    return this.rawFileDescriptor;
  }

  public async release(): Promise<void> {
    if (this.context && this.context !== null && this.songItem !== null) {
      this.context.resourceManager.closeRawFd(this.songItem.src);
    }
    this.songItem = null;
  }
}