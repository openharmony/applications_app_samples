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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct MyComponent9 {
  @State imgDatas: string[] = [];
  // 获取照片url集
  getAllImg() {
    try {
      let photoSelectOptions:photoAccessHelper.PhotoSelectOptions  = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 5;
      let photoPicker:photoAccessHelper.PhotoViewPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then((photoSelectResult:photoAccessHelper.PhotoSelectResult) => {
        this.imgDatas = photoSelectResult.photoUris;
        console.info('PhotoViewPicker.select successfully, photoSelectResult uri: ' + JSON.stringify(photoSelectResult));
      }).catch((err:Error) => {
        let message = (err as BusinessError).message;
        let code = (err as BusinessError).code;
        console.error(`PhotoViewPicker.select failed with. Code: ${code}, message: ${message}`);
      });
    } catch (err) {
      let message = (err as BusinessError).message;
      let code = (err as BusinessError).code;
      console.error(`PhotoViewPicker failed with. Code: ${code}, message: ${message}`);
    }
  }

  // aboutToAppear中调用上述函数，获取图库的所有图片url，存在imgDatas中
  async aboutToAppear() {
    this.getAllImg();
  }
  // 使用imgDatas的url加载图片。
  build() {
    Column() {
      Grid() {
        ForEach(this.imgDatas, (item:string) => {
          GridItem() {
            Image(item)
              .width(200)
          }
        }, (item:string):string => JSON.stringify(item))
      }
    }.width('100%').height('100%')
  }
}