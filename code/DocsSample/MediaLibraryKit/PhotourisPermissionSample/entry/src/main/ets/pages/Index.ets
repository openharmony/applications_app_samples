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

// [Start Request_PhotoUris_Permission_Button]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
// [StartExclude Request_PhotoUris_Permission_Button]
import { BusinessError } from '@kit.BasicServicesKit';
// [EndExclude Request_PhotoUris_Permission_Button]


@Entry
@Component
struct Index {
  private uris: Array<string> = new Array<string>();
  // [StartExclude Request_PhotoUris_Permission_Button]
  @State statusMessage: string = '';
  @State selectedUris: string = '';

  async selectPhotos() {
    try {
      let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;

      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.maxSelectNumber = 5;
      let photoViewPicker = new photoAccessHelper.PhotoViewPicker();
      let photoSelectResult = await photoViewPicker.select(photoSelectOptions);

      this.uris = photoSelectResult.photoUris;

      if (this.uris.length > 0) {
        this.statusMessage = 'Selected ' + this.uris.length + ' photo(s)';
        this.selectedUris = 'URIs:\n' + this.uris.join('\n');
      } else {
        this.statusMessage = 'No photos selected';
      }
    } catch (error) {
      let err = error as BusinessError;
      this.statusMessage = 'Selection failed: ' + err.message;
    }
  }
  // [EndExclude Request_PhotoUris_Permission_Button]
  build() {
    // [StartExclude Request_PhotoUris_Permission_Button]
    Scroll() {
      Column({ space: 20 }) {
        Text('Inheriting Media File Access Permissions')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Text('After Device Upgrade to HarmonyOS 5.0')
          .fontSize(16)
          .fontColor('#666666')

        Divider().margin({ top: 15, bottom: 15 })

        Button('Select Photos')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(() => {
            this.selectPhotos();
          })
        // [EndExclude Request_PhotoUris_Permission_Button]

        Button('Request Permission')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(() => {
            let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

            try {
              phAccessHelper.requestPhotoUrisReadPermission(this.uris).then((result: Array<string>) => {
                console.info("requestPhotoUrisReadPermission, result = " + JSON.stringify(result));

                if (result && result.length > 0) {
                  this.statusMessage = 'Authorization successful! ' + result.length + ' photo(s) authorized.';
                  this.selectedUris = 'Authorized URIs:\n' + result.join('\n');
                } else {
                  this.statusMessage = 'Authorization cancelled';
                  this.selectedUris = '';
                }
              }).catch((error: BusinessError) => {
                this.statusMessage = 'Authorization failed: ' + error.message;
                console.error("requestPhotoUrisReadPermission error: " + JSON.stringify(error));
              })
            } catch(error) {
              let err = error as BusinessError;
              this.statusMessage = 'Error: ' + err.message;
              console.error("requestPhotoUrisReadPermission error: " + JSON.stringify(err));
            }
          })

        // [StartExclude Request_PhotoUris_Permission_Button]
        if (this.statusMessage !== '') {
          Text(this.statusMessage)
            .fontSize(14)
            .width('90%')
            .padding(15)
            .backgroundColor('#E3F2FD')
            .borderRadius(8)
            .margin({ top: 10 })
        }

        if (this.selectedUris !== '') {
          Scroll() {
            Text(this.selectedUris)
              .fontSize(11)
              .width('90%')
              .padding(15)
              .backgroundColor('#FFF9C4')
              .borderRadius(8)
          }
          .width('90%')
          .height(150)
          .margin({ top: 10 })
        }
        // [EndExclude Request_PhotoUris_Permission_Button]
      }
      .width('100%')
      .padding({ bottom: 30 })
    }
    .width('100%')
    .height('100%')
    // [StartExclude Request_PhotoUris_Permission_Button]
    .scrollBar(BarState.Auto)
    // [EndExclude Request_PhotoUris_Permission_Button]
  }
}
// [End Request_PhotoUris_Permission_Button]