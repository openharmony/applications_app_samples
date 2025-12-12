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
import { pushSourceToBox, getFileFd } from '../utils/FunctionUtility'
const TAG: string = 'SourceFunctions';
export class SourceFunctions {
  constructor() {
  }

  private logger = new AppLog(TAG);

  async createImageSource(context: common.UIAbilityContext, fileName: string): Promise<void> {
    let filePath = context.filesDir + '/' + fileName;
    await pushSourceToBox(context, fileName);
    let errorCode = testNapi.createImageSource(filePath);
    this.logger.check_result('Create imageSource' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'Create imageSource success.'});
    } else {
      this.logger.log('Create imageSource error is: ' + errorCode);
      promptAction.showToast({ message: 'Create imageSource error is: ' + errorCode});
    }
  }

  getImageInfo() {
    let width = testNapi.getImageInfo();
    this.logger.log(`Get the width of the imageSource is ${width}.`);
    promptAction.showToast({ message: `Get the width of the imageSource is ${width}.`});
  }

  getImageProperty(key: string) {
    this.logger.log(`Get the key is ${key}.`);
    let value = testNapi.getImageProperty(key);
    this.logger.log(`Get the value of ${key} is ${value}.`);
    promptAction.showToast({ message: `Get the value of ${key} is ${value}.`});
  }

  modifyImageProperty(key: string, value: string): void {
    let errorCode = testNapi.modifyImageProperty(key, value);
    this.logger.check_result('ModifyImageProperty' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'ModifyImageProperty success.'});
    } else {
      promptAction.showToast({ message: `ModifyImageProperty failed with ${errorCode}.`});
      this.logger.log(`ModifyImageProperty failed with ${errorCode}.`);
    }
  }

  createPixelMap(): void {
    let errorCode = testNapi.createPixelMap();
    this.logger.check_result('CreatePixelMap' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'CreatePixelMap success.'});
    } else {
      promptAction.showToast({ message: `CreatePixelMap failed with ${errorCode}.`});
      this.logger.log(`CreatePixelMap failed with ${errorCode}.`);
    }
  }

  getFrameCount() {
    let count = testNapi.getFrameCount();
    promptAction.showToast({ message: `GetFrameCount return count ${count}.`});
  }

  createPixelmapList(): void {
    let errorCode = testNapi.createPixelmapList();
    this.logger.check_result('CreatePixelMapList' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'CreatePixelMapList success.'});
    } else {
      promptAction.showToast({ message: `CreatePixelMapList failed with ${errorCode}.`});
      this.logger.log(`CreatePixelMapList failed with ${errorCode}.`);
    }
  }

  getDelayTimeList() {
    let errorCode = testNapi.getDelayTimeList();
    this.logger.check_result('GetDelayTimeList' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'GetDelayTimeList success.'});
    } else {
      promptAction.showToast({ message: `GetDelayTimeList failed with ${errorCode}.`});
      this.logger.log(`GetDelayTimeList failed with ${errorCode}.`);
    }
  }

  releaseImageSource() {
    let errorCode = testNapi.releaseImageSource();
    this.logger.check_result('ReleaseImageSource' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'ReleaseImageSource success.'});
    } else {
      promptAction.showToast({ message: `ReleaseImageSource failed with ${errorCode}.`});
      this.logger.log(`ReleaseImageSource failed with ${errorCode}.`);
    }
  }

  async createPixelmapUsingAllocator(context: common.UIAbilityContext, fileName: string): Promise<void> {
    let filePath = context.filesDir + '/' + fileName;
    await pushSourceToBox(context, fileName);
    let errorCode = testNapi.testStrideWithAllocatorType(filePath);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'CreatePixelMapUsingAllocator success.'});
    } else {
      this.logger.log('CreatePixelMapUsingAllocator error is: ' + errorCode);
      promptAction.showToast({ message: 'CreatePixelMapUsingAllocator error is: ' + errorCode});
    }
  }

  packToFileFromImageSourceTestJs(context: common.UIAbilityContext, fileName: string) {
    const fd = getFileFd(context, fileName);
    let errorCode = testNapi.packToFileFromImageSourceTestJs(fd);
    this.logger.check_result('PackToFileFromImageSourceTestJs' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'PackToFileFromImageSourceTestJs success.'});
    } else {
      promptAction.showToast({ message: `PackToFileFromImageSourceTestJs failed with ${errorCode}.`});
      this.logger.log(`PackToFileFromImageSourceTestJs failed with ${errorCode}.`);
    }
  }

  packToFileFromPixelmapTestJs(context: common.UIAbilityContext, fileName: string) {
    let fd = getFileFd(context, fileName);
    let errorCode = testNapi.packToFileFromPixelmapTestJs(fd);
    this.logger.check_result('PackToFileFromPixelmapTestJs' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'PackToFileFromPixelmapTestJs success.'});
    } else {
      promptAction.showToast({ message: `PackToFileFromPixelmapTestJs failed with ${errorCode}.`});
      this.logger.log(`PackToFileFromPixelmapTestJs failed with ${errorCode}.`);
    }
  }
}
