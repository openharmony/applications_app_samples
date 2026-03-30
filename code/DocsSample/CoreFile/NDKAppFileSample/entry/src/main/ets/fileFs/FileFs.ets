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

import { common } from '@kit.AbilityKit';
import { fileIo, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import Logger from '../common/Logger';

const BUFFER: number = 1024; // 读取文件缓冲区大小

// 获取应用文件沙箱路径

export function createFile(context: common.UIAbilityContext): string {

  let file: fileIo.File | undefined;
  let filesDir = context.filesDir;
  const filePath = `${filesDir}/test.txt`;
  try {
    // 新建并打开文件
    file = fileIo.openSync(filesDir + '/test.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    // 写入一段内容至文件
    let writeLen = fileIo.writeSync(file.fd, 'Try to write str : hello world');
    Logger.info('The length of str is: ' + writeLen);
    // 从文件读取一段内容
    let arrayBuffer = new ArrayBuffer(BUFFER);
    let readOptions: ReadOptions = {
      offset: 0, // 从文件的开头开始读取
      length: arrayBuffer.byteLength
    };
    let readLen = fileIo.readSync(file.fd, arrayBuffer, readOptions);
    let buf = buffer.from(arrayBuffer, 0, readLen);
    Logger.info('the content of file: ' + buf.toString());
    let str = 'the content of file: ' + buf.toString();
    fileIo.closeSync(file);
    return str;
  } catch (error) {
    Logger.error('Failed to create file');
    return '';
  } finally {
    // 关闭文件
    if (file) {
      try {
        fileIo.closeSync(file);
        Logger.info(`成功关闭文件: ${filePath}`);
      } catch (closeError) {
        Logger.error(`关闭文件失败（路径：${filePath}）: ${(closeError as Error).message}`);
      }
    }
  }
}