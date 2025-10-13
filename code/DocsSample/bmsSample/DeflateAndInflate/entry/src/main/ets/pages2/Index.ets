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

// [Start deflate_and_inflate_003]
import { fileIo as fs} from '@kit.CoreFileKit';
import { BusinessError, zlib } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State dataSize: number = 0;  //用于保存原始数据的大小

  build() {
    Row() {
      // 示例一：读取data.txt文件内容并存入一个缓冲区，调用compress接口压缩缓冲区中的数据到目标缓冲区，并将目标缓冲区的内容写入文件data.bin
      Button('compress buffer').onClick(() => {
        let path = this.getUIContext()?.getHostContext()?.filesDir;
        let inFile = fs.openSync(path + '/data.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        let outFile = fs.openSync(path + '/data.bin', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        // 读取data.txt文件的内容，并存入缓冲区inBuf
        let stat = fs.statSync(inFile.path);
        let inBuf = new ArrayBuffer(stat.size);
        let readLen = fs.readSync(inFile.fd, inBuf);
        console.info(`original size: ${stat.size}, read len: ${readLen}`);
        // 获取原始数据的大小，并保存
        this.dataSize = stat.size;
        // 创建一个压缩对象实例
        let zip = zlib.createZipSync();
        // 获取一个目标缓冲区的上限
        zip.compressBound(stat.size).then((data) => {
          console.info(`the max dest buf len is ${data}`);
          // 目标缓冲区outBuf
          let outBuf = new ArrayBuffer(data);
          // 将inBuf中的数据压缩到outBuf中
          zip.compress(outBuf, inBuf, readLen).then((zipOutInfo) => {
            console.info(`compress success, status ${zipOutInfo.status}, destLen  ${zipOutInfo.destLen}`);
            // 将outBuf中的数据写入到data.bin文件
            let writeLen = fs.writeSync(outFile.fd, outBuf, { length: zipOutInfo.destLen });
            console.info(`write destBuf to data.bin, writeLen ${writeLen}`);
            // 关闭文件
            fs.closeSync(inFile.fd);
            fs.closeSync(outFile.fd);
          }).catch((errData: BusinessError) => {
            console.error(`errData is errCode:${errData.code}  message:${errData.message}`);
          })
        }).catch((errData: BusinessError) => {
          console.error(`errData is errCode:${errData.code}  message:${errData.message}`);
        })
      })

      // 示例二：读取data.bin文件中的压缩数据并存入一个缓冲区，调用uncompress接口将缓冲区中的数据解压到目标缓冲区，并将目标缓冲区的内容写入文件data.txt
      Button('uncompress buffer').onClick(() => {
        let path = this.getUIContext()?.getHostContext()?.filesDir;
        let inFile = fs.openSync(path + '/data.bin', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        let outFile = fs.openSync(path + '/data.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        // 读取data.bin文件中的压缩数据，并存入缓冲区inBuf
        let stat = fs.statSync(inFile.path);
        let inBuf = new ArrayBuffer(stat.size);
        let readLen = fs.readSync(inFile.fd, inBuf);
        console.info(`compressed data size: ${stat.size}, read len: ${readLen}`);
        // 创建一个目标缓冲区，此处的dataSize是我们进行数据压缩前保存的数据的原始大小
        let outBuf = new ArrayBuffer(this.dataSize);
        console.info(`the dest buf size is ${this.dataSize}`);
        // 创建一个压缩对象实例
        let zip = zlib.createZipSync();
        // 将inBuf中的数据解压缩outBuf中
        zip.uncompress(outBuf, inBuf, readLen).then((zipOutInfo) => {
          console.info(`uncompress success, status ${zipOutInfo.status}, destLen  ${zipOutInfo.destLen}`);
          // 将outBuf中的数据写入到data.txt文件
          let writeLen = fs.writeSync(outFile.fd, outBuf, { length: zipOutInfo.destLen });
          console.info(`write destBuf to data.txt, writeLen ${writeLen}`);
          // 关闭文件
          fs.closeSync(inFile.fd);
          fs.closeSync(outFile.fd);
        }).catch((errData: BusinessError) => {
          console.error(`errData is errCode:${errData.code}  message:${errData.message}`);
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End deflate_and_inflate_003]