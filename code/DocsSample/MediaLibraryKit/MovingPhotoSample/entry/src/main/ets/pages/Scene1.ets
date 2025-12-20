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

// [Start Save_Button]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
// [StartExclude SaveButton]
import { fileIo } from '@kit.CoreFileKit';
// [EndExclude SaveButton]

@Entry({ routeName : 'Scene1' })
@Component
export struct Scene1 {
  @State statusMessage: string = '';
  @State imageSource: string = '';

  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }// Set properties of SaveButton.

  // [StartExclude Save_Button]
  async prepareTestFiles() {
    try {
      let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let resourceManager = context.resourceManager

      let imageData = await resourceManager.getRawFileContent('create_moving_photo.jpg');
      let videoData = await resourceManager.getRawFileContent('create_moving_photo.mp4');

      let imageFile = fileIo.openSync(context.filesDir + '/create_moving_photo.jpg',
        fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
      fileIo.writeSync(imageFile.fd, imageData.buffer);
      fileIo.closeSync(imageFile);

      let videoFile = fileIo.openSync(context.filesDir + '/create_moving_photo.mp4',
        fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
      fileIo.writeSync(videoFile.fd, videoData.buffer);
      fileIo.closeSync(videoFile);

      this.imageSource = 'file://' + context.filesDir + '/create_moving_photo.jpg';
      this.statusMessage = 'Test files prepared:\nImage: ' + context.filesDir + '/create_moving_photo.jpg\nVideo: ' + context.filesDir + '/create_moving_photo.mp4';
      console.info('Test files prepared successfully');
    } catch (err) {
      this.statusMessage = `Prepare failed: ${err.code}, ${err.message}`;
      console.error(`Prepare test files failed: ${err.code}, ${err.message}`);
    }
  }
  // [EndExclude Save_Button]

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        // [StartExclude Save_Button]
        Text('Save Moving Photo')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        Text('SaveButton with image + video (max 10s)')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .width('90%')

        if (this.imageSource !== '') {
          Image(this.imageSource)
            .width(200)
            .height(200)
            .objectFit(ImageFit.Contain)
            .border({ width: 2, color: '#2196F3' })
            .borderRadius(8)
            .margin({ top: 10, bottom: 10 })
        }

        Button('Prepare Test Files')
          .width('80%')
          .height(50)
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            this.prepareTestFiles();
          })
        // [EndExclude Save_Button]

        SaveButton(this.saveButtonOptions) // Create a button with SaveButton.
          .onClick(async (event, result: SaveButtonOnClickResult) => {
            if (result == SaveButtonOnClickResult.SUCCESS) {
              try {
                let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
                // Ensure that the assets specified by imageFileUri and videoFileUri exist.
                let imageFileUri = 'file://' + context.filesDir + '/create_moving_photo.jpg';
                let videoFileUri = 'file://' + context.filesDir + '/create_moving_photo.mp4';

                let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
                  photoAccessHelper.MediaAssetChangeRequest.createAssetRequest(context,
                    photoAccessHelper.PhotoType.IMAGE, 'jpg', {
                      title: 'moving_photo',
                      subtype: photoAccessHelper.PhotoSubtype.MOVING_PHOTO
                    });

                assetChangeRequest.addResource(photoAccessHelper.ResourceType.IMAGE_RESOURCE, imageFileUri);
                assetChangeRequest.addResource(photoAccessHelper.ResourceType.VIDEO_RESOURCE, videoFileUri);

                await phAccessHelper.applyChanges(assetChangeRequest);

                this.statusMessage = 'create moving photo successfully, uri: ' + assetChangeRequest.getAsset().uri;
                console.info('create moving photo successfully, uri: ' + assetChangeRequest.getAsset().uri);
              } catch (err) {
                this.statusMessage = `create moving photo failed with error: ${err.code}, ${err.message}`;
                console.error(`create moving photo failed with error: ${err.code}, ${err.message}`);
              }
            } else {
              this.statusMessage = 'SaveButtonOnClickResult create moving photo failed';
              console.error('SaveButtonOnClickResult create moving photo failed');
            }
          })

        // [StartExclude Save_Button]
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
        // [EndExclude Save_Button]

      }
      .width('100%')
      .height('100%')
    }
    .title('Save Moving Photo')
  }
}
// [End Save_Button]

