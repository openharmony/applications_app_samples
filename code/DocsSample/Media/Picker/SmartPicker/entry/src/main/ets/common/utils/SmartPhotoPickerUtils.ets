/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'SmartPhotoPickerUtils';

export class SmartPhotoPickerUtils {
  async photoPicker() {
    let option: photoAccessHelper.PhotoSelectOptions = {
      isPhotoTakingSupported: true,
      maxSelectNumber: 1,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    try {
      photoPicker.select(option).then(() => {
        hilog.info(0x0000, TAG, 'Create photoPicker success');
      }).catch((error: BusinessError) => {
        hilog.error(0x0000, TAG, 'Create photoPicker failed, error.code = ' + error.code);
      });
    } catch (err) {
      hilog.error(0x0000, TAG, 'Create photoPicker failed, err.code = ' + err.code);
    }
  }

  async smartPhotoPickerByRecommendType(recommendType: number) {
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    let recommendationOptions: photoAccessHelper.RecommendationOptions = {
      recommendationType: recommendType
    };
    let option: photoAccessHelper.PhotoSelectOptions = {
      recommendationOptions: recommendationOptions,
      isPhotoTakingSupported: true,
      maxSelectNumber: 1,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
    try {
      photoPicker.select(option).then(() => {
        hilog.info(0x0000, TAG, 'Create photoPicker success');
      }).catch((error: BusinessError) => {
        hilog.error(0x0000, TAG, 'Create photoPicker failed, error.code = ' + error.code);
      });
    } catch (err) {
      hilog.error(0x0000, TAG, 'Create photoPicker failed, err.code = ' + err.code);
    }
  }

  async smartPhotoPickerByTextInfo(content: string) {
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    let textInfo: photoAccessHelper.TextContextInfo = {
      text: content
    };
    let recommendationOptions: photoAccessHelper.RecommendationOptions = {
      textContextInfo: textInfo
    };
    let option: photoAccessHelper.PhotoSelectOptions = {
      recommendationOptions: recommendationOptions,
      isPhotoTakingSupported: true,
      maxSelectNumber: 1,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
    try {
      photoPicker.select(option).then(() => {
        hilog.info(0x0000, TAG, 'Create photoPicker success');
      }).catch((error: BusinessError) => {
        hilog.error(0x0000, TAG, 'Create photoPicker failed, error.code = ' + error.code);
      });
    } catch (err) {
      hilog.error(0x0000, TAG, 'Create photoPicker failed, err.code = ' + err.code);
    }
  }
}

export default new SmartPhotoPickerUtils();