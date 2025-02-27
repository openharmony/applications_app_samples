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
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import Logger from '../common/Logger';

const BUFFER: number = 1024; // 读取文件缓冲区大小

// 获取应用文件沙箱路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;

export function createFile(): string {
  // 新建并打开文件
  let file = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  // 写入一段内容至文件
  let writeLen = fs.writeSync(file.fd, 'Try to write str : hello world');
  Logger.info('The length of str is: ' + writeLen);
  // 从文件读取一段内容
  let arrayBuffer = new ArrayBuffer(BUFFER);
  let readOptions: ReadOptions = {
    offset: 0, // 从文件的开头开始读取
    length: arrayBuffer.byteLength
  };
  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
  // 这个 buf 对象是 arrayBuffer 中从位置 0 开始的前 readLen 字节
  let buf = buffer.from(arrayBuffer, 0, readLen);
  Logger.info('the content of file: ' + buf.toString());
  let str = 'the content of file: ' + buf.toString();
  // 关闭文件
  fs.closeSync(file);
  return str;
}