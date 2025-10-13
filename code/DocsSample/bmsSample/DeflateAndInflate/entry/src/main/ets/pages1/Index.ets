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

// [Start deflate_and_inflate_002]
import { BusinessError, zlib } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  build() {
    Row() {
      // 示例一：将测试文件data.txt压缩并归档到data.zip中。
      Button('compressFile').onClick(() => {
        let path = this.getUIContext()?.getHostContext()?.filesDir;
        let inFile = path + '/data.txt';
        let outFile = path + '/data.zip';
        let options: zlib.Options = {};
        zlib.compressFile(inFile, outFile, options).then((data: void) => {
          console.info('compressFile success, data: ' + JSON.stringify(data));
        }).catch((errData: BusinessError) => {
          console.error(`compressFile errCode: ${errData.code}, message: ${errData.message}`);
        })
      })

      // 示例二：将data.zip文件解压到应用沙箱目录下。
      Button('decompressFile').onClick(() => {
        let path = this.getUIContext()?.getHostContext()?.filesDir;
        let inFile = path + '/data.zip';
        let outFile = path;
        let options: zlib.Options = {};
        zlib.decompressFile(inFile, outFile, options).then((data: void) => {
          console.info('decompressFile success, data: ' + JSON.stringify(data));
        }).catch((errData: BusinessError) => {
          console.error(`decompressFile errCode: ${errData.code}, message: ${errData.message}`);
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End deflate_and_inflate_002]