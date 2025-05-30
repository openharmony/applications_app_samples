/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import fileio from '@ohos.fileio';
import image from '@ohos.multimedia.image';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import common from '@ohos.app.ability.common';
import prompt from '@ohos.promptAction';
import {
  BarcodeFormat,
  MultiFormatWriter,
  BitMatrix,
  ZXingStringEncoding,
  EncodeHintType,
  MultiFormatReader,
  DecodeHintType,
  RGBLuminanceSource,
  BinaryBitmap,
  HybridBinarizer
} from '@ohos/zxing';
import DateTimeUtil from '../utils/DateTimeUtil';
import { CameraService } from './CameraService';
import { QRCodeScanConst, ImageAttribute, DecodeResultAttribute } from './QRCodeScanConst';
import Logger from '../utils/Logger';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import deviceInfo from '@ohos.deviceInfo';

const TAG: string = 'QRCodeParser';

/**
 * 二维码解析器
 */
class QRCodeParser {
  private deviceType: string = 'default';

  constructor() {
    this.deviceType = deviceInfo.deviceType;
    Logger.info(TAG, `deviceType: ${this.deviceType}`);
  }

  /**
   * 解析从相机获取的二维码图片
   *
   * @param cameraService
   * @param canvasContext
   */
  parseQRCodeImageFromCamera(cameraService: CameraService,
                             imageComponentType?: image.ComponentType): void {
    Logger.info("parseQRCodeImageFromCamera start")
    this.parseQRCodeImageWithNameFromCamera(cameraService, imageComponentType);
    Logger.info("parseQRCodeImageFromCamera end")
  }

  /**
   * 解析从相机获取的二维码图片，指定文件名称
   *
   * @param cameraService
   * @param canvasContext
   */
  parseQRCodeImageWithNameFromCamera(cameraService: CameraService,
                                     imageComponentType?: image.ComponentType): void {
    Logger.info("parseQRCodeImageWithNameFromCamera...")
    cameraService.imageReceiver.on('imageArrival', async () => {
      Logger.info("parseQRCodeImageWithNameFromCamera imageArrival start")
      // 从接收器获取下一个图像，并返回结果
      let targetImage: image.Image = await cameraService.imageReceiver.readNextImage()
      // 默认按JPEG格式处理
      let imgComponentType = imageComponentType === undefined ? image.ComponentType.JPEG : imageComponentType
      let imageComponent = await targetImage.getComponent(imgComponentType)
      // 给每次接收的image资源赋予随机文件名
      let fileName = this.getRandomFileName(QRCodeScanConst.IMG_FILE_PREFIX, QRCodeScanConst.IMG_SUFFIX_JPG)
      // 将image的ArrayBuffer写入指定文件中，返回文件uri
      let imageUri = await this.createPublicDirFileAsset(fileName, imageComponent.byteBuffer);
      // 释放已读取的image资源，以便处理下一个资源
      await targetImage.release()

      // 解析二维码
      let qrCodeParseRlt = await this.parseImageQRCode(imageUri);
      if (!qrCodeParseRlt.isSucess) {
        Logger.error("parseQRCodeImageWithNameFromCamera qrCodeParseRlt is null")
        prompt.showToast({
          message: $r('app.string.qrCodeNotRecognized')
        })
        return;
      }
      // 拼接解析结果
      AppStorage.SetOrCreate(QRCodeScanConst.QR_CODE_PARSE_RESULT, qrCodeParseRlt.decodeResult);
      Logger.info("parseQRCodeImageWithNameFromCamera imageArrival end")
    })
  }

