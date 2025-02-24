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

import { fileUri } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import testNapi from 'libentry.so';
import { createFile } from '../fileFs/FileFs';

// 获取应用文件沙箱路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;

let filePath = filesDir + '/test.txt';
let uri = fileUri.getUriFromPath(filePath);

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
        Button($r('app.string.createWriteReadfile'))
          .onClick(() => {
            this.message += createFile() + '\n';
          })
        Button($r('app.string.DetermineFileLocation'))
          .onClick(() => {
            this.message += testNapi.getFileLocation(uri) + '\n';
          })
      }

    }
  }
}
