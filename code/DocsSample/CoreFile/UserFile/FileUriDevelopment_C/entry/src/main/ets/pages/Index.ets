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

import { buffer } from '@kit.ArkTS';
import { fileUri, fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import common from '@ohos.app.ability.common';
import Logger from '../common/Logger';
import testNapi from 'libentry.so';

// 获取应用文件沙箱路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;
let filePath = filesDir + '/test.txt'; // 文件路径
let uri = fileUri.getUriFromPath(filePath); // 从文件路径获取 URI

export function createFile(): string {
  // 新建并打开文件
  let file = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  // 写入一段内容至文件
  let writeLen = fs.writeSync(file.fd, 'Try to write str : hello world');
  Logger.info('The length of str is: ' + writeLen); // 写入内容的长度
  // 从文件读取一段内容
  let arrayBuffer = new ArrayBuffer(1024); // 分配一个 1024 字节的缓冲区
  let readOptions: ReadOptions = {
    offset: 0, // 从文件的开头开始读取
    length: arrayBuffer.byteLength // 读取的长度为缓冲区的大小
  };
  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions); // 实际读取的字节数
  // 这个 buf 对象是 arrayBuffer 中从位置 0 开始的前 readLen 字节
  let buf = buffer.from(arrayBuffer, 0, readLen);
  Logger.info('the content of file: ' + buf.toString()); // 打印文件内容
  let str = 'the content of file: ' + buf.toString();
  // 关闭文件
  fs.closeSync(file);
  return str;
}

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.size_50')) // 设置字体大小为 50
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.invokeInterfaceButton1'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            createFile();
            this.message = testNapi.OH_FileUri_GetUriFromPathExample(filePath);
          })

        Button($r('app.string.invokeInterfaceButton2'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            this.message = testNapi.OH_FileUri_GetPathFromUriExample(uri);
          })

        Button($r('app.string.invokeInterfaceButton3'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            this.message = testNapi.OH_FileUri_GetFullDirectoryUriExample(uri);
          })

        Button($r('app.string.invokeInterfaceButton4'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            if (testNapi.OH_FileUri_IsValidUriExample(uri)) {
              this.message = 'UriIsTrue';
            }
          })

        Button($r('app.string.invokeInterfaceButton5'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            this.message = testNapi.OH_FileUri_GetFileNameExample(uri);
          })
      }
      .width('100%') // 设置列的宽度为 100%
    }
    .height('100%') // 设置行的高度为 100%
  }
}