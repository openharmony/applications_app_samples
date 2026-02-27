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
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[ImageUtil]';
/**
 * Converts a media resource into a PixelMap object.
 * @param resource The media resource containing bundle, module and ID references.
 * @returns Promise<image.PixelMap> with RGBA_8888 format.
 */
export async function getPixmapFromMedia(resource: Resource): Promise<image.PixelMap | undefined> {
  let unit8Array: Uint8Array | undefined = undefined;
  let imageSource: image.ImageSource | undefined = undefined;
  let pixelMap: image.PixelMap | undefined = undefined;

  try {
    const uiContext: UIContext | undefined = AppStorage.get('uiContext');
    unit8Array = await uiContext?.getHostContext()?.resourceManager.getMediaContent(resource.id);
    imageSource = image.createImageSource(unit8Array?.buffer.slice(0, unit8Array?.buffer.byteLength));
    pixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    });
    return pixelMap;
  } catch (error) {
    const err = error as BusinessError;
    hilog.error(0x0000, TAG, `Getting PixelMap from media failed: errCode = ${err.code}, errMessage = ${err.message}.`);
    return undefined;
  } finally {
    try {
      if (imageSource) {
        await imageSource.release();
      }
    } catch (releaseError) {
      const releaseErr = releaseError as BusinessError;
      hilog.error(0x0000, TAG,
        `Releasing image source failed: errCode = ${releaseErr.code}, errMessage = ${releaseErr.message}.`);
    }
    unit8Array = undefined;
  }
}