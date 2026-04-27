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
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            createFile(context);
          })
        Button($r('app.string.DetermineFileLocation'))
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let filesDir = context.filesDir;
            let filePath = filesDir + '/test.txt'
            let uri = fileUri.getUriFromPath(filePath);
            testNapi.getFileLocation(uri);
            this.message += 'getFileLocation SUCCESS' + '\n';
          })
      }

    }
  }
}
