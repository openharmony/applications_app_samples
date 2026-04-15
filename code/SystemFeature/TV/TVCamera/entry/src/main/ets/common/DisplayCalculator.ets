/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Constants } from '../common/Constants';

export class DisplaySize {
  public width: number = 0;
  public height: number = 0;
}

export default class DisplayCalculator {
  /**
   * 根据屏幕尺寸和目标宽高比计算预览显示尺寸。
   *
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param defaultAspectRatio 目标宽高比
   * @returns DisplaySize 计算后的显示尺寸
   */
  public static calcSurfaceDisplaySize(
    screenWidth: number, screenHeight: number, defaultAspectRatio: number
  ): DisplaySize {
    const displaySize: DisplaySize = new DisplaySize();
    displaySize.width = 1920;
    displaySize.height = 1080;
    if (AppStorage.get('deviceType') === Constants.TABLET || screenWidth > screenHeight) {
      if (screenWidth / screenHeight > defaultAspectRatio) {
        displaySize.width = Math.floor(screenHeight * defaultAspectRatio);
        displaySize.height = Math.floor(screenHeight);
      } else {
        displaySize.width = Math.floor(screenWidth);
        displaySize.height = Math.floor(screenWidth / defaultAspectRatio);
      }
    } else {
      if (screenWidth / screenHeight > defaultAspectRatio) {
        displaySize.width = Math.floor(screenHeight / defaultAspectRatio);
        displaySize.height = Math.floor(screenHeight);
      } else {
        displaySize.width = Math.floor(screenWidth);
        displaySize.height = Math.floor(screenWidth * defaultAspectRatio);
      }
    }
    return displaySize;
  }
}
