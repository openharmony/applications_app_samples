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


// [Start Reading_Moving_Photo_Assets]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
// [StartExclude Reading_Moving_Photo_Assets]
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
// [EndExclude Reading_Moving_Photo_Assets]
@Entry({ routeName : 'Scene4' })
@Component
export struct Scene4 {
  // [StartExclude Reading_Moving_Photo_Assets]
  @State statusMessage: string = '';
  @State movingPhotoObj: photoAccessHelper.MovingPhoto | null = null;
  @State imageSource: string = '';
  async prepareAndLoadMovingPhoto() {
    try {
      let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let resourceManager = context.resourceManager;

      let imageData = await resourceManager.getRawFileContent('local_moving_photo.jpg');
      let videoData = await resourceManager.getRawFileContent('local_moving_photo.mp4');

      let imageFile = fileIo.openSync(context.filesDir + '/local_moving_photo.jpg',
        fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
      fileIo.writeSync(imageFile.fd, imageData.buffer);
      fileIo.closeSync(imageFile);

      let videoFile = fileIo.openSync(context.filesDir + '/local_moving_photo.mp4',
        fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
      fileIo.writeSync(videoFile.fd, videoData.buffer);
      fileIo.closeSync(videoFile);

      let imageFileUri = 'file://' + context.filesDir + '/local_moving_photo.jpg';
      let videoFileUri = 'file://' + context.filesDir + '/local_moving_photo.mp4';
      this.movingPhotoObj =
        await photoAccessHelper.MediaAssetManager.loadMovingPhoto(context, imageFileUri, videoFileUri);

      this.imageSource = imageFileUri;
      this.statusMessage = 'Moving photo object loaded successfully!\nReady to export/read content.';
      console.info('Moving photo loaded successfully');
    } catch (err) {
      this.statusMessage = `Load failed: ${err.code}, ${err.message}`;
      console.error(`Load moving photo failed: ${err.code}, ${err.message}`);
    }
  }
  // [EndExclude Reading_Moving_Photo_Assets]

  // [StartExclude Reading_Moving_Photo_Assets]
  build() {
    NavDestination() {

      Column({ space: 20 }) {
        Text('Read Moving Photo Content')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        Text('Export or read image/video data from moving photo')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .width('90%')

        if (this.imageSource !== '') {
          Image(this.imageSource)
            .width(200)
            .height(200)
            .objectFit(ImageFit.Contain)
            .border({ width: 2, color: '#FF5722' })
            .borderRadius(8)
            .margin({ top: 10, bottom: 10 })
        }

        Button('Prepare & Load Moving Photo')
          .width('80%')
          .height(50)
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            this.prepareAndLoadMovingPhoto();
          })

        Button('example')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(async () => {
            if (this.movingPhotoObj) {
              let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              this.statusMessage = await example(this.movingPhotoObj, context);
            } else {
              this.statusMessage = 'Please prepare and load moving photo first!';
            }
          })

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
      }
      .width('100%')
      .height('100%')
    }
    .title('Read Content')
  }
}
// [EndExclude Reading_Moving_Photo_Assets]

async function example(movingPhoto: photoAccessHelper.MovingPhoto, context: Context): Promise<string> {
  try {
    let imageFileUri = context.filesDir + '/request_moving_photo.jpg';
    let videoFileUri = context.filesDir + '/request_moving_photo.mp4';
    await movingPhoto.requestContent(imageFileUri, videoFileUri);
    let imageData = await movingPhoto.requestContent(photoAccessHelper.ResourceType.IMAGE_RESOURCE);
    let videoData = await movingPhoto.requestContent(photoAccessHelper.ResourceType.VIDEO_RESOURCE);

    return 'Exported to:\n' + imageFileUri + '\n' + videoFileUri + '\n\nImage data size: ' + imageData.byteLength + ' bytes\nVideo data size: ' + videoData.byteLength + ' bytes';
  } catch (err) {
    console.error(`request content of moving photo failed with error: ${err.code}, ${err.message}`);
    return `request content of moving photo failed with error: ${err.code}, ${err.message}`;
  }
}
// [End Reading_Moving_Photo_Assets]