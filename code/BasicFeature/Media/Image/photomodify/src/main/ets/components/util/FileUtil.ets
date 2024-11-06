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
import { AppLog } from '../model/log';
import ndkTest from 'libentry.so'
import resourceManager from '@ohos.resourceManager';

const TAG: string = '[Sample_SavePixelMap]';

export class ImageTest {
  /**
   * 保存pixelMap，返回路径
   * @param pm
   * @returns
   */
  async savePixelMap(context: Context, pm: PixelMap): Promise<string> {
    if (pm === null) {
      logger.error(TAG, 'pm is null');
      return '';
    }
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 30 };
    try {
      this.packToFile(context, pm);
      const data: ArrayBuffer = await imagePackerApi.packing(pm, packOpts);
      // PixelMap转为data
      this.packToDataPixelMap(context, data)
      return await this.saveFile(context, data);
    } catch (err) {
      logger.error(TAG, 'save file failed，err=' + JSON.stringify(err));
      return '';
    }
  }

  async packToFile(context: Context, pixelMap: PixelMap) {
    let fPath: string = context.cacheDir + '/' + this.getTimeStr() + '.jpg';
    let writeFd: fs.File = await fs.open(fPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

    let opts: image.PackingOption = { format: `image/jpeg`, quality: 100 };
    const imagePacker = image.createImagePacker();
    await imagePacker.packToFile(pixelMap, writeFd.fd, opts);
    fs.closeSync(writeFd.fd);
  }

  async saveFile(context: Context, data: ArrayBuffer): Promise<string> {
    let uri: string = context.filesDir + '/' + this.getTimeStr() + '.jpg';
    let file: fileIo.File = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, data);
    // ImageSource转为file
    this.packToFileImageSource(context, file);
    // PixelMap转为file
    this.packToFilePixelMap(context, uri);
    // ImageSource转为data
    this.packToDataImageSource(context);
    fs.closeSync(file);
    // /data/storage/....  加上file://前缀
    uri = 'file:/' + uri;
    // 打开媒体文件，存储图片
    this.setImageList(uri);
    return uri;
  }

  setImageList(uri: string) {
    let imageList: Array<string> | undefined = AppStorage.get('imageList');
    const index: number | undefined = AppStorage.get('selectIndex');
    if (imageList !== undefined && index !== undefined) {
      imageList[index] = uri;
    }
    AppStorage.setOrCreate<Array<string>>('imageList', imageList);
  }

  getTimeStr() {
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
  packToFilePixelMap(context: Context, filePath: string) {
    try {
      const packFilePath: string = context.filesDir + '/' + this.getTimeStr() + '_1.png';
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
  packToFileImageSource(context: Context, file: fileIo.File): string {
    try {
      let fileName = this.getTimeStr() + `_sourceToFile.jpg`;
      const packFilePath: string = context.filesDir + '/' + this.getTimeStr() + '_sourceToFile.jpg'
      const packFile = fs.openSync(packFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      const result: number = ndkTest.packToFileImageSource(file.fd, packFile.fd)
      logger.info(TAG, 'packToFileImageSource result ' + result);
      return fileName;
    } catch (error) {
      logger.error(TAG, 'packing fail ' + JSON.stringify(error));
    }
    return `packing fail`;
  }

  /**
   * PixelMap转为data
   * @param context
   * @param buffer 调用data创建ImageSource方法, 需接收buffer参数
   */
  packToDataPixelMap(context: Context, buffer: ArrayBuffer) {
    try {
      const packFilePath: string = context.filesDir + '/' + this.getTimeStr() + '_3.jpg'
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
  async packToDataImageSource(context: Context): Promise<string> {
    const resourceMgr = context.createModuleContext('entry').resourceManager
    let rawFileDescriptor: resourceManager.RawFileDescriptor
    rawFileDescriptor = await resourceMgr.getRawFd('HdrVivid.jpg');
    let fileName = this.getTimeStr() + `_sourceToData`;
    const packFilePath: string = context.filesDir + '/' + fileName;
    const result: number = ndkTest.packToDataImageSource(rawFileDescriptor.fd, rawFileDescriptor.offset,
      rawFileDescriptor.length, packFilePath)
    logger.info(TAG, 'packToDataImageSource result ' + result);
    return fileName;
  }

  private logger: AppLog = new AppLog(`[Sample_Picture_File]`);

  // 将rawFile中的文件写到沙箱中
  async writeFileToBox(fileName: string): Promise<string> {
    let context = getContext(this);
    let value = await context.resourceManager.getRawFileContent(fileName);
    let myBuffer: ArrayBufferLike = value.buffer;
    let filePath = context.filesDir + `/` + fileName;
    this.logger.log(`filepath is ` + filePath);
    let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let writLen = await fs.write(file.fd, myBuffer);
    this.logger.log(`Write data to file successfully and size is : ` + writLen);
    fs.closeSync(file);
    return filePath;
  }

  // 多图解码
  async createPictureByImageSource(fileName: string): Promise<string> {
    let message = ndkTest.createPictureByImageSource(fileName);
    return this.logger.check_result(`CreatePictureByImageSource`, message);
  }

  // 创造解码参数
  createDecodingOptions(): string | number | image.DecodingOptionsForPicture {
    let message = ndkTest.createDecodingOptions();
    return this.logger.check_result(`createDecodingOptions`, message);
  }

  // 设置解码参数
  decodingOptionPictSetAux(): string {
    let desiredType: image.AuxiliaryPictureType[] = [image.AuxiliaryPictureType.GAINMAP,
      image.AuxiliaryPictureType.DEPTH_MAP,
      image.AuxiliaryPictureType.UNREFOCUS_MAP];
    let message = ndkTest.setDesiredAuxiliaryPictures(desiredType);
    return this.logger.check_result(`setDesiredAuxiliaryPictures`, message);
  }

  // 获取解码参数
  decodingOptionPictGetAux(): string {
    let message = ndkTest.getDesiredAuxiliaryPictures();
    return this.logger.check_result(`getDesiredAuxiliaryPictures`, message);
  }

  // 释放解码参数
  decodingOptionPictRelease(): string {
    let message = ndkTest.releaseDecodingOptions();
    return this.logger.check_result(`DecodingOptionPictRelease`, message);
  }

  // 将picture编码成buffer
  async packToDataFromPicture(fileName: string): Promise<string> {
    let context = getContext();
    let filePath = context.filesDir + `/` + fileName;
    let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let message = ndkTest.packToDataPicture(filePath);
    if (message != 0) {
      return this.logger.log(`PackToData failed, errorCode is: ` + message);
    }
    return this.logger.log(`PackToData success !`);
  }

  // 将picture编码成file
  async packToFileFromPicture(fileName: string): Promise<string> {
    let context = getContext();
    let filePath = context.filesDir + `/` + fileName;
    let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let message = ndkTest.packToFilePicture(file.fd);
    if (message != 0) {
      return this.logger.log(`PackToFile failed, errorCode is: ` + message);
    } else {
      return this.logger.log(`PackToFile success !`);
    }
  }

  // 展示图片
  async showPhoto(fileName: string): Promise<image.PixelMap> {
    let context = getContext();
    let filePath = context.filesDir + `/` + fileName;
    let imageSource = image.createImageSource(filePath);
    let pixelmap = await imageSource.createPixelMap();
    return pixelmap;
  }
}

export { ndkTest };
