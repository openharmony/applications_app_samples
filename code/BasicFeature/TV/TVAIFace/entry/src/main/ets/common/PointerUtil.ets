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
      getContext()
        .resourceManager
        .getMediaContent(isClick ? $r('app.media.mouse_click') : $r('app.media.mouse_show'))
        .then((svgFileData: Uint8Array) => {
          const svgBuffer: ArrayBuffer = svgFileData.buffer.slice(0);
          let svgImageSource: image.ImageSource = image.createImageSource(svgBuffer);
          let svgDecodingOptions: image.DecodingOptions = { desiredSize: { width: 50, height: 50 } };
          svgImageSource.createPixelMap(svgDecodingOptions).then((pixelMap: image.PixelMap) => {
            window.getLastWindow(getContext(), (_error: BusinessError, win: window.Window) => {
              if (win && win.getWindowProperties() && win.getWindowProperties().id) {
                let windowId: number = win.getWindowProperties().id;
                try {
                  pointer.setCustomCursorSync(windowId, pixelMap, 25, 25);
                  console.log(`setCustomCursorSync success`);
                } catch (error) {
                  console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              }
            });
          });
        });
    } catch (error) {
      console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }
}

