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
import { window } from '@kit.ArkUI';
import Logger from './Logger';

const TAG = 'ColorConversion';

/**
 * Color conversion processing class.
 */
export class ColorConversion {
  /**
   * Generate an immersive background color for the image.
   * @param rRGB
   * @param gRGB
   * @param bRGB
   * @returns
   */
  public static dealColor(rRGB: number, gRGB: number, bRGB: number) {
    let max = Math.max(Math.max(rRGB, gRGB), bRGB);
    let min = Math.min(Math.min(rRGB, gRGB), bRGB);
    let sHSB = max === 0 ? 0 : (max - min) / max;
    let bHSB = max / 255;
    let hHSB = 0;
    if (max === rRGB && gRGB >= bRGB) {
      hHSB = 60 * (gRGB - bRGB) / (max - min) + 0;
    }
    if (max === rRGB && gRGB < bRGB) {
      hHSB = 60 * (gRGB - bRGB) / (max - min) + 360;
    }
    if (max === gRGB) {
      hHSB = 60 * (bRGB - rRGB) / (max - min) + 120;
    }
    if (max === bRGB) {
      hHSB = 60 * (rRGB - gRGB) / (max - min) + 240;
    }

    if (bHSB >= 0.4) {
      bHSB = 0.3;
    } else if (bHSB >= 0.2) {
      bHSB -= 0.1;
    } else {
      bHSB = bHSB + 0.2;
    }

    let i: number = Math.floor((hHSB / 60) % 6);
    let f = (hHSB / 60) - i;
    let p = bHSB * (1 - sHSB);
    let q = bHSB * (1 - f * sHSB);
    let t = bHSB * (1 - (1 - f) * sHSB);
    switch (i) {
      case 0:
        rRGB = bHSB;
        gRGB = t;
        bRGB = p;
        break;
      case 1:
        rRGB = q;
        gRGB = bHSB;
        bRGB = p;
        break;
      case 2:
        rRGB = p;
        gRGB = bHSB;
        bRGB = t;
        break;
      case 3:
        rRGB = p;
        gRGB = q;
        bRGB = bHSB;
        break;
      case 4:
        rRGB = t;
        gRGB = p;
        bRGB = bHSB;
        break;
      case 5:
        rRGB = bHSB;
        gRGB = p;
        bRGB = q;
        break;
      default:
        break;
    }
    return [Math.floor(rRGB * 255.0), Math.floor(gRGB * 255.0), Math.floor(bRGB * 255.0)];
  }

  /**
   * Set the status bar to dark color .
   * @param isDarkBackground
   */
  public static async setSysBarLightBackground(isDarkBackground: boolean) {
    Logger.info(TAG, 'setSysBarLightBackground isDarkBackground is: ' + isDarkBackground);
    let window: window.Window | undefined = AppStorage.get('window');
    if (!window) {
      return;
    }
    let systemBarProperties: window.SystemBarProperties = {
      statusBarContentColor: '#ffffff',
    };
    if (!isDarkBackground) {
      Logger.info(TAG, 'current background is Dark ');
      systemBarProperties = {
        statusBarContentColor: '#000000',
      }
    }

    window.setWindowSystemBarProperties(systemBarProperties).then(() => {
      Logger.info(TAG, 'setWindowSystemBarProperties success ');
    })
  }
}