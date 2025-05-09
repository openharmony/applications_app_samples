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

// [Start import_starf_storageStatistics]
import { common } from '@kit.AbilityKit';
import { statfs } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { storageStatistics } from '@kit.CoreFileKit';
import Logger from '../common/Logger';
import {
  createFile,
  readWriteFile,
  getListFile,
  readWriteFileWithStream,
  readFile,
  copyFileWithReadable,
  copyFileWithData,
  hashFileWithStream
} from '../fileFs/FileFs';

// [StartExclude import_starf_storageStatistics]
const BUFFER: number = 1024; // 读取文件缓冲区
const MARGIN = 5; // 组件间的间隔
// [EndExclude import_starf_storageStatistics]

// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;
// [End import_starf_storageStatistics]

// [Start get_share_file]
function getShareFile(): string {
  let strFile = '';
  try {
    let URI: string | undefined = AppStorage.get('URI');
    if (URI === null || URI === undefined) {
      Logger.info('uri is invalid');
      let str = 'uri is invalid';
      return str;
    }
    try {
      // 根据需要对被分享文件的URI进行相应操作。例如读写的方式打开URI获取file对象
      let file = fs.openSync(URI, fs.OpenMode.READ_WRITE);
      Logger.info('open file successfully!');
      // [StartExclude get_share_file]
      // 1024为读取文件内容的缓冲区大小
      let arrayBuffer = new ArrayBuffer(BUFFER);
      let readOptions: ReadOptions = {
        offset: 0, // 从文件的开头开始读取
        length: arrayBuffer.byteLength
      };
      let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
      // 这个 buf 对象是 arrayBuffer 中从位置 0 开始的前 readLen 字节
      let buf = buffer.from(arrayBuffer, 0, readLen);
      Logger.info('the content of file: ' + buf.toString());
      // 关闭文件
      strFile = 'the content of file: ' + buf.toString();
      fs.closeSync(file);
      // [EndExclude get_share_file]
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.info(`Invoke openSync failed, code is ${error.code}, message is ${error.message}`);
    }
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    Logger.info(`Invoke openSync failed, code is ${err.code}, message is ${err.message}`);
  }
  return strFile;
}

// [End get_share_file]

@Entry
@Component
export default struct Index {
  @State message: string = '';
  @State filename: string = '';

  build() {
    Column() {
      TextArea({
        text: this.message,
        placeholder: '',
      })
        .width('100%')
        .height('40%')
      TextInput({
        text: 'test'
      })
        .width('100%')
        .height('5%')
        .onChange((value) => this.filename = value)
      Row() {
        Button($r('app.string.createWriteReadfile'))
          .width('25%')
          .height('100%')
          .onClick(() => {
            this.message += createFile() + '\n';
          })
        Button($r('app.string.copyDocument'))
          .width('25%')
          .height('100%')
          .onClick(() => {
            readWriteFile();
            readWriteFileWithStream();
            copyFileWithReadable();
            copyFileWithData();
          })
        Button($r('app.string.ReadFile'))
          .width('25%')
          .height('100%')
          .onClick(() => {
            this.message += readFile(this.filename) + '\n';
          })
        Button($r('app.string.GetFileList'))
          .width('25%')
          .height('100%')
          .onClick(() => {
            this.message += getListFile() + '\n';
          })
      }
      .width('100%')
      .height('8%')
      .margin(MARGIN)

      Button($r('app.string.getFileSystemSize'))
        .width('80%')
        .height('6%')
        .margin(MARGIN)
        .onClick(() => {
          // [Start statfs_get_FreeSize]
          statfs.getFreeSize(filesDir, (err: BusinessError, number: number) => {
            if (err) {
              Logger.info(`Invoke getFreeSize failed, code is ${err.code}, message is ${err.message}`);
            } else {
              Logger.info(`Invoke getFreeSize succeeded, size is ${number}`);
              // [StartExclude statfs_get_FreeSize]
              this.message += 'The size of the remaining space in the file system data: ' + number.toString() + '\n';
              // [EndExclude statfs_get_FreeSize]
            }
          });
          // [End statfs_get_FreeSize]
        })
      Button($r('app.string.appStorageSpaceSize'))
        .width('80%')
        .height('6%')
        .margin(MARGIN)
        .onClick(() => {
          // [Start storageStatistics_getCurrentBundleStats]
          storageStatistics.getCurrentBundleStats((err: BusinessError, bundleStats: storageStatistics.BundleStats) => {
            if (err) {
              Logger.info(`Invoke getCurrentBundleStats failed, code is ${err.code}, message is ${err.message}`);
            } else {
              Logger.info(`Invoke getCurrentBundleStats succeeded, appsize is ${bundleStats.appSize}`);
              // [StartExclude storageStatistics_getCurrentBundleStats]
              this.message += 'The size of the storage space in the system: ' + bundleStats.appSize.toString() + '\n';
              // [EndExclude storageStatistics_getCurrentBundleStats]
            }
          });
          // [End storageStatistics_getCurrentBundleStats]
        })
      Row() {
        Button($r('app.string.hash'))
          .onClick(() => {
            hashFileWithStream();
          })
          .width('50%')
          .height('90%')
        Button($r('app.string.getShareFile'))
          .onClick(() => {
            this.message += getShareFile() + '\n';
            let str: string | undefined = AppStorage.get('URI');
            this.message += str + '\n';
          })
          .width('50%')
          .height('90%')
      }
      .width('100%')
      .height('8%')
      .margin(MARGIN)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgb(242,242,242)')
  }
}

