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
// [Start native_rawfile_guide_sample]
import { util } from '@kit.ArkTS';
import { resourceManager } from '@kit.LocalizationKit';
import testNapi from 'libentry.so'; // 导入so

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private resMgr = this.getUIContext().getHostContext()?.resourceManager; // 获取本应用包的资源对象
  @State rawfileListMsg: string = 'FileList = ';
  @State retMsg: string = 'isRawDir = ';
  @State rawfileContentMsg: string = 'RawFileContent = ';
  @State rawfileDescriptorMsg: string = 'RawFileDescriptor.length = ';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .id('hello_world')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            // 传入资源管理对象，以及访问的rawfile文件夹名称
            let rawFileList: Array<String> = testNapi.getFileList(this.resMgr, '');
            this.rawfileListMsg = 'FileList = ' + rawFileList;
            console.log(this.rawfileListMsg);

            let ret: boolean = testNapi.isRawDir(this.resMgr, 'subrawfile');
            this.retMsg = 'isRawDir = ' + ret;
            console.log(this.retMsg);

            // 传入资源管理对象，以及访问的rawfile文件夹名称
            let rawfileArray: Uint8Array = testNapi.getRawFileContent(this.resMgr, 'rawfile1.txt');
            // 将Uint8Array转为字符串
            let textDecoder: util.TextDecoder = new util.TextDecoder();
            let rawfileContent: string = textDecoder.decodeToString(rawfileArray);
            this.rawfileContentMsg = 'RawFileContent = ' + rawfileContent;
            console.log(this.rawfileContentMsg);

            // 传入资源管理对象，以及访问的rawfile文件名称
            let rawfileDescriptor: resourceManager.RawFileDescriptor =
              testNapi.getRawFileDescriptor(this.resMgr, 'rawfile1.txt');
            this.rawfileDescriptorMsg = 'RawFileDescriptor.length = ' + rawfileDescriptor.length;
            console.log(this.rawfileDescriptorMsg);
          })
        Text(this.rawfileListMsg).id('get_file_list').fontSize(30);
        Text(this.retMsg).id('is_raw_dir').fontSize(30);
        Text(this.rawfileContentMsg).id('get_raw_file_content').fontSize(30);
        Text(this.rawfileDescriptorMsg).id('get_raw_file_descriptor').fontSize(30);
      }
      .width('100%')
    }
    .height('100%')
  }
}

// [End native_rawfile_guide_sample]