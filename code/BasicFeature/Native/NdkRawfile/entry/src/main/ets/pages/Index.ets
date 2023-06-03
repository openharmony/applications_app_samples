/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {

  build() {
    Row() {
      Column() {
        Text('getFileList = ' + globalThis.rawfilelist).id('get_file_list').fontSize(30)
        Text('getRawFileContent = ' + globalThis.rawfileContet).id('get_raw_file_content').fontSize(30)
        Text('rawfileDescriptor.fd = ' + globalThis.rawfileDescriptor.fd).fontSize(30)
        Text('rawfileDescriptor.offset = ' + globalThis.rawfileDescriptor.offset).fontSize(30)
        Text('rawfileDescriptor.length = ' + globalThis.rawfileDescriptor.length).id('length').fontSize(30)
      }
      .width('100%')
    }
    .height('100%')
  }
}
