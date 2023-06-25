/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import image from '@ohos.multimedia.image';

async function copyPixelMap(pm: PixelMap): Promise<PixelMap> {
  const imageInfo: image.ImageInfo = await pm.getImageInfo();
  const w: number = imageInfo.size.width;
  const h: number = imageInfo.size.height;
  let buffer: ArrayBuffer = new ArrayBuffer(w * h * 4);
  // readPixelsToBuffer输出为BGRA_8888
  await pm.readPixelsToBuffer(buffer);
  // pixelFormat 4代表BGRA_8888，3代表BARG_8888。  这里使用copyPixelMap的时候，每次都进行两次转换，保证色值正常。
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: w, width: h } };
  return await image.createPixelMap(buffer, opts);
}

export { copyPixelMap };