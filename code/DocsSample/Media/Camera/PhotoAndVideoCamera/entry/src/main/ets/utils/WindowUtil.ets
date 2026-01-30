/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { display, window } from '@kit.ArkUI';
import { Logger } from 'commons';

const TAG = 'WindowUtil'

class WindowUtil {
  static async enterImmersive(window: window.Window): Promise<void> {
    try {
      await window.setWindowLayoutFullScreen(true);
      await window.setWindowSystemBarEnable([]);
    } catch (exception) {
      Logger.error(TAG, 'Failed to enter immersive. Cause:', JSON.stringify(exception));
    }
  }

  // Given a ratio, obtain the maximum display width and height based on the screen width and height.
  static getMaxDisplaySize(ratio: number): Size {
    const defaultDisplay: display.Display = display.getDefaultDisplaySync();
    const windowWidth: number = defaultDisplay.width;
    const windowHeight: number = defaultDisplay.height;
    const rotation = display.getDefaultDisplaySync().rotation * 90;
    if (rotation === 90 || rotation === 270) {
      ratio = 1 / ratio;
    }
    // Calculate the height based on the screen width.
    const calculatedHeight = windowWidth * ratio;
    if (calculatedHeight <= windowHeight) {
      return {
        width: windowWidth,
        height: calculatedHeight
      };
    } else {
      return {
        width: windowHeight / ratio,
        height: windowHeight
      };
    }
  }

  static getWindowRatio(): number {
    const defaultDisplay: display.Display = display.getDefaultDisplaySync();
    return defaultDisplay.height / defaultDisplay.width;
  }
}

export default WindowUtil;