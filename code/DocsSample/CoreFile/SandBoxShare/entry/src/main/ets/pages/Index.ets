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

import { createFile, readFile, getListFile, shareFile } from '../fileFs/FileFs';

const MARGIN = 5; // 组件间的间隔

@Entry
@Component
struct Index {
  @State message: string = '';
  @State fileName: string = '';

  build() {
    Column() {
      TextArea({
        text: this.message
      })
        .width('100%')
        .height('40%')
      Text($r('app.string.ShareFileBasedOnName'))
        .width('100%')
        .height('5%')
      TextInput({
        text: 'test1'
      })
        .width('100%')
        .height('6%')
        .margin(MARGIN)
        .onChange((value) => this.fileName = value)
      Button($r('app.string.CreateFileTest'))
        .margin(MARGIN)
        .onClick(() => {
          let writeLen = createFile();
          this.message += 'The length of str is: ' + writeLen.toString() + '\n';
        })
      Button($r('app.string.getFileList'))
        .margin(MARGIN)
        .onClick(() => {
          this.message += getListFile() + '\n';
        })
      Button($r('app.string.ReadFile'))
        .onClick(() => {
          this.message += readFile(this.fileName) + '\n';
        })
      Button($r('app.string.FileShare'))
        .margin(MARGIN)
        .onClick(() => {
          shareFile(this.fileName);
        })
    }
  }
}