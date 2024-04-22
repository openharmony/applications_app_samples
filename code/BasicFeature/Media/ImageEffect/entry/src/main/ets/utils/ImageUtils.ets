/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import image from '@ohos.multimedia.image';

export class ImageUtils {
  private static  instance: ImageUtils;

  public static getInstance(): ImageUtils {
    if (!ImageUtils.instance) {
      ImageUtils.instance = new ImageUtils();
    }
    return ImageUtils.instance;
  }

  async getPixelMap(resource: Resource): Promise<image.PixelMap> {
    const resourceStr = getContext(this).resourceManager;
    let imageBuffer = await resourceStr.getMediaContent(resource);
    const pixelMap = await image.createImageSource(imageBuffer.buffer as object as ArrayBuffer).createPixelMap();
    return pixelMap;
  }

  async getPixelMapByFilePath(filePath: string): Promise<image.PixelMap> {
    const imageSource: image.ImageSource = image.createImageSource(filePath)
    const pixelMap = await imageSource.createPixelMap();
    return pixelMap;
  }
}