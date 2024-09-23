/*
 * Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import fileIo from '@ohos.file.fs';
import { logger } from './Logger';
import { ImageTest } from '../util/FileUtil';
import fs from '@ohos.file.fs';

const TAG: string = '[Sample_Picture]';
let test = new ImageTest();


let options: image.DecodingOptionsForPicture = {
  desiredAuxiliaryPictures: []
};
let packOpts: image.PackingOption = {
  format: 'image/jpeg',
  quality: 98
};
let pictureObj: image.Picture | null = null;
let pixelsBuffer: ArrayBuffer | null = null;
let imagePacker: image.ImagePacker | null = null;
let pixelMap: image.PixelMap | null = null;
let auxPictureObj: image.AuxiliaryPicture | null = null;

export async function DecodingPicture(uri: string, auxType: image.AuxiliaryPictureType): Promise<PixelMap | null> {
  let context = getContext();
  let resourceMgr = context.resourceManager;
  let rawFile = await resourceMgr.getRawFileContent(uri);
  let isSupportHEIFDecode: Boolean = image.createImageSource(rawFile.buffer as ArrayBuffer)
    .supportedFormats
    .includes('image/heif');
  if (!isSupportHEIFDecode) {
    logger.info(TAG, `device is not support heif decode`);
    rawFile = await resourceMgr.getRawFileContent('HdrVivid.jpg');
  }
  let imageSourceApi: image.ImageSource = image.createImageSource(rawFile.buffer as ArrayBuffer);
  if (!imageSourceApi) {
    return null;
  }
  pictureObj = await imageSourceApi.createPicture(options);
  auxPictureObj = pictureObj.getAuxiliaryPicture(auxType);
  if (auxPictureObj != null) {
    pixelsBuffer = await auxPictureObj.readPixelsToBuffer();
    let opts: image.InitializationOptions = {
      size: auxPictureObj.getAuxiliaryPictureInfo().size,
    }
    pixelMap = image.createPixelMapSync(pixelsBuffer, opts);
  } else {
    return null;
  }
  if (!pixelMap) {
    return null;
  }
  return pixelMap;
}

export async function EncodingPicture(pushStatus: number, uri: string, outState: number): Promise<PixelMap | null> {
  const context = getContext();
  const resourceMgr = context.resourceManager;
  const rawFile = await resourceMgr.getRawFileContent(uri);
  // createImageSource
  let imageSourceApi: image.ImageSource = image.createImageSource(rawFile.buffer as ArrayBuffer);
  if (!imageSourceApi) {
    return null;
  }
  // createImagePacker
  imagePacker = image.createImagePacker();
  // packingToFile Save
  const filePath: string = context.filesDir + '/packing.jpg';
  let file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
  // encode options
  if (!pushStatus) { // source
    if (outState) { // file
      await imagePacker.packToFile(imageSourceApi, file.fd, packOpts);
      let imageSource = image.createImageSource(filePath);
      pixelMap = await imageSource.createPixelMap();
      logger.info(TAG, `writePictureSource filePath is`, JSON.stringify(filePath));
    } else { // buffer
      pixelsBuffer = await imagePacker.packing(imageSourceApi, packOpts);
      let source: image.ImageSource = image.createImageSource(pixelsBuffer);
      pixelMap = await source.createPixelMap();
    }
  } else { // obj
    pictureObj = await imageSourceApi.createPicture(options);
    if (outState) { // file
      await imagePacker.packToFile(pictureObj, file.fd, packOpts);
      logger.info(TAG, `writePictureSource filePath is`, JSON.stringify(filePath));
      let imageSource = image.createImageSource(filePath);
      pixelMap = await imageSource.createPixelMap();
    } else { // buffer
      pixelsBuffer = await imagePacker.packing(pictureObj, packOpts);
      let source: image.ImageSource = image.createImageSource(pixelsBuffer);
      pixelMap = await source.createPixelMap();
    }
  }
  if (!pixelMap) {
    return null;
  }
  return pixelMap;
}

/**
 * 判断Native多图对象编码类型
 * @param decodingType 解码类型(1:Gain map)
 * @returns
 */
export async function checkEncodingType(fileName: string,
                                        encodingObject: string, encodingResult: string): Promise<string> {
  let context = getContext();
  let packingFileName: string = '';
  switch (encodingObject) {
    case 'imageSource':
      switch (encodingResult) {
        case 'data': {
          packingFileName = await test.packToDataImageSource(context);
          if (packingFileName != 'packing fail') {
            return packingFileName;
          }
          return 'Illegal input';
        }
        case 'file': {
          let sourcePath: string = context.filesDir + '/' + fileName;
          let file: fileIo.File = fs.openSync(sourcePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          packingFileName = test.packToFileImageSource(context, file);
          if (packingFileName != 'packing fail') {
            return packingFileName;
          }
          return 'Illegal input';
        }
      }
    case 'picture':
      switch (encodingResult) {
        case 'data': {
          packingFileName = 'packPictureToData.jpg';
          await test.packToDataFromPicture(packingFileName);
          return packingFileName;
        }
        case 'file': {
          packingFileName = 'packPictureToFile.jpg';
          await test.packToFileFromPicture(packingFileName);
          return packingFileName;
        }
      }
    default:
      return 'Illegal input';
  }
}

export async function showAuxiliaryPicture(uri: string, auxType: image.AuxiliaryPictureType): Promise<PixelMap | null> {
  let imageSourceApi: image.ImageSource = image.createImageSource(uri);
  if (!imageSourceApi) {
    return null;
  }
  pictureObj = await imageSourceApi.createPicture(options);
  auxPictureObj = pictureObj.getAuxiliaryPicture(auxType);
  if (auxPictureObj != null) {
    pixelsBuffer = await auxPictureObj.readPixelsToBuffer();
    let opts: image.InitializationOptions = {
      size: auxPictureObj.getAuxiliaryPictureInfo().size,
    }
    pixelMap = image.createPixelMapSync(pixelsBuffer, opts);
  } else {
    return null;
  }
  if (!pixelMap) {
    return null;
  }
  return pixelMap;
}

export async function NDKPictureDecoding(uri: string, auxType: image.AuxiliaryPictureType): Promise<PixelMap | null> {
  const context = getContext();
  const resourceMgr = context.resourceManager;
  const rawFile = await resourceMgr.getRawFileContent(uri);
  let isSupportHEIFDecode: Boolean =
    image.createImageSource(rawFile.buffer as ArrayBuffer).supportedFormats.includes('image/heif');
  console.log('isSupportHEIFDecode is : ' + isSupportHEIFDecode);
  if (!isSupportHEIFDecode) {
    logger.info(TAG, `device is not support heif decode`);
    uri = 'HdrVivid.jpg';
  }
  console.log('uri is : ' + uri);
  let filePath = await test.writeFileToBox(uri);
  test.createDecodingOptions();
  test.decodingOptionPictSetAux();
  test.decodingOptionPictGetAux();
  await test.createPictureByImageSource(filePath);
  pixelMap = await DecodingPicture(uri, auxType);
  return pixelMap
}

export async function NDKPictureEncoding(fileName: string, obj: string, result: string): Promise<PixelMap | null> {
  let filePath = await test.writeFileToBox(fileName);
  test.createDecodingOptions();
  test.decodingOptionPictSetAux();
  test.decodingOptionPictGetAux();
  test.createPictureByImageSource(filePath);
  let packName = await checkEncodingType(fileName, obj, result);
  if (packName != 'Illegal input') {
    pixelMap = await test.showPhoto(packName);
  } else if (!pixelMap) {
    return null;
  }
  return pixelMap;
}