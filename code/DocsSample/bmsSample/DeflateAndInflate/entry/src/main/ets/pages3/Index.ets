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

// [Start deflate_and_inflate_004]
import { fileIo as fs} from '@kit.CoreFileKit';
import { zlib } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  build() {
    Row() {
      // 示例一：从文件中不断读取数据进行压缩
      Button('deflateFile').onClick(() => {
        let path = this.getUIContext()?.getHostContext()?.filesDir;
        let inFile = fs.openSync(path + '/data.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        let outFile = fs.openSync(path + '/data.bin', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        deflateFile(inFile, outFile).then(() => {
          console.info('deflateFile success');
          fs.closeSync(inFile.fd);
          fs.closeSync(outFile.fd);
        })
      })

      // 示例二：从文件中不断读取压缩数据进行解压
      Button('inflateFile').onClick(() => {
        let path = this.getUIContext()?.getHostContext()?.filesDir;
        let inFile = fs.openSync(path + '/data.bin', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        let outFile = fs.openSync(path + '/data.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        inflateFile(inFile, outFile).then(() => {
          console.info('inflateFile success');
          fs.closeSync(inFile.fd);
          fs.closeSync(outFile.fd);
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}

// 从一个文件中，不断的读入数据，进行压缩，并写入到另一个文件中
async function deflateFile(src: fs.File, dest: fs.File) {
  let flush = zlib.CompressFlushMode.NO_FLUSH;
  let strm: zlib.ZStream = {};  //初始化一个压缩流
  const BUFLEN = 4096;
  let inBuf = new ArrayBuffer(BUFLEN);  // 初始化一个输入缓冲区
  let outBuf = new ArrayBuffer(BUFLEN); // 初始化一个输出缓冲区
  // 创建一个压缩对象实例
  let zip = zlib.createZipSync();
  // 初始化流的状态
  let initStatus = zip.deflateInit(strm, zlib.CompressLevel.COMPRESS_LEVEL_BEST_SPEED);
  console.info('deflateInit ret: ' + (await initStatus).valueOf());
  do {
    // 从文件中读取数据到缓冲区
    let readLen = fs.readSync(src.fd, inBuf);
    console.info('readSync readLen: ' + readLen);
    flush = readLen == 0 ? zlib.CompressFlushMode.FINISH : zlib.CompressFlushMode.NO_FLUSH;
    // 设置输入缓冲区
    strm.availableIn = readLen;
    strm.nextIn = inBuf;
    do {
      // 设置输出缓冲区
      strm.availableOut = BUFLEN;
      strm.nextOut = outBuf;
      try {
        // 压缩输入缓冲区中数据到输出缓冲区
        let deflateStatus = zip.deflate(strm, flush);
        console.info('deflate ret: ' + (await deflateStatus).valueOf());
        // 更新流的状态
        let innerStrm = zip.getZStream();
        strm.availableIn = (await innerStrm).availableIn;
        strm.nextIn = (await innerStrm).nextIn;
        strm.availableOut = (await innerStrm).availableOut;
        strm.nextOut = (await innerStrm).nextOut;
        strm.totalIn = (await innerStrm).totalIn;
        strm.totalOut = (await innerStrm).totalOut;

        if (strm.availableOut != undefined) {
          // 将已完成压缩的数据，写入到输出文件中
          let have = BUFLEN - strm.availableOut;
          let writeLen = fs.writeSync(dest.fd, outBuf, { length: have });
          console.info(`writeSync writeLen: ${writeLen}`);
        }
      } catch (err) {
        console.error('deflate err: ' + JSON.stringify(err));
      }
    } while (strm.availableOut == 0); // 循环压缩输入缓冲区中剩余的数据，直到全部完成压缩
  } while (flush != zlib.CompressFlushMode.FINISH); // 循环从文件中读取数据，直到数据全部读取
  // 释放资源
  zip.deflateEnd(strm);
}

// 从一个文件中，不断的读入已压缩的数据，进行解压，并写入到另一个文件中
async function inflateFile(src: fs.File, dest: fs.File) {
  let status: zlib.ReturnStatus = zlib.ReturnStatus.OK;
  let strm: zlib.ZStream = {};  //初始化一个压缩流
  const BUFLEN = 4096;
  let inBuf = new ArrayBuffer(BUFLEN);  // 初始化一个输入缓冲区
  let outBuf = new ArrayBuffer(BUFLEN); // 初始化一个输出缓冲区
  // 创建一个压缩对象实例
  let zip = zlib.createZipSync();
  // 初始化流的状态
  let initStatus = zip.inflateInit(strm);
  console.info('inflateInit ret: ' + (await initStatus).valueOf());
  do {
    // 从文件中读取已压缩的数据到缓冲区
    let readLen = fs.readSync(src.fd, inBuf);
    console.info('readSync readLen: ' + readLen);
    if (readLen == 0) {
      break;
    }
    // 设置输入缓冲区
    strm.availableIn = readLen;
    strm.nextIn = inBuf;
    do {
      // 设置输出缓冲区
      strm.availableOut = BUFLEN;
      strm.nextOut = outBuf;
      try {
        // 解压输入缓冲区中数据到输出缓冲区
        let inflateStatus = zip.inflate(strm, zlib.CompressFlushMode.NO_FLUSH);
        console.info('inflate ret: ' + (await inflateStatus).valueOf());
        status = await inflateStatus;
        // 更新流的状态
        let innerStrm = zip.getZStream();
        strm.availableIn = (await innerStrm).availableIn;
        strm.nextIn = (await innerStrm).nextIn;
        strm.availableOut = (await innerStrm).availableOut;
        strm.nextOut = (await innerStrm).nextOut;
        strm.totalIn = (await innerStrm).totalIn;
        strm.totalOut = (await innerStrm).totalOut;

        if (strm.availableOut != undefined) {
          // 将已完成解压的数据，写入到输出文件中
          let have = BUFLEN - strm.availableOut;
          let writeLen = fs.writeSync(dest.fd, outBuf, { length: have });
          console.info(`writeSync writeLen: ${writeLen}`);
        }
      } catch (err) {
        console.error('inflate err: ' + JSON.stringify(err));
      }
    } while (strm.availableOut == 0)  // 循环解压输入缓冲区中剩余的数据，直到全部完成解压
  } while (status != zlib.ReturnStatus.STREAM_END.valueOf())  // 循环从文件中读取数据，直到数据全部读取
  // 释放资源
  zip.inflateEnd(strm);
}
// [End deflate_and_inflate_004]