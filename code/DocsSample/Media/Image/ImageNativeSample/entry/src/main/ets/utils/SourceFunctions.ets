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

  async createImageSource(context: common.UIAbilityContext, fileName: string): Promise<string> {
    let message: string = '';
    let filePath = context.filesDir + '/' + fileName;
    await pushSourceToBox(context, fileName);
    let errorCode = testNapi.createImageSource(filePath);
    this.logger.check_result('Create imageSource' , errorCode);
    if(errorCode === 0) {
      message = 'Create imageSource success.';
    } else {
      this.logger.log('Create imageSource error is: ' + errorCode);
      message = 'Create imageSource error is: ' + errorCode;
    }
    return message;
  }

  getImageInfo(): string {
    let message: string = '';
    let width = testNapi.getImageInfo();
    this.logger.log(`Get the width of the imageSource is ${width}.`);
    message = `Get the width of the imageSource is ${width}.`;
    return message;
  }

  getImageProperty(key: string): string {
    let message: string = '';
    this.logger.log(`Get the key is ${key}.`);
    let value = testNapi.getImageProperty(key);
    this.logger.log(`Get the value of ${key} is ${value}.`);
    message = `Get the value of ${key} is ${value}.`;
    return message;
  }

  modifyImageProperty(key: string, value: string): string {
    let message: string = '';
    let errorCode = testNapi.modifyImageProperty(key, value);
    this.logger.check_result('ModifyImageProperty' , errorCode);
    if(errorCode === 0) {
      message = 'ModifyImageProperty success.';
    } else {
      message = `ModifyImageProperty failed with ${errorCode}.`;
      this.logger.log(`ModifyImageProperty failed with ${errorCode}.`);
    }
    return message;
  }

  createPixelMap(): string {
    let message: string = '';
    let errorCode = testNapi.createPixelMap();
    this.logger.check_result('CreatePixelMap' , errorCode);
    if(errorCode === 0) {
      message = 'CreatePixelMap success.';
    } else {
      message = `CreatePixelMap failed with ${errorCode}.`;
      this.logger.log(`CreatePixelMap failed with ${errorCode}.`);
    }
    return message;
  }

  getFrameCount(): string {
    let message: string = '';
    let count = testNapi.getFrameCount();
    message = `GetFrameCount return count ${count}.`;
    return message;
  }

  createPixelmapList(): string {
    let message: string = '';
    let errorCode = testNapi.createPixelmapList();
    this.logger.check_result('CreatePixelMapList' , errorCode);
    if(errorCode === 0) {
      message = 'CreatePixelMapList success.';
    } else {
      message = `CreatePixelMapList failed with ${errorCode}.`;
      this.logger.log(`CreatePixelMapList failed with ${errorCode}.`);
    }
    return message;
  }

  getDelayTimeList(): string {
    let message: string = '';
    let errorCode = testNapi.getDelayTimeList();
    this.logger.check_result('GetDelayTimeList' , errorCode);
    if(errorCode === 0) {
      message = 'GetDelayTimeList success.';
    } else {
      message = `GetDelayTimeList failed with ${errorCode}.`;
      this.logger.log(`GetDelayTimeList failed with ${errorCode}.`);
    }
    return message;
  }

  releaseImageSource(): string {
    let message: string = '';
    let errorCode = testNapi.releaseImageSource();
    this.logger.check_result('ReleaseImageSource' , errorCode);
    if(errorCode === 0) {
      message = 'ReleaseImageSource success.';
    } else {
      message = `ReleaseImageSource failed with ${errorCode}.`;
      this.logger.log(`ReleaseImageSource failed with ${errorCode}.`);
    }
    return message;
  }

  async createPixelmapUsingAllocator(context: common.UIAbilityContext, fileName: string): Promise<string> {
    let message: string = '';
    let filePath = context.filesDir + '/' + fileName;
    await pushSourceToBox(context, fileName);
    let errorCode = testNapi.testStrideWithAllocatorType(filePath);
    if(errorCode === 0) {
      message = 'CreatePixelMapUsingAllocator success.';
    } else {
      this.logger.log('CreatePixelMapUsingAllocator error is: ' + errorCode);
      message = 'CreatePixelMapUsingAllocator error is: ' + errorCode;
    }
    return message;
  }

  packToFileFromImageSourceTestJs(context: common.UIAbilityContext, fileName: string): string {
    let message: string = '';
    const fd = getFileFd(context, fileName);
    let errorCode = testNapi.packToFileFromImageSourceTestJs(fd);
    this.logger.check_result('PackToFileFromImageSourceTestJs' , errorCode);
    if(errorCode === 0) {
      message = 'PackToFileFromImageSourceTestJs success.';
    } else {
      message = `PackToFileFromImageSourceTestJs failed with ${errorCode}.`;
      this.logger.log(`PackToFileFromImageSourceTestJs failed with ${errorCode}.`);
    }
    return message;
  }

  packToFileFromPixelmapTestJs(context: common.UIAbilityContext, fileName: string): string {
    let message: string = '';
    let fd = getFileFd(context, fileName);
    let errorCode = testNapi.packToFileFromPixelmapTestJs(fd);
    this.logger.check_result('PackToFileFromPixelmapTestJs' , errorCode);
    if(errorCode === 0) {
      message = 'PackToFileFromPixelmapTestJs success.';
    } else {
      message = `PackToFileFromPixelmapTestJs failed with ${errorCode}.`;
      this.logger.log(`PackToFileFromPixelmapTestJs failed with ${errorCode}.`);
    }
    return message;
  }
}
