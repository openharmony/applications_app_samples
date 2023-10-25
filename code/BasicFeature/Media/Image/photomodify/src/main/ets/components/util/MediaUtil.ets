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
import image from '@ohos.multimedia.image'
import fs from '@ohos.file.fs';

export async function readImage(uri: string): Promise<PixelMap | null> {
  const prefix: string = 'file:/';
  if (uri.startsWith('file://media')) {
  } else if (prefix) {
    uri = uri.substr(prefix.length);
  }
  // path参数为文件的应用沙箱路径或文件URI，所以使用沙箱路径时，需要去掉前缀
  const file: fs.File = await fs.open(uri, fs.OpenMode.READ_ONLY);
  let imageSourceApi: image.ImageSource = image.createImageSource(file.fd);
  if (!imageSourceApi) {
    return null;
  }
  let pixmap: image.PixelMap = await imageSourceApi.createPixelMap();
  if (!pixmap) {
    return null;
  }
  return pixmap;
}