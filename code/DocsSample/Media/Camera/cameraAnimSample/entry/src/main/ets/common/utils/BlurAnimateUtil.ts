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

import { image } from '@kit.ImageKit';
import Logger from './Logger';
import { Constants } from '../Constants';

const TAG: string = 'BlurAnimateUtil';

// [Start blur_animate_util]
export class BlurAnimateUtil {
  public static surfaceShot: image.PixelMap;
  // [StartExclude blur_animate_util]
  public static readonly SHOW_BLUR_DURATION: number = 200;
  public static readonly HIDE_BLUR_DURATION: number = 200;
  public static readonly ROTATION_DURATION: number = 200;
  public static readonly FLIP_DELAY: number = 50;
  public static readonly ROTATE_AXIS: number = 0.5;
  public static readonly IMG_ROTATE_ANGLE_90: number = 90;
  public static readonly IMG_ROTATE_ANGLE_270: number = 270;
  public static readonly IMG_FLIP_ANGLE_0: number = 0;
  public static readonly IMG_FLIP_ANGLE_180: number = 180;
  public static readonly IMG_FLIP_ANGLE_90: number = 90;
  public static readonly IMG_FLIP_ANGLE_270: number = 270;
  public static readonly IMG_FLIP_ANGLE_MINUS_90: number = -90;
  public static readonly ANIM_MODE_SWITCH_BLUR = 48;
  public static readonly IMG_SCALE: number = 0.75;
  // [EndExclude blur_animate_util]

  /**
   * 获取surface截图
   * @param surfaceId
   * @returns
   */
  public static async doSurfaceShot(surfaceId: string) {
    Logger.info(TAG, `doSurfaceShot surfaceId:${surfaceId}.`);
    if ('' === surfaceId) {
      Logger.error(TAG, 'surface not ready!');
      return;
    }
    try {
      if (this.surfaceShot) {
        await this.surfaceShot.release();
      }
      this.surfaceShot = await image.createPixelMapFromSurface(surfaceId, {
        size: { width: Constants.X_COMPONENT_SURFACE_WIDTH, height: Constants.X_COMPONENT_SURFACE_HEIGHT }, // 取预览流profile的宽高。
        x: 0,
        y: 0
      });
      let imageInfo: image.ImageInfo = await this.surfaceShot.getImageInfo();
      Logger.info('doSurfaceShot surfaceShot:' + JSON.stringify(imageInfo.size));
    } catch (err) {
      Logger.error(JSON.stringify(err))
    }
  }

  public static getSurfaceShot() {
    return this.surfaceShot;
  }
}
// [End blur_animate_util]