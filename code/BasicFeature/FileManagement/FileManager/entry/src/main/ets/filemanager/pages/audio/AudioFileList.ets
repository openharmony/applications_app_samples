/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import prompt from '@ohos.prompt'
import { FileList } from '../common/FileList'

const ONE_SECOND: number = 1000

@Entry
@Component
struct AudioFileList {
  build() {
    Column() {
      FileList({
        title: $r('app.string.audio'),
        mediaType: mediaLibrary.MediaType.AUDIO,
        itemClickFunction: async (fileAsset: mediaLibrary.FileAsset) => {
          prompt.showToast({
            duration: ONE_SECOND,
            message: $r('app.string.not_supported_tip')
          })
        }
      })
    }
  }
}