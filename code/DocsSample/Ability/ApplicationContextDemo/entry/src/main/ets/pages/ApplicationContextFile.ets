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

// [Start app_context_file_start]
import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';
import { fileIo, ReadOptions } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Page_Context]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Row() {
      Column() {
        Text(this.message)
        // [StartExclude app_context_file_start]
          .width('50vp')
        // [EndExclude app_context_file_start]
        Button() {
          Text('create file')
          // [StartExclude app_context_file_start]
            .width('50vp')
          // [EndExclude app_context_file_start]
            .onClick(() => {
              let applicationContext = this.context.getApplicationContext();
              // 获取应用文件路径
              let filesDir = applicationContext.filesDir;
              hilog.info(DOMAIN_NUMBER, TAG, `filePath: ${filesDir}`);
              // 文件不存在时创建并打开文件，文件存在时打开文件
              let file = fileIo.openSync(filesDir + '/test.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
              // 写入一段内容至文件
              let writeLen = fileIo.writeSync(file.fd, "Try to write str.");
              hilog.info(DOMAIN_NUMBER, TAG, `The length of str is: ${writeLen}`);
              // 创建一个大小为1024字节的ArrayBuffer对象，用于存储从文件中读取的数据
              let arrayBuffer = new ArrayBuffer(1024);
              // 设置读取的偏移量和长度
              let readOptions: ReadOptions = {
                offset: 0,
                length: arrayBuffer.byteLength
              };
              // 读取文件内容到ArrayBuffer对象中，并返回实际读取的字节数
              let readLen = fileIo.readSync(file.fd, arrayBuffer, readOptions);
              // 将ArrayBuffer对象转换为Buffer对象，并转换为字符串输出
              let buf = buffer.from(arrayBuffer, 0, readLen);
              hilog.info(DOMAIN_NUMBER, TAG, `the content of file: ${buf.toString()}`);
              // 关闭文件
              fileIo.closeSync(file);
            })
        }
        // [StartExclude app_context_file_start]
        .width('50vp')
        // [EndExclude app_context_file_start]
      }
      // [StartExclude app_context_file_start]
      .width('50vp')
      // [EndExclude app_context_file_start]
    }
    // [StartExclude app_context_file_start]
    .width('50vp')
    // [EndExclude app_context_file_start]
  }
}
// [End app_context_file_start]