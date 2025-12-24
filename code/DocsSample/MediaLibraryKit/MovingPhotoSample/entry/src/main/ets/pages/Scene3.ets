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

// [Start Reading_Moving_Photo_Sample]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
// [StartExclude Reading_Moving_Photo_Sample]
import { fileIo } from '@kit.CoreFileKit';
// [EndExclude Reading_Moving_Photo_Sample]
@Entry({ routeName : 'Scene3' })
@Component
export struct Scene3 {
  @State statusMessage: string = '';
  @State imageSource: string = '';

  // [StartExclude Reading_Moving_Photo_Sample]
  async prepareTestFiles() {
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

      this.imageSource = 'file://' + context.filesDir + '/local_moving_photo.jpg';
      this.statusMessage = 'Test files prepared:\nImage: ' + context.filesDir + '/local_moving_photo.jpg\nVideo: ' + context.filesDir + '/local_moving_photo.mp4';
      console.info('Test files prepared successfully');
    } catch (err) {
      this.statusMessage = `Prepare failed: ${err.code}, ${err.message}`;
      console.error(`Prepare test files failed: ${err.code}, ${err.message}`);
    }
  }
  // [EndExclude Reading_Moving_Photo_Sample]
  build() {
    NavDestination() {
      Column({ space: 20 }) {
        // [StartExclude Reading_Moving_Photo_Sample]
        Text('Load Moving Photo from Sandbox')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        Text('Load moving photo object from application sandbox directory')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .width('90%')

        if (this.imageSource !== '') {
          Image(this.imageSource)
            .width(200)
            .height(200)
            .objectFit(ImageFit.Contain)
            .border({ width: 2, color: '#9C27B0' })
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
        // [EndExclude Reading_Moving_Photo_Sample]

        Button('example')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(async () => {
            let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            this.statusMessage = await example(context);
          })

        // [StartExclude Reading_Moving_Photo_Sample]
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
        // [EndExclude Reading_Moving_Photo_Sample]

      }
      .width('100%')
      .height('100%')
    }
    .title('Load from Sandbox')
  }
}

async function example(context: Context): Promise<string> {
  try {
    let imageFileUri = 'file://' + context.filesDir + '/local_moving_photo.jpg';
    let videoFileUri = 'file://' + context.filesDir + '/local_moving_photo.mp4';
    let movingPhoto = await photoAccessHelper.MediaAssetManager.loadMovingPhoto(context, imageFileUri, videoFileUri);
    console.info('load moving photo successfully');
    return 'load moving photo successfully';
  } catch (err) {
    console.error(`load moving photo failed with error: ${err.code}, ${err.message}`);
    return `load moving photo failed with error: ${err.code}, ${err.message}`;
  }
}
// [End Reading_Moving_Photo_Sample]