  /**
   * 解析图片二维码信息
   * @param canvasContext
   * @param imageSrc
   */
  async parseImageQRCode(imageSrc: string): Promise<DecodeResultAttribute> {
    Logger.info(TAG, `parseImageQRCode start`);
    let parseResult: DecodeResultAttribute = {
      isSucess: false,
      decodeResult: 'failed'
    };
    let width: number;
    let height: number;
    let pixelBytesNumber: number;
    let arrayBuffer: ArrayBuffer;
    if (this.deviceType !== 'default') {
      let imageSource: ImageAttribute = await this.getImageSource(imageSrc);
      imageSource = await this.getImageSource(imageSrc);
      // 图片宽高
      width = imageSource.width;
      height = imageSource.height;
      pixelBytesNumber = imageSource.pixelMap.getPixelBytesNumber();
      arrayBuffer = new ArrayBuffer(pixelBytesNumber);
      // 读取图像像素数据，结果写入ArrayBuffer里
      await imageSource.pixelMap.readPixelsToBuffer(arrayBuffer);
    } else {
      let media = photoAccessHelper.getPhotoAccessHelper(AppStorage.get<common.UIAbilityContext>('context'));
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      let imagesIdFetchOp: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates.equalTo('uri', imageSrc)
      };
      // 获取图片文件资源
      let fetchIdFileResult = await media.getAssets(imagesIdFetchOp);
      let fileIdAsset = await fetchIdFileResult.getFirstObject();
      // 获取文件描述符
      let fd = await fileIdAsset.open('RW');
      // 获取PixelMap图片数据
      let imageSource = image.createImageSource(fd, { sourceDensity: 120, sourceSize: { width: 120, height: 120 } });
      let decodingOptions: image.DecodingOptions = {
        sampleSize: 1,
        editable: true,
        desiredSize: { width: 120, height: 120 },
        rotate: 0,
        desiredPixelFormat: 3,
        desiredRegion: { size: { height: 120, width: 120 }, x: 0, y: 0 },
        index: 0
      };
      // 图片宽高
      width = 120;
      height = 120;
      let pixMapData = await imageSource.createPixelMap(decodingOptions);
      pixelBytesNumber = pixMapData.getPixelBytesNumber();
      arrayBuffer = new ArrayBuffer(pixelBytesNumber);
      // 读取图像像素数据，结果写入ArrayBuffer里
      await pixMapData.readPixelsToBuffer(arrayBuffer);
    }
    let int32Array = new Int32Array(arrayBuffer);
    let luminanceSource = new RGBLuminanceSource(int32Array, width, height);
    let binaryBitmap = new BinaryBitmap(new HybridBinarizer(luminanceSource));
    let mltiFormatReader = new MultiFormatReader();
    let hints: Map<number, number[]> = new Map();
    hints.set(DecodeHintType.POSSIBLE_FORMATS, [BarcodeFormat.QR_CODE]);
    mltiFormatReader.setHints(hints);
    try {
      // 解析二维码
      let decodeResult = mltiFormatReader.decode(binaryBitmap);
      let decodeText = decodeResult.getText();
      Logger.info(TAG, `parseImageQRCode end ${decodeText}`);
      parseResult = { isSucess: true, decodeResult: decodeText };
    } catch (err) {
      let error = `The error is ${err}`;
      Logger.info(TAG, `parseImageQRCode end`);
      parseResult = { isSucess: false, decodeResult: error };
    }
    return parseResult;
  }

  /**
   * 获取图片的属性
   * @param context
   * @param imageSrc
   */
  async getImageSource(imageSrc: string): Promise<ImageAttribute> {
    Logger.info(`getImageSource start`);
    let media = photoAccessHelper.getPhotoAccessHelper(AppStorage.get<common.UIAbilityContext>('context'));
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let imagesIdFetchOp: photoAccessHelper.FetchOptions = {
      fetchColumns: ['width', 'height'],
      predicates: predicates.equalTo('uri', imageSrc)
    };
    // 获取图片文件资源
    let fetchIdFileResult = await media.getAssets(imagesIdFetchOp);
    let fileIdAsset = await fetchIdFileResult.getFirstObject();
    // 将字符串分割，下标为1的数据即为图片类型
    let imgType = fileIdAsset.displayName.split('.')[1];
    // 获取文件描述符
    let fd = await fileIdAsset.open('RW');
    let context = AppStorage.get<common.UIAbilityContext>('context');
    // 获取当前时间
    let time = new Date().getTime();
    // 拼接路径
    let imagePath = `${context?.cacheDir}/${time.toString()}_note.${imgType}`;
    // 将图片copy到此路径当中
    await fileio.copyFile(fd, imagePath);
    // 创建一个图片源类
    let imageSource = image.createImageSource(imagePath);
    // 创建PixelMap数组
    let pixelMap = await imageSource.createPixelMap();
    // 4、关闭安fd,Asset
    await fileIdAsset.close(fd);
    return {
      width: fileIdAsset.get('width') as number,
      height: fileIdAsset.get('height') as number,
      pixelMap: pixelMap
    };
  }

  /**
   * 在媒体公共资源目录下的创建指定类型的资源对象
   */
  async createPublicDirFileAsset(fileDisplayName: string,
                                 fileByteBuffer: ArrayBuffer): Promise<string> {
    Logger.info("createPublicDirFileAsset start")
    // 获取mediaLibrary对象
    let mediaLibraryObj = photoAccessHelper.getPhotoAccessHelper(AppStorage.get('context'))
    let fileAsset = await mediaLibraryObj.createAsset(fileDisplayName)
    // 拿到fileAccess资源对应的uri
    let fileUri = fileAsset.uri
    // 调用open方法打开这个资源对象 // TODO 为啥要打开？
    let fd = await fileAsset.open('Rw')
    // 将图片资源写入对应的fileAccess
    await fileio.write(fd, fileByteBuffer)
    // 关闭这个资源对象
    await fileAsset.close(fd)
    Logger.info("createPublicDirFileAsset end")
    return fileUri
  }

  /**
   * 根据时间生成随机文件名
   *
   * @param filePrefix 文件名前缀
   * @param fileSuffix 文件名后缀
   */
  getRandomFileName(filePrefix: string, fileSuffix: string) {
    let dateTimeUtil = new DateTimeUtil()
    return filePrefix + `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}` + fileSuffix
  }
}

export { QRCodeParser }