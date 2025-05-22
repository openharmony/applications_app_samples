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

import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';


/**
 *  读取图片的EXIF信息，并将IMAGE_WIDTH设置为120。
 *
 * @param fd - 文件描述符。
 **/
export async function readAndEditEXIF(fd: number) {
  Logger.info('readAndEditEXIF Start');
  // [Start pixelmap_create_image_source_by_fd_in_edit]
  // 获取沙箱路径创建ImageSource
  const imageSourceApi: image.ImageSource = image.createImageSource(fd);
  // [End pixelmap_create_image_source_by_fd_in_edit]
  if (imageSourceApi == null) {
    Logger.error('fd undefined');
  }
  // [Start pixelmap_read_and_edit_EXIF_info]
  // 读取EXIF信息，BitsPerSample为每个像素比特数
  let options: image.ImagePropertyOptions = { index: 0, defaultValue: '9999' }
  await imageSourceApi.getImageProperty(image.PropertyKey.BITS_PER_SAMPLE, options).then((data: string) => {
    Logger.info('Succeeded in getting the value of the specified attribute key of the image.');
  }).catch((error: BusinessError) => {
    Logger.error('Failed to get the value of the specified attribute key of the image.', String(error));
  })

  // 编辑EXIF信息
  await imageSourceApi.modifyImageProperty(image.PropertyKey.IMAGE_WIDTH, '120').then(() => {
    imageSourceApi.getImageProperty(image.PropertyKey.IMAGE_WIDTH).then((width: string) => {
      Logger.info('The new imageWidth is ', width);
    }).catch((error: BusinessError) => {
      Logger.error('Failed to get the Image Width.', String(error));
    })
  }).catch((error: BusinessError) => {
    Logger.error('Failed to modify the Image Width.', String(error));
  })
  // [End pixelmap_read_and_edit_EXIF_info]

  Logger.info('readAndEditEXIF End');
}