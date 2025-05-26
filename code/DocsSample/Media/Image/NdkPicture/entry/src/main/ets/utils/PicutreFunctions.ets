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
import fs from '@ohos.file.fs'
import {AppLog } from  '../utils/Logger'
import image from '@ohos.multimedia.image';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'PictureFunctions: '
export class PictureFunctions {
  constructor() {
  }

  private logger = new AppLog(TAG)

  createPicture() {
    this.logger.log("start createPicture");
    let context = getContext();
    let filePath = context.filesDir + "/test.jpg";
    let ec = testNapi.CreatePicture(filePath);
    if(ec === 0) {
      promptAction.showToast({ message: 'Create Picture Success.'});
    } else {
      this.logger.log("CreatePicture error is: " + ec);
    }
  }

  createPictureByImageSource() {
    this.logger.log("start createPicture");
    let context = getContext();
    let filePath = context.filesDir + "/test.jpg";
    let ec = testNapi.CreatePictureByImageSource(filePath);
    if(ec === 0) {
      promptAction.showToast({ message: 'Create Picture Success.'});
    } else {
      this.logger.log("CreatePicture error is: " + ec);
    }
  }

  getMainPixelMap() {
    let ec = testNapi.GetMainPixelMap();
    this.logger.check_result("GetMainPixelMap", ec);
    if(ec === 0) {
      promptAction.showToast({ message: 'getMainPixelMap Success.'});
    } else {
      promptAction.showToast({ message: 'getMainPixelMap failed. Please create picture first.'});
      this.logger.log("getMainPixelMap error is: " + ec);
    }
  }

  packToData(): void {
    let ec = testNapi.PackToData();
    this.logger.check_result("packToDataFromPicture result is:" , ec);
    if(ec === 0) {
      promptAction.showToast({ message: 'packToData Success.'});
    } else {
      promptAction.showToast({ message: 'packToData failed. Please create picture first.'});
      this.logger.log("packToData error is: " + ec);
    }
  }

  packToFile(): void {
    let context = getContext();
    let filePath = context.filesDir + "/packTest.jpg";
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let ec = testNapi.PackToFile(file.fd);
    this.logger.check_result("packToDataFromPicture result is:" , ec);
    if(ec === 0) {
      promptAction.showToast({ message: 'packToFile Success.'});
    } else {
      promptAction.showToast({ message: 'packToFile failed. Please create picture first.'});
      this.logger.log("packToFile error is: " + ec);
    }
  }

  pictureRelease() {
    let ec = testNapi.ReleasePicture();
    this.logger.check_result("pictureNative_Release done, return is:" , ec);
    if(ec === 0) {
      promptAction.showToast({ message: 'pictureRelease Success.'});
    } else {
      promptAction.showToast({ message: 'pictureRelease failed. Please create picture first.'});
      this.logger.log("pictureRelease error is: " + ec);
    }
  }
}