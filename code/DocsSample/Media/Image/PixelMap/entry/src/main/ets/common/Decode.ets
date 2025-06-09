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

// [Start pixelmap_import_BusinessError_module]
import { BusinessError } from '@kit.BasicServicesKit';
// [End pixelmap_importBusinessError_module]
// [Start pixelmap_import_image_module_in_decode]
import { image } from '@kit.ImageKit';
// [End pixelmap_import_image_module_in_decode]
// [Start pixelmap_import_fileio_modulef]
import { fileIo as fs } from '@kit.CoreFileKit';
// [End pixelmap_import_fileio_modulef]
// [Start pixelmap_get_resource_manager]
// 导入resourceManager资源管理器
// [Start pixelmap_import_resource_manager_modulef]
import { resourceManager } from '@kit.LocalizationKit';
// [End pixelmap_import_resource_manager_modulef]
import Logger from './Logger';

const context: Context = getContext(this);
// 获取resourceManager资源管理
const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
// [End pixelmap_get_resource_manager]

export class Decode {
  /**
   *  通过沙箱路径直接获取文件资源实例
   *
   * @param fileName - 文件名称。
   * @returns 图片资源实例。
   **/
  public getImageSourceByFilePath(fileName: string): image.ImageSource {
    // [Start pixelmap_get_image_by_filepath]
    const context: Context = getContext(this);
    // fileName可使用'/test.jpg'，也可以根据实际环境传入其他图片名
    const filePath: string = context.cacheDir + fileName;
    // [End pixelmap_get_image_by_filepath]
    // path为已获得的沙箱路径
    // [Start pixelmap_create_image_source_by_file_path]
    const imageSource: image.ImageSource = image.createImageSource(filePath);
    // [End pixelmap_create_image_source_by_file_path]
    return imageSource;
  }

  /**
   *  通过沙箱内文件的文件描述符获取文件资源实例
   *
   * @param fileName - 文件名称。
   * @returns 图片资源实例。
   **/
  public getImageSourceByFd(fileName: string): image.ImageSource {
    // [Start pixelmap_get_image_by_fd]
    const context: Context = getContext(this);
    // fileName可使用'/test.jpg'，也可以根据实际环境传入其他图片名
    const filePath = context.cacheDir + fileName;
    const file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
    const fd: number = file?.fd;
    // [End pixelmap_get_image_by_fd]
    // fd为已获得的文件描述符
    // [Start pixelmap_create_image_source_by_fd]
    const imageSource: image.ImageSource = image.createImageSource(fd);
    // [End pixelmap_create_image_source_by_fd]
    return imageSource;
  }

  /**
   *  通过资源管理器获取资源文件(rawfile)的ArrayBuffer,再通过ArrayBuffer获取文件资源实例
   *
   * @param fileName - 文件名称。
   * @returns 图片资源实例。
   **/
  public getImageSourceByArrayBuffer(fileName: string): Promise<image.ImageSource> {
    // [Start pixelmap_get_resource_manager_in_arraybuffer]
    const context: Context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    // [End pixelmap_get_resource_manager_in_arraybuffer]
    return new Promise((resolve, reject) => {
      // [Start pixelmap_get_arraybuffer_of_resource]
      // fileName可使用'/test.jpg'，也可以根据实际环境传入其他图片名
      resourceMgr.getRawFileContent(fileName).then((fileData: Uint8Array) => {
        Logger.info('getImageSourceByArrayBuffer: ', 'Succeeded in getting RawFileContent');
        // 获取图片的ArrayBuffer
        const buffer = fileData.buffer.slice(0);
        // [Start pixelmap_create_image_source_by_arraybuffer]
        const imageSource: image.ImageSource = image.createImageSource(buffer);
        // [End pixelmap_create_image_source_by_arraybuffer]
        resolve(imageSource);
      }).catch((err: BusinessError) => {
        Logger.error('getImageSourceByArrayBuffer: ', 'Failed to get RawFileContent');
        reject(err);
      });
      // [End pixelmap_get_arraybuffer_of_resource]
    });
  }

