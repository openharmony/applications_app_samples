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
  AppStorage.SetOrCreate<Array<string>>('imageList', imageList);


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
 * 通过uri创建ImageSource
 * @param filePath
 */
function uriCreateImageSource(filePath: string) {
  return ndkTest.CreateFromUri(filePath)
}

/**
 * 通过fd创建ImageSource
 * @param file
 */
function fdCreateImageSource(file: fileIo.File) {
  return ndkTest.CreateFromFd(file.fd)
}

/**
 * 通过data创建ImageSource
 * @param buffer
 */
function dataCreateImageSource(buffer :ArrayBuffer) {
  return ndkTest.CreateFromData(buffer.slice(0))
}

/**
 * 通过rawFile创建ImageSource
 * @param context
 */
async function rawFileCreateImageSource(context: Context) {
  const resourceMgr = context.createModuleContext("entry").resourceManager
  let rawFileDescriptor: resourceManager.RawFileDescriptor
  rawFileDescriptor = await resourceMgr.getRawFd("test_jpg.jpg");
  return ndkTest.CreateFromRawFile(rawFileDescriptor.fd,  rawFileDescriptor.offset, rawFileDescriptor.length)
}

/**
 * imageSource转换为pixelMap
 * @param imageSource
 * @param options
 */
function imageSourceCreatePixelMap(imageSource: image.ImageSource, options: image.DecodingOptions) {
  return ndkTest.CreatePixelMap(imageSource, options)
}

/**
 * PixelMap转为file
 * @param context
 * @param filePath 调用uri创建ImageSource方法, 需接收filePath参数
 */
function packToFilePixelMap(context: Context, filePath: string){
  try {
    const packer = ndkTest.PackerCreate()
    const packOptions = ndkTest.CreatePackingOptions()
    ndkTest.PackingOptionsSetMimeType(packOptions, `image/png`)
    ndkTest.PackingOptionsSetQuality(packOptions, 100)
    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '____1.png';
    const packFile = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

    // uri创建ImageSource
    const imageSource = uriCreateImageSource(filePath)
    const options = ndkTest.CreateDecodingOptions()
    // 创建pixelMap
    const pixelMap = imageSourceCreatePixelMap(imageSource, options)

    const result = ndkTest.PackToFileFromPixelMap(packer, packOptions, pixelMap, packFile.fd)
    console.log("----------------- PackToFileFromPixelMap result " + result)
  } catch (error) {
    console.log( 'packing fail ' + JSON.stringify(error))
  }
}

/**
 * ImageSource转为file
 * @param context
 * @param file 调用fd创建ImageSource方法, 需接收file参数
 */
function packToFileImageSource(context: Context, file: fileIo.File){
  try {
    const packer = ndkTest.PackerCreate()
    const packOptions = ndkTest.CreatePackingOptions()
    ndkTest.PackingOptionsSetMimeType(packOptions, `image/jpeg`)
    ndkTest.PackingOptionsSetQuality(packOptions, 100)
    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '____2.jpg';
    const packFile = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

    // fd创建ImageSource
    const imageSource = fdCreateImageSource(file)
    const result = ndkTest.PackToFileFromImageSource(packer, packOptions, imageSource, packFile.fd)
    console.log("----------------- PackToFileFromImageSource result:" + result)
  } catch (error) {
    console.log('packTopFile fail' + JSON.stringify(error))
  }
}

/**
 * PixelMap转为data
 * @param context
 * @param buffer 调用data创建ImageSource方法, 需接收buffer参数
 */
function packToDataPixelMap(context: Context, buffer :ArrayBuffer){
  try {
    const packer = ndkTest.PackerCreate()
    const packOptions = ndkTest.CreatePackingOptions()
    ndkTest.PackingOptionsSetMimeType(packOptions, `image/jpeg`)
    ndkTest.PackingOptionsSetQuality(packOptions, 100)

    // data创建ImageSource
    const imageSource = dataCreateImageSource(buffer)
    const options = ndkTest.CreateDecodingOptions()
    // 创建pixelMap
    const pixelMap = imageSourceCreatePixelMap(imageSource, options)
    const packBuffer = new ArrayBuffer(1174449)

    const result = ndkTest.PackToDataFromPixelMap(packer, packOptions, pixelMap, packBuffer)
    console.log("----------------- PackToDataFromPixelMap result:" + result)

    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '____3.jpg';
    const file = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, packBuffer)
    fs.closeSync(file)
  } catch (error) {
    console.log( 'packing fail ' + JSON.stringify(error))
  }
}

/**
 * ImageSource转为数据
 * @param context 调用rawFile创建ImageSource方法
 */
async function packToDataImageSource(context: Context){
  try {
    const packer = ndkTest.PackerCreate()
    const packOptions = ndkTest.CreatePackingOptions()
    ndkTest.PackingOptionsSetMimeType(packOptions, `image/webp`)
    ndkTest.PackingOptionsSetQuality(packOptions, 100)

    // rawFile创建ImageSource
    const rawFileImageSource = await rawFileCreateImageSource(context);
    const packBuffer = new ArrayBuffer(1174449)

    const result = ndkTest.PackToDataFromImageSource(packer, packOptions, rawFileImageSource, packBuffer)
    console.log('----------------- PackToDataFromImageSource result:' + result)

    const packFilePath: string = context.filesDir + '/' + getTimeStr() + '____4.webp';
    const file = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, packBuffer)
    fs.closeSync(file)
  } catch (error) {
    console.log( 'packing fail ' + JSON.stringify(error))
  }
}