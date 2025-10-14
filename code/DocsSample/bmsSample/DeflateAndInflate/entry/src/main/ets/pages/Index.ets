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
// [Start deflate_and_inflate_001]
import { fileIo as fs} from '@kit.CoreFileKit';

@Entry
@Component
struct Index {
  @State dataSize: number = 0;

  build() {
    Row() {
      Column() {
        // 在应用沙箱目录下创建文件data.txt，并写入测试数据
        Button('创建测试文件data.txt').onClick(() => {
          let path = this.getUIContext()?.getHostContext()?.filesDir;
          // 创建文件data.txt
          let inFile = fs.openSync(path + '/data.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          // 写入测试数据
          for (let index = 0; index < 100; index++) {
            fs.writeSync(inFile.fd, index + ': hello world, hello world, hello world, hello world, hello world.\n');
          }
          // 获取测试数据原始大小，并保存到dataSize中
          let stat = fs.statSync(inFile.path);
          this.dataSize = stat.size;
          console.info('dataSize: ' + this.dataSize);
          // 关闭文件
          fs.closeSync(inFile);
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}
// [End deflate_and_inflate_001]