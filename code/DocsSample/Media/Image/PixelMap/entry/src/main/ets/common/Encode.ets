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

// 导入相关模块包
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import Logger from './Logger';

const context: Context = getContext(this);
const imagePackerApi = image.createImagePacker();

/**
 *  图片编码，通过PixelMap将图片打包成文件流，再将文件流写入文件保存。
 *
 * @param pixelMap - 位图操作对象。
 * @param isHdr - 是否为HDR格式。
 **/
export async function encodeToStreamByPixelMap(pixelMap: image.PixelMap, isHdr:boolean) {
  const path: string = context.cacheDir + '/pixel_map.jpg';
  let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
  if(isHdr == true) {
    packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
  }
  imagePackerApi.packing(pixelMap, packOpts).then((data: ArrayBuffer) => {
    // data 为打包获取到的文件流，写入文件保存即可得到一张图片
    fs.write(file.fd, data);
    Logger.info('Succeeded to pack the image and write to the file.');
  }).catch((error: BusinessError) => {
    Logger.error('Failed to pack the image. And the error is: ', String(error));
  })
}

/**
 *  图片编码，通过imageSource将图片打包成文件流，再将文件流写入文件保存。
 *
 * @param pixelMap - 位图操作对象。
 * @param isHdr - 是否为HDR格式。
 **/
export async function encodeToStreamByImageSource(imageSource:image.ImageSource,isHdr:boolean){
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
  if(isHdr == true) {
    packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
  }
  const path: string = context.cacheDir + '/pixel_map.jpg';
  let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  imagePackerApi.packing(imageSource, packOpts).then( (data : ArrayBuffer) => {
    // data 为打包获取到的文件流，写入文件保存即可得到一张图片
    fs.write(file.fd, data);
    Logger.info('Succeeded to pack the image and write to the file.');
  }).catch((error : BusinessError) => {
    Logger.error('Failed to pack the image. And the error is: ', String(error));
  })
}

/**
 *  图片编码，通过pixelMap将图片直接打包成文件保存。
 *
 * @param pixelMap - 位图操作对象。
 * @param isHdr - 是否为HDR格式。
 **/
export async function encodeToFileByPixelMap(pixelMap: image.PixelMap,isHdr:boolean) {
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
  if(isHdr == true) {
    packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
  }
  const path : string = context.cacheDir + '/pixel_map.jpg';
  let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  await imagePackerApi.packToFile(pixelMap, file.fd, packOpts).then(() => {
    // 直接打包进文件
    Logger.info('Succeeded to pack the image and write to the file.');
  }).catch((error : BusinessError) => {
    Logger.error('Failed to pack the image. And the error is: ', String(error));
  })
}

/**
 *  图片编码，通过imageSource将图片直接打包成文件保存。
 *
 * @param pixelMap - 位图操作对象。
 * @param isHdr - 是否为HDR格式。
 **/
export async function encodeToFileByImageSource(imageSource:image.ImageSource,isHdr:boolean) {
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
  if(isHdr == true) {
    packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
  }
  const filePath : string = context.cacheDir + '/image_source.jpg';
  let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  imagePackerApi.packToFile(imageSource, file.fd, packOpts).then(() => {
    // 直接打包进文件
    Logger.info('Succeeded to pack the image and write to the file.');
  }).catch((error : BusinessError) => {
    Logger.error('Failed to pack the image. And the error is: ', String(error));
  })
}