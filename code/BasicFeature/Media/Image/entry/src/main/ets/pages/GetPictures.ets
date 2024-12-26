/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from '@ohos/photomodify';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const LENGTH: number = 9;
const TAG: string = '[GetPictures]';

export default class GetPictures {
  async getImage(): Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
        photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
        photoSelectOptions.maxSelectNumber = LENGTH;
        let photoPicker = new photoAccessHelper.PhotoViewPicker();
        let photoSelectResult = await photoPicker.select(photoSelectOptions);
        logger.info(TAG, 'PhotoViewPicker.select successfully, PhotoSelectResult uris: ' + JSON.stringify(photoSelectResult));
        let imageList: Array<string> = AppStorage.get('imageList') as Array<string>;
        AppStorage.setOrCreate<Array<string>>('imageList', imageList.concat(photoSelectResult.photoUris));
        resolve();
      } catch (error) {
        let err: BusinessError = error as BusinessError;
        logger.error(TAG, `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
        reject();
      }
    })
  }
}