/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State cacheDir: string | undefined = this.getUIContext().getHostContext()?.cacheDir;
  @State message: string = '';

  build() {
    Row() {
      Column() {
        Button('Zip File Compress')
          .onClick(() => {
            let inFile = this.cacheDir + '/zip_compress_in';
            let zipFile = this.cacheDir + '/zip_compress.zip';
            let ret = testNapi.ZipFileCompress(inFile, zipFile);
            this.message += 'Zip File Compress Result' + ret + ' \n';
          })
        Button('Zip File Decompress')
          .onClick(() => {
            let inFile = this.cacheDir + '/zip_decompress_in';
            let zipFile = this.cacheDir + '/zip_decompress.zip';
            let outDir = this.cacheDir + '/zip_decompress_out_dir';
            let ret = testNapi.ZipFileDecompress(inFile, zipFile, outDir);
            this.message += 'Zip File Decompress Result' + ret + ' \n';
          })
        Button('Buffer Compress')
          .onClick(() => {
            let inFile = this.cacheDir + '/buffer_compress_in';
            let outFile = this.cacheDir + '/buffer_compress_out';
            let ret = testNapi.BufferCompress(inFile, outFile);
            this.message += 'Buffer Compress' + ret + ' \n';
          })
        Button('Buffer Decompress')
          .onClick(() => {
            let ret = testNapi.BufferDecompress();
            this.message += 'Buffer Decompress' + ret + ' \n';
          })
        Button('Stream Compress')
          .onClick(() => {
            let inFile = this.cacheDir + '/stream_compress_in';
            let outFile = this.cacheDir + '/stream_compress_out';
            let ret = testNapi.StreamCompress(inFile, outFile);
            this.message += 'Stream Compress' + ret + ' \n';
          })
        Button('Stream Compress Cancel')
          .onClick(() => {
            let inFile = this.cacheDir + '/stream_compress_cancel_in';
            let outFile = this.cacheDir + '/stream_compress_cancel_out';
            let ret = testNapi.StreamCompress(inFile, outFile);
            this.message += 'Stream Compress Cancel Result' + ret + ' \n';
          })
        Button('Stream Decompress')
          .onClick(() => {
            let ret = testNapi.StreamDecompress();
            this.message += 'Stream Decompress Result' + ret + ' \n';
          })
        Button('Stream Decompress Cancel')
          .onClick(() => {
            let ret = testNapi.StreamDecompressCancel();
            this.message += 'Stream Decompress Cancel Result' + ret + ' \n';
          })
        TextArea({
          text: this.message,
          placeholder: '',
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
