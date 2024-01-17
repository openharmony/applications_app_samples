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
import resourceManager from '@ohos.resourceManager';

export class ImageUtils {

  /**
   * 从Resource创造PixelMap
   */
  static async createPixelMapFromResource(resource: Resource, context: Context): Promise<image.PixelMap> {
    let colorsBuffer = await ImageUtils.getResourceArrayBufferFromResourceManager(resource, context);
    let imageSource: image.ImageSource = image.createImageSource(colorsBuffer);
    return ImageUtils.createPixelMapFromImageSource(imageSource);
  }

  private static async createPixelMapFromImageSource(imageSource: image.ImageSource): Promise<image.PixelMap> {
    let decodingOptions: image.DecodingOptions = {
      editable: true,
    };
    return await imageSource.createPixelMap(decodingOptions);
  }

  private static async getResourceArrayBufferFromResourceManager(resource: Resource, context: Context): Promise<ArrayBuffer> {
    let resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    let fileData: Uint8Array = await resourceMgr.getMediaContent(resource);
    return fileData.buffer;
  }
}