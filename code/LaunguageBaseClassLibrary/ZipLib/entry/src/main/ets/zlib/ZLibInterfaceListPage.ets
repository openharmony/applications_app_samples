/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { fileIo } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction, router } from '@kit.ArkUI';
import { zlib } from '@kit.BasicServicesKit';

const DOMAIN = 0xF811;
const BUNDLE = 'ZipLib_';
const TAG: string = '[ZLibInterfaceListPage]';
const SLEEP_TIME = 3000;
const BUFFER_SIZE = 13;
const OFFSET = 0;
const STRING_DATA = 'hello, hello!';

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
};

@Entry
@Component
struct ZLibInterfaceListPage {
  async zlibDecompression(): Promise<void> {
    hilog.info(DOMAIN, TAG, BUNDLE + `zlibDecompression begin`);
    let context = AppStorage.get('context') as Context;
    let pathDir = context.cacheDir;
    let zlibFile = fileIo.openSync(pathDir + '/zlibFile.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    fileIo.writeSync(zlibFile.fd, STRING_DATA);
    let arrayBufferIn = new ArrayBuffer(BUFFER_SIZE);
    fileIo.readSync(zlibFile.fd, arrayBufferIn, { offset: OFFSET });
    fileIo.closeSync(zlibFile);

    let arrayBufferOut = new ArrayBuffer(BUFFER_SIZE);
    // 创建zip对象
    let zip = zlib.createZipSync();
    // 压缩初始化
    await zip.deflateInit({}, zlib.CompressLevel.COMPRESS_LEVEL_BEST_SPEED);
    // 校验数据
    let checksum = zlib.createChecksumSync();
    checksum.crc32(0, arrayBufferIn);
    try {
      // 压缩数据
      await zip.deflate({ nextIn: arrayBufferIn, availableIn: BUFFER_SIZE, nextOut: arrayBufferOut,
        availableOut: BUFFER_SIZE }, zlib.CompressFlushMode.FINISH).then((data) => {
        // 将压缩后的buffer写入zlibDeflateFile.txt文件中
        let zlibDeflateFile = fileIo.openSync(pathDir + '/zlibDeflateFile.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        fileIo.writeSync(zlibDeflateFile.fd, arrayBufferOut);
        fileIo.closeSync(zlibDeflateFile);
        promptAction.showToast({
          message: $r('app.string.zlib_compress_success', STRING_DATA),
          bottom: '11%'
        });
      })
    } catch (errData) {
      promptAction.showToast({
        message: $r('app.string.zlib_compress_failure'),
        bottom: '11%'
      });
    }
    // 释放动态分配的数据结构
    await zip.deflateEnd({ nextOut: arrayBufferOut });
    await sleep(SLEEP_TIME);
    // 解压初始化
    await zip.inflateInit({});
    let inflateArrayBufferOut = new ArrayBuffer(BUFFER_SIZE);
    // 校验数据
    checksum.crc32(0, arrayBufferOut);
    try {
      // 解压数据
      await zip.inflate({ nextIn: arrayBufferOut, availableIn: BUFFER_SIZE, nextOut: inflateArrayBufferOut,
        availableOut: BUFFER_SIZE }, zlib.CompressFlushMode.NO_FLUSH).then((data) => {
        let array = new Uint8Array(inflateArrayBufferOut);
        let dataString = '';
        for (let i = 0; i < array.length; i++) {
          dataString += String.fromCharCode(array[i]);
        }
        // 将解压后的数据写入zlibInflateFile.txt文件中
        let zlibInflateFile = fileIo.openSync(pathDir + '/zlibInflateFile.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        fileIo.writeSync(zlibInflateFile.fd, dataString);
        fileIo.closeSync(zlibInflateFile);
        // 验证压缩与解压的数据是否一致
        if (STRING_DATA == dataString) {
          promptAction.showToast({
            message: $r('app.string.zlib_uncompress_success', dataString),
            bottom: '11%'
          });
        }
      })
    } catch (errData) {
      promptAction.showToast({
        message: $r('app.string.zlib_uncompress_failure'),
        bottom: '11%'
      });
    }
    // 释放动态分配的数据结构
    await zip.inflateEnd({ nextOut: arrayBufferOut });
    hilog.info(DOMAIN, TAG, BUNDLE + `zlibDecompression end`);
  }

  async gzipDecompression(): Promise<void> {
    hilog.info(DOMAIN, TAG, BUNDLE + `gzipDecompression begin`);
    let context = AppStorage.get('context') as Context;
    let pathDir = context.cacheDir;
    let file = fileIo.openSync(pathDir + '/gzipTest.gz', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    let path = pathDir + '/gzipTest.gz';
    fileIo.closeSync(file);

    // 创建gzip对象
    let gzip = zlib.createGZipSync();
    // 打开.gz文件，对文件进行写操作
    gzip.gzopen(path, 'wb');
    let str = STRING_DATA;
    let arrayBufferIn = new ArrayBuffer(BUFFER_SIZE);
    let byteArray = new Uint8Array(arrayBufferIn);
    for (let i = 0, j = str.length; i < j; i++) {
      byteArray[i] = str.charCodeAt(i);
    }
    try {
      // 将bufferWithData压缩并写入文件
      gzip.gzfwrite(arrayBufferIn, 8, 2).then((data) => {
        promptAction.showToast({
          message: $r('app.string.gzip_compress_success', str),
          bottom: '11%'
        });
      })
    } catch (errData) {
      promptAction.showToast({
        message: $r('app.string.gzip_compress_failure'),
        bottom: '11%'
      });
    }
    gzip.gzflush(0);
    gzip.gzclose();

    await sleep(SLEEP_TIME);
    // 打开.gz文件，对文件进行读操作
    gzip.gzopen(path, 'rb');
    try {
      let bufferWithDataOut = new ArrayBuffer(BUFFER_SIZE);
      // 从.gz文件中读取和解压数据
      gzip.gzfread(bufferWithDataOut, 8, 2).then((data) => {
        let array = new Uint8Array(bufferWithDataOut);
        let dataString = '';
        for (let i = 0; i < array.length; i++) {
          dataString += String.fromCharCode(array[i]);
        }
        if (dataString == str) {
          promptAction.showToast({
            message: $r('app.string.gzip_uncompress_success', dataString),
            bottom: '11%'
          });
          let gzipFile = fileIo.openSync(pathDir + '/gzipTest.txt', fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
          fileIo.writeSync(gzipFile.fd, dataString);
          fileIo.closeSync(gzipFile);
        }
      })
    } catch (errData) {
      promptAction.showToast({
        message: $r('app.string.gzip_uncompress_failure'),
        bottom: '11%'
      });
    }
    gzip.gzclose();
    hilog.info(DOMAIN, TAG, BUNDLE + `gzipDecompression end`);
  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.icon_back'))
            .size({ height: '71%' })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Index'
              });
            })
          Text($r('app.string.zlibInterface'))
            .fontSize(20)
            .margin({ left: 8 })
            .width('100%')
            .height('100%')
            .fontWeight(FontWeight.Bold)
        }
        .height('15.64%')
        .width('91%')

        Row() {
          Text($r('app.string.CompressFiles'))
            .textAlign(TextAlign.Start)
            .fontSize(16)
            .fontColor($r('app.color.text_color'))
          Image($r('app.media.icon_next'))
            .size({ height: '42.8%' })
            .objectFit(ImageFit.Contain)
        }
        .id('compressFiles')
        .onClick(() => {
          router.pushUrl({
            url: 'zlib/CompressFilesPage'
          });
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ right: 12, left: 12 })
        .height('15.64%')
        .width('91%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(15)
        .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('50%')

      Column() {
        Text($r('app.string.tip_Gzip'))
          .textAlign(TextAlign.Start)
          .fontSize(12)
          .fontColor($r('app.color.tip_Gzip_backeGround'))
          .width('86.4%')
          .height('9%')
          .margin({ bottom: 24 })

        Button($r('app.string.gzip_interface'))
          .id('gzipinterface')
          .width('100%')
          .height('100%')
          .fontSize(16)
          .fontFamily('HarmonyHeiTi')
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.button_backeGround'))
          .fontColor($r('app.color.button_color'))
          .borderRadius(20)
          .onClick(() => {
            this.gzipDecompression();
          })
          .margin({ bottom: 12 })
          .width('91%')
          .height('11.2%')

        Button($r('app.string.zlib_interface'))
          .id('zlibinterface')
          .width('100%')
          .height('100%')
          .fontSize(16)
          .fontFamily('HarmonyHeiTi')
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.button_backeGround'))
          .fontColor($r('app.color.button_color'))
          .borderRadius(20)
          .onClick(() => {
            this.zlibDecompression();
          })
          .margin({ bottom: 16 })
          .width('91%')
          .height('11.2%')
      }
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('50%')
    }
    .backgroundColor($r('app.color.backGrounding'))
    .width('100%')
    .height('100%')
  }
}