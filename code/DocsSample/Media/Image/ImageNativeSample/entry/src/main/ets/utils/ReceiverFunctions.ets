/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License  distributed on an "AS " BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import testNapi from 'libentry.so';
import {AppLog } from  '../utils/Logger'
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'ReceiverFunctions';
export class ReceiverFunctions {
  constructor() {
  }

  private logger = new AppLog(TAG);

  initImageReceiver() {
    let errorCode = testNapi.initImageReceiver();
    if(errorCode === 0) {
      promptAction.showToast({ message: 'InitImageReceiver success.'});
    } else {
      promptAction.showToast({ message: `InitImageReceiver failed with ${errorCode}.`});
      this.logger.log(`InitImageReceiver failed with ${errorCode}.`);
    }
  }

  takePhoto() {
    let errorCode = testNapi.takePhoto();
    this.logger.check_result('TakePhoto' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'TakePhoto success.'});
    } else {
      promptAction.showToast({ message: `TakePhoto failed with ${errorCode}.`});
      this.logger.log(`TakePhoto failed with ${errorCode}.`);
    }
  }

  getReceiverImageInfo() {
    let info = testNapi.getReceiverImageInfo();
    if(info !== null) {
      promptAction.showToast({ message: `GetImageInfo: ${JSON.stringify(info)}.`});
      this.logger.log(`GetImageInfo: ${JSON.stringify(info)}.`);
    } else {
      promptAction.showToast({ message: `GetImageInfo failed.`});
      this.logger.log(`GetImageInfo failed.`);
    }
  }

  releaseImageReceiver() {
    let errorCode = testNapi.releaseImageReceiver();
    this.logger.check_result('ReleaseImageReceiver' , errorCode);
    if(errorCode === 0) {
      promptAction.showToast({ message: 'ReleaseImageReceiver success.'});
    } else {
      promptAction.showToast({ message: `ReleaseImageReceiver failed with ${errorCode}.`});
      this.logger.log(`ReleaseImageReceiver failed with ${errorCode}.`);
    }
  }
}
