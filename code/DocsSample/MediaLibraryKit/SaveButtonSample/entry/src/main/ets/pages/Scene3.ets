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

// [Start Saving_MediaAsset_Using_Authorization_Popup]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
// [StartExclude Saving_MediaAsset_Using_Authorization_Popup]
import { common } from '@kit.AbilityKit';
// [EndExclude Saving_MediaAsset_Using_Authorization_Popup]
import { fileIo } from '@kit.CoreFileKit';

// [StartExclude Saving_MediaAsset_Using_Authorization_Popup]
@Entry({ routeName : 'Scene3' })
@Component
export struct Scene3 {
  @State statusMessage: string = '';
  @State imageSource: string = '';

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
  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text('Save with Authorization Dialog')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })
        if (this.imageSource !== '') {
          Image(this.imageSource)
            .width(200)
            .height(200)
            .objectFit(ImageFit.Contain)
            .border({ width: 2, color: '#FF9800' })
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
        Button('example')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(async () => {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
            this.statusMessage = await example(phAccessHelper, context);
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
    .title('Authorization Dialog')
  }
}
// [EndExclude Saving_MediaAsset_Using_Authorization_Popup]

async function example(
  phAccessHelper: photoAccessHelper.PhotoAccessHelper,
  context: common.UIAbilityContext
): Promise<string> {
  try {
    // Specify the URI of the image in the application sandbox directory to be saved.
    let srcFileUri = context.filesDir + '/test.jpg';
    let srcFileUris: string[] = [
      srcFileUri
    ];
    //Set parameters for the image to save: file extension, image type, title and subtype (both optional)
    let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
      {
        title: 'test', // This parameter is optional.
        fileNameExtension: 'jpg',
        photoType: photoAccessHelper.PhotoType.IMAGE,
        subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
      }
    ];

    console.info('Source URI: ' + srcFileUri);
    // Obtain the target URI in the media library based on pop-up authorization.
    let desFileUris: string[] = 
      await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
    console.info('Destination URIs: ' + JSON.stringify(desFileUris));
    // Write image from sandbox directory to target URI in media library.
    let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
    let srcFile: fileIo.File = await fileIo.open(srcFileUri, fileIo.OpenMode.READ_ONLY);
    await fileIo.copyFile(srcFile.fd, desFile.fd);
    fileIo.closeSync(srcFile);
    fileIo.closeSync(desFile);
    console.info('create asset by dialog successfully');
    return 'create asset by dialog successfully';
  } catch (err) {
    console.error(`failed to create asset by dialog successfully errCode is: ${err.code}, ${err.message}`);
    return `failed to create asset by dialog successfully errCode is: ${err.code}, ${err.message}`;
  }
}
// [End Saving_MediaAsset_Using_Authorization_Popup]