  /**
   *  通过资源管理器获取资源文件(rawfile)的RawFileDescriptor,再通过RawFileDescriptor获取文件资源实例
   *
   * @param fileName - 文件名称。
   * @returns 图片资源实例。
   **/
  public getImageSourceByRawFileDescriptor(fileName: string): Promise<image.ImageSource> {
    // [Start pixelmap_get_resource_manager_in_raw_file_descriptor]
    // 获取resourceManager资源管理器
    const context: Context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    // [End pixelmap_get_resource_manager_in_raw_file_descriptor]
    return new Promise((resolve, reject) => {
      // [Start pixelmap_get_rawfd_by_resource_manager]
      // fileName可使用'/test.jpg'，也可以根据实际环境传入其他图片名
      resourceMgr.getRawFd(fileName).then((rawFileDescriptor: resourceManager.RawFileDescriptor) => {
        Logger.info('getImageSourceByRawFileDescriptor: ', 'Succeeded in getting RawFileDescriptor');
        // [Start pixelmap_create_image_source_by_rawfd]
        const imageSource: image.ImageSource = image.createImageSource(rawFileDescriptor);
        // [End pixelmap_create_image_source_by_rawfd]
        resolve(imageSource);
      }).catch((err: BusinessError) => {
        Logger.error('getImageSourceByRawFileDescriptor: ', 'Failed to get RawFileDescriptor');
        reject(err);
      });
      // [End pixelmap_get_rawfd_by_resource_manager]
    });
  }


