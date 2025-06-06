/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import prompt from '@ohos.promptAction';
import { FileList } from '../common/FileList';
import userFileManager from '@ohos.filemanagement.userFileManager';

const ONE_SECOND: number = 1000;

@Entry
@Component
struct VideoFileList {
  build() {
    Column() {
      FileList({
        title: $r('app.string.video'),
        mediaType: userFileManager.FileType.VIDEO,
        itemClickFunction: async (fileAsset: userFileManager.FileAsset) => {
          prompt.showToast({
            duration: ONE_SECOND,
            message: $r('app.string.not_supported_tip')
          })
        }
      })
    }
  }
}