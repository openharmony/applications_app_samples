/*
 * Copyright (c) 2023-2024 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import fs from '@ohos.file.fs';
import fileIo from '@ohos.file.fs';
import { logger } from '../util/Logger';
import ndkTest from 'libentry.so'
import resourceManager from '@ohos.resourceManager';

const TAG: string = '[Sample_SavePixelMap]';
/**
 * 保存pixelMap，返回路径
 * @param pm
 * @returns
 */
export async function savePixelMap(context: Context, pm: PixelMap): Promise<string> {
  if (pm === null) {
    logger.error(TAG, '传入的pm为空');
    return '';
  }
  const imagePackerApi: image.ImagePacker = image.createImagePacker();
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 30 };
  try {
    packToFile(context, pm);
    const data: ArrayBuffer = await imagePackerApi.packing(pm, packOpts);
    // PixelMap转为data
    packToDataPixelMap(context, data)
    return await saveFile(context, data);
  } catch (err) {
    logger.error(TAG, '保存文件失败，err=' + JSON.stringify(err));
    return '';
  }
}

async function packToFile(context: Context, pixelMap: PixelMap) {
  let fPath: string = context.cacheDir + '/' + getTimeStr() + '.jpg';
  let writeFd: fs.File = await fs.open(fPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

  let opts : image.PackingOption = { format: "image/jpeg", quality: 100};
  const imagePacker = image.createImagePacker();
  await imagePacker.packToFile(pixelMap, writeFd.fd, opts);
  fs.closeSync(writeFd.fd);
}

async function saveFile(context: Context, data: ArrayBuffer): Promise<string> {
  let uri: string = context.filesDir + '/' + getTimeStr() + '.jpg';
  let file: fileIo.File = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.writeSync(file.fd, data);
  // ImageSource转为file
  packToFileImageSource(context, file);
  // PixelMap转为file
  packToFilePixelMap(context, uri);
  // ImageSource转为data
  packToDataImageSource(context);
  fs.closeSync(file);
  // /data/storage/....  加上file://前缀
  uri = 'file:/' + uri;
  // 打开媒体文件，存储图片
  setImageList(uri);
  return uri;
}

function setImageList(uri: string) {

  let imageList: Array<string> | undefined = AppStorage.Get('imageList');
  const index: number | undefined = AppStorage.Get('selectIndex');
  if (imageList !== undefined && index !== undefined) {
    imageList[index] = uri;
  }
  AppStorage.setOrCreate<Array<string>>('imageList', imageList);


}

function getTimeStr() {
  const now: Date = new Date();
  const year: number = now.getFullYear();
  const month: number = now.getMonth() + 1;
  const day: number = now.getDate();
  const hours: number = now.getHours();
  const minutes: number = now.getMinutes();
  const seconds: number = now.getSeconds();
  return `${year}${month}${day}_${hours}${minutes}${seconds}`;
}

/**
 * PixelMap转为file
 * @param context
 * @param filePath 调用uri创建ImageSource方法, 需接收filePath参数
 */
function packToFilePixelMap(context: Context, filePath: string){
  try {
    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '_1.png';
    const packFile = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const result: number = ndkTest.packPixelMapToFile(filePath, packFile.fd)
    logger.info(TAG, 'packPixelMapToFile result ' + result);
  } catch (error) {
    logger.error(TAG, 'packing fail ' + JSON.stringify(error));
  }
}

/**
 * ImageSource转为file
 * @param context
 * @param file 调用fd创建ImageSource方法, 需接收file参数
 */
function packToFileImageSource(context: Context, file: fileIo.File){
  try {
    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '_2.jpg'
    const packFile = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    const result: number = ndkTest.packToFileImageSource(file.fd, packFile.fd)
    logger.info(TAG, 'packToFileImageSource result ' + result);
  } catch (error) {
    logger.error(TAG, 'packing fail ' + JSON.stringify(error));
  }
}

/**
 * PixelMap转为data
 * @param context
 * @param buffer 调用data创建ImageSource方法, 需接收buffer参数
 */
function packToDataPixelMap(context: Context, buffer :ArrayBuffer){
  try {
    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '_3.jpg'
    const result: number = ndkTest.packToDataPixelMap(buffer, packFilePath)
    logger.info(TAG, 'packToDataPixelMap result ' + result);
  } catch (error) {
    logger.error(TAG, 'packing fail ' + JSON.stringify(error));
  }
}

/**
 * ImageSource转为数据
 * @param context 调用rawFile创建ImageSource方法
 */
async function packToDataImageSource(context: Context){
  try {
    // rawFile创建ImageSource
    const resourceMgr = context.createModuleContext('entry').resourceManager
    let rawFileDescriptor: resourceManager.RawFileDescriptor
    rawFileDescriptor = await resourceMgr.getRawFd('test_jpg.jpg');
    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '_4.webp'

    const result: number = ndkTest.packToDataImageSource(rawFileDescriptor.fd, rawFileDescriptor.offset,
      rawFileDescriptor.length, packFilePath)
    logger.info(TAG, 'packToDataImageSource result ' + result);
  } catch (error) {
    logger.error(TAG, 'packing fail ' + JSON.stringify(error));
  }
}