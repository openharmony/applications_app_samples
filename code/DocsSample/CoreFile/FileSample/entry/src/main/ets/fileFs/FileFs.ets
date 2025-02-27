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

import { fileIo as fs, ReadOptions, WriteOptions, ListFileOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { hash } from '@kit.CoreFileKit';
import Logger from '../common/Logger';

// 获取应用文件沙箱路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;

const BUFFER: number = 1024; // 读取文件数据的缓冲区大小
const READSIZE: number = 0; // 初始化读取的字节数为 0

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
  let buf = buffer.from(arrayBuffer, 0, readLen); // 这个 Buffer 对象是 arrayBuffer 中从位置 0 开始的前 readLen 字节
  Logger.info('the content of file: ' + buf.toString());
  let str = 'the content of file: ' + buf.toString();
  // 关闭文件
  fs.closeSync(file);
  return str;
}

// 读取文件内容并写入到另一个文件 test.txt => testFile.txt
export function readWriteFile(): void {
  // 打开文件
  let srcFile = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let destFile = fs.openSync(filesDir + '/testFile.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  // 读取源文件内容并写入至目的文件
  let bufSize = BUFFER;
  let readSize = READSIZE;
  let buf = new ArrayBuffer(bufSize);
  let readOptions: ReadOptions = {
    offset: readSize,
    length: bufSize
  };
  let readLen = fs.readSync(srcFile.fd, buf, readOptions);
  while (readLen > 0) { // 循环继续，直到没有更多数据可以读取
    readSize += readLen;
    let writeOptions: WriteOptions = {
      length: readLen
    };
    fs.writeSync(destFile.fd, buf, writeOptions);
    readOptions.offset = readSize;
    readLen = fs.readSync(srcFile.fd, buf, readOptions);
    Logger.info('test.txt => testFile.txt');
  }
  // 关闭文件
  fs.closeSync(srcFile);
  fs.closeSync(destFile);
}

// 根据文件名读取文件内容
export function readFile(fileName: string): string {
  let file = fs.openSync(filesDir + '/' + fileName + '.txt', fs.OpenMode.READ_ONLY);
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
  return str;
}

// 查看文件列表
export function getListFile(): string {
  let str = '';
  let listFileOption: ListFileOptions = {
    recursion: false,
    listNum: 0, // 0 表示不限制文件数量
    filter: {
      suffix: ['.png', '.jpg', '.txt', '.jpeg', '.json'],
      displayName: ['*'],
      fileSizeOver: 0, // 0 表示列出所有文件，不限制文件大小
      lastModifiedAfter: new Date(0).getTime()  // 返回的时间戳是0
    }
  };
  let files = fs.listFileSync(filesDir, listFileOption);
  for (let i = 0; i < files.length; i++) {
    Logger.info(`The name of file: ${files[i]}`);
    str += files[i] + '\n';
  }
  return str;
}

// 以流的形式读写文件test.txt => destFile.txt
export async function readWriteFileWithStream(): Promise<void> {
  // 打开文件流
  let inputStream = fs.createStreamSync(filesDir + '/test.txt', 'r+');
  let outputStream = fs.createStreamSync(filesDir + '/destFile.txt', 'w+');
  // 以流的形式读取源文件内容并写入目的文件
  let bufSize = BUFFER;
  let readSize = READSIZE;
  let buf = new ArrayBuffer(bufSize);
  let readOptions: ReadOptions = {
    offset: readSize,
    length: bufSize
  };
  let readLen = await inputStream.read(buf, readOptions);
  readSize += readLen;
  while (readLen > 0) { // 循环继续，直到没有更多数据可以读取
    const writeBuf = readLen < bufSize ? buf.slice(0, readLen) : buf;
    await outputStream.write(writeBuf);
    readOptions.offset = readSize;
    readLen = await inputStream.read(buf, readOptions);
    readSize += readLen;
  }
  // 关闭文件流
  inputStream.closeSync();
  outputStream.closeSync();
}

// 使用文件流
export function copyFileWithReadable(): void {
  // 创建文件可读流
  const rs = fs.createReadStream(`${filesDir}/test.txt`);
  // 创建文件可写流
  const ws = fs.createWriteStream(`${filesDir}/destFile.txt`);
  // 暂停模式拷贝文件
  rs.on('readable', () => {
    const data = rs.read();
    if (!data) {
      return;
    }
    ws.write(data);
  });
}

export function copyFileWithData(): void {

  // 创建文件可读流
  const rs = fs.createReadStream(`${filesDir}/testFile.txt`);
  // 创建文件可写流
  const ws = fs.createWriteStream(`${filesDir}/destFile.txt`);
  // 流动模式拷贝文件
  rs.on('data', (emitData) => {
    const data = emitData?.data;
    if (!data) {
      return;
    }
    ws.write(data as Uint8Array);
  });
}

// 使用文件哈希流
export function hashFileWithStream() {
  const filePath = `${filesDir}/test.txt`;
  // 创建文件可读流
  const rs = fs.createReadStream(filePath);
  // 创建哈希流
  const hs = hash.createHash('sha256');
  rs.on('data', (emitData) => {
    const data = emitData?.data;
    // 0 表示获取字符串中第一个字符的 字符编码 （即 Unicode 编码点）的值
    hs.update(new Uint8Array(data?.split('').map((x: string) => x.charCodeAt(0))).buffer);
  });
  rs.on('close', async () => {
    const hashResult = hs.digest();
    const fileHash = await hash.hash(filePath, 'sha256');
    Logger.info(`hashResult: ${hashResult}, fileHash: ${fileHash}`);
  });
}