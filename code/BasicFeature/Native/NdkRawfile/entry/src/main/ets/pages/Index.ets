/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import resourceManager from '@ohos.resourceManager';
import { util } from '@kit.ArkTS';
import { Logger } from '../utils/Logger';

@Entry
@Component
struct Index {
  private resMgr: resourceManager.ResourceManager = getContext().resourceManager;
  private rawFileList: string = '';
  private rawFileContent: string = '';
  private rawFileDescriptor: resourceManager.RawFileDescriptor | undefined = undefined;
  private rawFileContentWithOffset: string = '';
  private rawFileContent64: string = '';
  private rawFileDescriptor64: resourceManager.RawFileDescriptor | undefined = undefined;
  private rawFileContentWithOffset64: string = '';

  aboutToAppear() {
    let textDecoder = new util.TextDecoder();
    // get raw file list
    this.rawFileList = JSON.stringify(testNapi.getFileList(this.resMgr, ''));

    // get content of rawfile.txt
    let rawFileArray = testNapi.getRawFileContent(this.resMgr, 'rawfile.txt');
    this.rawFileContent = textDecoder.decodeToString(rawFileArray);

    // get raw file descriptor of rawfile.txt
    this.rawFileDescriptor = testNapi.getRawFileDescriptor(this.resMgr, 'rawfile.txt');

    // get content of rawfile.txt with offset 3
    rawFileArray = testNapi.getRawFileContent(this.resMgr, 'rawfile.txt', 3);
    this.rawFileContentWithOffset = textDecoder.decodeToString(rawFileArray);

    // get content of rawfile1.txt by getRawFileContent64
    rawFileArray = testNapi.getRawFileContent64(this.resMgr, 'rawfile1.txt');
    this.rawFileContent64 = textDecoder.decodeToString(rawFileArray);

    // get raw file descriptor of rawfile1.txt by getRawFileDescriptor64
    this.rawFileDescriptor64 = testNapi.getRawFileDescriptor64(this.resMgr, 'rawfile1.txt');

    // get content of rawfile1.txt by getRawFileContent64 with offset 6
    rawFileArray = testNapi.getRawFileContent64(this.resMgr, 'rawfile1.txt', 8);
    this.rawFileContentWithOffset64 = textDecoder.decodeToString(rawFileArray);
  }

  aboutToDisappear(): boolean | void {
    Logger.info('aboutToDisappear');
    if (this.rawFileDescriptor) {
      let result = testNapi.releaseRawFileDescriptor(this.resMgr, this.rawFileDescriptor);
      Logger.info(`releaseRawFileDescriptor: ${result}`);
    }

    if (this.rawFileDescriptor64) {
      let result = testNapi.releaseRawFileDescriptor64(this.resMgr, this.rawFileDescriptor64);
      Logger.info(`releaseRawFileDescriptor64: ${result}`);
    }
  }

  build() {
    Row() {
      Column() {
        Text('file list: ' + this.rawFileList)
          .id('raw_file_list')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt content: ' + this.rawFileContent)
          .id('raw_file_content')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt content with offset: ' + this.rawFileContentWithOffset)
          .id('raw_file_content_offset')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt fd: ' + this.rawFileDescriptor?.fd)
          .id('raw_file_fd')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt fd.offset: ' + this.rawFileDescriptor?.offset)
          .id('raw_file_fd_offset')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt fd.length: ' + this.rawFileDescriptor?.length)
          .id('raw_file_fd_length')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })

        Text('rawfile.txt content64: ' + this.rawFileContent64)
          .id('raw_file_content64')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15, top: 15 })
        Text('rawfile.txt content with offset64: ' + this.rawFileContentWithOffset64)
          .id('raw_file_content_offset64')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt fd64: ' + this.rawFileDescriptor64?.fd)
          .id('raw_file_fd64')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt fd.offset64: ' + this.rawFileDescriptor64?.offset)
          .id('raw_file_fd_offset64')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
        Text('rawfile.txt fd.length64: ' + this.rawFileDescriptor64?.length)
          .id('raw_file_fd_length64')
          .fontSize(20)
          .width('100%')
          .margin({ bottom: 15 })
      }
      .padding({ left: 15, right: 15 })
      .width('100%')
    }
    .height('100%')
  }
}
