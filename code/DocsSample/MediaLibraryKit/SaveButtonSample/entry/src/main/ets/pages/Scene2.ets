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

// [Start Creating_Media_Asset]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
// [StartExclude Creating_Media_Asset]
import { fileIo } from '@kit.CoreFileKit';
// [EndExclude Creating_Media_Asset]
@Entry({ routeName : 'Scene2' })
@Component
export struct Scene2 {
  @State statusMessage: string = '';
  @State imageSource: string = '';

  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }// Set properties of SaveButton.

 // [StartExclude Creating_Media_Asset]
  async prepareTestImage() {
    try {
      let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let resourceManager = context.resourceManager;

      let imageData = await resourceManager.getRawFileContent('test.jpg');

      let file = fileIo.openSync(context.filesDir + '/test.jpg',
        fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
      fileIo.writeSync(file.fd, imageData.buffer);
      fileIo.closeSync(file);

      this.imageSource = 'file://' + context.filesDir + '/test.jpg';
      this.statusMessage = 'Test image prepared at:\n' + context.filesDir + '/test.jpg';
      console.info('Test image prepared successfully');
    } catch (err) {
      this.statusMessage = `Prepare failed: ${err.code}, ${err.message}`;
      console.error(`Prepare test image failed: ${err.code}, ${err.message}`);
    }
  }
  // [EndExclude Creating_Media_Asset]

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        // [StartExclude Creating_Media_Asset]
        Text('Save Image with SaveButton')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        if (this.imageSource !== '') {
          Image(this.imageSource)
            .width(200)
            .height(200)
            .objectFit(ImageFit.Contain)
            .border({ width: 2, color: '#4CAF50' })
            .borderRadius(8)
            .margin({ top: 10, bottom: 10 })
        }

        Button('Prepare Test Image')
          .width('80%')
          .height(50)
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            this.prepareTestImage();
          })
        // [EndExclude Creating_Media_Asset]

        SaveButton(this.saveButtonOptions) // Create a button with SaveButton.
          .onClick(async (event, result: SaveButtonOnClickResult) => {
            if (result == SaveButtonOnClickResult.SUCCESS) {
              try {
                let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
                
                // 需要确保fileUri对应的资源存在。
                let fileUri = 'file://' + context.filesDir + '/test.jpg';
                let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
                  photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, fileUri);

                await phAccessHelper.applyChanges(assetChangeRequest);

                let resultUri = assetChangeRequest.getAsset().uri;
                this.statusMessage = 'createAsset successfully, uri: ' + resultUri;
                console.info('createAsset successfully, uri: ' + resultUri);
              } catch (err) {
                this.statusMessage = `create asset failed with error: ${err.code}, ${err.message}`;
                console.error(`create asset failed with error: ${err.code}, ${err.message}`);
              }
            } else {
              this.statusMessage = 'SaveButtonOnClickResult create asset failed';
              console.error('SaveButtonOnClickResult create asset failed');
            }
          })

        // [StartExclude Creating_Media_Asset]
        if (this.statusMessage !== '') {

          Scroll() {
            Text(this.statusMessage)
              .fontSize(12)
              .width('90%')
              .padding(15)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
          }
          .width('100%')
          .layoutWeight(1)
          .margin({ top: 10 })
        }
        // [EndExclude Creating_Media_Asset]
      }
      .width('100%')
      .height('100%')
    }
    .title('SaveButton Example')
  }
}
// [End Creating_Media_Asset]