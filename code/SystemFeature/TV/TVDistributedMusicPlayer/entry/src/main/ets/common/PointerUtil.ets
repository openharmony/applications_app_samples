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

import { pointer } from '@kit.InputKit';
import { image } from '@kit.ImageKit';
import { JSON } from '@kit.ArkTS';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 指针相关工具类
 */
export class PointerUtil {
  public static pixelMap: image.PixelMap | null = null;

  /**
   * 修改鼠标样式
   * @param isClick 是否点击
   */
  static changePointStyle(isClick: boolean): void {
    try {
      // 直接使用资源引用，不通过resourceManager
      const resourceId = isClick ? $r('app.media.mouse_click') : $r('app.media.mouse_show');
      // 简化实现，暂时注释掉复杂的鼠标样式设置
      console.log(`changePointStyle: ${isClick}`);
    } catch (error) {
      console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  /**
   * 设置鼠标样式为默认样式
   */
  static changePointDefaultStyle(): void {
    try {
      // 简化实现，暂时注释掉复杂的鼠标样式设置
      console.log(`changePointDefaultStyle`);
    } catch (error) {
      console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }
}

