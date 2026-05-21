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
import { fileIo } from '@kit.CoreFileKit'
import { MLog } from './MLog';
import { image } from '@kit.ImageKit';
import { taskpool } from '@kit.ArkTS';
import { getVideoThumb } from '../manager/FileTaskPool';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'FileUtil';
const DEFAULT_IMAGE_QUALITY = 100;

interface ImageDimensions {
  width: number;
  height: number;
}

interface ImageErrorInfo {
  uri: string;
  errorCode?: number;
  errorMessage?: string;
  errorName?: string;
  fullError: string;
}

class FileUtil {
  // 获取缓存目录
  async getCacheDir(context: Context): Promise<string> {
    const cacheDir = context.cacheDir + '/videoCovers/';
    try {
      let exist = false;
      try {
        let stat = await fileIo.stat(cacheDir);
        exist = stat.isDirectory();
      } catch (e) {
        MLog.error(TAG, 'get file stat' + JSON.stringify(e));
      }
      if (!exist) {
        fileIo.mkdirSync(cacheDir);
      }
    } catch (e) {
      MLog.error(TAG, 'getCacheDir' + JSON.stringify(e));
      throw new Error('getCache dir fail ' + JSON.stringify(e));
    }
    return cacheDir;
  }

  // 保存图片
  async savePixelMap(pixelMap: image.PixelMap, path: string): Promise<void> {
    try {
      const imagePacker = image.createImagePacker();
      // 编码为指定格式
      const options: image.PackingOption = {
        format: 'image/png',
        quality: DEFAULT_IMAGE_QUALITY
      };
      let imageArray: ArrayBuffer = await imagePacker.packToData(pixelMap, options);
      const imageFile = await fileIo.open(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
      await fileIo.write(imageFile.fd, imageArray);
      await fileIo.close(imageFile.fd);
    } catch (e) {
      MLog.error(TAG, 'save pixel map fail ' + JSON.stringify(e));
      throw new Error('save pixel map fail ' + JSON.stringify(e));
    }
  }

  // 生成文件名
  getFileName(str: string) {
    let fileCode = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      fileCode = ((fileCode << 5) - fileCode) + char;
      fileCode = fileCode & fileCode;
    }
    return Math.abs(fileCode).toString(16);
  }

  // 获取视频缩略图
  async getThumbNail(cacheDir: string, uri: string, width: number, height: number): Promise<string> {
    const task = new taskpool.Task(getVideoThumb, cacheDir, uri, width, height);
    const result = await taskpool.execute(task);
    return 'file://' + (result as string);
  }

  // 获取图片原始宽高信息（不解码，只读元数据）
  async getImageOriginalDimensions(uri: string): Promise<ImageDimensions> {
    let file: fileIo.File | null = null;
    let imageSource: image.ImageSource | null = null;
    MLog.info(TAG, `获取原始图片宽高信息: ${uri}`);
    try {
      MLog.info(TAG, `开始获取宽高`);

      // 检查 URI 是否有效
      if (!uri || typeof uri !== 'string') {
        console.error(TAG, 'Invalid URI: URI is empty or not a string');
      }

      file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      console.info(TAG, `文件打开成功，FD: ${file.fd}`);

      // 创建图片源
      imageSource = image.createImageSource(file.fd);
      // 验证 imageSource 是否成功创建
      if (!imageSource) {
        console.error(TAG, `createImageSource returned null/undefined for URI: ${uri}`);
      }
      imageSource.getImageInfo((error: BusinessError, imageInfo: image.ImageInfo) => {
        if (error) {
          console.error(TAG, `获取基础信息失败: ${error.code}, ${error.message}`);
        } else {
          console.info(TAG, `图片宽度: ${imageInfo.size.width}`);
          console.info(TAG, `图片高度: ${imageInfo.size.height}`);
          console.info(TAG, `图片格式: ${imageInfo.mimeType}`);
        }
      });
      // 获取图片信息（只读元数据，不解码）
      const imageInfo = await imageSource.getImageInfo();

      // 释放资源
      await imageSource.release();

      // 提取原始宽高
      const width: number = imageInfo.size.width;
      const height: number = imageInfo.size.height;
      // 验证宽高是否有效
      if (width <= 0 || height <= 0) {
        MLog.warn(TAG, '图片尺寸无效');
      }
      MLog.info(TAG, `Image original dimensions: ${width}x${height}`);

      return { width, height };
    } catch (err) {
      // 确保释放资源
      if (imageSource) {
        try {
          await imageSource.release();
          MLog.info(TAG, `Resource released in catch block`);
        } catch (releaseErr) {
          MLog.error(TAG, `Failed to release resource: ${JSON.stringify(releaseErr)}`);
        }
      }

      // 详细记录错误信息
      const errorInfo: ImageErrorInfo = {
        uri: uri,
        errorCode: (err as BusinessError)?.code,
        errorMessage: (err as BusinessError)?.message,
        errorName: (err as Error)?.name,
        fullError: JSON.stringify(err)
      };
      MLog.error(TAG, `Failed to get image dimensions: ${JSON.stringify(errorInfo)}`);

      if ((err as BusinessError)?.code === 401) {
        throw new Error(`权限不足：无法访问该图片文件`);
      } else if ((err as BusinessError)?.code === 201) {
        throw new Error(`文件不存在：${uri}`);
      } else if ((err as BusinessError)?.code === 601) {
        throw new Error(`不支持的图片格式`);
      } else {
        throw new Error(`获取图片信息失败：${(err as Error)?.message || '未知错误'}`);
      }
    } finally {
      // 关闭打开的文件资源
      if (file) {
        fileIo.closeSync(file);
      }
    }
  }
}

let fileUtil = new FileUtil();

export default fileUtil;