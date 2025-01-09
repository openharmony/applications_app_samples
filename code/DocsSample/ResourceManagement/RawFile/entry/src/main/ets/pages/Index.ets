/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import testNapi from 'libentry.so';  // 导入so

class RawFileDescriptor {
  fd: number;
  offset: number;
  length: number;

  constructor(fd: number, offset: number, length: number) {
    this.fd = fd;
    this.offset = offset;
    this.length = length;
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private resmgr = getContext().resourceManager;  // 获取本应用包的资源对象
  @State rawfilelistMsg: string = 'FileList = ';
  @State retMsg: string = 'isRawDir = ';
  @State rawfileContetMsg: string = 'RawFileContent = ';
  @State rawfileDescriptorMsg: string = 'RawFileDescriptor.length = ';
  
  build() {
    Row() {
      Column() {
        Text(this.message)
          .id('hello_world')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
            console.log('rawfilelist');
            let rawfilelist = testNapi.getFileList(this.resmgr, ''); // 传入资源对象，以及访问的rawfile文件夹名称
                console.log('rawfilelist:' + rawfilelist);
            this.rawfilelistMsg = 'FileList = ' + rawfilelist;

            let ret = testNapi.isRawDir(this.resmgr, 'rawfile1.txt');
            console.log('isRawDir:' + ret);
            this.retMsg = 'isRawDir = ' + ret;

            let rawfileContet = testNapi.getRawFileContent(this.resmgr, 'rawfile1.txt');
            console.log('rawfileContet:' + rawfileContet);
            this.rawfileContetMsg = 'RawFileContent = ' + rawfileContet;

            let rawfileDescriptor = (testNapi.getRawFileDescriptor(this.resmgr, 'rawfile1.txt') as RawFileDescriptor);
            console.log('RawFileDescriptor:' + rawfileDescriptor.fd, rawfileDescriptor.offset,
              rawfileDescriptor.length);
            this.rawfileDescriptorMsg = 'RawFileDescriptor.length = ' + rawfileDescriptor.length;
          })
        Text(this.rawfilelistMsg).id('get_file_list').fontSize(30);
        Text(this.retMsg).id('is_raw_dir').fontSize(30);
        Text(this.rawfileContetMsg).id('get_raw_file_content').fontSize(30);
        Text(this.rawfileDescriptorMsg).id('get_raw_file_descriptor').fontSize(30);
      }
      .width('100%')
    }
    .height('100%')
  }
}