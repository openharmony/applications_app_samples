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

// [Start photo_edit_index]
import { common } from '@kit.AbilityKit';
import { UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';

const TAG = '[ExamplePhotoEditorAbility]';

@Entry
@Component
struct Index {
  @State message: string = 'editImg';
  @State originalImage: PixelMap | null = null;
  @State editedImage: PixelMap | null = null;
  private newWant ?: Want;
  private storage = this.getUIContext().getSharedLocalStorage();

  aboutToAppear(): void {
    let originalImageUri = this.storage?.get<string>('uri') ?? '';
    hilog.info(0x0000, TAG, `OriginalImageUri: ${originalImageUri}.`);

    this.readImageByUri(originalImageUri).then(imagePixMap => {
      this.originalImage = imagePixMap;
    })
  }

  // 根据uri读取图片内容
  async readImageByUri(uri: string): Promise < PixelMap | null > {
    hilog.info(0x0000, TAG, `uri: ${uri}`);
    let file: fileIo.File | undefined;
    try {
      file = await fileIo.open(uri, fileIo.OpenMode.READ_ONLY);
      hilog.info(0x0000, TAG, `Original image file id: ${file.fd}`);

      let imageSourceApi: image.ImageSource = image.createImageSource(file.fd);
      if(!imageSourceApi) {
        hilog.info(0x0000, TAG, `ImageSourceApi failed.`);
        return null;
      }
      let pixmap: image.PixelMap = await imageSourceApi.createPixelMap();
      if(!pixmap) {
        hilog.info(0x0000, TAG, `createPixelMap failed.`);
        return null;
      }
      this.originalImage = pixmap;
      return pixmap;
    } catch(e) {
      hilog.error(0x0000, TAG, `ReadImage failed:${e}`);
    } finally {
      fileIo.close(file);
    }
    return null;
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('RotateAndSaveImg').onClick(event => {
          hilog.info(0x0000, TAG, 'Start to edit image and save.');
          // 编辑图片功能实现
          this.originalImage?.rotate(90).then(() => {
            let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
            try {
              // 调用saveEditedContentWithImage保存图片
              (this.getUIContext().getHostContext() as common.PhotoEditorExtensionContext).saveEditedContentWithImage(
                this.originalImage as image.PixelMap,
                packOpts).then(data => {
                if (data.resultCode == 0) {
                  hilog.info(0x0000, TAG, 'Save succeed.');
                }
                hilog.info(0x0000, TAG,
                  `saveContentEditingWithImage result: ${JSON.stringify(data)}`);
                this.newWant = data.want;
                // data.want.uri存有编辑过图片的uri
                this.readImageByUri(this.newWant?.uri ?? '').then(imagePixMap => {
                  this.editedImage = imagePixMap;
                })
              })
            } catch (e) {
              hilog.error(0x0000, TAG, `saveContentEditingWithImage failed:${e}`);
              return;
            }
          })
        }).margin({ top: 10 })

        Button('terminateSelfWithResult').onClick((event => {
          hilog.info(0x0000, TAG, 'Finish the current editing.');

          let session = this.storage?.get('session') as UIExtensionContentSession;
          // 关闭并回传修改结果给调用方
          session?.terminateSelfWithResult({ resultCode: 0, want: this.newWant });
        })).margin({ top: 10 })

        Image(this.originalImage).width('100%').height(200).margin({ top: 10 }).objectFit(ImageFit.Contain)

        Image(this.editedImage).width('100%').height(200).margin({ top: 10 }).objectFit(ImageFit.Contain)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor(Color.Pink)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}
// [End photo_edit_index]