/*
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
import testNapi from 'libentry.so';
import {AppLog } from  '../utils/Logger'
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { pushSourceToBox } from './FunctionUtility';
import { image } from '@kit.ImageKit';
import { fileIo as fs } from '@kit.CoreFileKit';

const TAG: string = 'PictureFunctions';
export class PictureFunctions {
  constructor() {
  }

  private logger = new AppLog(TAG);

  async createPictureByImageSource(context: common.UIAbilityContext, fileName: string): Promise<void> {
    console.log(`fileName: ${fileName}`);
    let filePath = context.filesDir + '/' + fileName;
    await pushSourceToBox(context, fileName);
    let errorCode = testNapi.createPictureByImageSource(filePath);
    this.logger.check_result('CreatePictureByImageSource' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'CreatePicture success.'});
    } else {
      this.logger.log('CreatePicture error is: ' + errorCode);
      promptAction.showToast({ message: 'CreatePicture error is: ' + errorCode});
    }
  }

  setDesiredAuxiliaryPictures() {
    // 根据所需解码的辅助图类型设置解码参数。
    let typeList: image.AuxiliaryPictureType[] = [image.AuxiliaryPictureType.GAINMAP];
    let errorCode = testNapi.setDesiredAuxiliaryPictures(typeList);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'SetDesiredAuxiliaryPictures success.'});
    } else {
      promptAction.showToast({ message: `SetDesiredAuxiliaryPictures failed with ${errorCode}.`});
      this.logger.log(`SetDesiredAuxiliaryPictures failed with ${errorCode}.`);
    }
  }

  releasePictureSource() {
    let errorCode = testNapi.releasePictureSource();
    this.logger.check_result('ReleasePicture' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'ReleasePicture success.'});
    } else {
      promptAction.showToast({ message: `ReleasePicture failed with ${errorCode}.`});
      this.logger.log(`ReleasePicture failed with ${errorCode}.`);
    }
  }

  packToDataFromPicture() {
    let errorCode = testNapi.packToDataFromPicture('image/jpeg');
    this.logger.check_result('PackToDataFromPicture' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'PackToDataFromPicture success.'});
    } else {
      promptAction.showToast({ message: `PackToDataFromPicture failed with ${errorCode}.`});
      this.logger.log(`PackToDataFromPicture failed with ${errorCode}.`);
    }
  }

  packToFileFromPicture(context: Context, fileName: string) {
    this.logger.log(`PackToFileFromPicture start with ${fileName}.`);
    const filePath: string = context.filesDir + '/' + fileName;
    this.logger.log(`PackToFileFromPicture start with ${filePath}.`);
    const file: fs.File = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    let fd: number = file?.fd;
    this.logger.log(`PackToFileFromPicture start with ${fd}.`);
    let errorCode = testNapi.packToFileFromPicture(fd, 'image/jpeg');
    this.logger.check_result('PackToFileFromPicture' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'PackToFileFromPicture success.'});
    } else {
      promptAction.showToast({ message: `PackToFileFromPicture failed with ${errorCode}.`});
      this.logger.log(`PackToFileFromPicture failed with ${errorCode}.`);
    }
  }
}
