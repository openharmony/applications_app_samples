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

import Logger from '../../utils/Logger';
import FileManager from '../FileManager';
import userFileManager from '@ohos.filemanagement.userFileManager';

/**
 * 缩略图组件，组件构建时，需传入fileAsset对象，组件会处理该对象，生成缩略图组件
 * 示例：ThumbnailImage({ fileAsset: this.fileListItem })
 */
@Component
export default struct ThumbnailImage {
  @State thumbnail: PixelMap | null = null;
  private fileAsset?: userFileManager.FileAsset;

  async aboutToAppear() {
    if (this.fileAsset == undefined) {
      Logger.error('fileAsset undefined');
      return
    }
    this.thumbnail = await FileManager.getThumbnail(this.fileAsset);
  }

  build() {
    Image(this.thumbnail == undefined ? $r('app.media.default_document') : this.thumbnail)
      .objectFit(ImageFit.Fill)
  }
}