  /**
   *  设置期望的format进行解码
   *
   * @param imageSource - 图片资源实例。
   * @returns 位图操作实例。
   **/
  public decodeByFormatWithParameter(imageSource: image.ImageSource): Promise<image.PixelMap> {
    Logger.info('getPixelMap DecodeByFormatWithParameter Start');
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: 3, // 以RGBA_8888格式进行解码
    }
    return new Promise((resolve, reject) => {
      // 创建pixelMap
      imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
        Logger.info('decodeByFormatWithParameter: ', 'Succeeded in creating PixelMap');
        resolve(pixelMap);
      }).catch((err: BusinessError) => {
        Logger.error('decodeByFormatWithParameter: ', 'Failed to create PixelMap');
        reject(err);
      });
    });
  }

  /**
   *  HDR图片解码
   *
   * @param imageSource - 图片资源实例。
   * @returns 位图操作对象。
   **/
  public decodeByAutoWithParameter(imageSource: image.ImageSource): Promise<image.PixelMap> {
    let decodingOptions: image.DecodingOptions = {
      //设置为AUTO会根据图片资源格式解码，如果图片资源为HDR资源则会解码为HDR的pixelmap。
      desiredDynamicRange: image.DecodingDynamicRange.AUTO,
    }
    return new Promise((resolve, reject) => {
      // 创建pixelMap
      imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
        Logger.info('decodeByAutoWithParameter: ', 'Succeeded in creating PixelMap');
        // 判断pixelmap是否为hdr内容
        let info = pixelMap.getImageInfoSync();
        Logger.info('pixelmap isHdr: ', String(info.isHdr));
        resolve(pixelMap);
      }).catch((err: BusinessError) => {
        Logger.error('decodeByAutoWithParameter: ', 'Failed to create PixelMap');
        reject(err);
      });
    });
  }

  /**
   *  设置期望的format直接解码resources下的图片资源
   *
   * @returns 位图操作对象。
   **/
  public async decodeByFormat(): Promise<image.PixelMap> {
    Logger.info('getPixelMap DecodeByFormat Start');
    // [Start pixelmap_decode_using_RGBA_8888_format]
    let img = await getContext(this).resourceManager.getMediaContent($r('app.media.image'));
    let imageSource: image.ImageSource = image.createImageSource(img.buffer.slice(0));
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: 3, // 以RGBA_8888格式进行解码
    }
    return new Promise((resolve, reject) => {
      // 创建pixelMap
      imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
        Logger.info('decodeByFormat: ', 'Succeeded in creating PixelMap');
        resolve(pixelMap);
      }).catch((err: BusinessError) => {
        Logger.error('decodeByFormat: ', 'Failed to create PixelMap');
        reject(err);
      });
      // [Start pixelmap_release_image_source]
      imageSource.release();
      // [End pixelmap_release_image_source]
    });
    // [End pixelmap_decode_using_RGBA_8888_format]
  }

  /**
   *  自动推断解码方式,解码resources下的图片资源
   *
   * @returns 位图操作对象。
   **/
  public async decodeByAuto(): Promise<image.PixelMap> {
    // [Start pixelmap_decode_using_auto_format]
    let img = await getContext(this).resourceManager.getMediaContent($r('app.media.CUVAHdr'));
    let imageSource: image.ImageSource = image.createImageSource(img.buffer.slice(0));
    let decodingOptions: image.DecodingOptions = {
      //设置为AUTO会根据图片资源格式解码，如果图片资源为HDR资源则会解码为HDR的pixelmap。
      desiredDynamicRange: image.DecodingDynamicRange.AUTO,
    }
    return new Promise((resolve, reject) => {
      // 创建pixelMap
      imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
        Logger.info('decodeByAuto: ', 'Succeeded in creating PixelMap');
        // 判断pixelmap是否为hdr内容
        let info = pixelMap.getImageInfoSync();
        Logger.info('pixelmap isHdr: ', String(info.isHdr));
        resolve(pixelMap);
      }).catch((err: BusinessError) => {
        Logger.error('decodeByAuto: ', 'Failed to create PixelMap');
        reject(err);
      });
      imageSource.release();
    });
    // [End pixelmap_decode_using_auto_format]
  }

  /**
   *  开发示例方式一,通过ArrayBuffer解码rawfile下的图片资源
   *
   * @returns 位图操作对象。
   **/
  public decodeSample_1(): Promise<image.PixelMap> {
    return new Promise((resolve, reject) => {
      // [Start pixelmap_create_image_source_by_text_jpg_arraybuffer]
      resourceMgr.getRawFileContent('test.jpg').then((fileData: Uint8Array) => {
        Logger.info('decodeSample_1: ', 'Succeeded in getting RawFileContent');
        // 获取图片的ArrayBuffer
        const buffer = fileData.buffer.slice(0);
        const imageSource: image.ImageSource = image.createImageSource(buffer);
        // [Start pixelmap_create_pixelmap]
        imageSource.createPixelMap().then((pixelMap: image.PixelMap) => {
          Logger.info('decodeSample_1: ', 'Succeeded in creating PixelMap');
          resolve(pixelMap);
        }).catch((err: BusinessError) => {
          Logger.error('decodeSample_1: ', 'Failed to create PixelMap');
          reject(err);
        });
        // [End pixelmap_create_pixelmap]
        imageSource.release();
      }).catch((err: BusinessError) => {
        Logger.error('decodeSample_1: ', 'Failed to get RawFileContent');
        reject(err);
      });
      // [End pixelmap_create_image_source_by_text_jpg_arraybuffer]
    });
  }

  /**
   *  开发示例方式二,通过RawFileDescriptor解码rawfile下的图片资源
   *
   * @returns 位图操作对象。
   **/
  public decodeSample_2(): Promise<image.PixelMap> {
    return new Promise((resolve, reject) => {
      resourceMgr.getRawFd('test.jpg').then((rawFileDescriptor: resourceManager.RawFileDescriptor) => {
        Logger.info('decodeSample_2: ', 'Succeeded in getting RawFd');
        const imageSource: image.ImageSource = image.createImageSource(rawFileDescriptor);
        imageSource.createPixelMap().then((pixelMap: image.PixelMap) => {
          Logger.info('decodeSample_2: ', 'Succeeded in creating PixelMap');
          resolve(pixelMap);
        }).catch((err: BusinessError) => {
          Logger.error('decodeSample_2: ', 'Failed to create PixelMap');
          reject(err);
        });
        imageSource.release();
      }).catch((err: BusinessError) => {
        Logger.error('decodeSample_2: ', 'Failed to get RawFileContent');
        reject(err);
      });
    });
  }
}
