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

import { fileIo as fs, hash, ListFileOptions, ReadOptions, securityLabel, WriteOptions } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

// [Start create_and_read_File]
function createFile(context: common.UIAbilityContext): void {
  let filesDir = context.filesDir;
  // 文件不存在时创建并打开文件，文件存在时打开文件
  let file = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  // 写入一段内容至文件
  let writeLen = fs.writeSync(file.fd, 'Try to write str.');
  console.info('The length of str is: ' + writeLen);
  // 创建一个大小为1024字节的ArrayBuffer对象，用于存储从文件中读取的数据
  let arrayBuffer = new ArrayBuffer(1024);
  // 设置读取的偏移量和长度
  let readOptions: ReadOptions = {
    offset: 0,
    length: arrayBuffer.byteLength
  };
  // 读取文件内容到ArrayBuffer对象中，并返回实际读取的字节数
  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
  // 将ArrayBuffer对象转换为Buffer对象，并转换为字符串输出
  let buf = buffer.from(arrayBuffer, 0, readLen);
  console.info('the content of file: ' + buf.toString());
  // 关闭文件
  fs.closeSync(file);
}
// [End create_and_read_File]

// [Start read_write_file]
function readWriteFile(context: common.UIAbilityContext): void {
  let filesDir = context.filesDir;
  // 打开文件
  let srcFile = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let destFile = fs.openSync(filesDir + '/destFile.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  // 读取源文件内容并写入至目的文件
  let bufSize = 4096;
  let readSize = 0;
  let buf = new ArrayBuffer(bufSize);
  let readOptions: ReadOptions = {
    offset: readSize,
    length: bufSize
  };
  let readLen = fs.readSync(srcFile.fd, buf, readOptions);
  while (readLen > 0) {
    readSize += readLen;
    let writeOptions: WriteOptions = {
      length: readLen
    };
    fs.writeSync(destFile.fd, buf, writeOptions);
    readOptions.offset = readSize;
    readLen = fs.readSync(srcFile.fd, buf, readOptions);
  }
  // 关闭文件
  fs.closeSync(srcFile);
  fs.closeSync(destFile);
}
// [End read_write_file]

// [Start read_write_file_with_stream]
async function readWriteFileWithStream(context: common.UIAbilityContext): Promise<void> {
  let filesDir = context.filesDir;
  // 创建并打开输入文件流
  let inputStream = fs.createStreamSync(filesDir + '/test.txt', 'r+');
  // 创建并打开输出文件流
  let outputStream = fs.createStreamSync(filesDir + '/destFile.txt', 'w+');

  let bufSize = 4096;
  let readSize = 0;
  let buf = new ArrayBuffer(bufSize);
  let readOptions: ReadOptions = {
    offset: readSize,
    length: bufSize
  };
  // 以流的形式读取源文件内容并写入到目标文件
  let readLen = await inputStream.read(buf, readOptions);
  readSize += readLen;
  while (readLen > 0) {
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
// [End read_write_file_with_stream]

// 查看文件列表
// [Start get_list_file]
function getListFile(context: common.UIAbilityContext): void {
  let listFileOption: ListFileOptions = {
    recursion: false,
    listNum: 0,
    filter: {
      suffix: ['.png', '.jpg', '.txt'],
      displayName: ['test*'],
      fileSizeOver: 0,
      lastModifiedAfter: new Date(0).getTime()
    }
  };
  let filesDir = context.filesDir;
  let files = fs.listFileSync(filesDir, listFileOption);
  for (let i = 0; i < files.length; i++) {
    console.info(`The name of file: ${files[i]}`);
  }
}
// [End get_list_file]

// [Start copy_file_with_readable]
function copyFileWithReadable(context: common.UIAbilityContext): void {
  let filesDir = context.filesDir;
  // 创建文件可读流
  const rs = fs.createReadStream(`${filesDir}/test.txt`);
  // 创建文件可写流
  const ws = fs.createWriteStream(`${filesDir}/destFile.txt`);
  // 暂停模式拷贝文件。在拷贝数据时，将原始数据暂停，然后将数据复制到另一个位置，适用于对数据完整性和一致性要求较高的场景
  rs.on('readable', () => {
    const data = rs.read();
    if (!data) {
      return;
    }
    ws.write(data);
  });
}
// [End copy_file_with_readable]

// [Start copy_file_with_data]
function copyFileWithData(context: common.UIAbilityContext): void {
  let filesDir = context.filesDir;
  // 创建文件可读流
  const rs = fs.createReadStream(`${filesDir}/test.txt`);
  // 创建文件可写流
  const ws = fs.createWriteStream(`${filesDir}/destFile.txt`);
  // 流动模式拷贝文件。数据的读取和写入是同时进行的，不需要暂停原始数据的访问，适用于对数据实时性要求较高的场景
  rs.on('data', (emitData) => {
    const data = emitData?.data;
    if (!data) {
      return;
    }
    ws.write(data as Uint8Array);
  });
}
// [End copy_file_with_data]

// [Start hash_file_with_stream]
function hashFileWithStream(context: common.UIAbilityContext) {
  let filesDir = context.filesDir;
  const filePath = `${filesDir}/test.txt`;
  // 创建文件可读流
  const rs = fs.createReadStream(filePath);
  // 创建哈希流
  const hs = hash.createHash('sha256');
  rs.on('data', (emitData) => {
    const data = emitData?.data;
    hs.update(new Uint8Array(data?.split('').map((x: string) => x.charCodeAt(0))).buffer);
  });
  rs.on('close', async () => {
    const hashResult = hs.digest();
    const fileHash = await hash.hash(filePath, 'sha256');
    console.info(`hashResult: ${hashResult}, fileHash: ${fileHash}`);
  });
}
// [End hash_file_with_stream]

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Column() {
      TextArea({
        text: this.message,
        placeholder: '',
      })
        .width('100%')
        .height('50%')

      Row() {
        Button($r('app.string.createFile'))
          .onClick(() => {
            // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            createFile(context);
            this.message += 'createFile SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.readWriteFile'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            readWriteFile(context);
            this.message += 'readWriteFile SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.readWriteFileWithStream'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            readWriteFileWithStream(context);
            this.message += 'readWriteFileWithStream SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.getListFile'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            getListFile(context);
            this.message += 'getListFile SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.copyFileWithReadable'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            copyFileWithReadable(context);
            this.message += 'copyFileWithReadable SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.copyFileWithData'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            copyFileWithData(context);
            this.message += 'copyFileWithData SUCCESS' + '\n';
          })
      }
      Row() {
        Button($r('app.string.hashFileWithStream'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            hashFileWithStream(context);
            this.message += 'hashFileWithStream SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.setSecurityLabel'))
          .onClick(async () => {
            // [Start set_security_label]
            // 获取需要设备数据等级的文件沙箱路径，请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let pathDir = context.filesDir;
            let filePath = pathDir + '/test.txt';

            //打开文件
            let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            // 设置文件的数据等级为s0
            securityLabel.setSecurityLabel(filePath, 's0').then(() => {
              console.info('Succeeded in setSecurityLabeling.');
              fs.closeSync(file);
            }).catch((err: BusinessError) => {
              console.error(`Failed to setSecurityLabel. Code: ${err.code}, message: ${err.message}`);
            });
            // [End set_security_label]
            this.message += 'GetUserDocumentDirPathExample SUCCESS' + '\n';
          })
      }

    }
  }
}