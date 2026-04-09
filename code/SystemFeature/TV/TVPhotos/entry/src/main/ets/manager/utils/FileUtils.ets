/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import fileIo from '@ohos.file.fs';
import Logger from '../../common/Logger';
import { DirectoryEntry } from 'smbProtocol';

const TAG = 'FileUtil'
const DEFAULT_IMAGE_QUALITY = 100

class FileUtil {
  async getNasCacheDir(context: Context): Promise<string> {
    const cacheDir = context.cacheDir + '/nasCovers/'
    try {
      let exist = false
      try {
        let stat = await fileIo.stat(cacheDir)
        exist = stat.isDirectory()
      } catch (e) {
      }
      if (!exist) {
        fileIo.mkdirSync(cacheDir)
      }
    } catch (e) {
      Logger.error('getCache dir fail ' + JSON.stringify(e))
      throw new Error('getCache dir fail ' + JSON.stringify(e))
    }
    return cacheDir
  }

  async getCacheDir(context: Context): Promise<string> {
    const cacheDir = context.cacheDir + '/videoCovers/'
    try {
      let exist = false
      try {
        let stat = await fileIo.stat(cacheDir)
        exist = stat.isDirectory()
      } catch (e) {
      }
      if (!exist) {
        fileIo.mkdirSync(cacheDir)
      }
    } catch (e) {
      Logger.error('getCache dir fail ' + JSON.stringify(e))
      throw new Error('getCache dir fail ' + JSON.stringify(e))
    }
    return cacheDir
  }

  getLocalFilePathByUri(uri: string): string {
    let newName = uri.replace('file://', '').replaceAll('/', '_')
    return newName + '.thumb'
  }

  getNasLocalFile(host: string, imageFile: DirectoryEntry) {
    let newName =
      `${host.replaceAll('.', '')}_${imageFile.shareEnum}_${imageFile.absoluteDir.replace('/',
        '_')}_${imageFile.filename}`
    return newName + '.thumb'
  }

  fileExist(path: string): Promise<boolean> {
    return fileIo.access(path)
  }

  async savePixelMap(pixelMap: image.PixelMap, path: string): Promise<void> {
    try {
      let imagePacker = image.createImagePacker();
      // 设置编码格式为 PNG
      let options: image.PackingOption = { format: 'image/png', quality: DEFAULT_IMAGE_QUALITY };
      // 将 PixelMap 编码为指定格式
      let imageArray = await imagePacker.packing(pixelMap, options)
      let imageFile = await fileIo.open(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
      await fileIo.write(imageFile.fd, imageArray);
      await fileIo.close(imageFile.fd);
    } catch (e) {
      Logger.error('save pixel map fail ' + JSON.stringify(e))
      throw new Error('save pixel map fail ' + JSON.stringify(e))
    }
  }
}

let fileUtil = new FileUtil()

export default fileUtil