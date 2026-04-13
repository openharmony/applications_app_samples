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

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
// [Start media_tools]
import { util } from '@kit.ArkTS';
import Logger from '../Logger';

// [StartExclude media_tools]

const TAG = 'MediaTools';
// [EndExclude media_tools]
export class MediaTools {
  // [StartExclude media_tools]
  static async getPixelMapFromResource(context: common.UIAbilityContext,
    name: resourceManager.Resource): Promise<PixelMap> {
    let resourceMgr = context.resourceManager;
    let fileData: Uint8Array = await resourceMgr.getMediaContent(name.id);
    return await image.createImageSource(fileData.buffer as ArrayBuffer).createPixelMap();
  }

  static async getPixelMapFromFile(id: string, path: string): Promise<image.PixelMap> {
    Logger.info(TAG, 'getPixelMapFromFile id:' + id + ', path:' + path);
    return await image.createImageSource(path).createPixelMap();
  }

  /**
   * @param {string} value - Data value
   * @return {string} - If the date is less than two digits, add 0
   */
  private static fill(value: number): string {
    return value.toString().padStart(2, '0');
  }

  static msToCountdownTime(ms: number): string {
    if (!ms) {
      return '00:00';
    }
    const days = Math.floor(ms / (1000 * 60 * 60 * 24));
    const hours = Math.floor((ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((ms % (1000 * 60)) / 1000);
    return `${(days ? MediaTools.fill(days) + ':' : '')}${(hours ? MediaTools.fill(hours) + ':' : '')}
      ${MediaTools.fill(minutes)}:${MediaTools.fill(seconds)} `.trim();
  }
  // [EndExclude media_tools]
  static async getLrcFromRawFile(context: common.UIAbilityContext, filename: string): Promise<string | undefined> {
    if (!filename) {
      return undefined;
    }
    const lyricUint8Array: Uint8Array = await context.resourceManager.getRawFileContent(filename);
    let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    let resStr: string = textDecoder.decodeToString(lyricUint8Array, { stream: false });
    return resStr;
  }
}
// [End media_tools]